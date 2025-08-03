# twolame

TWOLAME_VERSION := 0.4.0
TWOLAME_URL := $(SF)/twolame/twolame-$(TWOLAME_VERSION).tar.gz

ifdef BUILD_ENCODERS
PKGS += twolame
endif
ifeq ($(call need_pkg,"twolame"),)
PKGS_FOUND += twolame
endif

$(TARBALLS)/twolame-$(TWOLAME_VERSION).tar.gz:
	$(call download_pkg,$(TWOLAME_URL),twolame)

.sum-twolame: twolame-$(TWOLAME_VERSION).tar.gz

twolame: twolame-$(TWOLAME_VERSION).tar.gz .sum-twolame
	$(UNPACK)
	$(UPDATE_AUTOCONFIG) && cd $(UNPACK_DIR) && cp config.guess config.sub build-scripts
	$(MOVE)

.twolame: twolame
	$(RECONF)
	cd $< && $(HOSTVARS) ./configure $(HOSTCONF) CFLAGS="${CFLAGS} -DLIBTWOLAME_STATIC"
	$(MAKE) -C $<
	$(MAKE) -C $< -C libtwolame install
	$(MAKE) -C $< install-data
	touch $@
