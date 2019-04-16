# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import os
import shutil
import subprocess

# to make sure we
# NEVER NEVER NEVER
# deletes something outside
# the build directory
class CopyUtils:
    def __init__(self, outdir, verbose=True):
        self.outdir = outdir
        self.verbose = verbose

    def _is_in_out_dir(self, name):
        if self.outdir not in name:
            realpath = os.path.realpath(name)
            if self.outdir not in realpath:
                raise Exception("Trying to do file operation outside bundle directory! " + name)

    def chmodW(self, path):
        self._is_in_out_dir(path)
        subprocess.call(['chmod', '-R', '+w', path])

    def chmodX(self, path):
        self._is_in_out_dir(path)
        subprocess.call(['chmod', '-R', '+x', path])

    def recreate_dir(self, name):
        if os.path.exists(name):
            self.rmtree(name)
            if os.path.exists(name + "/.DS_Store"):
                self.remove(name + "/.DS_Store")
        else:
            os.makedirs(name)

    def rename(self, src, dest):
        self._is_in_out_dir(src)
        self._is_in_out_dir(dest)
        os.rename(src, dest)

    def remove(self, name):
        self._is_in_out_dir(name)
        os.remove(name)

    def rmtree(self, name):
        self._is_in_out_dir(name)
        shutil.rmtree(name)

    def symlink(self, src, dest):
        self._is_in_out_dir(dest)
        if os.path.isabs(src):
            self._is_in_out_dir(src)
        else:
            self._is_in_out_dir(os.path.dirname(dest) + "/" + src)
        try:
            os.symlink(src, dest)
        except:
            print( dest + " -> " + src)
            raise

    def unlink(self, name):
        self._is_in_out_dir(name)
        os.unlink(name)

    def copy(self, src, dest):
        self._is_in_out_dir(dest)
        shutil.copy2(src, dest)

    def copytree(self, src, dest, symlinks):
        self._is_in_out_dir(dest)
        shutil.copytree(src, dest, symlinks=symlinks)

    def rm(self, src):
        if os.path.exists(src):
            self._is_in_out_dir(src)
            if os.path.islink(src):
                self.unlink(src)
            elif os.path.isfile(src):
                self.remove(src)
            else:
                self.rmtree(src)
