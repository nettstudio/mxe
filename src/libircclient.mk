# This file is part of MXE. See LICENSE.md for licensing information.

# Note that IPv6 support is partly broken and therefore disabled.

PKG             := libircclient
$(PKG)_WEBSITE  := http://sourceforge.net/projects/libircclient/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8
$(PKG)_CHECKSUM := 2cf8523ac683588f2785b08159a2df3e4d15939ee655c0024aa86334149de8f6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/libircclient/files/libircclient/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-debug \
        --enable-threads \
        --disable-ipv6
    $(MAKE) -C '$(1)'/src -j '$(JOBS)' static
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/src/libircclient.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/libircclient'
    $(INSTALL) -m644 '$(1)/include/libircclient.h' '$(PREFIX)/$(TARGET)/include/libircclient'
    $(INSTALL) -m644 '$(1)/include/libirc_errors.h' '$(PREFIX)/$(TARGET)/include/libircclient'
    $(INSTALL) -m644 '$(1)/include/libirc_events.h' '$(PREFIX)/$(TARGET)/include/libircclient'
    $(INSTALL) -m644 '$(1)/include/libirc_rfcnumeric.h' '$(PREFIX)/$(TARGET)/include/libircclient'
    $(INSTALL) -m644 '$(1)/include/libirc_options.h' '$(PREFIX)/$(TARGET)/include/libircclient'

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libircclient.exe' \
        -lircclient -lws2_32
endef

$(PKG)_BUILD_SHARED =
