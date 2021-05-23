#!/bin/bash
#
# FusePDF - https://nettstudio.no
#
# Copyright (c) 2021 NettStudio AS. All rights reserved.
#
#

CWD=`pwd`
APP=$CWD/..
BUILD_DIR=${BUILD_DIR:-"${CWD}/tmp"}
MXE=${MXE:-"${CWD}"}
MXE_TC=${MXE_TC:-x86_64-w64-mingw32.static}
STRIP=${MXE_TC}-strip
TIMESTAMP=${TIMESTAMP:-`date +%Y%m%d%H%M`}
VERSION=`cat $APP/fusepdf.pro | sed '/VERSION =/!d' | awk '{print $3}'`
COMMIT=`(cd $APP; git rev-parse --short HEAD)`
TAG=${TAG:--${TIMESTAMP}-${COMMIT}}
ZIP="FusePDF-$VERSION$TAG.zip"
FOLDER="FusePDF-$VERSION$TAG"

if [ ! -d "${MXE}" ]; then
    echo "Please setup MXE!"
    exit 1
fi
rm -rf "${BUILD_DIR}" || true
mkdir -p "${BUILD_DIR}" && cd "${BUILD_DIR}" || exit 1

export PATH="${MXE}/usr/bin:${MXE}/usr/${MXE_TC}/qt5/bin:${PATH}"
export PKG_CONFIG_PATH="${MXE}/usr/${MXE_TC}/lib/pkgconfig"

qmake CONFIG+=release ${APP} || exit 1
make || exit 1
mkdir $FOLDER || exit 1
cp -a $APP/COPYING $FOLDER/ || exit 1
cp release/FusePDF.exe $FOLDER || exit 1
$STRIP -s $FOLDER/*.exe || exit 1
zip -r -9 $ZIP $FOLDER || exit 1

echo "DONE!"
