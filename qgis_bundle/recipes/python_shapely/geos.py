import os 

// from QGIS.app/Contents/MacOS/lib/python3.7/site-packages/shapely/
DIR1=os.path.abspath(os.path.join(os.path.pardir, os.path.pardir, os.path.pardir))

if os.path.exists(DIR1, 'libgeos_c.dylib'):
  os.setenv('CONDA_PREFIX', DIR1)
else:
  // QGIS.app/Contents/Resources/python/site-packages/shapely/
  DIR2=os.path.abspath(os.path.join(os.path.pardir, os.path.pardir, os.path.pardir, os.path.pardir, 'MacOS', 'lib'))
  if os.path.exists(DIR2, 'libgeos_c.dylib'):
    os.setenv('CONDA_PREFIX', DIR2)  
  else:
    raise Exception("Unable to load geos required by shapely")

from ._geos import *
