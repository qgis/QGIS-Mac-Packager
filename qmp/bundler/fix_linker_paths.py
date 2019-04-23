# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import glob
from .utils import *
from .otool import get_binary_dependencies
from .install_name_tool import fix_lib
from ..common import QGISBundlerError


LIB_PATCHED_PATH = "@executable_path/lib"
REL_LIB_PATH_TO_FRAMEWORK = "@executable_path/../Frameworks"


def _patching_frameworks(cp, msg, pa):
    frameworks = glob.glob(pa.frameworksDir + "/*.framework")
    for framework in frameworks:
        msg.dev("Patching " + framework)
        framework_basename = os.path.basename(framework)
        framework_basename = framework_basename.replace(".framework", "")

        # patch versions framework
        last_version = None
        versions = sorted(glob.glob(os.path.join(framework, "Versions") + "/*"))
        for version in versions:
            ver_framework = os.path.join(version, framework_basename)
            if os.path.exists(ver_framework):
                if not os.path.islink(ver_framework):
                    binaryDependencies = get_binary_dependencies(pa, ver_framework)
                    cp.chmodX(ver_framework)
                    fix_lib(msg,
                            ver_framework,
                            binaryDependencies,
                            pa.contentsDir,
                            LIB_PATCHED_PATH,
                            REL_LIB_PATH_TO_FRAMEWORK)

                if version is not "Current":
                    last_version = os.path.basename(version)
            else:
                msg.warn("Missing " + ver_framework)

        # patch current version
        currentFramework = os.path.join(framework, framework_basename)
        if os.path.exists(currentFramework):
            if not os.path.islink(ver_framework):
                binaryDependencies = get_binary_dependencies(pa, currentFramework)
                fix_lib(msg,
                        currentFramework,
                        binaryDependencies,
                        pa.contentsDir,
                        LIB_PATCHED_PATH,
                        REL_LIB_PATH_TO_FRAMEWORK)
                cp.chmodX(currentFramework)
        else:
            if last_version is None:
                msg.warn("Missing " + currentFramework)
            else:
                msg.dev("Creating version link for " + currentFramework)
                subprocess.call(["ln", "-s", last_version, framework + "/Versions/Current"])
                subprocess.call(["ln", "-s", "Versions/Current/" + framework_basename, currentFramework])

        # TODO generic?
        # patch helpers (?)
        helper = os.path.join(framework, "Helpers", "QtWebEngineProcess.app", "Contents", "MacOS", "QtWebEngineProcess")
        if os.path.exists(helper):
            binaryDependencies = get_binary_dependencies(pa, helper)
            fix_lib(msg,
                    helper,
                    binaryDependencies,
                    pa.contentsDir,
                    LIB_PATCHED_PATH,
                    REL_LIB_PATH_TO_FRAMEWORK)
            cp.chmodX(helper)

        # TODO generic?
        helper = os.path.join(framework, "Versions/Current/Resources/Python.app/Contents/MacOS/Python")
        if os.path.exists(helper):
            binaryDependencies = get_binary_dependencies(pa, helper)
            fix_lib(msg,
                    helper,
                    binaryDependencies,
                    pa.contentsDir,
                    LIB_PATCHED_PATH,
                    REL_LIB_PATH_TO_FRAMEWORK)
            cp.chmodX(helper)
            # add link to MacOS/bin too
            cp.symlink(os.path.relpath(helper, pa.binDir), pa.binDir + "/python")
            cp.symlink(os.path.relpath(helper, pa.binDir), pa.binDir + "/python3")

        helper = os.path.join(framework, "Versions/Current/lib/" + pa.version.python + "/lib-dynload")
        if os.path.exists(helper):
            for bin in glob.glob(helper + "/*.so"):
                binaryDependencies = get_binary_dependencies(pa, bin)
                fix_lib(msg,
                        bin,
                        binaryDependencies,
                        pa.contentsDir,
                        LIB_PATCHED_PATH,
                        REL_LIB_PATH_TO_FRAMEWORK)
                cp.chmodX(bin)

                link = pa.libDir + "/" + os.path.basename(bin)
                cp.symlink(os.path.relpath(bin, pa.libDir),
                           link)
                link = os.path.realpath(link)
                if not os.path.exists(link):
                    raise QGISBundlerError("Ups, wrongly relinked! " + bin)

        if "Python" in framework:
            filepath = os.path.join(framework, "Versions/Current/lib/" + pa.version.python + "/site-packages")
            cp.unlink(filepath)
            cp.symlink("../../../../../../Resources/python", filepath)
            filepath = os.path.realpath(filepath)
            if not os.path.exists(filepath):
                raise QGISBundlerError("Ups, wrongly relinked! " + "site-packages")

    return len(frameworks)


def _patching_libs(cp, msg, pa):
    libs = []
    for root, dirs, files in os.walk(pa.qgisApp):
        for file in files:
            filepath = os.path.join(root, file)
            if ".framework" not in filepath:
                filename, file_extension = os.path.splitext(filepath)
                if file_extension in [".dylib", ".so"]:
                    libs += [filepath]

    # note there are some libs here: /Python.framework/Versions/Current/lib/*.dylib but
    # those are just links to Current/Python
    for lib in libs:
        if not os.path.islink(lib):
            msg.dev("Patching " + lib)
            binaryDependencies = get_binary_dependencies(pa, lib)
            fix_lib(msg,
                    lib,
                    binaryDependencies,
                    pa.contentsDir,
                    LIB_PATCHED_PATH,
                    REL_LIB_PATH_TO_FRAMEWORK)
            cp.chmodX(lib)

            # TODO what to do with unlinked_libs????
            # now we hope noone references them
        else:
            msg.dev("Skipping link " + lib)

    return len(libs)


def _patching_exe(cp, msg, pa):
    exes = set()
    exes.add(pa.qgisExe)
    exes |= set(glob.glob(pa.frameworksDir + "/Python.framework/Versions/Current/bin/*"))
    exes |= set(
        glob.glob(pa.frameworksDir + "/Python.framework/Versions/Current/Resources/Python.app/Contents/MacOS/Python"))
    exes |= set(glob.glob(pa.binDir + "/*"))
    exes |= set(glob.glob(pa.grass7Dir + "/bin/*"))
    exes |= set(glob.glob(pa.grass7Dir + "/driver/db/*"))
    exes |= set(glob.glob(pa.grass7Dir + "/etc/*"))
    exes |= set(glob.glob(pa.grass7Dir + "/etc/*/*"))

    for exe in exes:
        if not os.path.isdir(exe):
            if not os.path.islink(exe):
                msg.dev("Patching " + exe)
                binaryDependencies = get_binary_dependencies(pa.qgisApp, exe)
                try:
                    fix_lib(msg,
                            exe,
                            binaryDependencies,
                            pa.contentsDir,
                            LIB_PATCHED_PATH,
                            REL_LIB_PATH_TO_FRAMEWORK)
                except subprocess.CalledProcessError:
                    # Python.framework/Versions/Current/bin/idle3 is not a Mach-O file ??
                    pass
                cp.chmodX(exe)

                exeDir = os.path.dirname(exe)
                # as we use @executable_path everywhere,
                # there is a problem
                # because QGIS and bin/* is different directory
                if not os.path.exists(exeDir + "/lib"):
                    cp.symlink(os.path.relpath(pa.libDir, exeDir), exeDir + "/lib")
                testLink = os.path.realpath(exeDir + "/lib")
                if testLink != os.path.realpath(pa.libDir):
                    raise QGISBundlerError("invalid lib link!")

                # we need to create symlinks to Frameworks, so for example python does not pick system Python 2.7 dylibs
                if not os.path.exists(exeDir + "/../Frameworks"):
                    cp.symlink(os.path.relpath(pa.frameworksDir, os.path.join(exeDir, os.pardir)),
                               exeDir + "/../Frameworks")
                testLink = os.path.realpath(exeDir + "/../Frameworks")
                if testLink != os.path.realpath(pa.frameworksDir):
                    raise QGISBundlerError("invalid frameworks link!")

            else:
                msg.dev("Skipping link " + exe)
                cp.chmodX(exe)

    return len(exes)


def _replace_string_in_binary(filename, src, dest):
    if not os.path.exists(filename):
        raise QGISBundlerError("{} does not exist" + filename)

    if len(src) != len(dest):
        raise QGISBundlerError("Unable to patch {}, src and dest must have the same length" + filename)

    with open(filename, 'rb+') as fh:
        data = fh.read()
        data = data.replace(bytes(src, "utf-8"), bytes(dest, "utf-8"))
        fh.seek(0)
        fh.write(data)

    output = subprocess.check_output(["strings", filename], encoding='UTF-8')
    if src in output:
        raise QGISBundlerError("Failed to patch " + filename)


def _patch_saga_cmd(cp, msg, pa):
    basePathForLinks = pa.installQgisApp + "/Contents/Resources"
    # we need to replace with the string with same length
    if len(basePathForLinks + "/") < len(pa.host.sagaLibCellar):
        link_length = len(pa.host.sagaLibCellar) - len(basePathForLinks + "/")
        sagaLibDir = ""
        sagaLibDir += link_length * "a"
        sagaLibInstall = basePathForLinks + "/" + sagaLibDir
        msg.dev("patching SAGA shared data " + pa.host.sagaLibCellar + " with " + sagaLibInstall)
        cp.symlink(os.path.relpath(pa.sagaDataDir + "/tools", pa.resourcesDir), pa.resourcesDir + "/" + sagaLibDir)
    else:
        raise QGISBundlerError("Unable to modify install path for SAGA lib folder")

    sagaBin = os.path.join(pa.binDir, "saga_cmd")
    _replace_string_in_binary(
        sagaBin,
        pa.host.sagaLibCellar,
        sagaLibInstall
    )

    # we need to replace with the string with same length
    if len(basePathForLinks + "/") < len(pa.host.sagaShareCellar):
        link_length = len(pa.host.sagaShareCellar) - len(basePathForLinks + "/")
        sagaShareDir = ""
        sagaShareDir += link_length * "b"
        sagaShareInstall = basePathForLinks + "/" + sagaShareDir
        msg.dev("patching SAGA shared data " + pa.host.sagaShareCellar + " with " + sagaShareInstall)
        cp.symlink(os.path.relpath(pa.sagaDataDir, pa.resourcesDir), pa.resourcesDir + "/" + sagaShareDir)
    else:
        raise QGISBundlerError("Unable to modify install path for SAGA shared folder")

    _replace_string_in_binary(
        sagaBin,
        pa.host.sagaShareCellar,
        sagaShareInstall
    )

    output = subprocess.check_output(["strings", sagaBin], encoding='UTF-8')
    if "osgeo-saga-lts" in output:
        raise QGISBundlerError("Failed to patch " + sagaBin)

    # unlink in lib/saga because here SAGA_MLB variable points in QGIS SAGA processing script
    if os.path.exists(pa.libDir + "/saga"):
        raise QGISBundlerError("Extra dir in lib/saga")


def fix_linker_paths(cp,
                     msg,
                     pa,
                     qca_dir):

    cp.chmodW(pa.qgisApp)

    msg.info("Patching frameworks linker paths")
    patched_n_frameworks = _patching_frameworks(cp, msg, pa)

    msg.info("Patching libraries/plugins linker paths")
    patched_n_libs = _patching_libs(cp, msg, pa)

    msg.info("Fix executables linker paths")
    patched_n_exes = _patching_exe(cp, msg, pa)

    msg.info("Fix QCA_PLUGIN_PATH Qt Plugin path")
    # It looks like that QCA compiled with QCA_PLUGIN_PATH CMake define
    # adds this by default to QT_PLUGIN_PATH. Overwrite this
    # in resulting binary library
    _replace_string_in_binary(
        os.path.join(pa.frameworksDir, "qca-qt5.framework", "qca-qt5"),
        qca_dir + "/lib/qt5/plugins",
        qca_dir + "/xxx/xxx/plugins")

    msg.info("Fix SAGA lib dir in saga_cmd")
    # saga_cmd has hardcoded path to /usr/local to search for the tools and shared folder
    _patch_saga_cmd(cp, msg, pa)

    # Now everything should be here
    cp.chmodW(pa.qgisApp)

    msg.info("Create PROJ lib link")
    # PROJ
    if not os.path.exists(pa.libDir + "/" + pa.version.projLib):
        raise QGISBundlerError("Proj lib not present " + pa.version.projLib + ". Maybe it has new version?")
    cp.symlink(pa.version.projLib, pa.libDir + "/libproj.dylib")

    msg.info("Create GRASS7 lib link")
    link = pa.grass7Dir + "/lib"
    if os.path.exists(link):
        raise QGISBundlerError(link + " should have been deleted during grass7 copy.")
    cp.symlink(os.path.relpath(pa.libDir, pa.grass7Dir), link)
    cp.remove(pa.grass7Dir + "/grass.sh")
    cp.symlink("bin/" + pa.version.grass, pa.grass7Dir + "/grass.sh")
    cp.remove(pa.grass7Dir + "/" + pa.version.grass + ".sh")
    cp.symlink("bin/" + pa.version.grass, pa.grass7Dir + "/" + pa.version.grass + ".sh")

    msg.info("Patched {} frameworks, {} libs, {} exes".format(patched_n_frameworks, patched_n_libs, patched_n_exes))
