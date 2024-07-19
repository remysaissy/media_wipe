#!/bin/sh

BUILD_NUMBER="$(date +'%Y%m%d%H%M')"

flutter clean
flutter build ios --build-number=$BUILD_NUMBER --release --obfuscate --split-debug-info=symbols
mv symbols/app.ios-arm64.symbols symbols/app-$BUILD_NUMBER.ios-arm64.symbols
echo "Now open XCode, Product::Archive, Validate it and upload to the App Store"
echo "Symbols: symbols/app-$BUILD_NUMBER.ios-arm64.symbols"
echo "Don't forget to git add and commit if the build is deployed."
