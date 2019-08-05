MODVERSION := $(shell sed -n 's/version=\(.*\)/\1/p' zsh_arm64/module.prop)
MOD := zsh_arm64
STAGE := stage
ZIP := $(MOD)-$(MODVERSION).zip
#ZIP := $(MOD)-$(MODVERSION)-$(shell date +%m-%d).zip

VCODE := $(subst .,,$(MODVERSION))

DEPS := $(shell find $(MOD) -type f)
STAGEDEPS := $(DEPS:$(MOD)/%=$(STAGE)/%)

ZSHVERSION := 5.7
SRCDIR=zsh-$(ZSHVERSION)
SRCURL := https://sourceforge.net/projects/zsh/files/zsh/$(ZSHVERSION)/zsh-$(ZSHVERSION).tar.xz/download
ARCHIVE := $(SRCDIR).tar.xz

CURDIR := $(shell pwd)
PROCS := $(shell nproc)

.PHONY: 

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
		--bindir=/system/xbin \
		--datarootdir=/system/usr/share \
		--disable-dynamic \
		--disable-dynamic-nss \
		--disable-gdbm \
		--disable-restricted-r \
		--disable-runhelpdir \
		--enable-cppflags=-static \
		--enable-ldflags=-static \
		--enable-zshenv=/system/etc/zsh/zshenv \
		--enable-zprofile=/system/etc/zsh/zprofile \
		--enable-zlogin=/system/etc/zsh/zlogin \
		--enable-zlogout=/system/etc/zsh/zlogout \
		--enable-multibyte \
		--enable-pcre \
		--enable-site-fndir=/system/usr/share/zsh/functions \
		--enable-fndir=/system/usr/share/zsh/functions \
		--enable-function-subdirs \
		--enable-scriptdir=/system/usr/share/zsh/scripts \
		--enable-site-scriptdir=/system/usr/share/zsh/scripts \
		--enable-etcdir=/system/etc \
		--enable-libs=-lpthread \
		--host=aarch64-linux-gnu \
		--libexecdir=/system/xbin \
		--prefix=/system \
		--sbindir=/system/xbin \
		--sysconfdir=/system/etc 


build/work/$(SRCDIR)/Src/zsh: build/work/$(SRCDIR)/Makefile $(DEPS)
	cd $(CURDIR)/build/work/$(SRCDIR); \
	make -j$(PROCS)


$(STAGE)/system/xbin/zsh: build/work/$(SRCDIR)/Src/zsh 
	cd $(CURDIR)/build/work/$(SRCDIR); \
	make install DESTDIR=$(CURDIR)/$(STAGE); \
	chmod 755 $(CURDIR)/$(STAGE)/system/xbin/*

$(STAGE)/%: $(MOD)/% 
	mkdir -p $(@D)
	cp -v $? $@

$(STAGE)/README.md: README.md
	cp README.md $(STAGE)/README.md

out/$(ZIP): $(STAGEDEPS) $(STAGE)/system/xbin/zsh $(STAGE)/README.md
	cd $(STAGE); \
		rm -rf system/usr/share/man; \
		rm -f system/xbin/zsh-* system/xbin/zsh.old; \
		zip -qr ../out/$(ZIP) $(notdir $(wildcard $(STAGE)/*))

#sed -i "s/version=.*/version=$(MODVERSION)/" module.prop; \
#sed -i "s/versionCode=.*/versionCode=$(VCODE)/" module.prop; \

clean:
	rm -rf build/work/*
	rm -rf $(STAGE)/*

distclean: clean
	rm -f out/*.zip

