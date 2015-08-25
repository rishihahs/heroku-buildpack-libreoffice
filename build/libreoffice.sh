#!/usr/bin/env bash

# The current LibreOffice version
VERSION="4.1.4"

# Official download for .debs
DEB_DOWNLOAD_URL="http://download.documentfoundation.org/libreoffice/stable/${VERSION}/deb/x86_64/LibreOffice_${VERSION}_Linux_x86-64_deb.tar.gz"
GETTEXT_DOWNLOAD_URL="http://ftp.gnu.org/pub/gnu/gettext/gettext-0.18.3.1.tar.gz"
DBUS_DOWNLOAD_URL="http://dbus.freedesktop.org/releases/dbus/dbus-1.6.18.tar.gz"
LIBFFI_DOWNLOAD_URL="ftp://sourceware.org/pub/libffi/libffi-3.0.13.tar.gz"
GLIB_DOWNLOAD_URL="http://ftp.gnome.org/pub/gnome/sources/glib/2.38/glib-2.38.2.tar.xz"
DBUS_GLIB_DOWNLOAD_URL="http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.100.2.tar.gz"

# File names
LIBREOFFICE_BINARIES_FILE="libreoffice${VERSION}_x86-64.tar.gz"
DEPS_FILE="libreoffice_deps.tar.gz"

PREFIX=/app/vendor/libreoffice/deps
mkdir -p $PREFIX

temp_dir=$(mktemp -d /tmp/libreoffice.XXXXXXXXXX)
cd ${temp_dir}

# Release dir
mkdir -p release

# Download and extract the .debs
curl -L ${DEB_DOWNLOAD_URL} -o libreoffice.tar.gz
archive_name=$(tar tzf libreoffice.tar.gz | sed -e 's@/.*@@' | uniq)
tar xzf libreoffice.tar.gz

cd ${archive_name}
for f in DEBS/*.deb
do
  ar p "$f" data.tar.gz | tar zx
done

tar pczf ${LIBREOFFICE_BINARIES_FILE} opt
mv ${LIBREOFFICE_BINARIES_FILE} "${temp_dir}/release/${LIBREOFFICE_BINARIES_FILE}"
cd ${temp_dir}

echo "==================================== LibreOffice built, now building dependencies ===================================="

# ============================== DEPENDENCIES ======================================

# Download and build gettext
curl ${GETTEXT_DOWNLOAD_URL} -o gettext.tar.gz
archive_name=$(tar tzf gettext.tar.gz | sed -e 's@/.*@@' | uniq)
tar xzf gettext.tar.gz
cd ${archive_name}
./configure --prefix=${PREFIX}
make
make install
cd ${temp_dir}

# Add gettext to PATH and LD_LIBRARY_PATH and PKG_CONFIG_PATH
export PATH="$PREFIX/bin:$PATH"
export LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"

# Download and build DBus
curl ${DBUS_DOWNLOAD_URL} -o dbus.tar.gz
archive_name=$(tar tzf dbus.tar.gz | sed -e 's@/.*@@' | uniq)
tar xzf dbus.tar.gz
cd ${archive_name}
./configure --prefix=${PREFIX}
make
make install
cd ${temp_dir}

# Download and build libffi
curl ${LIBFFI_DOWNLOAD_URL} -o libffi.tar.gz
archive_name=$(tar tzf libffi.tar.gz | sed -e 's@/.*@@' | uniq)
tar xzf libffi.tar.gz
cd ${archive_name}
./configure --prefix=${PREFIX}
make
make install
cd ${temp_dir}

# Download and build GLib
curl ${GLIB_DOWNLOAD_URL} -o glib.tar.xz
archive_name=$(tar tJf glib.tar.xz | sed -e 's@/.*@@' | uniq)
tar xJf glib.tar.xz
cd ${archive_name}
./configure --prefix=${PREFIX}
make
make install
cd ${temp_dir}

# Download and build DBus-GLib
curl ${DBUS_GLIB_DOWNLOAD_URL} -o dbus-glib.tar.gz
archive_name=$(tar tzf dbus-glib.tar.gz | sed -e 's@/.*@@' | uniq)
tar xzf dbus-glib.tar.gz
cd ${archive_name}
./configure --prefix=${PREFIX}
make
make install
cd ${temp_dir}

# Compress all dependencies
tar pczf ${DEPS_FILE} ${PREFIX}
mv ${DEPS_FILE} release/${DEPS_FILE}

echo "=================================== DONE ================================"
