#!/bin/sh

if [ $# -ne 2 ] || [ ! -d "$1" ]
then
  cat <<-EOF
  Usage:
    $(basename $0) <dir> <name>
EOF
fi

cd "$1"

cat <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: $2
type: Opaque
data:
EOF

for f in *
do
  echo "  $f: $(base64 -w0 "$f")"
done
