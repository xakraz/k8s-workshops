#!/usr/bin/env bash



# == Vars
#
PROJECT_DIR="$(git rev-parse --show-toplevel)"

DIND_URL=${DIND_URL:-https://cdn.rawgit.com/Mirantis/kubeadm-dind-cluster/master/fixed/dind-cluster}
DIND_VERSION=${DIND_VERSION:-$(kubectl version --client --output=yaml | grep -i gitVersion | cut -d':' -f 2 | cut -d '.' -f 1,2 | cut -d ' ' -f 2)}
[ -z "${DIND_VERSION}" ] \
  && echo 'Kubectl has not been found in your PATH ...' \
  && exit 2

# == Bash options
#
set -e
set -u


# == Main
#
pushd $PROJECT_DIR
  echo "===> $0: Start"
  echo "---> DIND_URL: ${DIND_URL}"
  echo "---> DIND_VERSION: ${DIND_VERSION}"
  echo '* You can override these value with ENV variables'
  echo ''

  echo '---> Downloading kubectl binary'
  curl -# -LO ${DIND_URL}-${DIND_VERSION}.sh
  echo ''

  echo '---> Installing DIND locally'
  [[ -d ${PROJECT_DIR}/bin ]] || mkdir -vp ${PROJECT_DIR}/bin
  chmod +x ./dind-cluster-${DIND_VERSION}.sh
  mv -v ./dind-cluster-${DIND_VERSION}.sh  ${PROJECT_DIR}/bin/
  echo ''
  echo "===> $0: DONE"

  echo ''
  echo ''
  echo ''
  echo ''
  echo '===> Configure your shell and Run: '
  echo "* export PATH=${PROJECT_DIR}/bin:\${PATH}"
  echo "* dind-cluster-${DIND_VERSION}.sh up"
  echo ''
  echo ''
  echo ''
  echo ''
popd

