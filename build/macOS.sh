#!/bin/bash -e

if [ ! -f ../CMakeLists.txt ]; then
	echo "Please run from build/ directory"
	exit 1
fi

brew install cmake freetype gettext irrlicht leveldb lib{ogg,vorbis} luajit
echo

mkdir -p build-macOS
cd build-macOS

cmake ../.. -G Xcode \
	-DCMAKE_BUILD_TYPE=Release -DENABLE_{FREETYPE,LEVELDB,GETTEXT}=TRUE \
	-DBUILD_SERVER=FALSE -DCUSTOM_GETTEXT_PATH=/usr/local/opt/gettext \
	-DCMAKE_EXE_LINKER_FLAGS="-L/usr/local/lib"

echo "OK"
open MultiCraft.xcodeproj
