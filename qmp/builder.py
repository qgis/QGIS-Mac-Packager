# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import os
import git
import subprocess
import multiprocessing

from .common import QGISBuildError


class Progress(git.remote.RemoteProgress):
    def __init__(self, msg):
        self.msg = msg

    def update(self, op_code, cur_count, max_count=None, message=''):
        self.msg.dev('update(%s, %s, %s, %s)' % (op_code, cur_count, max_count, message))


def _update_git(msg, pa, git_commit, qgis_repo):

    if not os.path.exists(pa.output.qgis):
        os.makedirs(pa.output.qgis)
    os.chdir(pa.output.qgis)
    if os.listdir(pa.output.qgis):
        # dir is not empty
        try:
            repo = git.Repo(pa.output.qgis)
        except git.InvalidGitRepositoryError:
            raise QGISBuildError(pa.output.qgis + 'isn`t git repo')
    else:
        # clone
        msg.info("Cloning " + qgis_repo)
        git.Repo.clone_from(qgis_repo, pa.output.qgis, progress=Progress(msg))

    repo = git.Repo(pa.output.qgis)
    g = git.Git(pa.output.qgis)
    o = repo.remotes.origin
    o.fetch()
    g.checkout(git_commit)
    try:
        # pull does not work when we have tag, only on branch (e.g. master)
        o.pull()
    except git.exc.GitCommandError:
        msg.dev("Failed to pull, probably you are on tag and not branch...")


def _clean(msg, cp, clean, pa):
    if clean:
        msg.info("Cleaning: " + pa.output.build)
        cp.recreate_dir(pa.output.build)
    else:
        msg.dev("Skipped, clean build not requested")
        if not os.path.exists(pa.output.build):
            os.makedirs(pa.output.build)

    # always clean the install directory
    msg.dev("Cleaning: " + pa.output.install)
    cp.recreate_dir(pa.output.install)


def _generate_cmake(msg, pa):
    os.chdir(pa.output.build)

    env = {
        "PATH": pa.host.path,
        "GRASS_PREFIX7": pa.host.grass_base,
        "LIB_DIR": pa.host.libdir
    }

    # copied from homebrew receipt... is it needed at all?
    # keep superenv from stripping (use Cellar prefix)
    env["CXXFLAGS"] = "-isystem {}/include".format(pa.host.grass_base)

    # FindGEOS.cmake is confused because it finds geos library but not framework Info.plist
    cmake_args = [
        "cmake",
        "-DCMAKE_BUILD_TYPE=Release",
        "-DCMAKE_INSTALL_PREFIX=" + os.path.realpath(pa.output.install),
        "-DCMAKE_PREFIX_PATH=" + pa.host.cmakePrefix,
        "-DQGIS_MACAPP_BUNDLE=0",
        "-DWITH_3D=TRUE",
        "-DWITH_BINDINGS=TRUE",
        "-DSQLITE3_INCLUDE_DIR=" + pa.host.sqlite + "/include",
        "-DSQLITE3_LIBRARY=" + pa.host.sqlite + "/lib/libsqlite3.dylib",
        "-DCMAKE_FIND_FRAMEWORK=LAST"]

    enable_tests = False  # TODO
    if not enable_tests:
        # disable unit tests
        cmake_args += ["-DENABLE_TESTS=FALSE"]

    cmake_args += ["-DCMAKE_OSX_DEPLOYMENT_TARGET={}".format(pa.version.minos)]
    cmake_args += [pa.output.qgis]

    try:
        result = subprocess.run(
            cmake_args,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,  # Combine out/err into stdout; stderr will be None
            universal_newlines=True,
            check=True,
            env=env,
            encoding='UTF-8'
        )
        output = result.stdout
        msg.info(output)

        if "Could not determine GEOS version from framework." in output:
            raise QGISBuildError("Unable to determine GEOS version!!")

        if "Could not find GRASS 7" in output:
            raise QGISBuildError("Unable to determine GRASS7 installation!!")

    except subprocess.CalledProcessError as err:
        raise QGISBuildError(err.output)

    return env


def _make(msg, pa, env):
    cores = multiprocessing.cpu_count() - 1
    os.chdir(pa.output.build)

    make_args = ["make", "-j" + str(cores), "install"]
    try:
        result = subprocess.run(
            make_args,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,  # Combine out/err into stdout; stderr will be None
            universal_newlines=True,
            check=True,
            env=env,
            encoding='UTF-8',
            errors='replace'
        )
        output = result.stdout
        msg.dev(output)

        if "make: *** [all] Error" in output:
            raise QGISBuildError("Found build error")

    except subprocess.CalledProcessError as err:
        raise QGISBuildError(err.output)


def build(cp, msg, pa, clean, git_commit, qgis_repo):
    msg.header("Get QGIS repo " + qgis_repo)
    _update_git(msg, pa, git_commit, qgis_repo)

    msg.header("Clean the build/install directory ")
    _clean(msg, cp, clean, pa)

    msg.header("Generate CMAKE build system")
    env = _generate_cmake(msg, pa)

    msg.header("Make")
    _make(msg, pa, env)
