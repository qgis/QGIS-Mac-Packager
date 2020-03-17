Prerequisities
--------------

1. XCode and xcode command line tools. Check by opening XCode and try to build hello world
2. Install Python 3.x from https://www.python.org/downloads/mac-osx/. Python should be installed in the location /Library/Frameworks/Python.framework/Versions/3.7 or similar.
3. Install QT 5.x from the official Maintanance tool from https://www.qt.io/download. Qt for MacOS should be installed in location /opt/Qt/5.13.1 or similar
4. Cmake and other build tools. Use homebrew  (see scripts/install_brew.bash and scripts/install_brew_dev_packages)

Build QGIS-deps
---------------

1. Update config.conf
2. run `./distribute.sh -mqgis`

Build QGIS (Qt Creator)
-----------------------

1. Open Qt Creator
2. Open QGIS CMakeLists.txt
3. In Kits, setup native Qt (from prerequisities)
4. In Build Environment, setup LIB_DIR=<path from config.conf>/qgis-deps-<release_version>/stage 
5. In Build Environment, setup CMAKE_PREFIX_PATH=/opt/Qt/<qt_version>/clang_64:${LIB_DIR}
6. Rerun cmake from menu (Clear Cmake Configration + run Cmake)
7. Build

License & Acknowledgement
-------------------------
- [distribute.sh](https://github.com/opengisch/OSGeo4A/blob/master/LICENSE-for-distribute-sh) MIT license, Copyright (c) 2010-2013 Kivy Team and other contributors