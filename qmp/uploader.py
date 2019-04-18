# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import subprocess

from .common import QGISUploadError


class RemoteCommand(object):
    def __init__(self, msg, pa, server):
        self.pa = pa
        self.server = server
        self.msg = msg

    def ssh(self, cmd):
        args = ["ssh", "-i", self.pa.host.ssh_private_key, self.server, cmd]
        try:
            out = subprocess.check_output(args, stderr=subprocess.STDOUT, encoding='UTF-8')
            self.msg.info(out)
        except subprocess.CalledProcessError as err:
            raise QGISUploadError(err.output)

    def scp(self, src, dest):
        args = ["scp", "-i", self.pa.host.ssh_private_key, src, self.server + ":" + dest]

        try:
            out = subprocess.check_output(args, stderr=subprocess.STDOUT, encoding='UTF-8')
            self.msg.info(out)
        except subprocess.CalledProcessError as err:
            raise QGISUploadError(err.output)


def upload(msg, pa, server, folder):
    if pa.args.no_credentials:
        msg.msg("Upload skipped, no ssh key supplied")
        return

    rc = RemoteCommand(msg, pa, server)

    # create folder
    root = folder + "/" + pa.args.release_type
    rc.ssh("mkdir -p " + root)

    print("Folder " + root + " created")

    # upload file
    src = pa.output.dmg
    remote_dmg = root + "/" + pa.args.dmg_name
    rc.scp(src, remote_dmg)
    print("File " + remote_dmg + " uploaded")

    # create md5 sum
    remote_md5 = remote_dmg + ".md5sum"
    rc.ssh("md5sum " + remote_dmg + " > " + remote_md5)
    print("File " + remote_md5 + " uploaded")

    # recreate links
    link_dmg = folder + "/" + "qgis-latest-macos-" + pa.args.release_type + ".dmg"
    link_md5 = link_dmg + ".md5sum"

    rc.ssh("rm -f " + link_dmg)
    rc.ssh("rm -f " + link_md5)
    rc.ssh("ln -s " + remote_dmg + " " + link_dmg)
    rc.ssh("ln -s " + remote_md5 + " " + link_md5)
    print("Links " + pa.args.release_type + " recreated")

