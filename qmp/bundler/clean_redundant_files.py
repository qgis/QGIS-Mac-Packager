# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import os


def clean_redundant_files(msg, pa, cp):
    removed_files = 0
    removed_dirs = 0
    removed_links = 0

    extensions_to_check = [".a", ".pyc", ".c", ".cpp", ".h", ".hpp", ".cmake", ".prl"]
    dirs_to_check = ["/include", "/Headers", "/__pycache__", "/man/"]

    # remove unneeded files/dirs
    for root, dirnames, filenames in os.walk(pa.qgisApp):
        for file in filenames:
            fpath = os.path.join(root, file)
            filename, file_extension = os.path.splitext(fpath)
            if any(ext == file_extension for ext in extensions_to_check):
                msg.dev("Removing " + fpath)
                cp.rm(fpath)
                removed_files += 1

        for dir in dirnames:
            dpath = os.path.join(root, dir)
            if any(ext in dpath for ext in dirs_to_check):
                msg.dev("Removing " + dpath)
                cp.rm(dpath)
                removed_dirs += 1

    # remove broken links and empty dirs
    for root, dirnames, filenames in os.walk(pa.qgisApp):
        for file in filenames:
            fpath = os.path.join(root, file)
            real = os.path.realpath(fpath)
            if not os.path.exists(real):
                msg.dev("Removing empty/broken " + fpath)
                os.unlink(fpath)
                removed_links += 1

    msg.info("Removed {} files, {} dirs, {} broken links".format(removed_files, removed_dirs, removed_links))
