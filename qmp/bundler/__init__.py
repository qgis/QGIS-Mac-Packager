# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

from .otool import *
from .install_name_tool import *
from .utils import *
from .copy_files_to_bundle import copy_files_to_bundle
from .analyze_external_deps import analyze_external_deps
from .copy_external_deps_to_bundle import copy_extenal_deps_to_bundle
from .fix_linker_paths import fix_linker_paths
from .clean_redundant_files import clean_redundant_files
from .patch_files import patch_files
from .test_full_tree_consistency import test_full_tree_consistency


def bundle(cp, msg, pa):
    msg.header("Copy QGIS and independent folders to build folder")
    copy_files_to_bundle(cp, msg, pa)

    msg.header("Analyze the libraries we need to bundle")
    external_libs, external_frameworks, qca_dir = analyze_external_deps(cp, msg, pa)

    msg.header("Copy libraries/plugins/frameworks to bundle")
    copy_extenal_deps_to_bundle(cp, msg, pa, libs=external_libs, frameworks=external_frameworks)

    msg.header("Fix frameworks links/executables links/hardcoded paths in binaries")
    fix_linker_paths(cp,
                     msg,
                     pa,
                     qca_dir)

    msg.header("Clean redundant files")
    clean_redundant_files(msg, pa, cp)

    msg.header("Patch files")
    patch_files(msg, pa, pa.version.minos)

    msg.header("Test full tree QGIS.app")
    test_full_tree_consistency(msg, pa)

    # Wow we are done!
    cpt = sum([len(files) for r, d, files in os.walk(pa.qgisApp)])
    msg.info("Done with files bundled " + str(cpt))
