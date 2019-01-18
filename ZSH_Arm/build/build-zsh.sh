#!/bin/false
# NOTE: this is not meant to be ran, its just documentation for building zsh from source.
echo "Don't run me!"; exit 1

# First, be sure to copy over the config.modules file from this directory to the root of
# the source tree.

# The following command was used to configure zsh:
./configure \
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

