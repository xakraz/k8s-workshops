#!/usr/bin/env sh

DIR=$(readlink -f $(dirname $0))

echo "export PATH=${DIR}/bin:${PATH}"
echo "source <(kubectl completion $(basename $SHELL))"
