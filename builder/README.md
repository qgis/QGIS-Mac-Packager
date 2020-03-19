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

1. run `./distribute.sh -B`
2. Rerun cmake from menu (Clear Cmake Configration + run Cmake)
3. Set Projects>Build Settings>Cmake option QGIS_MACAPP_BUNDLE=0
4. If it stops on "unable to find Qt5WebKit module or Qt5SerialPort", 
   your Qt installation is probably without this module. 
   Open Projects>Build Settings>Cmake and add "WITH_QTWEBKIT=FALSE" and/or "WITH_QT5SERIALPORT=FALSE"
5. Build

License & Acknowledgement
-------------------------
- [distribute.sh](https://github.com/opengisch/OSGeo4A/blob/master/LICENSE-for-distribute-sh) MIT license, Copyright (c) 2010-2013 Kivy Team and other contributors