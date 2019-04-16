# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import os

from .common import QGISMacPackagerError


class PathGroup():
    pass


class Paths:
    def __init__(self, args):
        self.args = args

        self.package = PathGroup() # destinations in the QGIS-Mac-Packager
        self.host = PathGroup() # destinations on the host system
        self.output = PathGroup()  # destinations in the output directory
        self.bundle = PathGroup() # destinations in the output/bundle directory
        self.install = PathGroup() # destination in the install location on user machine
        self.version = PathGroup() # versions of the libraries

        self.version.grass = "grass76"
        self.version.grassBrew = "7.6.1_3"
        self.version.grassFull = "grass-7.6.1"
        self.version.mod_spatialite = "mod_spatialite.7.dylib"
        self.version.python = "python3.7"
        self.version.saga = "2.3.2_3"
        self.version.projLib = "libproj.15.dylib" # proj.13 is proj4, proj.15 is proj6
        self.version.libwx = "3.0"
        self.version.libwxFull = "3.0.0.4.0"
        self.version.libpq = "5.10"
        self.version.libpqFull = "5"
        self.version.cpython = "cpython-37m-darwin"
        self.version.sip = "4.19.15"
        self.version.minos = "10.11.0" # MACOS minimum supported OS

        # jpeg.9 is /usr/local/Cellar/jpeg/9c/lib/libjpeg.9.dylib
        # required by others
        # jpeg.8 is /usr/local/Cellar/jpeg-turbo/2.0.0/lib/libjpeg.8.dylib
        # required by /osgeo4mac/osgeo-qt-webkit
        # hdf5
        # /usr/local/Cellar//hdf5/1.10.4/lib/libhdf5.103.dylib
        # required by others
        # /usr/local/lib/python3.7//site-packages/h5py/.dylibs/libhdf5.101.dylib
        # required by h5py
        # QOpenGLFunctions
        # 2.0 and 2.1 already in /usr/local/Cellar/osgeo-pyqt/5.10.1_1/lib/python3.7/site-packages/osgeo-pyqt/
        # PQ: used by saga
        # libz and libopenjp2 : PIL (pillow) dep
        # proj.13 is proj5, proj.15 is proj6: SAGA still uses proj5.2
        self.version.exceptions = [
            "_QOpenGLFunctions_2_0.so", "_QOpenGLFunctions_2_1.so",
            "libhdf5.101.dylib", "libhdf5.103.dylib",
            "libjpeg.8.dylib", "libjpeg.9.dylib",
            "libpq.5.10.dylib", "libpq.5.11.dylib",
            "libopenjp2.2.1.0.dylib", "libopenjp2.7.dylib",
            "libz.1.dylib", "libz.1.2.11.dylib",
            "libproj.15.dylib", "libproj.13.dylib"  
            "libicudata.63.dylib", "libicudata.63.1.dylib"
        ]

        # destinations in the qgis-mac-packager
        self.package.dir = os.path.dirname(os.path.realpath(__file__))
        self.package.resources = os.path.join(self.package.dir, os.pardir, "resources")

        # destinations on host OS
        self.host.sipCellar = "/usr/local/Cellar/osgeo-sip/" + self.version.sip + "/lib/" + self.version.python + "/site-packages/PyQt5"
        self.host.pyqt = "/usr/local/opt/osgeo-pyqt/lib/python3.7/site-packages/PyQt5"
        self.host.pyqtPluginFile = os.path.join(self.host.pyqt, os.pardir, os.pardir, os.pardir, os.pardir, "share", "osgeo-pyqt", "plugins")
        self.host.pythonBase = "/usr/local/opt/python3/Frameworks/Python.framework/Versions/3.7"
        self.host.python = self.host.pythonBase + "/Python"
        self.host.pySitePackages = os.path.join(self.host.pythonBase, "lib", self.version.python, "site-packages")
        self.host.pythonDynload = self.host.pythonBase + "/lib/" + self.version.python + "/lib-dynload/"
        self.host.gdal = "/usr/local/opt/osgeo-gdal"
        self.host.gdalShare = self.host.gdal + "/share/gdal"
        self.gdalPythonHost = os.path.realpath(self.host.gdal + "-python")
        self.sagaHost = "/usr/local/opt/osgeo-saga-lts"
        self.host.grass = "/usr/local/opt/osgeo-grass"
        self.host.grass_base = "/usr/local/opt/osgeo-grass" + "/grass-base"
        self.grass7Host = self.host.grass_base # TODO remove
        self.host.grass7Cellar = "/usr/local/Cellar/osgeo-grass/" + self.version.grassBrew
        self.gdalPluginsHost = "/usr/local/lib/gdalplugins"
        self.mysqlDriverHost = "/usr/local/opt/osgeo-qt-mysql/lib/qt/plugins/sqldrivers/libqsqlmysql.dylib"
        self.psqlDriverHost =  "/usr/local/opt/osgeo-qt-psql/lib/qt/plugins/sqldrivers/libqsqlpsql.dylib"
        self.odbcDriverHost =  "/usr/local/opt/osgeo-qt-odbc/lib/qt/plugins/sqldrivers/libqsqlodbc.dylib"
        self.host.projLib = "/usr/local/opt/osgeo-proj/lib"
        self.projHost = "/usr/local/opt/osgeo-proj/share"
        self.projDatumGridsHost = self.package.dir + "/../../proj-datumgrid/grids"
        self.host.geotiff = "/usr/local/opt/osgeo-libgeotiff"
        self.geotiffHost = self.host.geotiff + "/share/epsg_csv"
        self.host.spatialite = "/usr/local/opt/osgeo-libspatialite"
        self.host.mod_spatialite = self.host.spatialite + "/lib/" + self.version.mod_spatialite
        self.host.sagaLibCellar = "/usr/local/Cellar/osgeo-saga-lts/" + self.version.saga + "/lib/saga"
        self.host.sagaShareCellar = "/usr/local/Cellar/osgeo-saga-lts/" + self.version.saga + "/share/saga"
        self.host.lapack = "/usr/local/opt/lapack/lib/"
        self.host.openblas = "/usr/local/opt/openblas/lib"
        self.host.path = "/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
        self.host.qt = "/usr/local/opt/qt"
        self.host.webkit = "/usr/local/opt/osgeo-qt-webkit"
        self.host.qscintilla2 = "/usr/local/opt/osgeo-qscintilla2"
        self.host.qwt = "/usr/local/opt/qwt"
        self.host.qwtpolar = "/usr/local/opt/qwtpolar"
        self.host.qca = "/usr/local/opt/qca"
        self.host.gsl = "/usr/local/opt/gsl"
        self.host.geos = "/usr/local/opt/geos"
        self.host.proj = "/usr/local/opt/osgeo-proj"
        self.host.spatialindex = "/usr/local/opt/spatialindex"
        self.host.fcgi = "/usr/local/opt/fcgi"
        self.host.expat = "/usr/local/opt/expat"
        self.host.sqlite = "/usr/local/opt/sqlite"
        self.host.flex = "/usr/local/opt/flex"
        self.host.bison = "/usr/local/opt/bison"
        self.host.lizip = "/usr/local/opt/libzip"
        self.host.tasn1 = "/usr/local/opt/libtasn1"
        self.host.libdir = "/usr/local"


        self.host.cmakePrefix = ";".join([
            self.host.qt,
            self.host.webkit,
            self.host.qscintilla2,
            self.host.qwt,
            self.host.qwtpolar,
            self.host.qca,
            self.host.gdal,
            self.host.gsl,
            self.host.geos,
            self.host.proj,
            self.host.spatialite,
            self.host.spatialindex,
            self.host.fcgi,
            self.host.expat,
            self.host.flex,
            self.host.bison,
            self.host.lizip,
            self.host.tasn1,
            self.host.grass,
            self.host.geotiff,
            self.host.libdir
        ])

        # new output destinations
        self.output.root = os.path.realpath(args.output_directory)
        self.output.qgis = os.path.join(self.output.root, "qgis")
        self.output.build = os.path.join(self.output.root, "build")
        self.output.install = os.path.join(self.output.root, "install")
        self.output.bundle = os.path.join(self.output.root, "bundle")
        self.output.dmg = os.path.join(self.output.root, args.dmg_name)

        # new bundle destinations
        self.qgisApp = os.path.join(self.output.bundle, args.qgisapp_name)
        self.contentsDir = os.path.join(self.qgisApp, "Contents")
        self.macosDir = os.path.join(self.contentsDir, "MacOS")
        self.frameworksDir = os.path.join(self.contentsDir, "Frameworks")
        self.libDir = os.path.join(self.macosDir, "lib")
        self.qgisExe = os.path.join(self.macosDir, "QGIS")
        self.pluginsDir = os.path.join(self.contentsDir, "PlugIns")
        self.qgisPluginsDir = os.path.join(self.pluginsDir, "qgis")
        self.resourcesDir = os.path.join(self.contentsDir, "Resources")
        self.pythonDir = os.path.join(self.resourcesDir, "python")
        self.binDir = os.path.join(self.macosDir, "bin")
        self.grass7Dir = os.path.join(self.resourcesDir, "grass7")
        self.gdalDataDir = os.path.join(self.resourcesDir, "gdal")
        self.gdalPluginsDir = os.path.join(self.gdalDataDir, "gdalplugins")
        self.sagaDataDir = os.path.join(self.resourcesDir, "saga")
        self.sqlDriversDir = os.path.join(self.pluginsDir, "sqldrivers")
        self.projDir = os.path.join(self.resourcesDir, "proj")
        self.geotiffDir = os.path.join(self.resourcesDir, "geotiff")

        # install location
        self.installQgisAppName = args.qgisapp_name
        self.installQgisApp = "/Applications/" + self.installQgisAppName
        self.installQgisLib = self.installQgisApp + "/Contents/MacOS/lib"
        self.sagaShareInstall = self.installQgisApp + "/Contents/Resources/saga"
        self.grass7Install = self.installQgisApp + "/Contents/Resources/grass7"
        self.projShareInstall = self.installQgisApp + "/Contents/Resources/proj"
        self.geotiffShareInstall = self.installQgisApp + "/Contents/Resources/geotiff"
        self.gdalShareInstall = self.installQgisApp + "/Contents/Resources/gdal"
        self.gdalPluginsInstall = self.installQgisApp + "/Contents/Resources/gdal/gdalplugins"

    def verify(self):
        # check input args
        if "/" in self.args.qgisapp_name:
            raise QGISMacPackagerError(self.args.qgisapp_name + " must not contain path separator")

        # check host paths exist
        expected_paths = [
            self.host.libdir,
            self.package.resources,
            self.host.pyqt,
            self.host.pyqtPluginFile,
            self.host.python,
            os.path.dirname(self.host.python) + "/lib/python3.7/site-packages/PyQt5/QtCore.so",
            self.host.gdal + "/bin",
            self.sagaHost + "/bin",
            self.grass7Host + "/bin",
            self.host.grass7Cellar + "/libexec/bin/" + self.version.grass,
            self.projHost + "/proj/proj.db",
            self.geotiffHost + "/coordinate_system.csv",
            self.projDatumGridsHost,
            self.gdalPluginsHost,
            self.mysqlDriverHost,
            self.psqlDriverHost,
            self.odbcDriverHost,
            self.grass7Host + "/../bin/" + self.version.grass,
            self.host.mod_spatialite,
            self.host.sagaLibCellar,
            self.host.sagaShareCellar,
            self.host.lapack,
            self.host.openblas,
            self.host.gdalShare,
            self.host.qt,
            self.host.webkit,
            self.host.qscintilla2,
            self.host.qwt,
            self.host.qwtpolar,
            self.host.qca,
            self.host.gdal,
            self.host.gsl,
            self.host.geos,
            self.host.proj,
            self.host.spatialite,
            self.host.spatialindex,
            self.host.fcgi,
            self.host.expat,
            self.host.flex,
            self.host.bison,
            self.host.lizip,
            self.host.tasn1,
            self.host.grass,
            self.host.geotiff,
            self.host.pythonDynload
        ]

        for f in expected_paths:
            if not os.path.exists(f):
                raise QGISMacPackagerError(f + " does not exists")
