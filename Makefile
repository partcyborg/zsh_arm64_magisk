MODVERSION := 0.7
MOD := ZSH_Arm
ZIP := ${MOD}-${VERSION}-$(shell date +%m-%d).zip

VCODE := $(subst .,,$(MODVERSION))
DEPS := $(shell find ${MOD} -type f)

ZSHVERSION := 5.7.1
SRCDIR=zsh-${ZSHVERSION}
SRCURL := https://sourceforge.net/projects/zsh/files/zsh/5.7.1/zsh-5.7.1.tar.xz/download
#SRCURL := https://github.com/zsh-users/zsh/archive/zsh-${ZSHVERSION}.tar.gz

CURDIR := $(shell pwd)
PROCS := $$(( $(shell nproc) -1 ))

all: out/$(ZIP)

build/work/$(SRCDIR):
	cd $(CURDIR)/build/work; \
	wget --output-document=zsh-$(ZSHVERSION).tar.gz $(SRCURL); \
	tar xf zsh-$(ZSHVERSION).tar.gz

build/work/$(SRCDIR)/Src/zsh: build/work/$(SRCDIR)
	cd $(CURDIR)/build/work/$(SRCDIR); \
	cp ../../config.modules .; \
	./Util/preconfig; \
	./configure \
		--host=armv8l-linux-gnueabihf \
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
		--disable-dynamic-nss \
		--enable-libs=-lpthread \
		CC=armv8l-linux-gnueabihf-gcc; \
	make -j$(PROCS); \ 
	make install DESTDIR=$(CURDIR)/ZSH_Arm

	

out/$(ZIP): build/work/$(SRCDIR)/Src/zsh $(DEPS)
	cd $(MOD); \
		sed -i "s/version=.*/version=${VERSION}/" module.prop; \
		sed -i "s/versionCode=.*/versionCode=${VCODE}/" module.prop; \
		zip -r ../out/$(ZIP) $(notdir $(wildcard $(MOD)/*))

clean:
	rm -f out/*.zip
	rm -rf build/work/*

