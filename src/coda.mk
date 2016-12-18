# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := coda
$(PKG)_WEBSITE  := https://stcorp.nl/coda/
$(PKG)_DESCR    := CODA
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.15.1
$(PKG)_CHECKSUM := 51076ff958ec15633d741ea021761fc6d8c6492f931175c489288481e37ac810
$(PKG)_SUBDIR   := coda-$($(PKG)_VERSION)
$(PKG)_FILE     := coda-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/stcorp/coda/releases/download/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-idl \
        --disable-matlab \
        --disable-python \
        --without-hdf5 \
        --without-hdf4

    # Fortran includes are generated by the tool 'generate-finc',
    # which needs to run natively:
    cd '$(1)' && $(CC) -I . -o generate-finc fortran/generate-finc.c

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install-libLTLIBRARIES install-nodist_includeHEADERS install-fortranDATA

    '$(TARGET)-gcc' \
        -std=c99 -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-coda.exe' \
        -lcoda
endef
