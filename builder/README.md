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

0. build QGIS-deps or download&extract from qgis download area
1. Go to the qgis-deps folder and activate virtualenv (source bin/activate)
2. Open QT Creator and load CMakeLists of QGIS
3. Setup Kit in Qt Creator with QT from /opt/QT (as in prerequisities)
4. Set/Add in Projects>Build Settings>Cmake
  - QGIS_MAC_DEPS_DIR=dir with stage/lib dir 
  - QGIS_MACAPP_BUNDLE=0
  - WITH_QTWEBKIT=FALSE
  - WITH_QT5SERIALPORT=FALSE
  - BISON_EXECUTABLE=/usr/local/opt/bison/bin/bison
  - FLEX_EXECUTABLE=/usr/local/opt/flex/bin/flex
  
Alternatively create a folder build-QGIS (next to QGIS repo), cd into folder and run 
```
QGIS_DEPS=<path/to/qgis-deps-0.1.0/stage>;\
QT_BASE=/opt/Qt/<QT version>/clang_64;\
cmake -DQGIS_MAC_DEPS_DIR=$QGIS_DEPS \
      -DCMAKE_PREFIX_PATH=$QT_BASE \
      -DQGIS_MACAPP_BUNDLE=0 \
      -DWITH_QTWEBKIT=FALSE \
      -DWITH_QT5SERIALPORT=FALSE \
      -DBISON_EXECUTABLE=/usr/local/opt/bison/bin/bison \
      -DFLEX_EXECUTABLE=/usr/local/opt/flex/bin/flex ../QGIS/ \
      -DWITH_GRASS=OFF
```
5. Rerun cmake from menu (Clear Cmake Configration + run Cmake)
6. Build

License & Acknowledgement
-------------------------
- [distribute.sh](https://github.com/opengisch/OSGeo4A/blob/master/LICENSE-for-distribute-sh) 