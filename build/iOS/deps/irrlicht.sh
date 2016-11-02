#!/bin/bash -e

. ../sdk.sh

[ ! -d irrlicht-src ] && \
	git clone https://github.com/MoNTE48/irrlicht -b stable irrlicht-src

cd irrlicht-src/

cd source/Irrlicht/iOS
xcodebuild build \
	-project iOS.xcodeproj \
	-destination generic/platform=iOS
cd ../../..

[ -d ../irrlicht ] && rm -r ../irrlicht
mkdir -p ../irrlicht
cp source/Irrlicht/iOS/build/Release-iphoneos/libIrrlicht.a ../irrlicht/
cp -r include ../irrlicht/include
cp -r media ../irrlicht/media

echo "Irrlicht build successful"
