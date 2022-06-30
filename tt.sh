#!/bin/sh

INSTALL_DIR=~/bin
BIN_NAME=tt

# [ $# -eq 0 ] && { echo "Usage: $0 dir-name"; exit 1; }
if [ $# -eq 1 ] && [[ "${1?}" == -d ]]
then
  echo "> Uninstalling ... "
  if [ -f "$INSTALL_DIR/$BIN_NAME" ]
  then
    rm "$INSTALL_DIR/$BIN_NAME"
    echo "Removed $INSTALL_DIR/$BIN_NAME"
  fi
else
  # create dir if not already exist
  if [ ! -d "$INSTALL_DIR" ]
  then
    echo "$INSTALL_DIR not found, therefore creating"
    mkdir -p $INSTALL_DIR
    echo "remember to add $INSTALL_DIR to your PATH"
  else
    echo "Found installation path $INSTALL_DIR"
  fi

  TEMP_DIR=`mktemp -d`
  cd $TEMP_DIR
  git clone https://github.com/lemnos/tt
  cd tt
  go mod tidy
  go build -o "$INSTALL_DIR/$BIN_NAME" src/*.go



  # delete temp dir
  function cleanup {
    echo "> Cleaning up working dir ($TEMP_DIR) <"
    rm -rf $TEMP_DIR
  }
  trap cleanup EXIT
  # install success
  echo "Installed to: $INSTALL_DIR/$BIN_NAME"
fi

