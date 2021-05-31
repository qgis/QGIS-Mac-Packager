#!/usr/bin/env bash

set -e

echo "Adding EULA"

ECW_LICENSE=$1
MRSID_LICENSE=$2
QGIS_LICENSE=$3
RESOURCE_TEMPLATE=$4
DMG_FILE=$5

EULA_RSRC=$(mktemp -t dmglicense.tmp.XXXXXXXXXX)
cat $QGIS_LICENSE > $EULA_RSRC
echo "[1] ERDAS ECW/JP2" >> $EULA_RSRC
cat $ECW_LICENSE > $EULA_RSRC
echo "[2] MrSID Decode SDKs" >> $EULA_RSRC
cat $MRSID_LICENSE > $EULA_RSRC

echo "Created license $EULA_RSRC"

  #
 	# Use udifrez instead flatten/rez/unflatten
 	# Based on a thread from dawn2dusk & peterguy
 	# https://developer.apple.com/forums/thread/668084
 	# Based on create-dmg implementation
 	#
 	EULA_RESOURCES_FILE=$(mktemp -t dmgresource.tmp.XXXXXXXXXX)
 	EULA_FORMAT=$(file -b ${EULA_RSRC})
 	if [[ ${EULA_FORMAT} == 'Rich Text Format data'* ]] ; then
 		EULA_FORMAT='RTF '
 	else
 		EULA_FORMAT='TEXT'
 	fi

 	# Encode the EULA to base64
 	EULA_DATA="$(base64 -b 52 "${EULA_RSRC}" | sed s$'/^\(.*\)$/\t\t\t\\1/')"
 	# Fill the template with the custom EULA contents
 	eval "cat > \"${EULA_RESOURCES_FILE}\" <<EOF
 	$(<${RESOURCE_TEMPLATE})
 	EOF
 	"
 	# Apply the resources
 	hdiutil udifrez -xml "${EULA_RESOURCES_FILE}" '' -quiet "${DMG_FILE}" || {
 		echo "Failed to add the EULA license to $DMG_FILE"
 		exit 1
 	}
 	echo "Successfully added the EULA license to $DMG_FILE"
