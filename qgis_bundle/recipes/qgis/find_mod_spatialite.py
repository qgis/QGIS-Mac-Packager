import os
# this file is part of qgis/QGIS-Mac-Packager package
# https://github.com/qgis/QGIS-Mac-Packager/issues/79

def mod_spatialite_path():
  # from QGIS*.app/Contents/MacOS/lib/python3.x/qgis/ -> QGIS*.app/Contents/MacOS/lib
  DIR1=os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.path.pardir, os.path.pardir))
  MOD_SPATIALITE_1=os.path.join(DIR1, 'mod_spatialite.so')
  if os.path.exists(MOD_SPATIALITE_1):
    return MOD_SPATIALITE_1
  else:
    # from QGIS*.app/Contents/Resources/python/qgis/ -> QGIS*.app/Contents/MacOS/lib
    DIR2 = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.path.pardir, os.path.pardir, os.path.pardir, 'MacOS', 'lib'))
    MOD_SPATIALITE_2 = os.path.join(DIR2, 'mod_spatialite.so')
    if os.path.exists(MOD_SPATIALITE_2):
      return MOD_SPATIALITE_2

  raise Exception("Unable to find mod_spatialite.so required by qgis's utils from " + DIR1 + " nor " + DIR2)
