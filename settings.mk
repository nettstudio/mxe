JOBS := 8
MXE_TARGETS := i686-w64-mingw32.static x86_64-w64-mingw32.static
MXE_PLUGIN_DIRS := plugins/gcc7
LOCAL_PKG_LIST := cc cmake libressl qtbase
.DEFAULT_GOAL := local-pkg-list
local-pkg-list: $(LOCAL_PKG_LIST)
