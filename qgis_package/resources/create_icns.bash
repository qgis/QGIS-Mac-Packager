#!/usr/bin/env bash

# https://stackoverflow.com/a/20703594/2838364

ICON="qgis-icon-macos.png"
OUT="QGIS"

mkdir ${OUT}.iconset
sips -z 16 16     $ICON --out ${OUT}.iconset/icon_16x16.png
sips -z 32 32     $ICON --out ${OUT}.iconset/icon_16x16@2x.png
sips -z 32 32     $ICON --out ${OUT}.iconset/icon_32x32.png
sips -z 64 64     $ICON --out ${OUT}.iconset/icon_32x32@2x.png
sips -z 128 128   $ICON --out ${OUT}.iconset/icon_128x128.png
sips -z 256 256   $ICON --out ${OUT}.iconset/icon_128x128@2x.png
sips -z 256 256   $ICON --out ${OUT}.iconset/icon_256x256.png
sips -z 512 512   $ICON --out ${OUT}.iconset/icon_256x256@2x.png
sips -z 512 512   $ICON --out ${OUT}.iconset/icon_512x512.png
cp $ICON ${OUT}.iconset/icon_512x512@2x.png
iconutil -c icns ${OUT}.iconset
rm -R ${OUT}.iconset