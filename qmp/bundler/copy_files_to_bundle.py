# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import glob
from .utils import *
from ..common import QGISBundlerError


def _append_recursively_site_packages(msg, pa, cp, sourceDir, destDir):
    for item in os.listdir(sourceDir):
        s = os.path.join(sourceDir, item)
        d = os.path.join(destDir, item)
        # do not copy sip pyqt5, because link is also in global site-packages and pyqt5's Qt libraries are
        # not copied
        if os.path.exists(d) or (s == pa.host.sipCellar):
            msg.dbg("Skipped " + s)
            continue
        else:
            msg.dev(" Copied " + s + " ~~~~> " + d)

        if os.path.isdir(s):
            # hard copy - no symlinks
            cp.copytree(s, d, False)

            if os.path.exists(d + "/.dylibs"):
                msg.dev("Removing extra " + d + "/.dylibs")
                cp.rmtree(d + "/.dylibs")
        else:
            # if it is link, copy also content of the dir of that link.
            # this is because pth files can get other site-packages
            # but we want it on one place
            if os.path.islink(s):
                dirname = os.path.realpath(s)
                dirname = os.path.dirname(dirname)
                msg.dev("packaging also site-package " + dirname)
                _append_recursively_site_packages(msg, pa, cp, dirname, destDir)

            # this can contain also site-packages with absolute path
            if s.endswith(".pth"):
                with open(s, 'r') as myfile:
                    dirname = myfile.read().strip()
                if os.path.isdir(dirname):
                    msg.dev("packaging also site-package " + dirname)
                    _append_recursively_site_packages(msg, pa, cp, dirname, destDir)

            if not os.path.exists(d):
                cp.copy(s, d)


def copy_files_to_bundle(cp, msg, pa):
    msg.info("Cleaning: " + pa.output.bundle)
    if os.path.exists(pa.output.bundle):
        cp.rmtree(pa.output.bundle)
        if os.path.exists(pa.output.bundle + "/.DS_Store"):
            cp.remove(pa.output.bundle + "/.DS_Store")

    msg.info("Copying " + pa.output.install)
    if not os.path.exists(pa.output.install):
        raise QGISBundlerError(pa.output.install + " does not exists")
    cp.copytree(pa.output.install, pa.output.bundle, symlinks=True)
    if pa.args.qgisapp_name != "QGIS.app":
        cp.rename(os.path.join(pa.output.bundle, "QGIS.app"), pa.qgisApp)
    if not os.path.exists(pa.qgisApp):
        raise QGISBundlerError(pa.qgisExe + " does not exists")
    if not os.path.exists(pa.binDir):
        os.makedirs(pa.binDir)

    msg.info("Remove crssync")
    if os.path.exists(pa.libDir + "/qgis/crssync"):
        cp.rmtree(pa.libDir + "/qgis")

    # https://doc.qt.io/qt-5/sql-driver.html#supported-databases
    msg.info("Copying QT SQL Drivers")
    if not os.path.exists(pa.sqlDriversDir):
        os.makedirs(pa.sqlDriversDir)
    for item in [pa.mysqlDriverHost, pa.psqlDriverHost, pa.odbcDriverHost]:
        cp.copy(item, pa.sqlDriversDir)

    msg.info("Copying GDAL" + pa.host.gdal)
    for item in os.listdir(pa.host.gdal + "/bin"):
        cp.copy(pa.host.gdal + "/bin/" + item, pa.binDir)
    cp.copytree(pa.host.gdal + "/share/gdal", pa.gdalDataDir, symlinks=False)
    cp.copytree(pa.gdalPluginsHost, pa.gdalPluginsDir, symlinks=False)
    cp.chmodW(pa.gdalDataDir)

    # normally this should be on MacOS/bin/ so logic in GdalUtils.py works,
    # but .py file in MacOS/bin halts the signing of the bundle
    msg.info("Copying GDAL-PYTHON" + pa.gdalPythonHost)
    if not os.path.exists(pa.gdalDataDir + "/bin"):
        os.makedirs(pa.gdalDataDir + "/bin")
    if not os.path.exists(pa.binDir):
        cp.makedirs(pa.binDir)
    for item in os.listdir(pa.gdalPythonHost + "/bin"):
        if not os.path.isdir(pa.gdalPythonHost + "/bin/" + item):
            cp.copy(pa.gdalPythonHost + "/bin/" + item, pa.gdalDataDir + "/bin/" + item)
            cp.symlink(os.path.relpath(pa.gdalDataDir + "/bin/" + item, pa.binDir), pa.binDir + "/" + item)

    msg.info("Copying SAGA " + pa.sagaHost)
    cp.copy(pa.sagaHost + "/bin/saga_cmd", pa.binDir)
    # we need to have it in subfolder because there is where
    # qgis saga batch bash script expects the SAGA tools to be located
    cp.copytree(pa.sagaHost + "/share/saga", pa.sagaDataDir, symlinks=False)
    os.makedirs(pa.sagaDataDir + "/tools")
    for item in os.listdir(pa.sagaHost + "/lib/saga"):
        cp.copy(pa.sagaHost + "/lib/saga/" + item, pa.sagaDataDir + "/tools/" + item)
    cp.chmodW(pa.binDir)

    msg.info("Copying GRASS7 " + pa.grass7Host)
    cp.copytree(pa.grass7Host, pa.grass7Dir, symlinks=True)
    for item in os.listdir(pa.grass7Host + "/lib"):
        if os.path.islink(pa.grass7Host + "/lib/" + item):
            linkto = os.readlink(pa.grass7Host + "/lib/" + item)
            os.symlink(linkto, pa.libDir + "/" + item)
        else:
            cp.copy(pa.grass7Host + "/lib/" + item, pa.libDir + "/" + item)
    cp.rmtree(pa.grass7Dir + "/lib")
    cp.copy(pa.grass7Host + "/../bin/" + pa.version.grass, pa.grass7Dir + "/bin")
    cp.copy(pa.grass7Host + "/../libexec/bin/" + pa.version.grass, pa.grass7Dir + "/bin/_" + pa.version.grass)
    cp.chmodW(pa.grass7Dir)
    cp.chmodX(pa.grass7Dir + "/bin")

    msg.info("Remove unneeded qgis_bench.app")
    if os.path.exists(pa.binDir + "/qgis_bench.app"):
        cp.rmtree(pa.binDir + "/qgis_bench.app")

    msg.info("Remove unneeded qgis_process.app")
    if os.path.exists(pa.binDir + "/qgis_process.app"):
        cp.rmtree(pa.binDir + "/qgis_process.app")

    msg.info("Append Python site-packages " + pa.host.pySitePackages)
    _append_recursively_site_packages(msg, pa, cp, pa.host.pySitePackages, pa.pythonDir)
    if not os.path.exists(pa.pythonDir + "/PyQt5/Qt.so"):
        raise QGISBundlerError("PyQt5 missing: " + pa.pythonDir + "/PyQt5/Qt.so")
    if not os.path.exists(pa.pythonDir + "/PyQt5/sip.so"):
        raise QGISBundlerError("PyQt5 missing: " + pa.pythonDir + "/PyQt5/sip.so")

    # TODO copy of python site-packages should be rather
    # selective an not copy-all and then remove
    msg.info("remove not needed python site-packages")
    redundantPyPackages = [
        "dropbox*",
        "GitPython*",
        "homebrew-*",
    ]
    for pp in redundantPyPackages:
        for path in glob.glob(pa.pythonDir + "/" + pp):
            msg.dev("Removing " + path)
            if os.path.isdir(path):
                cp.rmtree(path)
            else:
                cp.remove(path)
    cp.chmodW(pa.pluginsDir)

    msg.info("add pyqgis_startup.py to remove MacOS default paths")
    startup_script = os.path.join(pa.package.resources, "pyqgis-startup.py")
    if not os.path.exists(startup_script):
        raise QGISBundlerError("Missing resource " + startup_script)
    cp.copy(startup_script, os.path.join(pa.pythonDir, "pyqgis-startup.py"))

    msg.info("Copying PyQt plugins " + pa.host.pyqtPluginFile)
    cp.copytree(pa.host.pyqtPluginFile, pa.pluginsDir + "/PyQt5", True)
    cp.chmodW(pa.pluginsDir + "/PyQt5")

    msg.info("Copying mod_spatiallite")
    cp.copy(pa.host.mod_spatialite, os.path.join(pa.libDir, pa.version.mod_spatialite))

    msg.info("Copy PROJ shared folder")
    cp.copytree(pa.projHost, pa.projDir, True)
    for item in os.listdir(pa.projDatumGridsHost):
        src = pa.projDatumGridsHost + "/" + item
        dest = pa.projDir + "/proj/" + item
        if os.path.exists(dest):
            cp.remove(dest)
        cp.copy(src, dest)

    msg.info("Copy GEOTIFF shared folder")
    cp.copytree(pa.geotiffHost, pa.geotiffDir, True)

    # at the end make it all writable
    cp.chmodW(pa.contentsDir)
