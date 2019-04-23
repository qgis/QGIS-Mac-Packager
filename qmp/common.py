# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import colorama


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
        self.current_chapter = 0
        self.current_header = 0
        colorama.init()

    def dbg(self, msg):
        """ Debugging info """
        if self.verbosity >= 3:
            print(colorama.Fore.BLUE + "DEBUG: " + msg + colorama.Style.RESET_ALL)

    def dev(self, msg):
        """ A bit more detailed logs (Developer) """
        if self.verbosity >= 2:
            print(msg)

    def info(self, msg):
        """ Major information, e.g. for auto (nightly) builds """
        if self.verbosity >= 1:
            print(msg)

    def header(self, msg):
        """ Headers """
        self.current_header += 1
        s = "{}.{} {}".format(self.current_chapter, self.current_header, msg)
        print(colorama.Fore.CYAN + s)
        print(len(s) * "~" + colorama.Style.RESET_ALL)

    def chapter(self, msg):
        """ Chapters """
        self.current_chapter += 1
        s = "{}. {}".format(self.current_chapter, msg.upper())
        print(colorama.Fore.GREEN + len(s) * "*")
        print(s)
        print(len(s) * "*" + colorama.Style.RESET_ALL)

    def warn(self, msg):
        print(colorama.Fore.RED + "WARNING: " + msg + colorama.Style.RESET_ALL)
