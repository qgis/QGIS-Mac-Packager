import os
# this file is part of qgis/QGIS-Mac-Packager package
# from STAGE_PATH/lib/python<ver>/site-packages/shapely -> STAGE_PATH/lib
DIR1=os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.path.pardir, os.path.pardir, os.path.pardir))
GEOS_C_LIB=os.path.join(DIR1, 'libgeos_c.dylib')

if os.path.exists(GEOS_C_LIB):
  # https://github.com/qgis/QGIS-Mac-Packager/issues/81
  os.environ['CONDA_PREFIX'] = DIR1
else:
  raise Exception("Unable to load geos_c required by shapely from $DIR1")

# fix:
# ImportError: dlopen(.../site-packages/Fiona-....egg/fiona/ogrext.cpython-37m-darwin.so, 2): Symbol not found: _GEOSArea
#   Referenced from: .../stage/lib/libspatialite.7.dylib
#   Expected in: flat namespace
import fiona

from ._geos import *
