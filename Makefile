VERSION := 0.7
MOD := ZSH_Arm
ZIP := ${MOD}-${VERSION}-$(shell date +%m-%d).zip

VCODE := $(subst .,,$(VERSION))
DEPS := $(shell find ${MOD} -type f)

all: out/$(ZIP)

out/$(ZIP): $(DEPS)
	cd $(MOD); \
		sed -i "s/version=.*/version=${VERSION}/" module.prop; \
		sed -i "s/versionCode=.*/versionCode=${VCODE}/" module.prop; \
		zip -r ../out/$(ZIP) $(notdir $(wildcard $(MOD)/*))

clean:
	rm -f out/*.zip

