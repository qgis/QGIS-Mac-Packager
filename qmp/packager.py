# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import os
import subprocess

from .common import QGISPackageError


def sign_this(path, identity, keychainFile):
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
        print(out.strip())
    except subprocess.CalledProcessError as err:
        if not "is already signed" in str(err.output):
            print(err.output)
            raise
        else:
            print(path + " is already signed")


def sign_bundle_content(qgisApp, identity, keychain):
    # sign all binaries/libraries but QGIS
    for root, dirs, files in os.walk(qgisApp, topdown=False):
        # first sign all binaries
        for file in files:
            filepath = os.path.join(root, file)
            filename, file_extension = os.path.splitext(filepath)
            if file_extension in [".dylib", ".so", ""] and os.access(filepath, os.X_OK):
                if not filepath.endswith("/Contents/MacOS/QGIS"):
                    sign_this(filepath, identity, keychain)

    # it is not necessary to sign each individual resource separately

    # now sign the directory
    print("Sign the app dir")
    sign_this(qgisApp + "/Contents/MacOS/QGIS", identity, keychain)
    sign_this(qgisApp, identity, keychain)


def verify_sign(path):
    args = ["codesign",
            "--deep-verify",
            "--verbose",
            path]

    try:
        out = subprocess.check_output(args, stderr=subprocess.STDOUT, encoding='UTF-8')
        print(out.strip())
    except subprocess.CalledProcessError as err:
        print(err.output)
        raise


def print_identities(keychain):
    args = ["security",
            "find-identity",
            "-v", "-p",
            "codesigning"]

    if keychain:
        args += [keychain]

    try:
        out = subprocess.check_output(args, stderr=subprocess.STDOUT, encoding='UTF-8')
        print(out.strip())
    except subprocess.CalledProcessError as err:
        print(err.output)
        raise


def package(msg, pa, signFile = None, keychainFile = None):
    '''
        sign: File with Apple signing identity'
        keychain: keychain file to use
    '''

    if not os.path.exists(pa.qgisApp):
        raise QGISPackageError(pa.qgisApp + " does not exists")

    identity = None
    if signFile:
        with open(signFile, "r") as fh:
            # parse token
            identity = fh.read().strip()
            if len(identity) != 40:
                raise QGISPackageError("ERROR: Looks like your ID is not valid, should be 40 char long")

    if keychainFile:
        keychainFile = os.path.realpath(keychainFile)
        print("Using keychain " + keychainFile)
        if not os.path.exists(keychainFile):
            raise QGISPackageError("missing file " + keychainFile)
    else:
        print("No keychain file specified")

    print("Print available identities")
    print_identities(keychainFile)

    if identity:
        print("Signing the bundle")
        sign_bundle_content(pa.qgisApp, identity, keychainFile)
        verify_sign(pa.qgisApp)
    else:
        print("Signing skipped, no identity supplied")

    print(100 * "*")
    print("STEP: Create dmg image")
    print(100 * "*")
    dmgFile = pa.output.dmg
    if os.path.exists(dmgFile):
        print("Removing old dmg")
        os.remove(dmgFile)

    args = ["/usr/local/bin/dmgbuild",
            "-Dapp=" + pa.qgisApp,
            "-s", pa.package.resources + "/dmgsettings.py",
            pa.args.qgisapp_name,
            dmgFile,
            ]

    try:
        out = subprocess.check_output(args, stderr=subprocess.STDOUT, encoding='UTF-8')
        print(out)
    except subprocess.CalledProcessError as err:
        print(err.output)
        raise

    if identity:
        sign_this(dmgFile, identity, keychainFile)
        verify_sign(pa.qgisApp)
    else:
        print("Signing skipped, no identity supplied")

    fsize = subprocess.check_output(["du", "-h", dmgFile], stderr=subprocess.STDOUT, encoding='UTF-8')
    print("ALL DONE\n" + fsize)
