#!/bin/zsh

SOURCE_URL="https://github.com/zsh-users/zsh/archive/zsh-5.7.1.tar.gz"

[ -z "$NDK_BUILD" ] && { echo "NDK_BUILD not defined"; exit 1; }

wget "$SOURCE_URL"
tar xvf zsh-5.7.1.tar.gz
cd zsh-zsh-5.7.1


# First, be sure to copy over the config.modules file from this directory to the root of
# the source tree.
cp ../config.modules .

# The following command was used to configure zsh:
./configure \
   --host=aarch64-unknown-linux-gnu\
   --bindir=/system/xbin \
   --sbindir=/system/xbin \
   --libexecdir=/system/xbin \
   --datarootdir=/system/usr/share \
   --prefix=/system \
   --enable-cppflags='-static -fPIC' \
   --enable-cppflags='-fPIC' \
   --enable-ldflags=-static \
   --enable-zshenv=/system/etc/zsh/zshenv \
   --enable-zprofile=/system/etc/zsh/zprofile \
   --enable-zlogin=/system/etc/zsh/zlogin \
   --enable-zlogout=/system/etc/zsh/zlogout \
   --disable-dynamic \
   --disable-restricted-r \
   --enable-pcre \
   --disable-gdbm \
   --disable-dynamic-nss \
   --enable-site-fndir=/system/usr/share/zsh/functions \
   --enable-fndir=/system/usr/share/zsh/functions \
   --disable-runhelpdir \
   --enable-function-subdirs \
   --sysconfdir=/system/etc \
   --enable-etcdir=/system/etc \
   --enable-libs=-lpthread

