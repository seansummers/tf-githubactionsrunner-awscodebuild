#! /bin/bash -xe

ARCH="$(uname -m | sed s/aarch/arm/ | sed s/x86_/amd/)"
DEB_FILTER=".assets[].browser_download_url | select(match(\"_${ARCH}.deb$\"))"
RELEASE_URL="https://api.github.com/repos/tofuutils/tenv/releases/latest"

TMP=$(mktemp)
trap "rm -f ${TMP}" EXIT

# tenv for Tofu, Terragrunt, Terraform, atmos
if ! hash tenv 2>/dev/null
then
  TENV_RELEASE=$(curl -sL ${RELEASE_URL} | jq -r "${DEB_FILTER}")
  curl -sL -o ${TMP} "${TENV_RELEASE}" && sudo dpkg -i "${TMP}"
fi
