# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import glob
import os

from .otool import get_binary_dependencies, binary_type, SYS_LIB, FRAMEWORK, LIB
from .utils import resolve_libpath
from ..common import QGISBundlerError


def analyze_external_deps(cp, msg, pa):
    # Find QT
    qt_dir = None
    for framework in get_binary_dependencies(pa, pa.qgisExe).frameworks:
        if "lib/QtCore.framework" in framework:
            path = os.path.realpath(framework)
            qt_dir = path.split("/lib/")[0]
            break
    if not qt_dir:
        raise QGISBundlerError("Unable to find QT install directory")
    msg.info("Found QT: " + qt_dir)

    # Find QCA dir
    qca_dir = None
    for framework in get_binary_dependencies(pa, pa.qgisExe).frameworks:
        if "lib/qca" in framework:
            path = os.path.realpath(framework)
            qca_dir = path.split("/lib/")[0]
            break
    if not qca_dir:
        raise QGISBundlerError("Unable to find QCA install directory")
    msg.info("Found QCA: " + qca_dir)

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
    deps_queue |= set(glob.glob(qt_dir + "/plugins/*/*.dylib"))
    deps_queue |= set(glob.glob(qca_dir + "/lib/qt5/plugins/*/*.dylib"))
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
    # debug_lib = "libproj.13.dylib"

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
        lib_fixed = resolve_libpath(pa, lib_fixed)

        if "@loader_path" in lib_fixed:
            raise QGISBundlerError("Ups, unable to get library path, maybe fix resolve_libpath? " + lib_fixed)

        if lib_fixed in done_queue:
            continue

        if not lib_fixed:
            continue

        if os.path.isdir(lib_fixed):
            continue

        extra_info = "" if lib == lib_fixed else "(" + lib_fixed + ")"
        msg.dev("Analyzing " + lib + extra_info)

        if not os.path.exists(lib_fixed):
            raise QGISBundlerError("Library missing! " + lib_fixed)

        done_queue.add(lib_fixed)

        binary_dependencies = get_binary_dependencies(pa, lib_fixed)

        if debug_lib:
            for l in binary_dependencies.libs:
                if debug_lib in l:
                    msg.dbg("{} -- {}".format(debug_lib, lib))

        lib_fixed, tp = binary_type(pa, lib_fixed)
        if tp is SYS_LIB:
            sys_libs |= set(binary_dependencies.sys_libs)
        elif tp is FRAMEWORK:
            frameworks |= set([lib_fixed])
        elif tp is LIB:
            libs |= set([lib_fixed])

        deps_queue |= set(binary_dependencies.libs)
        deps_queue |= set(binary_dependencies.frameworks)

    s = "\nLibs:\n\t"
    s += "\n\t".join(sorted(libs))
    s += "\nFrameworks:\n\t"
    s += "\n\t".join(sorted(frameworks))
    s += "\nSysLibs:\n\t"
    s += "\n\t".join(sorted(sys_libs))
    msg.info(s)

    return libs, frameworks, qca_dir
