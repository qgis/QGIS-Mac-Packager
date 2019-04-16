# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import glob
import os
import subprocess

from .otool import *
from .install_name_tool import *
from .utils import *
from .steps import append_recursively_site_packages, clean_redundant_files, patch_files, test_full_tree_consistency
from .deps import get_computer_info

from ..common import QGISBundlerError


def bundle(cp, msg, pa):
    computer_info = get_computer_info()
    msg.info(computer_info)
    with_SAGA = True

    print(100 * "*")
    print("STEP 0: Copy QGIS and independent folders to build folder")
    print(100 * "*")

    print("Cleaning: " + pa.output.bundle)
    if os.path.exists(pa.output.bundle):
        cp.rmtree(pa.output.bundle)
        if os.path.exists(pa.output.bundle + "/.DS_Store"):
            cp.remove(pa.output.bundle + "/.DS_Store")

    print("Copying " + pa.output.install)
    if not os.path.exists(pa.output.install):
        raise QGISBundlerError(pa.output.install + " does not exists")
    cp.copytree(pa.output.install, pa.output.bundle, symlinks=True)
    if pa.args.qgisapp_name != "QGIS.app":
        cp.rename(os.path.join(pa.output.bundle, "QGIS.app"), pa.qgisApp)
    if not os.path.exists(pa.qgisApp):
        raise QGISBundlerError(pa.qgisExe + " does not exists")
    if not os.path.exists(pa.binDir):
        os.makedirs(pa.binDir)

    print("Remove crssync")
    if os.path.exists(pa.libDir + "/qgis/crssync"):
        cp.rmtree(pa.libDir + "/qgis")

    # https://doc.qt.io/qt-5/sql-driver.html#supported-databases
    print("Copying QT SQL Drivers")
    if not os.path.exists(pa.sqlDriversDir):
        os.makedirs(pa.sqlDriversDir)
    for item in [pa.mysqlDriverHost, pa.psqlDriverHost, pa.odbcDriverHost]:
        cp.copy(item, pa.sqlDriversDir)

    print("Copying GDAL" + pa.host.gdal)
    for item in os.listdir(pa.host.gdal + "/bin"):
        cp.copy(pa.host.gdal + "/bin/" + item, pa.binDir)
    cp.copytree(pa.host.gdal + "/share/gdal", pa.gdalDataDir, symlinks=False)
    cp.copytree(pa.gdalPluginsHost, pa.gdalPluginsDir, symlinks=False)
    cp.chmodW(pa.gdalDataDir)

    # normally this should be on MacOS/bin/ so logic in GdalUtils.py works,
    # but .py file in MacOS/bin halts the signing of the bundle
    print("Copying GDAL-PYTHON" + pa.gdalPythonHost)
    if not os.path.exists(pa.gdalDataDir + "/bin"):
        os.makedirs(pa.gdalDataDir + "/bin")
    if not os.path.exists(pa.binDir):
        cp.makedirs(pa.binDir)
    for item in os.listdir(pa.gdalPythonHost + "/bin"):
        if not os.path.isdir(pa.gdalPythonHost + "/bin/" + item):
            cp.copy(pa.gdalPythonHost + "/bin/" + item, pa.gdalDataDir + "/bin/" + item)
            cp.symlink(os.path.relpath(pa.gdalDataDir + "/bin/" + item, pa.binDir), pa.binDir + "/" + item)

    if with_SAGA:
        print("Copying SAGA " + pa.sagaHost)
        cp.copy(pa.sagaHost + "/bin/saga_cmd", pa.binDir)
        # we need to have it in subfolder because there is where
        # qgis saga batch bash script expects the SAGA tools to be located
        cp.copytree(pa.sagaHost + "/share/saga", pa.sagaDataDir, symlinks=False)
        os.makedirs(pa.sagaDataDir + "/tools")
        for item in os.listdir(pa.sagaHost + "/lib/saga"):
            cp.copy(pa.sagaHost + "/lib/saga/" + item, pa.sagaDataDir + "/tools/" + item)
        cp.chmodW(pa.binDir)
    else:
        print("SAGA skipped")

    print("Copying GRASS7 " + pa.grass7Host)
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

    print("Remove unneeded qgis_bench.app")
    if os.path.exists(pa.binDir + "/qgis_bench.app"):
        cp.rmtree(pa.binDir + "/qgis_bench.app")

    print("Append Python site-packages " + pa.host.pySitePackages)
    append_recursively_site_packages(pa, cp, pa.host.pySitePackages, pa.pythonDir)
    if not os.path.exists(pa.pythonDir + "/PyQt5/Qt.so"):
        raise QGISBundlerError("PyQt5 missing: " + pa.pythonDir + "/PyQt5/Qt.so")
    if not os.path.exists(pa.pythonDir + "/PyQt5/sip.so"):
        raise QGISBundlerError("PyQt5 missing: " + pa.pythonDir + "/PyQt5/sip.so")

    # TODO copy of python site-packages should be rather
    # selective an not copy-all and then remove
    print("remove not needed python site-packages")
    redundantPyPackages = [
        "dropbox*",
        "GitPython*",
        "homebrew-*",
    ]
    for pp in redundantPyPackages:
        for path in glob.glob(pa.pythonDir + "/" + pp):
            print("Removing " + path)
            if os.path.isdir(path):
                cp.rmtree(path)
            else:
                cp.remove(path)
    cp.chmodW(pa.pluginsDir)

    print("add pyqgis_startup.py to remove MacOS default paths")
    startup_script = os.path.join(pa.package.resources, "pyqgis-startup.py")
    if not os.path.exists(startup_script):
        raise QGISBundlerError("Missing resource " + startup_script)
    cp.copy(startup_script, os.path.join(pa.pythonDir, "pyqgis-startup.py"))

    print("Copying PyQt plugins " + pa.host.pyqtPluginFile)
    cp.copytree(pa.host.pyqtPluginFile, pa.pluginsDir + "/PyQt5", True)
    cp.chmodW(pa.pluginsDir + "/PyQt5")

    print("Copying mod_spatiallite")
    cp.copy(pa.host.mod_spatialite, os.path.join(pa.libDir, pa.version.mod_spatialite))

    print("Copy PROJ shared folder")
    cp.copytree(pa.projHost, pa.projDir, True)
    for item in os.listdir(pa.projDatumGridsHost):
        src = pa.projDatumGridsHost + "/" + item
        dest = pa.projDir + "/proj/" + item
        if os.path.exists(dest):
            cp.remove(dest)
        cp.copy(src, dest)

    print("Copy GEOTIFF shared folder")
    cp.copytree(pa.geotiffHost, pa.geotiffDir, True)

    # at the end make it all writable
    cp.chmodW(pa.contentsDir)

    print(100 * "*")
    print("STEP 1: Analyze the libraries we need to bundle")
    print(100 * "*")

    # Find QT
    qtDir = None
    for framework in otool.get_binary_dependencies(pa, pa.qgisExe).frameworks:
        if "lib/QtCore.framework" in framework:
            path = os.path.realpath(framework)
            qtDir = path.split("/lib/")[0]
            break
    if not qtDir:
        raise QGISBundlerError("Unable to find QT install directory")
    print("Found QT: " + qtDir)

    # Find QCA dir
    qcaDir = None
    for framework in otool.get_binary_dependencies(pa, pa.qgisExe).frameworks:
        if "lib/qca" in framework:
            path = os.path.realpath(framework)
            qcaDir = path.split("/lib/")[0]
            break
    if not qcaDir:
        raise QGISBundlerError("Unable to find QCA install directory")
    print("Found QCA: " + qcaDir)

    # Analyze all
    sys_libs = set()
    libs = set()
    frameworks = set()

    deps_queue = set()
    done_queue = set()

    # initial items:
    # 1. qgis executable
    deps_queue.add(pa.qgisExe)
    # 2. all so and dylibs in bundle folder
    for root, dirs, files in os.walk(pa.qgisApp):
        for file in files:
            filepath = os.path.join(root, file)
            filename, file_extension = os.path.splitext(filepath)
            if file_extension in [".dylib", ".so"]:
                deps_queue.add(filepath)
    # 3. python libraries
    deps_queue |= set(glob.glob(pa.host.pythonDynload + "/*.so"))
    # 4. dynamic qt providers
    deps_queue |= set(glob.glob(qtDir + "/plugins/*/*.dylib"))
    deps_queue |= set(glob.glob(qcaDir + "/lib/qt5/plugins/*/*.dylib"))
    # 5. python interpreter
    deps_queue.add(pa.host.python)
    # 6. saga for processing toolbox and other bins
    deps_queue |= set(glob.glob(pa.binDir + "/*"))
    # 7. grass7
    deps_queue |= set(glob.glob(pa.grass7Dir + "/bin/*"))
    deps_queue |= set(glob.glob(pa.grass7Dir + "/lib/*.dylib"))
    deps_queue |= set(glob.glob(pa.grass7Dir + "/driver/db/*"))
    deps_queue |= set(glob.glob(pa.grass7Dir + "/etc/*"))
    deps_queue |= set(glob.glob(pa.grass7Dir + "/etc/*/*"))

    # DEBUGGING
    debug_lib = None
    debug_lib = "libproj.13.dylib"

    while deps_queue:
        lib = deps_queue.pop()

        if lib.endswith(".py"):
            continue

        lib_fixed = lib
        # patch @rpath, @loader_path and @executable_path
        if "@rpath" in lib_fixed:
            # replace rpath we know from homebrew
            patched_path = lib_fixed.replace("@rpath", pa.host.lapack)
            if os.path.exists(patched_path):
                lib_fixed = patched_path

        lib_fixed = lib_fixed.replace("@executable_path", pa.macosDir)
        lib_fixed = utils.resolve_libpath(pa, lib_fixed)

        if "@loader_path" in lib_fixed:
            raise QGISBundlerError("Ups, unable to get library path, maybe fix resolve_libpath? " + lib_fixed)

        if lib_fixed in done_queue:
            continue

        if not lib_fixed:
            continue

        if os.path.isdir(lib_fixed):
            continue

        extraInfo = "" if lib == lib_fixed else "(" + lib_fixed + ")"
        print("Analyzing " + lib + extraInfo)

        if not os.path.exists(lib_fixed):
            raise QGISBundlerError("Library missing! " + lib_fixed)

        done_queue.add(lib_fixed)

        binaryDependencies = otool.get_binary_dependencies(pa, lib_fixed)

        if debug_lib:
            for l in binaryDependencies.libs:
                if debug_lib in l:
                    print(100 * "*")
                    print("DEBUG: {} -- {}".format(debug_lib, lib))

        lib_fixed, type = otool.binary_type(pa, lib_fixed)
        if type is otool.SYS_LIB:
            sys_libs |= set(binaryDependencies.sys_libs)
        elif type is otool.FRAMEWORK:
            frameworks |= set([lib_fixed])
        elif type is otool.LIB:
            libs |= set([lib_fixed])

        deps_queue |= set(binaryDependencies.libs)
        deps_queue |= set(binaryDependencies.frameworks)

    msg = "\nLibs:\n\t"
    msg += "\n\t".join(sorted(libs))
    msg += "\nFrameworks:\n\t"
    msg += "\n\t".join(sorted(frameworks))
    msg += "\nSysLibs:\n\t"
    msg += "\n\t".join(sorted(sys_libs))
    print(msg)

    print(100 * "*")
    print("STEP 2: Copy libraries/plugins to bundle")
    print(100 * "*")

    unlinked_libs = set()
    unlink_links = set()

    for lib in libs:
        if not lib:
            continue

        if ("@rpath" in lib) or ("@loader_path" in lib) or ("@executable_path" in lib):
            raise QGISBundlerError("Ups, analysis of the library " + lib + " is wrong!")

        # libraries to lib dir
        # plugins to plugin dir/plugin name/, e.g. PlugIns/qgis, PlugIns/platform, ...
        if "/plugins/" in lib:
            pluginFolder = lib.split("/plugins/")[1]
            pluginFolder = pluginFolder.split("/")[0]
            # Skip this is already copied
            if "libpyqt5qmlplugin.dylib" in lib:
                if os.path.exists(pa.pluginsDir + "/PyQt5/libpyqt5qmlplugin.dylib"):
                    target_dir = pa.pluginsDir + "/PyQt5"
                else:
                    raise QGISBundlerError("Ups, missing libpyqt5qmlplugin.dylib")
            else:
                target_dir = pa.pluginsDir + "/" + pluginFolder
        else:
            target_dir = pa.libDir

        # only copy if not already in the bundle
        # frameworks are copied elsewhere
        if (pa.qgisApp not in lib) and (".framework" not in lib):
            print("Bundling " + lib + " to " + target_dir)
            if not os.path.exists(target_dir):
                os.makedirs(target_dir)

            cp.copy(lib, target_dir)

            new_file = os.path.join(target_dir, os.path.basename(lib))
            cp.chmodW(new_file)

        # link to libs folder if the library is somewhere around the bundle dir
        if (pa.qgisApp in lib) and (pa.libDir not in lib):
            link = pa.libDir + "/" + os.path.basename(lib)
            if not os.path.exists(link):
                cp.symlink(os.path.relpath(lib, pa.libDir),
                           link)
                link = os.path.realpath(link)
                if not os.path.exists(link):
                    raise QGISBundlerError("Ups, wrongly linked! " + lib)
            else:
                # we already have this lib in the bundle (because there is a link! in lib/), so make sure we do not have it twice!
                existing_link_realpath = os.path.realpath(link)
                if existing_link_realpath != os.path.realpath(lib):
                    if utils.files_differ(existing_link_realpath, lib):
                        # libraries with the same name BUT with different contents
                        # so do not have it in libs folder because we do not know which
                        # we HOPE that this happens only for cpython extensions for python modules
                        if not pa.version.cpython in link:
                            raise QGISBundlerError(
                                "multiple libraries with same name but different content " + link + "; " + lib)
                        unlink_links.add(link)
                        unlinked_libs.add(existing_link_realpath)
                        unlinked_libs.add(os.path.realpath(lib))

                    else:
                        # same library (binary) --> we need just one
                        # ok, in this case remove the new library and just symlink to the lib
                        cp.remove(lib)
                        relpath = os.path.relpath(existing_link_realpath, os.path.dirname(lib))
                        cp.symlink(relpath,
                                   lib)

                        link = os.path.realpath(lib)
                        if not os.path.exists(link):
                            raise QGISBundlerError("Ups, wrongly relinked! " + link)

        # find out if there are no python3.7 plugins in the dir
        plugLibDir = os.path.join(os.path.dirname(lib), pa.version.python, "site-packages", "PyQt5")
        if os.path.exists(plugLibDir):
            for file in glob.glob(plugLibDir + "/*.so"):
                basename = os.path.basename(file)
                destFile = pa.pluginsDir + "/PyQt5/" + basename
                link = pa.pythonDir + "/PyQt5/" + basename
                if not os.path.exists(destFile):
                    if os.path.exists(link):
                        print("Linking extra python plugin " + file)
                        relpath = os.path.relpath(link, os.path.dirname(destFile))
                        cp.symlink(relpath,
                                   destFile)
                    else:
                        raise QGISBundlerError("All PyQt5 modules should be already bundled!" + file)

    # these are cpython libs, unlink them it is enough to have them in python site-packages
    for lib in unlink_links:
        cp.unlink(lib)

    # fix duplicit libraries
    # this is really just a workaround,
    # because when libraries are copied, we should copy all the link tree
    # xy.dylib -> dx.1.0.dylib -> dx.1.0.0.dylib ..but now we copy it 3 times
    # and not as links
    workarounds = {}

    for l in ["libwx_osx_cocoau_core",
              "libwx_osx_cocoau_html",
              "libwx_baseu_xml",
              "libwx_osx_cocoau_adv",
              "libwx_baseu"
              ]:
        lib = pa.libDir + "/" + l + "-" + pa.version.libwx + ".dylib"
        existing_link_realpath = pa.libDir + "/" + l + "-" + pa.version.libwxFull + ".dylib"
        workarounds[lib] = existing_link_realpath

    lib = pa.libDir + "/libpq." + pa.version.libpq + ".dylib"
    existing_link_realpath = pa.libDir + "/libpq." + pa.version.libpqFull + ".dylib"
    workarounds[lib] = existing_link_realpath
    for lib, existing_link_realpath in workarounds.items():
        if not (os.path.exists(lib) and os.path.exists(existing_link_realpath)):
            print(
                "WARNING: Workaround " + lib + "->" + existing_link_realpath + " is no longer valid, maybe you upaded packages?")
            continue

        cp.remove(lib)
        relpath = os.path.relpath(existing_link_realpath, os.path.dirname(lib))
        cp.symlink(relpath, lib)

    print(100 * "*")
    print("STEP 3: Copy frameworks to bundle")
    print(100 * "*")
    for framework in frameworks:
        if not framework:
            continue

        frameworkName, baseFrameworkDir = utils.framework_name(framework)
        new_framework = os.path.join(pa.frameworksDir, frameworkName + ".framework")

        # only copy if not already in the bundle
        if os.path.exists(new_framework):
            print("Skipping " + new_framework + " already exists")
            continue

        # do not copy system libs
        if pa.qgisApp not in baseFrameworkDir:
            print("Bundling " + frameworkName + ": " + framework + "  to " + pa.frameworksDir)
            cp.copytree(baseFrameworkDir, new_framework, symlinks=True)
            cp.chmodW(new_framework)

    libPatchedPath = "@executable_path/lib"
    relLibPathToFramework = "@executable_path/../Frameworks"

    # Now everything should be here
    cp.chmodW(pa.qgisApp)

    print(100 * "*")
    print("STEP 4: Fix frameworks linker paths")
    print(100 * "*")
    frameworks = glob.glob(pa.frameworksDir + "/*.framework")
    for framework in frameworks:
        print("Patching " + framework)
        frameworkName = os.path.basename(framework)
        frameworkName = frameworkName.replace(".framework", "")

        # patch versions framework
        last_version = None
        versions = sorted(glob.glob(os.path.join(framework, "Versions") + "/*"))
        for version in versions:
            verFramework = os.path.join(version, frameworkName)
            if os.path.exists(verFramework):
                if not os.path.islink(verFramework):
                    binaryDependencies = otool.get_binary_dependencies(pa, verFramework)
                    cp.chmodX(verFramework)
                    install_name_tool.fix_lib(verFramework, binaryDependencies, pa.contentsDir, libPatchedPath,
                                              relLibPathToFramework)

                if version is not "Current":
                    last_version = os.path.basename(version)
            else:
                print("Warning: Missing " + verFramework)

        # patch current version
        currentFramework = os.path.join(framework, frameworkName)
        if os.path.exists(currentFramework):
            if not os.path.islink(verFramework):
                binaryDependencies = otool.get_binary_dependencies(pa, currentFramework)
                install_name_tool.fix_lib(currentFramework, binaryDependencies, pa.contentsDir, libPatchedPath,
                                          relLibPathToFramework)
                cp.chmodX(currentFramework)
        else:
            if last_version is None:
                print("Warning: Missing " + currentFramework)
            else:
                print("Creating version link for " + currentFramework)
                subprocess.call(["ln", "-s", last_version, framework + "/Versions/Current"])
                subprocess.call(["ln", "-s", "Versions/Current/" + frameworkName, currentFramework])

        # TODO generic?
        # patch helpers (?)
        helper = os.path.join(framework, "Helpers", "QtWebEngineProcess.app", "Contents", "MacOS", "QtWebEngineProcess")
        if os.path.exists(helper):
            binaryDependencies = otool.get_binary_dependencies(pa, helper)
            install_name_tool.fix_lib(helper, binaryDependencies, pa.contentsDir, libPatchedPath, relLibPathToFramework)
            cp.chmodX(helper)

        # TODO generic?
        helper = os.path.join(framework, "Versions/Current/Resources/Python.app/Contents/MacOS/Python")
        if os.path.exists(helper):
            binaryDependencies = otool.get_binary_dependencies(pa, helper)
            install_name_tool.fix_lib(helper, binaryDependencies, pa.contentsDir, libPatchedPath, relLibPathToFramework)
            cp.chmodX(helper)
            # add link to MacOS/bin too
            cp.symlink(os.path.relpath(helper, pa.binDir), pa.binDir + "/python")
            cp.symlink(os.path.relpath(helper, pa.binDir), pa.binDir + "/python3")

        helper = os.path.join(framework, "Versions/Current/lib/" + pa.version.python + "/lib-dynload")
        if os.path.exists(helper):
            for bin in glob.glob(helper + "/*.so"):
                binaryDependencies = otool.get_binary_dependencies(pa, bin)
                install_name_tool.fix_lib(bin, binaryDependencies, pa.contentsDir, libPatchedPath,
                                          relLibPathToFramework)
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

    print(100 * "*")
    print("STEP 5: Fix libraries/plugins linker paths")
    print(100 * "*")
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
            print("Patching " + lib)
            binaryDependencies = otool.get_binary_dependencies(pa, lib)
            install_name_tool.fix_lib(lib, binaryDependencies, pa.contentsDir, libPatchedPath, relLibPathToFramework)
            cp.chmodX(lib)

            # TODO what to do with unlinked_libs????
            # now we hope noone references them
        else:
            print("Skipping link " + lib)

    print(100 * "*")
    print("STEP 6: Fix executables linker paths")
    print(100 * "*")
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
                print("Patching " + exe)
                binaryDependencies = otool.get_binary_dependencies(pa.qgisApp, exe)
                try:
                    install_name_tool.fix_lib(exe, binaryDependencies, pa.contentsDir, libPatchedPath,
                                              relLibPathToFramework)
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
                print("Skipping link " + exe)
                cp.chmodX(exe)

    print(100 * "*")
    print("STEP 7: Fix hardcoded paths in binaries")
    print(100 * "*")

    print("Fix QCA_PLUGIN_PATH Qt Plugin path")
    # It looks like that QCA compiled with QCA_PLUGIN_PATH CMake define
    # adds this by default to QT_PLUGIN_PATH. Overwrite this
    # in resulting binary library
    qcaLib = os.path.join(pa.frameworksDir, "qca-qt5.framework", "qca-qt5")
    f = open(qcaLib, 'rb+')
    data = f.read()
    data = data.replace(bytes(qcaDir + "/lib/qt5/plugins", "utf-8"), bytes(qcaDir + "/xxx/xxx/plugins", "utf-8"))
    f.seek(0)
    f.write(data)
    f.close()
    output = subprocess.check_output(["strings", qcaLib], encoding='UTF-8')
    if qcaLib in output:
        raise QGISBundlerError("Failed to patch " + qcaLib)

    # saga_cmd has hardcoded path to /usr/local to search for the tools and shared folder
    if with_SAGA:
        basePathForLinks = pa.installQgisApp + "/Contents/Resources"
        # we need to replace with the string with same length
        if len(basePathForLinks + "/") < len(pa.host.sagaLibCellar):
            link_length = len(pa.host.sagaLibCellar) - len(basePathForLinks + "/")
            sagaLibDir = ""
            sagaLibDir += link_length * "a"
            sagaLibInstall = basePathForLinks + "/" + sagaLibDir
            print("patching SAGA shared data " + pa.host.sagaLibCellar + " with " + sagaLibInstall)
            cp.symlink(os.path.relpath(pa.sagaDataDir + "/tools", pa.resourcesDir), pa.resourcesDir + "/" + sagaLibDir)
        else:
            raise QGISBundlerError("Unable to modify install path for SAGA lib folder")

        sagaBin = os.path.join(pa.binDir, "saga_cmd")
        f = open(sagaBin, 'rb+')
        data = f.read()
        # we need to replace same number of bytes to not breakup the lib
        if len(pa.host.sagaLibCellar) != len(sagaLibInstall):
            raise QGISBundlerError("bad length  " + sagaLibInstall)
        data = data.replace(bytes(pa.host.sagaLibCellar, "utf-8"),
                            bytes(sagaLibInstall, "utf-8"))
        f.seek(0)
        f.write(data)
        f.close()

        # we need to replace with the string with same length
        if len(basePathForLinks + "/") < len(pa.host.sagaShareCellar):
            link_length = len(pa.host.sagaShareCellar) - len(basePathForLinks + "/")
            sagaShareDir = ""
            sagaShareDir += link_length * "b"
            sagaShareInstall = basePathForLinks + "/" + sagaShareDir
            print("patching SAGA shared data " + pa.host.sagaShareCellar + " with " + sagaShareInstall)
            cp.symlink(os.path.relpath(pa.sagaDataDir, pa.resourcesDir), pa.resourcesDir + "/" + sagaShareDir)
        else:
            raise QGISBundlerError("Unable to modify install path for SAGA shared folder")

        f = open(sagaBin, 'rb+')
        data = f.read()
        if len(pa.host.sagaShareCellar) != len(sagaShareInstall):
            raise QGISBundlerError("bad length  " + sagaShareInstall)
        data = data.replace(bytes(pa.host.sagaShareCellar, "utf-8"),
                            bytes(sagaShareInstall, "utf-8"))
        f.seek(0)
        f.write(data)
        f.close()

        output = subprocess.check_output(["strings", sagaBin], encoding='UTF-8')
        if "osgeo-saga-lts" in output:
            raise QGISBundlerError("Failed to patch " + sagaBin)

        # unlink in lib/saga because here SAGA_MLB variable points in QGIS SAGA processing script
        if os.path.exists(pa.libDir + "/saga"):
            raise QGISBundlerError("Extra dir in lib/saga")

    print(100 * "*")
    print("STEP 8: Create some extra links")
    print(100 * "*")
    # PROJ
    if not os.path.exists(pa.libDir + "/" + pa.version.projLib):
        raise QGISBundlerError("Proj lib not present " + pa.version.projLib + ". Maybe it has new version?")
    cp.symlink(pa.version.projLib, pa.libDir + "/libproj.dylib")

    # GRASS7
    link = pa.grass7Dir + "/lib"
    if os.path.exists(link):
        raise QGISBundlerError(link + " should have been deleted during grass7 copy.")
    cp.symlink(os.path.relpath(pa.libDir, pa.grass7Dir), link)
    cp.remove(pa.grass7Dir + "/grass.sh")
    cp.symlink("bin/" + pa.version.grass, pa.grass7Dir + "/grass.sh")
    cp.remove(pa.grass7Dir + "/" + pa.version.grass + ".sh")
    cp.symlink("bin/" + pa.version.grass, pa.grass7Dir + "/" + pa.version.grass + ".sh")

    print(100 * "*")
    print("STEP 9: Clean redundant files")
    print(100 * "*")
    clean_redundant_files(pa, cp)

    print(100 * "*")
    print("STEP 10: Patch files")
    print(100 * "*")
    patch_files(pa, pa.version.minos)

    print(100 * "*")
    print("STEP 11: Test full tree QGIS.app")
    print(100 * "*")
    test_full_tree_consistency(pa)

    # Wow we are done!
    cpt = sum([len(files) for r, d, files in os.walk(pa.qgisApp)])
    print("Done with files bundled " + str(cpt))
