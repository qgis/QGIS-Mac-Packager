# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import subprocess
import os
from .utils import framework_basename


def _run(args, msg):
    try:
        subprocess.run(
            args,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,  # Combine out/err into stdout; stderr will be None
            universal_newlines=True,
            check=True,
            encoding='UTF-8'
        )
    except subprocess.CalledProcessError as err:
        if "is not a Mach-O file" in err.output:
            msg.dbg("{}\n{}".format(" ".join(args), err.output))
        else:
            msg.warn("{}\n{}".format(" ".join(args), err.output))


def fix_lib(msg, binary, depLibs, contentsPath, relLibPathToExe, relLibPathToFramework):
    binary = os.path.realpath(binary)
    p = binary.replace(contentsPath, "@executable_path/..")
    args = ["install_name_tool", "-id", p, binary]
    _run(args, msg)

    for lib in depLibs.libs:
        args = ["install_name_tool",
                "-change", lib,
                relLibPathToExe + "/" + os.path.basename(lib),
                binary]
        _run(args, msg)

    for framework in depLibs.frameworks:
        framework_name, framework_dir = framework_basename(framework)
        # Do not use versions lib, just the main one
        framework_path = relLibPathToFramework + "/" + framework_name + ".framework/" + framework_name
        args = ["install_name_tool", "-change", framework, framework_path, binary]
        _run(args, msg)
