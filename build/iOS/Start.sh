#!/bin/bash -e

echo
echo "Starting build MultiCraft for iOS..."

echo
echo "Run sdk.sh:"

./sdk.sh

echo
echo "Build Libraries:"

./libraries.sh

echo
echo "Creating Assets.zip:"

./assets.sh

echo
echo "Install pods:"

pods install

echo
echo "All done! You can continue in Xcode!"
