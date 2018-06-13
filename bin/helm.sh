PROJECT_NAME="helm"
TAG=${HELM_VERSION:-"2.9.1"}

: ${HELM_INSTALL_DIR:="/usr/local/bin"}

# downloadFile downloads the  binary package and also the checksum
# for that binary.
downloadFile() {
  HELM_DIST="helm-v$TAG-$OS-$ARCH.tar.gz"
  DOWNLOAD_URL="https://kubernetes-helm.storage.googleapis.com/$HELM_DIST"
  CHECKSUM_URL="$DOWNLOAD_URL.sha256"
  HELM_TMP_FILE="/tmp/$HELM_DIST"
  HELM_SUM_FILE="/tmp/$HELM_DIST.sha256"
  echo "Downloading $DOWNLOAD_URL"
  curl -Ls -v "$CHECKSUM_URL" -o "$HELM_SUM_FILE"
  curl -L -v "$DOWNLOAD_URL" -o "$HELM_TMP_FILE"
}

# installFile verifies the SHA256 for the file, then unpacks and
# installs it.
installFile() {
  HELM_TMP="/tmp/$PROJECT_NAME"
  local sum=$(openssl sha -sha256 ${HELM_TMP_FILE} | awk '{print $2}')
  local expected_sum=$(cat ${HELM_SUM_FILE})
  if [ "$sum" != "$expected_sum" ]; then
    echo "SHA sum of $HELM_TMP does not match. Aborting."
    exit 1
  fi

  mkdir -p "$HELM_TMP"
  tar xf "$HELM_TMP_FILE" -C "$HELM_TMP"
  HELM_TMP_BIN="$HELM_TMP/$OS-$ARCH/$PROJECT_NAME"
  echo "Preparing to install into ${HELM_INSTALL_DIR} (sudo)"
  sudo cp "$HELM_TMP_BIN" "$HELM_INSTALL_DIR"
  rm -rf "$HELM_TMP_FILE"
  rm -rf "$HELM_TMP_BIN"
}

# testVersion tests the installed client to make sure it is working.
testVersion() {
  set +e
  echo "$PROJECT_NAME installed into $HELM_INSTALL_DIR/$PROJECT_NAME"
  HELM="$(which $PROJECT_NAME)"
  if [ "$?" = "1" ]; then
    echo "$PROJECT_NAME not found. Is $HELM_INSTALL_DIR on your "'$PATH?'
    exit 1
  fi
  set -e
  echo "Run '$PROJECT_NAME init' to configure $PROJECT_NAME."
}

# initArch discovers the architecture for this system.
initArch() {
  ARCH=$(uname -m)
  case $ARCH in
    armv5*) ARCH="armv5";;
    armv6*) ARCH="armv6";;
    armv7*) ARCH="armv7";;
    aarch64) ARCH="arm64";;
    x86) ARCH="386";;
    x86_64) ARCH="amd64";;
    i686) ARCH="386";;
    i386) ARCH="386";;
  esac
}

# initOS discovers the operating system for this system.
initOS() {
  OS=$(echo `uname`|tr '[:upper:]' '[:lower:]')

  case "$OS" in
    # Minimalist GNU for Windows
    mingw*) OS='windows';;
  esac
}

initOS
initArch
downloadFile
installFile
testVersion
