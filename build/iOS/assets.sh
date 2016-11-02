#!/bin/bash -e

if [ ! -d MultiCraft/MultiCraft.xcodeproj ]; then
	echo "Run this in build/iOS"
	exit 1
fi

DEST=$(mktemp -d)

for dir in builtin client textures; do
	cp -r ../../$dir $DEST/$dir
done
mkdir -p $DEST/fonts
cp ../../fonts/*.ttf $DEST/fonts/ # PNG fonts useless with freetype
mkdir -p $DEST/games
cp -r ../../games/default $DEST/games/default
mkdir -p $DEST/media
cp -r deps/irrlicht/media/Shaders $DEST/media/Shaders

find $DEST -type d -name '.git' -print0 | xargs -0 -- rm -r
find $DEST -type f -name '.git*' -delete
find $DEST -type f -name '.DS_Store' -delete

echo "Creating assets.zip"
ZIPDEST=$(pwd)/assets.zip
rm -f $ZIPDEST

cd $DEST; zip -9r $ZIPDEST -- *
cd /; rm -rf $DEST
