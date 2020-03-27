Prerequisities
--------------

1. XCode and xcode command line tools. Check by opening XCode and try to build hello world
2. Install QT 5.x from the official Maintanance tool from https://www.qt.io/download. Qt for MacOS should be installed in location /opt/Qt/5.13.1 or similar
3. Cmake and other build tools. Use homebrew  (see scripts/install_brew.bash and scripts/install_brew_dev_packages)

Build QGIS-deps
---------------

Note: if you want to just develop QGIS and not the qgis-deps package,
skip this and go to build QGIS step

1. Update config.conf (usually not needed)
2. Run `./distribute.sh -mqgis_deps`
3. Enjoy

Build QGIS
-----------------------

1. Build QGIS-deps or download&extract from [qgis download area](https://qgis.org/downloads/macos/deps/)
2. Run `./configure_qgis_build.bash <path/to/qgis/QGIS/repo> </path/to/build-QGIS>` (or look at the script to 
see the CMAKE vars needed, critical variable is `QGIS_MAC_DEPS_DIR`)
3. Run make in </path/to/build-QGIS>

Alternatively you can 
2. Open QT Creator and load CMakeLists of QGIS
3. Setup Kit in Qt Creator with QT from /opt/QT (as in prerequisities)
4. Set/Add in Projects>Build Settings>Cmake similarly to `configure_qgis_build.bash`
5. Rerun cmake from menu (Clear Cmake Configration + run Cmake)
6. Build

License & Acknowledgement
-------------------------
- original copy of [distribute.sh](https://github.com/opengisch/OSGeo4A/blob/master/LICENSE-for-distribute-sh) 