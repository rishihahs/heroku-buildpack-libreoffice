#!/usr/bin/env bash

set -e

BUILD_DIR=$1
CACHE_DIR=$2

# config
VERSION="5.0.2"
MINOR_VERSION="5.0"

# LibreOffice Binaries URL
FILE_NAME=libreoffice${VERSION}_x86-64.tar.gz
BUILDPACK_LIBREOFFICE_PACKAGE=https://s3-eu-west-1.amazonaws.com/libreoffice-heroku-buildpack/${FILE_NAME}
ARCHIVE_NAME=opt/libreoffice${VERSION}

# LibreOffice Dependencies URL
DEPS_FILE_NAME=libreoffice${VERSION}_x86-64_deps.tar.gz
DEPS_BUILDPACK_LIBREOFFICE_PACKAGE=https://s3-eu-west-1.amazonaws.com/libreoffice-heroku-buildpack/${DEPS_FILE_NAME}
DEPS_ARCHIVE_NAME=app/vendor/libreoffice/deps

mkdir -p $CACHE_DIR
if ! [ -e $CACHE_DIR/$FILE_NAME ]; then
  echo "-----> LibreOffice: Downloading LibreOffice ${VERSION} binaries from ${BUILDPACK_LIBREOFFICE_PACKAGE}"
  curl -L $BUILDPACK_LIBREOFFICE_PACKAGE -o $CACHE_DIR/$FILE_NAME
fi

if ! [ -e $CACHE_DIR/$DEPS_FILE_NAME ]; then
  echo "-----> LibreOffice: Downloading LibreOffice dependencies (gettext, dbus, libffi, glib, dbus-glib) from ${DEPS_BUILDPACK_LIBREOFFICE_PACKAGE}"
  curl -L $DEPS_BUILDPACK_LIBREOFFICE_PACKAGE -o $CACHE_DIR/$DEPS_FILE_NAME
fi

echo "-----> LibreOffice: Extracting LibreOffice ${VERSION} binaries to ${BUILD_DIR}/vendor/libreoffice"
mkdir -p $CACHE_DIR/$ARCHIVE_NAME
mkdir -p $BUILD_DIR/vendor/
tar xzf $CACHE_DIR/$FILE_NAME -C $CACHE_DIR/$ARCHIVE_NAME
mv ${CACHE_DIR}/${ARCHIVE_NAME}/opt/libreoffice${MINOR_VERSION} $BUILD_DIR/vendor/libreoffice

echo "-----> LibreOffice: Extracting LibreOffice dependencies to ${BUILD_DIR}/vendor/libreoffice/deps"
mkdir -p $CACHE_DIR/$DEPS_ARCHIVE_NAME
tar xzf $CACHE_DIR/$DEPS_FILE_NAME -C $CACHE_DIR
mv $CACHE_DIR/$DEPS_ARCHIVE_NAME $BUILD_DIR/vendor/libreoffice/deps

echo "-----> LibreOffice: Setting PATH and LD_LIBRARY_PATH"
PROFILE_PATH="$BUILD_DIR/.profile.d/libreoffice.sh"
mkdir -p $(dirname $PROFILE_PATH)

# add vendor binaries to the path
echo 'export PATH="$HOME/vendor/libreoffice/program:/app/vendor/libreoffice/deps/bin:$PATH"' >> $PROFILE_PATH

# configure LD_LIBRARY_PATH to include dependencies
echo 'export LD_LIBRARY_PATH="$HOME/vendor/libreoffice/deps/lib:$LD_LIBRARY_PATH"' >> $PROFILE_PATH
