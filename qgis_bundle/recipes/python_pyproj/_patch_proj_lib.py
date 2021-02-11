import os
# this file is part of qgis/QGIS-Mac-Packager package

if not os.getenv("PROJ_LIB"):
    # from QGIS*.app/Contents/MacOS/lib/python3.x/site-packages/pyproj-*.egg/pyproj -> QGIS*.app/Contents/Resources/proj/
    PROJ_DIR_1=os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.path.pardir, os.path.pardir, os.path.pardir, os.path.pardir, os.path.pardir, os.path.pardir, "Resources", "proj"))
    if os.path.exists(PROJ_DIR_1):
        os.environ['PROJ_LIB'] = PROJ_DIR_1
    else:
        # from QGIS*.app/Contents/Resources/python/site-packages/pyproj-*.egg/pyproj -> QGIS*.app/Contents/Resources/proj/
        PROJ_DIR_2 = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.path.pardir, os.path.pardir, os.path.pardir, os.path.pardir, os.path.pardir, "Resources", "proj"))
        if os.path.exists(PROJ_DIR_2):
            os.environ['PROJ_LIB'] = PROJ_DIR_2
        else:
            raise Exception("Unable to find valid PROJ_DIR for pyproj in " + PROJ_DIR_1 + " nor " + PROJ_DIR_2)
