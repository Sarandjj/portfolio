#!/bin/bash

# Stop the script if any command fails
set -e

# STEP 1: Build the Flutter web app
flutter build web --release --dart-define=FLUTTER_WEB_RENDERER=canvaskit

# STEP 2: Copy your SEO and meta files into the build directory
echo "🔁 Copying SEO files to build/web..."

cp ./seo/robots.txt ./build/web/
cp ./seo/sitemap.xml ./build/web/
cp ./seo/humans.txt ./build/web/

# If you have a .well-known directory
mkdir -p ./build/web/.well-known
cp .well-known/security.txt ./build/web/.well-known/

echo "✅ Flutter Web built with custom SEO files!"
