import os
# this file is part of qgis/QGIS-Mac-Packager package
# from STAGE_PATH/lib/python<ver>/site-packages/RTree-*.egg/rtree -> STAGE_PATH/lib
DIR1=os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.path.pardir, os.path.pardir, os.path.pardir, os.path.pardir))
SPATIALINDEX_C_LIBRARY_1=os.path.join(DIR1, 'libspatialindex_c.dylib')

if os.path.exists(SPATIALINDEX_C_LIBRARY_1):
  os.environ['SPATIALINDEX_C_LIBRARY'] = SPATIALINDEX_C_LIBRARY_1
else:
  raise Exception("Unable to load spatialindex_c required by rtree in " + DIR1)

from ._core import *
