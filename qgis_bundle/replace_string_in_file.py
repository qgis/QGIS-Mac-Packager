# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version
import os
import argparse
import subprocess

def _replace_string_in_binary(filename, src, dest):
    if not os.path.exists(filename):
        raise Exception("{} does not exist" + filename)

    if len(src) != len(dest):
        raise Exception("Unable to patch {}, src and dest must have the same length" + filename)

    with open(filename, 'rb+') as fh:
        data = fh.read()
        data = data.replace(bytes(src, "utf-8"), bytes(dest, "utf-8"))
        fh.seek(0)
        fh.write(data)

    output = subprocess.check_output(["strings", filename], encoding='UTF-8')
    if src in output:
        raise Exception("Failed to patch " + filename)


parser = argparse.ArgumentParser(description='Replace string in binary')
parser.add_argument('--file',
                    required=True)

parser.add_argument('--install_path',
                    required=True)

parser.add_argument('--bundle_path',
                    required=True)

parser.add_argument('--stage_path',
                    required=True)

args = parser.parse_args()

homebrew = "/usr/local/"

for i in [homebrew, args.install_path, args.bundle_path, args.stage_path]:
    key = "INVALID/"
    replacement = key + i[len(key):]
    _replace_string_in_binary(args.file, i, replacement)
