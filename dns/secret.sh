#!/bin/bash

# Copyright 2014 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# The business logic for whether a given object should be created
# was already enforced by salt, and /etc/kubernetes/addons is the
# managed result is of that. Start everything below that directory.
KUBECTL=kubectl

function create-kubeconfig-secret() {
  local -r token=$1
  local -r username=$2
  local -r safe_username=$(tr -s ':_' '--' <<< "${username}")

  # Make a kubeconfig file with the token.
  # TODO(etune): put apiserver certs into secret too, and reference from authfile,
  # so that "Insecure" is not needed.
  # Point the kubeconfig file at https://kubernetes:443. Pods/components that
  # do not have DNS available will have to override the server.
  read -r -d '' kubeconfig <<EOF
apiVersion: v1
kind: Config
users:
- name: ${username}
  user:
    token: ${token}
clusters:
- name: local
  cluster:
     server: "https://kubernetes:443"
     insecure-skip-tls-verify: true
contexts:
- context:
    cluster: local
    user: ${username}
  name: service-account-context
current-context: service-account-context
EOF
  local -r kubeconfig_base64=$(echo "${kubeconfig}" | base64 -w0)
  read -r -d '' secretyaml <<EOF
apiVersion: v1beta3
data:
  kubeconfig: ${kubeconfig_base64}
kind: Secret
metadata:
  name: token-${safe_username}
type: Opaque
EOF
  create-resource-from-string "${secretyaml}" 100 10 "Secret-for-token-for-user-${username}" &
# TODO: label the secrets with special label so kubectl does not show these?
}

# $1 string with json or yaml.
# $2 count of tries to start the addon.
# $3 delay in seconds between two consecutive tries
# $3 name of this object to use when logging about it.
function create-resource-from-string() {
  local -r config_string=$1;
  local tries=$2;
  local -r delay=$3;
  local -r config_name=$1;
  while [ ${tries} -gt 0 ]; do
    echo "${config_string}" | ${KUBECTL} create -f - && \
        echo "== Successfully started ${config_name} at $(date -Is)" && \
        return 0;
    let tries=tries-1;
    echo "== Failed to start ${config_name} at $(date -Is). ${tries} tries remaining. =="
    sleep ${delay};
  done
  return 1;
}

# Generate secrets for "internal service accounts".
# TODO(etune): move to a completely yaml/object based
# workflow so that service accounts can be created
# at the same time as the services that use them.
# NOTE: needs to run as root to read this file.
# Read each line in the csv file of tokens.
while read line; do
  # Split each line into the token and username.
  IFS=',' read -a parts <<< "${line}"
  token=${parts[0]}
  username=${parts[1]}
  create-kubeconfig-secret "${token}" "${username}"
done < /srv/kubernetes/etc/known_tokens.csv
