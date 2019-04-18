# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import os
import shutil
import subprocess


def files_differ(file1, file2):
    try:
        subprocess.check_output(["diff", file1, file2], stderr=subprocess.STDOUT, encoding='UTF-8')
    except subprocess.CalledProcessError:
        return True
    return False


def framework_name(framework):
    path = framework
    while path:
        path = os.path.abspath(path)
        if path.endswith(".framework"):
            break
        path = os.path.join(path, os.pardir)

    if not path:
        raise Exception("Wrong framework directory structure!" + framework)

    frameworkName = os.path.basename(path)
    frameworkName = frameworkName.replace(".framework", "")

    return frameworkName, path


def is_text(fn):
    msg = subprocess.Popen(["file", "--mime", fn],
                           stdout=subprocess.PIPE,
                           encoding='UTF-8',
                           errors='replace').communicate()[0]
    # returns something like
    # <path>/libdelimitedtextprovider.so: application/x-mach-binary; charset=binary
    msg = msg.replace(fn, "")
    return "text" in msg


def resolve_libpath(pa, lib_path):
    # loader path should be really resolved here, because
    # it is relative to this binary
    if "@loader_path" in lib_path:
        if os.path.exists(lib_path.replace("@loader_path/../../../MacOS/../Frameworks", pa.frameworksDir)):
            lib_path = lib_path.replace("@loader_path/../../../MacOS/../Frameworks", pa.frameworksDir)
        elif os.path.exists(lib_path.replace("@loader_path/../../MacOS/../Frameworks", pa.frameworksDir)):
            lib_path = lib_path.replace("@loader_path/../../MacOS/../Frameworks", pa.frameworksDir)
        elif os.path.exists(lib_path.replace("@loader_path/../../../MacOS/..", pa.contentsDir)):
            lib_path = lib_path.replace("@loader_path/../../../MacOS/..", pa.contentsDir)
        elif os.path.exists(lib_path.replace("@loader_path/../../..", pa.frameworksDir)):
            lib_path = lib_path.replace("@loader_path/../../..", pa.frameworksDir)
        elif os.path.exists(lib_path.replace("@loader_path/../..", pa.contentsDir)):
            lib_path = lib_path.replace("@loader_path/../..", pa.contentsDir)
        elif os.path.exists("/usr/local/lib" + lib_path.replace("@loader_path/.dylibs", "")):
            lib_path = "/usr/local/lib" + lib_path.replace("@loader_path/.dylibs", "")
        elif os.path.exists("/usr/local/lib" + lib_path.replace("@loader_path/../.dylibs", "")):
            lib_path = "/usr/local/lib" + lib_path.replace("@loader_path/../.dylibs", "")
        elif os.path.exists("/usr/local" + lib_path.replace("@loader_path", "")):
            lib_path = "/usr/local" + lib_path.replace("@loader_path", "")
        elif os.path.exists("/usr/local/lib" + lib_path.replace("@loader_path", "")):
            lib_path = "/usr/local/lib" + lib_path.replace("@loader_path", "")
        elif os.path.exists("/usr/local/opt/opencv@2/lib" + lib_path.replace("@loader_path", "")):
            # opencv@2 is not in /usr/local/lib
            lib_path = "/usr/local/opt/opencv@2/lib" + lib_path.replace("@loader_path", "")
        elif os.path.exists("/usr/local/opt/icu4c/lib/" + lib_path.replace("@loader_path", "")):
            # icu4c is not in /usr/local/lib
            lib_path = "/usr/local/opt/icu4c/lib/" + lib_path.replace("@loader_path", "")
        else:
            # workarounds. Some python packages have bundled their libraries
            # but the libraries are in different version than the libraries
            # from brew packages
            for item in os.listdir(pa.host.pySitePackages):
                s = os.path.join(pa.host.pySitePackages, item)
                if os.path.isdir(s):
                    if os.path.exists(s + "/" + lib_path.replace("@loader_path", "")):
                        lib_path = s + "/" + lib_path.replace("@loader_path", "")
                        break
                    if os.path.exists(s + "/.dylibs/" + lib_path.replace("@loader_path", "")):
                        lib_path = s + "/.dylibs/" + lib_path.replace("@loader_path", "")
                        break
                    if os.path.exists(s + "/" + lib_path.replace("@loader_path/..", "")):
                        lib_path = s + "/" + lib_path.replace("@loader_path/..", "")
                        break
                    if os.path.exists(s + "/.dylibs/" + lib_path.replace("@loader_path/..", "")):
                        lib_path = s + "/.dylibs/" + lib_path.replace("@loader_path/..", "")
                        break
    return lib_path
