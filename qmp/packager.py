# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import os
import subprocess

from .common import QGISPackageError


def sign_this(msg, path, identity, keychainFile):
    # TODO maybe codesing --deep option will be satisfactory
    # instead of signing one by one binary!
    try:
        args = ["codesign",
                "-s", identity,
                "-v",
                "--force"]
        # --force is required, since XQuarz packages in brew is already
        # signed and you cannot ship bundle with 2 different signatures
        # we may end up in resigning the binaries, but who cares

        if keychainFile:
            args += ["--keychain", keychainFile]

        args += [path]

        out = subprocess.check_output(args, stderr=subprocess.STDOUT, encoding='UTF-8')
        msg.dev(out.strip())
    except subprocess.CalledProcessError as err:
        if "is already signed" not in str(err.output):
            raise QGISPackageError(err.output)
        else:
            msg.dev(path + " is already signed")


def sign_bundle_content(msg, qgisApp, identity, keychain):
    # sign all binaries/libraries but QGIS
    for root, dirs, files in os.walk(qgisApp, topdown=False):
        # first sign all binaries
        for file in files:
            file_path = os.path.join(root, file)
            filename, file_extension = os.path.splitext(file_path)
            if file_extension in [".dylib", ".so", ""] and os.access(file_path, os.X_OK):
                if not file_path.endswith("/Contents/MacOS/QGIS"):
                    sign_this(msg, file_path, identity, keychain)

    # it is not necessary to sign each individual resource separately
    # now sign the directory
    sign_this(msg, qgisApp + "/Contents/MacOS/QGIS", identity, keychain)
    sign_this(msg, qgisApp, identity, keychain)


def verify_sign(msg, path):
    args = ["codesign",
            "--deep-verify",
            "--verbose",
            path]

    try:
        out = subprocess.check_output(args, stderr=subprocess.STDOUT, encoding='UTF-8')
        msg.info(out.strip())
    except subprocess.CalledProcessError as err:
        raise QGISPackageError(err.output)


def print_identities(msg, keychain):
    args = ["security",
            "find-identity",
            "-v", "-p",
            "codesigning"]

    if keychain:
        args += [keychain]

    try:
        out = subprocess.check_output(args, stderr=subprocess.STDOUT, encoding='UTF-8')
        msg.dev(out.strip())
    except subprocess.CalledProcessError as err:
        raise QGISPackageError(err.output)


def package(msg, pa):
    '''
        sign: File with Apple signing identity'
        keychain: keychain file to use
    '''

    if not os.path.exists(pa.qgisApp):
        raise QGISPackageError(pa.qgisApp + " does not exists")

    if pa.args.no_credentials:
        sign_file = None
        keychain_file = None
    else:
        sign_file = pa.host.sign_identity
        keychain_file = pa.host.keychain

    identity = None
    if sign_file:
        with open(sign_file, "r") as fh:
            # parse token
            identity = fh.read().strip()
            if len(identity) != 40:
                raise QGISPackageError("ERROR: Looks like your ID is not valid, should be 40 char long")

    if keychain_file:
        keychain_file = os.path.realpath(keychain_file)
        msg.dev("Using keychain " + keychain_file)
        if not os.path.exists(keychain_file):
            raise QGISPackageError("missing file " + keychain_file)

    msg.dev("Print available identities")
    print_identities(msg, keychain_file)

    msg.header("Signing the files " + pa.qgisApp)
    if identity:
        sign_bundle_content(msg, pa.qgisApp, identity, keychain_file)
        verify_sign(msg, pa.qgisApp)
    else:
        msg.info("Signing skipped, no identity supplied")

    msg.header("Create dmg image")
    dmg_file = pa.output.dmg
    if os.path.exists(dmg_file):
        msg.info("Removing old dmg")
        os.remove(dmg_file)

    args = ["/usr/local/bin/dmgbuild",
            "-Dapp=" + pa.qgisApp,
            "-s", pa.package.resources + "/dmgsettings.py",
            pa.args.qgisapp_name,
            dmg_file]

    try:
        out = subprocess.check_output(args, stderr=subprocess.STDOUT, encoding='UTF-8')
        msg.dev(out)
    except subprocess.CalledProcessError as err:
        raise QGISPackageError(err.output)

    msg.header("Signing the dmg " + dmg_file)
    if identity:
        sign_this(msg, dmg_file, identity, keychain_file)
        verify_sign(msg, pa.qgisApp)
    else:
        msg.info("Signing skipped, no identity supplied")

    f_size = subprocess.check_output(["du", "-h", dmg_file], stderr=subprocess.STDOUT, encoding='UTF-8')
    msg.info("Dmg created with size " + f_size)
