# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

import unittest


def fun(x):
    return x + 1


class MyTest(unittest.TestCase):
    def test(self):
        self.assertEqual(fun(3), 4)


if __name__ == '__main__':
    unittest.main()
