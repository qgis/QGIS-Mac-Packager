# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import subprocess
import os

from .otool import is_omach_file, get_binary_dependencies
from .utils import is_text, files_differ
import re
from ..common import QGISBundlerError


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


def test_full_tree_consistency(msg, pa):
    msg.info("Test qgis --help works")
    try:
        output = subprocess.check_output([pa.qgisExe, "--help"], stderr=subprocess.STDOUT, encoding='UTF-8')
    except subprocess.CalledProcessError as err:
        # for some reason it returns exit 1 even when it writes help
        output = err.output
    if output:
        msg.info(output.split("\n")[0])
    if "QGIS" not in output:
        raise QGISBundlerError("wrong QGIS.app installation")

    msg.info("Test that we have just one-of-kind of library type")
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
                msg.dev('Checking duplicity of library ' + basename)
                if basename in unique_libs:
                    if files_differ(filepath, unique_libs[basename]):
                        # make sure there is no link in libs
                        if os.path.exists(pa.libDir + "/" + os.path.basename(filepath)):
                            s = "Link exists for library " + filepath
                            s += " is bundled multiple times, first time in " + unique_libs[basename]
                            errors += [s]
                    else:
                        s = "Library " + filepath
                        s += " is bundled multiple times, first time in " + unique_libs[basename]
                        errors += [s]

                unique_libs[basename] = filepath

    if errors:
        msg.warn("\n".join(errors))
        raise QGISBundlerError("Duplicate libraries found!")

    msg.info("Test that all libraries have correct link and and bundled")
    for root, dirs, files in os.walk(pa.qgisApp):
        for file in files:
            filepath = os.path.join(root, file)
            filename, file_extension = os.path.splitext(filepath)
            if file_extension in [".dylib", ".so"] and is_omach_file(filepath):
                msg.dev('Checking compactness of library ' + filepath)
                check_deps(pa, filepath, os.path.realpath(pa.macosDir))
            elif not file_extension and is_omach_file(filepath):  # no extension == binaries
                if os.access(filepath, os.X_OK) and ("/Frameworks/" not in filepath):
                    msg.dev('Checking compactness of binaries ' + filepath)
                    check_deps(pa, filepath, os.path.dirname(filepath))
                else:
                    msg.dev('Checking compactness of library ' + filepath)
                    check_deps(pa, filepath, os.path.realpath(pa.macosDir))

    msg.info("Test that all links are pointing to the destination inside the bundle")
    for root, dirs, files in os.walk(pa.qgisApp):
        for file in files:
            filepath = os.path.join(root, file)
            filepath = os.path.realpath(filepath)
            if not os.path.exists(filepath):
                raise QGISBundlerError(" File " + root + "/" + file + " does not exist")

            if pa.qgisApp not in filepath:
                raise QGISBundlerError(" File " + root + "/" + file + " is not in bundle dir")

    msg.info("Test GDAL installation")
    if not os.path.exists(pa.binDir + "/gdal_merge.py"):
        raise QGISBundlerError("gdal_merge.py does not exist")

    gdalinfo = pa.binDir + "/gdalinfo"
    expected_formats = ["GRIB", "GPKG", "GTiff"]
    expected_formats += ["netCDF"]

    try:
        output = subprocess.check_output([gdalinfo, "--formats"], stderr=subprocess.STDOUT, encoding='UTF-8')
    except subprocess.CalledProcessError as err:
        raise QGISBundlerError(err.output)

    for f in expected_formats:
        if f not in output:
            raise QGISBundlerError("format {} missing in gdalinfo --formats".format(f))

    msg.info("Test that all text files does not contain references to homebrew /usr/local")
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
        msg.warn("reference to /usr/local")
        msg.warn("{}".format("/n".join(errors)))
