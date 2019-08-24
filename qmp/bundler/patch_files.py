# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import os

from .utils import is_text
from ..common import QGISBundlerError


def _patch_file(pa, filepath, keyword, replace_from, replace_to):
    realpath = os.path.realpath(filepath)
    if not os.path.exists(realpath) or pa.qgisApp not in realpath:
        raise QGISBundlerError("Invalid file to patch " + filepath)

    if pa.qgisApp in replace_to:
        raise QGISBundlerError("Wrong destination! " + replace_to)

    with open(filepath, "r") as f:
        c = f.read()

        if keyword in c:
            raise QGISBundlerError("Ups {} already present in info {}".format(keyword, filepath))

        c = c.replace(replace_from,
                      replace_to)

    with open(filepath, "w") as f:
        f.write(c)

    # check
    with open(filepath, "r") as f:
        c = f.read()
        if keyword not in c:
            raise QGISBundlerError("Ups failed to add {} in info {}".format(keyword, filepath))


def patch_files(msg, pa, min_os):
    patch_info_plist(pa, min_os)
    patch_sqlite(pa)
    patch_text_files(msg, pa)


def patch_info_plist(pa, min_os):
    add_python_home = True
    add_python_start = True
    add_python_path = True
    add_grass7_folder = True
    add_qgis_prefix = True
    add_gdal_paths = True
    add_proj_path = True
    add_quarantine = True
    patchCFBundleIdentifier = True
    patchBundleName = False
    patchBundleSignature = True

    destContents = pa.installQgisApp + "/Contents"

    # Info.plist
    # https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/LaunchServicesKeys.html#//apple_ref/doc/uid/20001431-113253
    infoplist = os.path.join(pa.contentsDir, "Info.plist")
    if not os.path.exists(infoplist):
        raise QGISBundlerError("MISSING " + infoplist)

    # CFBundleIdentifier
    if patchCFBundleIdentifier:
        identifier = pa.installQgisAppName.replace(".app", "").lower().replace(".", "")
        _patch_file(pa,
                    infoplist,
                    identifier,
                    "org.qgis.qgis3",
                    "org.qgis.{}".format(identifier))

    # Bundle name
    if patchBundleName:
        _patch_file(pa,
                    infoplist,
                    pa.installQgisAppName.replace(".app", ""),
                    "\t<key>CFBundleName</key>\n\t<string>QGIS</string>",
                    "\t<key>CFBundleName</key>\n\t<string>{}</string>"
                    .format(pa.installQgisAppName.replace(".app", "")))

    # Bundle signature
    if patchBundleSignature:
        _patch_file(pa,
                    infoplist,
                    pa.installQgisAppName.replace(".app", ""),
                    "\t<key>CFBundleSignature</key>\n\t<string>QGIS</string>",
                    "\t<key>CFBundleSignature</key>\n\t<string>{}</string>"
                    .format(pa.installQgisAppName.replace(".app", "")))

    # Minimum version
    if not (min_os is None):
        _patch_file(pa,
                    infoplist,
                    "LSMinimumSystemVersion",
                    "\t<key>CFBundleDevelopmentRegion</key>",
                    "\t<key>LSMinimumSystemVersion</key>\n" +
                    "\t<string>{}</string>\n".format(min_os) +
                    "\t<key>CFBundleDevelopmentRegion</key>")

    # LSFileQuarantineEnabled
    if add_quarantine:
        _patch_file(pa,
                    infoplist,
                    "LSFileQuarantineEnabled",
                    "\t<key>CFBundleDevelopmentRegion</key>",
                    "\t<key>LSFileQuarantineEnabled</key>\n" +
                    "\t<false/>\n".format(min_os) +
                    "\t<key>CFBundleDevelopmentRegion</key>")

    # Python Start
    if add_python_start:
        _patch_file(pa,
                    infoplist,
                    "PYQGIS_STARTUP",
                    "\t\t<key>QT_AUTO_SCREEN_SCALE_FACTOR</key>",
                    "\t\t<key>PYQGIS_STARTUP</key>\n" +
                    "\t\t<string>{}/Resources/python/pyqgis-startup.py</string>\n".format(destContents) +
                    "\t\t<key>QT_AUTO_SCREEN_SCALE_FACTOR</key>")

    # Python Home
    if add_python_home:
        _patch_file(pa,
                    infoplist,
                    "PYTHONHOME",
                    "\t\t<key>QT_AUTO_SCREEN_SCALE_FACTOR</key>",
                    "\t\t<key>PYTHONHOME</key>\n" +
                    "\t\t<string>{}/Frameworks/Python.framework/Versions/Current</string>\n".format(destContents) +
                    "\t\t<key>QT_AUTO_SCREEN_SCALE_FACTOR</key>")

    # Python path
    if add_python_path:
        _patch_file(pa,
                    infoplist,
                    "PYTHONPATH",
                    "\t\t<key>QT_AUTO_SCREEN_SCALE_FACTOR</key>",
                    "\t\t<key>PYTHONPATH</key>\n" +
                    "\t\t<string>{}/Resources/python</string>\n".format(destContents) +
                    "\t\t<key>QT_AUTO_SCREEN_SCALE_FACTOR</key>")

    # qgis prefix
    if add_qgis_prefix:
        _patch_file(pa,
                    infoplist,
                    "QGIS_PREFIX_PATH",
                    "\t\t<key>QT_AUTO_SCREEN_SCALE_FACTOR</key>",
                    "\t\t<key>QGIS_PREFIX_PATH</key>\n" +
                    "\t\t<string>{}/MacOS</string>\n".format(destContents) +
                    "\t\t<key>QT_AUTO_SCREEN_SCALE_FACTOR</key>")

    # Grass7 folder
    if add_grass7_folder:
        grass7pyfile = os.path.join(pa.pythonDir, "plugins/processing/algs/grass7/Grass7Utils.py")
        destGrass7Dir = "{}/Resources/grass7".format(destContents)
        _patch_file(pa,
                    grass7pyfile,
                    destGrass7Dir,
                    "'/Applications/GRASS-7.{}.app/Contents/MacOS'.format(version)",
                    "'{}'".format(destGrass7Dir))

    # fix GDAL paths
    if add_gdal_paths:
        _patch_file(pa,
                    infoplist,
                    "GDAL_DRIVER_PATH",
                    "\t\t<key>QT_AUTO_SCREEN_SCALE_FACTOR</key>",
                    "\t\t<key>GDAL_DRIVER_PATH</key>\n" +
                    "\t\t<string>{}</string>\n".format(pa.gdalPluginsInstall) +
                    "\t\t<key>QT_AUTO_SCREEN_SCALE_FACTOR</key>")

        _patch_file(pa,
                    infoplist,
                    "GDAL_DATA",
                    "\t\t<key>QT_AUTO_SCREEN_SCALE_FACTOR</key>",
                    "\t\t<key>GDAL_DATA</key>\n" +
                    "\t\t<string>{}</string>\n".format(pa.gdalShareInstall) +
                    "\t\t<key>QT_AUTO_SCREEN_SCALE_FACTOR</key>")

    # fix PROJ paths
    if add_proj_path:
        _patch_file(pa,
                    infoplist,
                    "PROJ_LIB",
                    "\t\t<key>QT_AUTO_SCREEN_SCALE_FACTOR</key>",
                    "\t\t<key>PROJ_LIB</key>\n" +
                    "\t\t<string>{}/Resources/proj/proj</string>\n".format(destContents) +
                    "\t\t<key>QT_AUTO_SCREEN_SCALE_FACTOR</key>")

    # fix for Retina displays
    with open(infoplist, "r") as f:
        c = f.read()
        keyword = "NSHighResolutionCapable"
        if keyword not in c:
            raise QGISBundlerError("Missing {} in info {}".format(keyword, infoplist))


def patch_sqlite(pa):
    destContents = pa.installQgisApp + "/Contents"
    # Fix sqlite module
    qgis_utils_file = os.path.join(pa.pythonDir, "qgis/utils.py")
    spatialite_mod_path = destContents + "/MacOS/lib/" + pa.version.mod_spatialite

    _patch_file(pa, qgis_utils_file,
                spatialite_mod_path,
                "\"mod_spatialite\"",
                "\"" + spatialite_mod_path + "\""
                )


def patch_text_files(msg, pa):
    # First patch GRASS7 shell script
    grass7file = pa.grass7Dir + "/bin/" + pa.version.grass
    toreplace = """
export PYTHONHOME=XXX/Contents/Frameworks/Python.framework/Versions/Current
export PYTHONPATH=XXX/Contents/Resources/python
export GRASS_PYTHON=XXX/Contents/MacOS/bin/python
export MANPATH=/usr/local/share/man:/usr/share/man:/opt/X11/share/man:/Library/Developer/CommandLineTools/usr/share/man
export GRASS_LD_LIBRARY_PATH=XXX/Contents/MacOS/lib
$GRASS_PYTHON XXX/Contents/Resources/grass7/bin/_grass76 $@
""".replace("XXX", pa.installQgisApp)
    _patch_file(pa,
                grass7file,
                "MANPATH",
                "GRASS_PYTHON=python2 exec " + pa.host.grass7Cellar + "/libexec/bin/" + pa.version.grass,
                toreplace)

    # now crowl and replace in all other files
    replacements = [
        pa.host.grass7Cellar + "/grass-base" + "~~>" + pa.grass7Install,
        pa.host.grass7Cellar + "/" + pa.version.grassFull + "~~>" + pa.grass7Install,
        pa.projHost + "~~>" + pa.projShareInstall,
        pa.host.grass7Cellar + "/" + pa.version.grassFull + "/lib" + "~~>" + pa.installQgisLib,
        pa.host.projLib + "~~>" + pa.installQgisLib,
        pa.geotiffHost + "~~>" + pa.geotiffShareInstall,
        pa.host.gdalShare + "~~>" + pa.gdalShareInstall,
        "=python2 " + "~~>" + "=" + pa.installQgisApp + "/Contents/MacOS/bin/python ",
        pa.host.grass7Cellar + "/libexec/bin/" + pa.version.grass + "~~>" +
        pa.grass7Install + "/bin/_" + pa.version.grass,
        pa.host.openblas + "~~>" + pa.installQgisLib,
        "/usr/local/lib" + "~~>" + pa.installQgisLib,
    ]

    for root, dirs, files in os.walk(pa.qgisApp):
        for file in files:
            filepath = os.path.join(root, file)
            if is_text(filepath):
                try:
                    with open(filepath, "r") as fh:
                        orig_text = fh.read()
                        text = orig_text
                        for r in replacements:
                            key = r.split("~~>")[0]
                            value = r.split("~~>")[1]
                            text = text.replace(key, value)

                    if text != orig_text:
                        msg.dev("Patching text file " + filepath)
                        with open(filepath, "w") as fh:
                            fh.write(text)
                except Exception:
                    msg.warn("Failed to patch file " + filepath)
                    pass
