#!/usr/bin/env bash

set -e

# WARNING!!!
# If we build something we MUST use --build-bottle flag!!!
#
# https://docs.brew.sh/Bottles
# By default, bottles will be built for the oldest CPU supported by the OS/architecture you’re building for
# (Core 2 for 64-bit OSs). This ensures that bottles are compatible with all computers you might distribute
# them to. If you really want your bottles to be optimized for something else, you can pass the --bottle-arch=
# option to build for another architecture; for example, brew install foo --build-bottle --bottle-arch=penryn.
# Just remember that if you build for a newer architecture some of your users might get binaries they can’t
# run and that would be sad!

brew tap osgeo/osgeo4mac

#cask
brew cask install java
brew cask install XQuartz # requirement of osgeo-grass

# tools & common libraries
brew install git
brew install cmake
brew install ninja
brew install gsl
brew install bison
brew install flex
brew install pkg-config
brew install python
brew install fcgi
brew install openvpn
brew install szip
pip3 install GitPython
pip3 install owslib
pip3 install colorama
brew install wget
brew install bash-completion
brew install gettext
#/usr/local/opt/osgeo-grass/grass-base/include/grass/glocale.h:9:10: fatal error: 'libintl.h' file not found
brew link gettext --force
brew install gpsbabel
brew install gsl
brew install exiv2
brew install qca
brew install qwt
brew install qwtpolar
brew install expat
brew install libpq
brew install curl
brew install libzip
brew install libtasn1
brew install hicolor-icon-theme
brew install libiconv
brew install openssl
brew install poppler
brew install gnu-sed

# https://github.com/al45tair/dmgbuild/issues/12
brew install python@2
pip3 install pip
pip install dmgbuild


# r
brew install r

# scipy
brew install scipy

# data storage
brew install osgeo-netcdf
brew install hdf5
brew install sqlite

# spatialindex
brew install spatialindex

# qt
brew install osgeo-sip
brew link osgeo-sip
brew install qt
brew install qjson
brew install osgeo/osgeo4mac/osgeo-qt-webkit
brew install osgeo/osgeo4mac/osgeo-qt-mysql
brew install osgeo/osgeo4mac/osgeo-qt-odbc
brew install osgeo/osgeo4mac/osgeo-qt-psql
brew install osgeo/osgeo4mac/osgeo-pyqt
brew link osgeo-pyqt
brew install osgeo/osgeo4mac/osgeo-pyqt-webkit
brew link osgeo-pyqt-webkit --force
brew install osgeo/osgeo4mac/osgeo-qscintilla2
brew install osgeo/osgeo4mac/osgeo-qtkeychain

# proj
brew install osgeo-proj
pip3 install python-dateutil
pip3 install cython
pip3 install pyproj

# mrsid
brew install osgeo/osgeo4mac/osgeo-mrsid-sdk

# ecwjp2
brew install osgeo/osgeo4mac/osgeo-ecwjp2-sdk

# saga
brew install osgeo/osgeo4mac/osgeo-saga-lts

# postgis
brew install osgeo/osgeo4mac/osgeo-postgresql
brew install osgeo/osgeo4mac/osgeo-postgis

# oracle
# brew install oracle-client-sdk

# spatialite
brew install osgeo/osgeo4mac/osgeo-libspatialite
brew install osgeo/osgeo4mac/osgeo-pyspatialite

# geos
brew install geos

# gdal
brew install osgeo/osgeo4mac/osgeo-gdal
brew link osgeo-gdal --force
brew install osgeo/osgeo4mac/osgeo-gdal-python
brew install osgeo/osgeo4mac/osgeo-gdal-mrsid
brew install osgeo/osgeo4mac/osgeo-gdal-ecwjp2
# brew install osgeo/osgeo4mac/osgeo-gdal-filegdb
# brew install osgeo/osgeo4mac/osgeo-gdal-mdb
# brew install osgeo/osgeo4mac/osgeo-gdal-mongodb
# brew install osgeo/osgeo4mac/osgeo-gdal-mysql
# brew install osgeo/osgeo4mac/osgeo-gdal-ogdi
# brew install osgeo/osgeo4mac/osgeo-gdal-oracle
# brew install osgeo/osgeo4mac/osgeo-gdal-pdf
# brew install osgeo/osgeo4mac/osgeo-gdal-sosi

# grass
brew install osgeo-grass

# matplotlib
brew install numpy
brew install osgeo-matplotlib
brew link --overwrite numpy

# python modules
pip3 install certifi
pip3 install chardet
pip3 install idna
pip3 install OWSLib
pip3 install cython
pip3 install pyproj
pip3 install python-dateutil
pip3 install pytz
pip3 install requests
pip3 install six
pip3 install urllib3
pip3 install coverage
pip3 install funcsigs
pip3 install future
pip3 install mock
pip3 install nose2
pip3 install pbr
pip3 install psycopg2
pip3 install PyYAML
pip3 install Jinja2
pip3 install MarkupSafe
pip3 install Pygments
pip3 install termcolor
pip3 install oauthlib
pip3 install pyOpenSSL
pip3 install numpy
pip3 install certifi
pip3 install chardet
pip3 install coverage
pip3 install cycler
pip3 install decorator
pip3 install exifread
pip3 install future
pip3 install GDAL==2.4.0
pip3 install h5py
pip3 install httplib2
pip3 install idna
pip3 install ipython-genutils
pip3 install jinja2
pip3 install jsonschema
pip3 install jupyter-core
pip3 install kiwisolver
pip3 install markupsafe
pip3 install matplotlib
pip3 install mock
pip3 install mock
pip3 install nbformat
pip3 install networkx
pip3 install nose2
pip3 install numpy
pip3 install owslib
pip3 install pandas
pip3 install pbr
pip3 install plotly
pip3 install ply
pip3 install psycopg2
pip3 install pygments
pip3 install pyodbc
pip3 install pyparsing
pip3 install pypubsub
pip3 install pysal
pip3 install pytz
pip3 install pyyaml
pip3 install requests
pip3 install retrying
pip3 install scipy
pip3 install setuptools
pip3 install shapely
pip3 install simplejson
pip3 install six
pip3 install test
pip3 install tools
pip3 install traitlets
pip3 install urllib3
pip3 install xlrd
pip3 install xlwt
pip3 install pillow
