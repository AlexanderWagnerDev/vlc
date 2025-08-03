# ZLIB
ZLIB_VERSION := 1.2.13
ZLIB_URL := $(GITHUB)/madler/zlib/releases/download/v$(ZLIB_VERSION)/zlib-$(ZLIB_VERSION).tar.xz

PKGS += zlib
ifeq ($(call need_pkg,"zlib"),)
PKGS_FOUND += zlib
endif

$(TARBALLS)/zlib-$(ZLIB_VERSION).tar.xz:
	$(call download_pkg,$(ZLIB_URL),zlib)

.sum-zlib: zlib-$(ZLIB_VERSION).tar.xz

zlib: zlib-$(ZLIB_VERSION).tar.xz .sum-zlib
	$(UNPACK)
	$(APPLY) $(SRC)/zlib/0001-Fix-mingw-static-library-name-on-mingw.patch
	# disable the installation of the dynamic library since there's no option
	cd $(UNPACK_DIR) && sed -e 's,install(TARGETS zlib zlibstatic,install(TARGETS zlibstatic,' -i.orig CMakeLists.txt
	$(MOVE)

ZLIB_CONF = -DINSTALL_PKGCONFIG_DIR:STRING=$(PREFIX)/lib/pkgconfig

# ASM is disabled as the necessary source files are not in the tarball nor the git
# ifeq ($(ARCH),i386)
# ZLIB_CONF += -DASM686=ON
# endif
# ifeq ($(ARCH),x86_64)
# ZLIB_CONF += -DAMD64=ON
# endif

.zlib: zlib toolchain.cmake
	$(CMAKECLEAN)
	$(HOSTVARS) $(CMAKE) $(ZLIB_CONF)
	+$(CMAKEBUILD)
	+$(CMAKEBUILD) --target install
	touch $@
