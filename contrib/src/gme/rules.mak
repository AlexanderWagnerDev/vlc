# Game Music Emu

GME_VERSION := 0.6.3
GME_URL := $(GITHUB)/libgme/game-music-emu/archive/refs/tags/$(GME_VERSION).tar.gz

PKGS += gme

$(TARBALLS)/game-music-emu-$(GME_VERSION).tar.gz:
	$(call download_pkg,$(GME_URL),gme)

DEPS_gme = zlib $(DEPS_zlib)

.sum-gme: game-music-emu-$(GME_VERSION).tar.gz

game-music-emu: game-music-emu-$(GME_VERSION).tar.gz .sum-gme
	$(UNPACK)
	$(APPLY) $(SRC)/gme/skip-underrun.patch
	$(APPLY) $(SRC)/gme/add-libm.patch
ifdef HAVE_MACOSX
	$(APPLY) $(SRC)/gme/mac-use-c-stdlib.patch
endif
	$(APPLY) $(SRC)/gme/0004-Blip_Buffer-replace-assert-with-a-check.patch
	$(call pkg_static,"gme/libgme.pc.in")
	$(MOVE)

GME_CONF := -DENABLE_UBSAN=OFF

.gme: game-music-emu toolchain.cmake
	$(CMAKECLEAN)
	$(HOSTVARS) $(CMAKE) $(GME_CONF)
	+$(CMAKEBUILD)
	$(CMAKEINSTALL)
	touch $@
