# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import unittest
import os
import sys

from qmp.bundler import utils


class MyTest(unittest.TestCase):
    def test_files_differ(self):
        THIS_DIR = os.path.dirname(os.path.realpath(__file__))
        DATA_DIR = os.path.join(THIS_DIR, os.pardir, os.pardir, "data")

        file1 = os.path.join(DATA_DIR, "file1.txt")
        file2 = os.path.join(DATA_DIR, "file2.txt")
        file1_2 = os.path.join(DATA_DIR, "file1_2.txt")
        self.assertTrue(utils.files_differ(file1, file2))
        self.assertFalse(utils.files_differ(file1, file1_2))


if __name__ == '__main__':
    unittest.main()
