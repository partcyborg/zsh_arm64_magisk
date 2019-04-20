MODVERSION := 1.0
MOD := zsh_arm64
ZIP := $(MOD)-$(MODVERSION).zip
#ZIP := $(MOD)-$(MODVERSION)-$(shell date +%m-%d).zip

VCODE := $(subst .,,$(MODVERSION))
DEPS := $(shell find $(MOD) -type f)

ZSHVERSION := 5.7
SRCDIR=zsh-$(ZSHVERSION)
SRCURL := https://sourceforge.net/projects/zsh/files/zsh/$(ZSHVERSION)/zsh-$(ZSHVERSION).tar.xz/download
ARCHIVE := $(SRCDIR).tar.gz

CURDIR := $(shell pwd)
PROCS := $(shell nproc)

all: out/$(ZIP)

build/work/$(ARCHIVE):
	mkdir -p $(CURDIR)/build/work; \
	cd $(CURDIR)/build/work; \
	wget --output-document=$(ARCHIVE) $(SRCURL); \
	tar xf zsh-$(ZSHVERSION).tar.xz

build/work/$(SRCDIR)/Makefile: build/work/$(ARCHIVE)
	cd $(CURDIR)/build/work/$(SRCDIR); \
	./Util/preconfig; \
	cp ../../config.modules .; \
	./configure \
		--host=aarch64-linux-gnu \
		--bindir=/system/xbin \
		--sbindir=/system/xbin \
		--libexecdir=/system/xbin \
		--datarootdir=/system/usr/share \
		--prefix=/system \
		--enable-cppflags=-static \
		--enable-ldflags=-static \
		--enable-zshenv=/system/etc/zsh/zshenv \
		--enable-zprofile=/system/etc/zsh/zprofile \
		--enable-zlogin=/system/etc/zsh/zlogin \
		--enable-zlogout=/system/etc/zsh/zlogout \
		--disable-dynamic \
		--disable-restricted-r \
		--disable-dynamic-nss \
		--disable-gdbm \
		--enable-pcre \
		--enable-site-fndir=/system/usr/share/zsh/functions \
		--enable-fndir=/system/usr/share/zsh/functions \
		--disable-runhelpdir \
		--sysconfdir=/system/etc \
		--enable-etcdir=/system/etc \
		--enable-libs=-lpthread


build/work/$(SRCDIR)/Src/zsh: build/work/$(SRCDIR)/Makefile $(DEPS)
	cd $(CURDIR)/build/work/$(SRCDIR); \
	make -j$(PROCS)


$(MOD)/system/xbin/zsh: build/work/$(SRCDIR)/Src/zsh
	cd $(CURDIR)/build/work/$(SRCDIR); \
	make install DESTDIR=$(CURDIR)/$(MOD); \
	chmod 755 $(CURDIR)/$(MOD)/system/xbin/*


out/$(ZIP): $(MOD)/system/xbin/zsh
	cd $(MOD); \
		rm -rf system/usr/share/man; \
		rm system/xbin/zsh-* system/xbin/zsh.old; \
		sed -i "s/version=.*/version=$(MODVERSION)/" module.prop; \
		sed -i "s/versionCode=.*/versionCode=$(VCODE)/" module.prop; \
		zip -r ../out/$(ZIP) $(notdir $(wildcard $(MOD)/*))

clean:
	rm -f out/*.zip
	rm -rf build/work/*
	rm -rf $(MOD)/system/xbin/zsh $(MOD)/system/usr/share/zsh

