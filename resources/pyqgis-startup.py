# -*- coding: utf-8 -*-
"""
/***************************************************************************
 OSGeo4Mac Python startup script to strip macOS system Python site-packages
                              -------------------
        begin    : 2013-09-20
        copyright: (C) 2013, 2017 Larry Shaffer
        email    : larrys@dakotacarto.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""
import sys
import os

sys.path[:] = (pth for pth in sys.path if not (pth.startswith('/Library/Python') or \
pth.startswith('/Library/Frameworks') or \
pth.startswith('/System/Library/Frameworks/Python.framework')))

# make abs paths
sys.path[:] = (os.path.abspath(pth) for pth in sys.path)

# remove duplicit entries
sys.path = list(set(sys.path))
