import os
# this file is part of qgis/QGIS-Mac-Packager package
# from QGIS.app/Contents/MacOS/lib/python3.7/site-packages/RTree-*.egg/rtree -> QGIS.app/Contents/MacOS/lib/
DIR1=os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.path.pardir, os.path.pardir, os.path.pardir, os.path.pardir))
SPATIALINDEX_C_LIBRARY_1=os.path.join(DIR1, 'libspatialindex_c.dylib')

if os.path.exists(SPATIALINDEX_C_LIBRARY_1):
  os.environ['SPATIALINDEX_C_LIBRARY'] = SPATIALINDEX_C_LIBRARY_1
else:
  # from QGIS.app/Contents/Resources/python/site-packages/RTree-*.egg/rtree -> QGIS.app/Contents/MacOS/lib
  DIR2 = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.path.pardir, os.path.pardir, os.path.pardir, os.path.pardir, os.path.pardir, 'MacOS', 'lib'))
  SPATIALINDEX_C_LIBRARY_2 = os.path.join(DIR2, 'libspatialindex_c.dylib')

  if os.path.exists(SPATIALINDEX_C_LIBRARY_2):
    os.environ['SPATIALINDEX_C_LIBRARY'] = SPATIALINDEX_C_LIBRARY_2
  else:
    raise Exception("Unable to load spatialindex_c required by rtree in " + DIR1 + " nor " + DIR2)

from ._core import *