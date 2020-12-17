import os
# this file is part of qgis/QGIS-Mac-Packager package
# https://github.com/qgis/QGIS-Mac-Packager/issues/32

# from QGIS.app/Contents/MacOS/lib/python3.7/ -> QGIS.app/Contents/Resources/certs/
DIR1=os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.path.pardir, os.path.pardir, os.path.pardir, 'Resources', 'certs'))
CERTS1=os.path.join(DIR1, 'certs.pem')
if os.path.exists(CERTS1):
  os.environ['SSL_CERT_DIR'] = DIR1
  os.environ['SSL_CERT_FILE'] = CERTS1
else:
  # from QGIS.app/Contents/Resources/python/  -> QGIS.app/Contents/Resources/certs/
  DIR2 = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.path.pardir, 'certs'))
  CERTS2 = os.path.join(DIR2, 'certs.pem')
  if os.path.exists(CERTS2):
    os.environ['SSL_CERT_DIR'] = DIR2
    os.environ['SSL_CERT_FILE'] = CERTS2
  else:
    raise Exception("Unable to load certs.pem required by ssl from " + DIR1 + " nor " + DIR2)

from _ssl2 import *

# private functions are not imported by default
# but this one is used in some QGIS plugins
from _ssl2 import _create_unverified_context
from _ssl2 import _create_default_https_context

