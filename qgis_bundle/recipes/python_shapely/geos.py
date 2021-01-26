import os
# this file is part of qgis/QGIS-Mac-Packager package
# https://github.com/qgis/QGIS-Mac-Packager/issues/81

# from QGIS*.app/Contents/MacOS/lib/python3.7/site-packages/shapely/ -> QGIS*.app/Contents/MacOS/lib
DIR1=os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.path.pardir, os.path.pardir, os.path.pardir))
GEOS_C_LIB_1=os.path.join(DIR1, 'libgeos_c.dylib')
if os.path.exists(GEOS_C_LIB_1):
  os.environ['CONDA_PREFIX'] = DIR1
else:
  # from QGIS*.app/Contents/Resources/python/site-packages/shapely/ -> QGIS*.app/Contents/MacOS/lib
  DIR2 = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.path.pardir, os.path.pardir, os.path.pardir, os.path.pardir, 'MacOS', 'lib'))
  GEOS_C_LIB_2 = os.path.join(DIR2, 'libgeos_c.dylib')
  if os.path.exists(GEOS_C_LIB_2):
    os.environ['CONDA_PREFIX'] = DIR2
  else:
    raise Exception("Unable to load geos_c required by shapely from " + DIR1 + " nor " + DIR2)

# fix:
# ImportError: dlopen(.../site-packages/Fiona-....egg/fiona/ogrext.cpython-37m-darwin.so, 2): Symbol not found: _GEOSArea
#   Referenced from: .../stage/lib/libspatialite.7.dylib
#   Expected in: flat namespace
import fiona

from ._geos import *
