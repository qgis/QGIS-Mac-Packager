Prerequisities
--------------

1. XCode and xcode command line tools. Check by opening XCode and try to build hello world
2. Install QT 5.x from the official Maintanance tool from https://www.qt.io/download. Qt for MacOS should be installed in location /opt/Qt/5.15.2 or similar
3. Cmake and other build tools. You can use homebrew (see scripts/install_brew_dev_packages) or other means

Build QGIS-deps
---------------

Note: if you want to just develop QGIS and not the qgis-deps package,
skip this and go to build QGIS step

1. Update config/qgis-deps-dev.conf (usually not needed)
2. Run `./build-deps.bash`
3. Take a break and cross your fingers

Upload deps to qgis.org
------------------
For this you need to have QGIS signing certificate, and ssh access to qgis.org
Usually this is done on build server and it is not necessary for development of 
the qgis-deps pacakges

1. Build QGIS-Deps
2. Run `sign_deps.bash _DEPS_VERSION_`
3. Run `create_package.bash _DEPS_VERSION_`
4. Run `upload_to_qgis2.bash _DEPS_VERSION_`

How to create patch file
-----------------------
diff -rupN file.orig file

Build QGIS
-----------------------

1. Build QGIS-deps or download&extract from [qgis download area](https://qgis.org/downloads/macos/deps/)
2. Run 
```
cd <qgis-build-dir>
PATH=<qgis-deps>/stage/bin:$PATH \
cmake -DQGIS_MAC_DEPS_DIR=<qgis-deps>/stage \
      -DCMAKE_PREFIX_PATH=<qt-path>/clang_64 \
      -DQGIS_MACAPP_BUNDLE=0 \
      -DWITH_QT5SERIALPORT=FALSE \
      -DWITH_GRASS=OFF \
      <qgis-git-repo>
```
3. Run `make`

Alternatively you can 

2. Open QT Creator and load CMakeLists of QGIS
3. Setup Kit in Qt Creator with QT from /opt/QT (as in prerequisities)
4. Set/Add in Projects>Build Settings>Cmake similarly to `configure_qgis_build.bash`
5. Rerun cmake from menu (Clear Cmake Configration + run Cmake)
6. Build

License & Acknowledgement
-------------------------
- original copy of [distribute.sh](https://github.com/opengisch/OSGeo4A/blob/master/LICENSE-for-distribute-sh) 
