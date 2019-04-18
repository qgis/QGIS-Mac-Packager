# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version


class QGISMacPackagerError(Exception):
    pass


class QGISBuildError(QGISMacPackagerError):
    pass


class QGISBundlerError(QGISMacPackagerError):
    pass


class QGISPackageError(QGISMacPackagerError):
    pass


class QGISUploadError(QGISMacPackagerError):
    pass


class Message(object):
    def __init__(self, verbosity=None):
        if verbosity is None:
            verbosity = 1  # warnings and headers
        self.verbosity = verbosity

    def dev(self, msg):
        """ Developer/Debugging info """
        if self.verbosity >= 3:
            print(msg)

    def msg(self, msg):
        """ A bit more detailed logs, e.g. for auto (nightly) builds """
        if self.verbosity >= 2:
            print(msg)

    def info(self, msg):
        """ Headers/Sections/Major information"""
        if self.verbosity >= 1:
            print(msg)

    def warn(self, msg):
        print(msg)
