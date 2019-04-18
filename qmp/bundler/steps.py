# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import subprocess
import os

from .otool import is_omach_file, get_binary_dependencies
from .utils import is_text, files_differ
import re
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


def patch_files(pa, min_os):
    patch_info_plist(pa, min_os)
    patch_sqlite(pa)
    patch_text_files(pa)


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


def patch_text_files(pa):
    # First patch GRASS7 shell script
    grass7file = pa.grass7Dir + "/bin/" + pa.version.grass
    toreplace = """
export PYTHONHOME=XXX/Contents/Frameworks/Python.framework/Versions/Current
export PYTHONPATH=XXX/Contents/Resources/python
export GRASS_PYTHON=XXX/Contents/MacOS/bin/python
export MANPATH=/usr/local/share/man:/usr/share/man:/opt/X11/share/man:/Library/Developer/CommandLineTools/usr/share/man
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
                        print("Patching text file " + filepath)
                        with open(filepath, "w") as fh:
                            fh.write(text)
                except Exception as e:
                    # print("Failed to patch " + filepath )
                    pass


def append_recursively_site_packages(pa, cp, sourceDir, destDir):
    for item in os.listdir(sourceDir):
        s = os.path.join(sourceDir, item)
        d = os.path.join(destDir, item)
        # do not copy sip pyqt5, because link is also in global site-packages and pyqt5's Qt libraries are
        # not copied
        if os.path.exists(d) or (s == pa.host.sipCellar):
            print("Skipped " + s)
            continue
        else:
            print(" Copied " + s + " ~~~~> " + d)

        if os.path.isdir(s):
            # hard copy - no symlinks
            cp.copytree(s, d, False)

            if os.path.exists(d + "/.dylibs"):
                print("Removing extra " + d + "/.dylibs")
                cp.rmtree(d + "/.dylibs")
        else:
            # if it is link, copy also content of the dir of that link.
            # this is because pth files can get other site-packages
            # but we want it on one place
            if os.path.islink(s):
                dirname = os.path.realpath(s)
                dirname = os.path.dirname(dirname)
                print("packaging also site-package " + dirname)
                append_recursively_site_packages(pa, cp, dirname, destDir)

            # this can contain also site-packages with absolute path
            if s.endswith(".pth"):
                with open(s, 'r') as myfile:
                    dirname = myfile.read().strip()
                if os.path.isdir(dirname):
                    print("packaging also site-package " + dirname)
                    append_recursively_site_packages(pa, cp, dirname, destDir)

            if not os.path.exists(d):
                cp.copy(s, d)


def clean_redundant_files(pa, cp):
    extensionsToCheck = [".a", ".pyc", ".c", ".cpp", ".h", ".hpp", ".cmake", ".prl"]
    dirsToCheck = ["/include", "/Headers", "/__pycache__", "/man/"]

    # remove unneeded files/dirs
    for root, dirnames, filenames in os.walk(pa.qgisApp):
        for file in filenames:
            fpath = os.path.join(root, file)
            filename, file_extension = os.path.splitext(fpath)
            if any(ext == file_extension for ext in extensionsToCheck):
                print("Removing " + fpath)
                cp.rm(fpath)

        for dir in dirnames:
            dpath = os.path.join(root, dir)
            print(dpath)
            if any(ext in dpath for ext in dirsToCheck):
                print("Removing " + dpath)
                cp.rm(dpath)

    # remove broken links and empty dirs
    for root, dirnames, filenames in os.walk(pa.qgisApp):
        for file in filenames:
            fpath = os.path.join(root, file)
            real = os.path.realpath(fpath)
            if not os.path.exists(real):
                os.unlink(fpath)


def check_deps(pa, filepath, executable_path):
    binaryDependencies = get_binary_dependencies(pa, filepath)
    all_binaries = binaryDependencies.libs + binaryDependencies.frameworks

    for bin in all_binaries:
        if bin:
            binpath = bin.replace("@executable_path", executable_path)
            binpath = os.path.realpath(binpath)

            if "@" in binpath:
                raise QGISBundlerError("Library/Framework " + bin + " with rpath or loader path for " + filepath)

            binpath = os.path.realpath(binpath)
            if not os.path.exists(binpath):
                raise QGISBundlerError("Library/Framework " + bin + " not exist for " + filepath)

            if pa.qgisApp not in binpath:
                raise QGISBundlerError("Library/Framework " + bin + " is not in bundle dir for " + filepath)


def test_full_tree_consistency(pa):
    print("Test qgis --help works")
    try:
        output = subprocess.check_output([pa.qgisExe, "--help"], stderr=subprocess.STDOUT, encoding='UTF-8')
    except subprocess.CalledProcessError as err:
        # for some reason it returns exit 1 even when it writes help
        output = err.output
    if output:
        print(output.split("\n")[0])
    if "QGIS" not in output:
        raise QGISBundlerError("wrong QGIS.app installation")

    print("Test that we have just one-of-kind of library type")
    errors = []
    exceptions = pa.version.exceptions
    unique_libs = {}
    for root, dirs, files in os.walk(pa.qgisApp):
        for file in files:
            filepath = os.path.join(root, file)
            if not os.path.islink(filepath):
                filename, file_extension = os.path.splitext(filepath)

                if not (file_extension in [".dylib", ".so"] and is_omach_file(filepath)):
                    continue

                basename = os.path.basename(filename)

                skip = False
                for e in exceptions:
                    if filepath.endswith(e):
                        skip = True
                if skip:
                    continue

                basename = basename.replace("." + pa.version.cpython, "")
                basename = re.sub(r'(\-\d+)?(\.\d+)?(\.\d+)?(\.\d+)?(\.\d+)$', '', basename)  # e.g. 3.0.0.4 or 3.0
                print('Checking duplicity of library ' + basename)
                if basename in unique_libs:
                    if files_differ(filepath, unique_libs[basename]):
                        # make sure there is no link in libs
                        if os.path.exists(pa.libDir + "/" + os.path.basename(filepath)):
                            msg = "Link exists for library " + filepath
                            msg += " is bundled multiple times, first time in " + unique_libs[basename]
                            errors += [msg]
                    else:
                        msg = "Library " + filepath
                        msg += " is bundled multiple times, first time in " + unique_libs[basename]
                        errors += [msg]

                unique_libs[basename] = filepath

    if errors:
        print("\n".join(errors))
        raise QGISBundlerError("Duplicate libraries found!")

    print("Test that all libraries have correct link and and bundled")
    for root, dirs, files in os.walk(pa.qgisApp):
        for file in files:
            filepath = os.path.join(root, file)
            filename, file_extension = os.path.splitext(filepath)
            if file_extension in [".dylib", ".so"] and is_omach_file(filepath):
                print('Checking compactness of library ' + filepath)
                check_deps(pa, filepath, os.path.realpath(pa.macosDir))
            elif not file_extension and is_omach_file(filepath):  # no extension == binaries
                if os.access(filepath, os.X_OK) and ("/Frameworks/" not in filepath):
                    print('Checking compactness of binaries ' + filepath)
                    check_deps(pa, filepath, os.path.dirname(filepath))
                else:
                    print('Checking compactness of library ' + filepath)
                    check_deps(pa, filepath, os.path.realpath(pa.macosDir))

    print("Test that all links are pointing to the destination inside the bundle")
    for root, dirs, files in os.walk(pa.qgisApp):
        for file in files:
            filepath = os.path.join(root, file)
            filepath = os.path.realpath(filepath)
            if not os.path.exists(filepath):
                raise QGISBundlerError(" File " + root + "/" + file + " does not exist")

            if pa.qgisApp not in filepath:
                raise QGISBundlerError(" File " + root + "/" + file + " is not in bundle dir")

    print("Test GDAL installation")
    if not os.path.exists(pa.binDir + "/gdal_merge.py"):
        raise QGISBundlerError("gdal_merge.py does not exist")

    gdalinfo = pa.binDir + "/gdalinfo"
    expected_formats = ["GRIB", "GPKG", "GTiff"]
    expected_formats += ["netCDF"]

    try:
        output = subprocess.check_output([gdalinfo, "--formats"], stderr=subprocess.STDOUT, encoding='UTF-8')
    except subprocess.CalledProcessError as err:
        print(err.output)
        raise

    for f in expected_formats:
        if f not in output:
            raise QGISBundlerError("format {} missing in gdalinfo --formats".format(f))

    print("Test that all text files does not contain references to homebrew /usr/local")
    errors = []
    # TODO wondering what we really need from these files in the bundle
    exceptions = [
        "-config",  # this file is to show the compilation flags of libraries
        "sitecustomize.py",  # this sets up python if used in homebrew context, so we do not need it here
        "INSTALL",
        "METADATA",
        ".rst",
        "SagaUtils.py",  # saga already found by prefixPath + "bin"
        ".txt",
        ".html",
        ".pc",  # pkgconfig
        "Makefile",
        "Setup",

    ]
    for root, dirs, files in os.walk(pa.qgisApp):
        for file in files:
            filepath = os.path.join(root, file)
            if any(filepath.endswith(ext) for ext in exceptions):
                continue

            if is_text(filepath):
                try:
                    with open(filepath, "r", encoding='utf-8') as fh:
                        if "/usr/local" in fh.read():
                            errors += [filepath]
                except UnicodeDecodeError:
                    pass
    if errors:
        print("WARNING! reference to /usr/local")
        print("{}".format("/n".join(errors)))
