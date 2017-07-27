#!/usr/bin/env bash

set -o errexit


# == Vars
#
PROJECT_DIR="$(git rev-parse --show-toplevel)"

KUBECTL_URL=${KUBECTL_URL:-https://storage.googleapis.com/kubernetes-release/release}
KUBECTL_VERSION=${KUBECTL_VERSION:-$(curl -s ${KUBECTL_URL}/stable.txt)}



# == Bash options
#
set -u


# == Main
#
pushd $PROJECT_DIR
  echo "===> $0: Start"
  echo "---> KUBECTL_URL: ${KUBECTL_URL}"
  echo "---> KUBECTL_VERSION: ${KUBECTL_VERSION}"
  echo '* You can override these value with ENV variable'
  echo ''

  echo '---> Downloading kubectl binary'
  curl -# -LO ${KUBECTL_URL}/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
  echo ''

  echo '---> Installing kubectl locally'
  [[ -d ${PROJECT_DIR}/bin ]] || mkdir -vp ${PROJECT_DIR}/bin
  chmod +x ./kubectl
  mv -v kubectl ${PROJECT_DIR}/bin/
  echo ''

  echo '---> Configure your shell:'
  echo "* export PATH=${PROJECT_DIR}/bin:\${PATH}"
  echo "* source <(kubectl completion $(basename $SHELL))"
popd

