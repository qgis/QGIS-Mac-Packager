# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import subprocess
import os


class BinaryDependencies:
    def __init__(self, libname, path, frameworks, sys_libs, libs):
        self.libname = libname
        self.path = path
        self.frameworks = frameworks
        self.sys_libs = sys_libs
        self.libs = libs

    def __str__(self):
        msg = "BinaryDependency " + self.libname + " (" + self.path + ")"
        msg += "\nLibs:\n\t"
        msg += "\n\t".join(self.libs)
        msg += "\nFrameworks:\n\t"
        msg += "\n\t".join(self.frameworks)
        msg += "\nSysLibs:\n\t"
        msg += "\n\t".join(self.sys_libs)
        return msg


def is_omach_file(binary):
    args = ["otool", "-L", binary]
    try:
        ret = subprocess.check_output(args, encoding='UTF-8')
    except:
        return False

    return "is not an object file" not in ret


SYS_LIB = 1
LIB = 2
FRAMEWORK = 3
BINARY = 4


def binary_type(pa, lib_path):
    filename, file_extension = os.path.splitext(lib_path)
    # hmmm, some broken library in python package
    if "/DLC/h5py/" in lib_path:
        lib_path = lib_path.replace("/DLC/h5py/", "/usr/local/lib/" + pa.version.python +"/site-packages/h5py/.dylibs/")
    if "/DLC/psycopg2/" in lib_path:
        lib_path = lib_path.replace("/DLC/psycopg2/", "/usr/local/lib/" + pa.version.python +"/site-packages/psycopg2/.dylibs/")
    if "/DLC/PIL/" in lib_path:
        lib_path = lib_path.replace("/DLC/PIL/", "/usr/local//lib/" + pa.version.python +"/site-packages/PIL/.dylibs/")
    if "/DLC/pyproj/" in lib_path:
        lib_path = lib_path.replace("/DLC/pyproj/", "/usr/local/lib/" + pa.version.python +"/site-packages/pyproj/.dylibs/")

    # note "/opt/X11" comes from XQuarz and it has ALREADY signed X libraries
    if lib_path.startswith("/usr/lib/") or lib_path.startswith("/System/Library/"):
        type = SYS_LIB
        # current/lib and bin is for some reason Python has some bundled libs/exes in framework
        # plugins is for dynamically loaded plugins in frameworks (e.g. Qt modules)
    elif (".framework" in lib_path) and ("/plugins/" not in lib_path) and ("/Current/lib/" not in lib_path) and (
            "/Current/bin/" not in lib_path):
        type = FRAMEWORK
    # elif [".dylib", ".so"] in lib_path:
    elif file_extension in [".dylib", ".so"]:
        type = LIB
    else:
        # binaries
        type = BINARY
    return lib_path, type


def get_binary_dependencies(pa, binary):
    args = ["otool", "-L", binary]
    ret = subprocess.check_output(args, encoding='UTF-8')
    otool_libs = ret.split("\n")
    path = otool_libs.pop(0)[:-1] # first one is the library path
    libname = os.path.basename(path)

    frameworks = []
    sys_libs = []
    libs = []
    binaries = []

    # also add library itself
    for lib in otool_libs + [binary]:
        # e.g.
        # \t@executable_path/lib/libqgis_app.3.3.0.dylib (compatibility version 3.3.0, current version 3.3.0)
        lib = lib.strip()
        lib_parts = lib.split(" (")
        lib_path = lib_parts[0]

        lib_path, type = binary_type(pa, lib_path)

        if type is SYS_LIB:
            sys_libs.append(lib_path)
        elif type is FRAMEWORK:
            frameworks.append(lib_path)
        elif type is LIB:
            libs.append(lib_path)
        elif type is BINARY:
            binaries.append(lib_path)
        else:
            raise Exception("Internal error: missing enum type " + type)

    # binaries must be copied manually to the destination
    return BinaryDependencies(libname, path, frameworks, sys_libs, libs)


