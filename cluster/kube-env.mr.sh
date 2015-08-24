# environment variables for kube-up and friends

set -a

KUBERNETES_PROVIDER=aws
KUBE_AWS_ZONE=eu-west-1a
MINION_SIZE=m3.medium
NUM_MINIONS=2
AWS_S3_BUCKET=mr-kubernetes-artifacts
AWS_S3_REGION=eu-west-1
MASTER_RESERVED_IP=auto
KUBE_ENABLE_INSECURE_REGISTRY=true

set +a
