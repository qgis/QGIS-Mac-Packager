# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import glob
import os

from .utils import framework_basename, files_differ
from ..common import QGISBundlerError


def copy_extenal_deps_to_bundle(cp, msg, pa, libs, frameworks):
    unlinked_libs = set()
    unlink_links = set()

    copied_files = 0

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
            msg.dev("Bundling " + lib + " to " + target_dir)
            copied_files += 1
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
                # we already have this lib in the bundle (because there is a link! in lib/),
                # so make sure we do not have it twice!
                existing_link_realpath = os.path.realpath(link)
                if existing_link_realpath != os.path.realpath(lib):
                    if files_differ(existing_link_realpath, lib):
                        # libraries with the same name BUT with different contents
                        # so do not have it in libs folder because we do not know which
                        # we HOPE that this happens only for cpython extensions for python modules
                        if pa.version.cpython not in link:
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
                        msg.dev("Linking extra python plugin " + file)
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
            str = "Workaround " + lib + "->" + existing_link_realpath
            str += " is no longer valid, maybe you upaded packages?"
            msg.warn(str)
            continue

        cp.remove(lib)
        relpath = os.path.relpath(existing_link_realpath, os.path.dirname(lib))
        cp.symlink(relpath, lib)

    for framework in frameworks:
        if not framework:
            continue

        framework_name, base_framework_dir = framework_basename(framework)
        new_framework = os.path.join(pa.frameworksDir, framework_name + ".framework")

        # only copy if not already in the bundle
        if os.path.exists(new_framework):
            msg.dbg("Skipping " + new_framework + " already exists")
            continue

        # do not copy system libs
        if pa.qgisApp not in base_framework_dir:
            msg.dev("Bundling " + framework_name + ": " + framework + "  to " + pa.frameworksDir)
            copied_files += 1
            cp.copytree(base_framework_dir, new_framework, symlinks=True)
            cp.chmodW(new_framework)

    msg.info("Copied {} files".format(copied_files))
