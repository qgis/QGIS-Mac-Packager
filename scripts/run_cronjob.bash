#!/usr/bin/env bash

set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BD=$DIR/builds
LD=$DIR/logs
LOG=$LD/qgis_${TIMESTAMP}.log
SD=$DIR/QGIS-Mac-Packager/scripts

echo "Starting CRONJOB ${TIMESTAMP} ${LOG}" > $LOG 2>&1

echo "Manage ENV" >> $LOG 2>&1
export PATH=/usr/local/opt/ccache/libexec:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:$PATH

echo "Create dirs " >> $LOG 2>&1
mkdir -p $LD
mkdir -p $BD
touch $LOG

echo "clean the build directories" >> $LOG 2>&1
# remove all dmg files older than X days
find $BD -name "*.dmg" -maxdepth 2 -type f -mtime +5 -exec rm {} \;

echo "clean the log directories" >> $LOG 2>&1
# remove all files older than 60 days
find $LD -name "*.log" -type f -mtime +60 -exec rm {} \;

echo "Check GIT repo" >> $LOG 2>&1
cd $DIR/QGIS-Mac-Packager
git fetch origin | tee -a $LOG
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse origin)

if [ $LOCAL = $REMOTE ]; then
    echo "GIT Up-to-date" >> $LOG 2>&1
else
    echo "Update QGIS-Mac-Packager" >> $LOG 2>&1
    git rebase origin/master >> $LOG 2>&1
fi

export failed= ok=
for i in nightly pr ltr; do
	echo "build $i" >> $LOG 2>&1
	if $SD/run_pkg.bash $i >> $LOG 2>&1; then
		ok="$ok $i"
		echo "SUCCESS $i" >> $LOG 2>&1
	else
		failed="$failed $i"
		echo "FAIL $i" >> $LOG 2>&1
	fi
done

(
   echo QGIS MacOS Build Status:
   [ -z "$ok" ] || echo ok:$ok
   [ -z "$failed" ] || echo failed:$failed
) | mutt -a $LOG -s "Your QGIS MacOS Build Status" -- admin@localhost

if [ -n "$failed" ]; then
	echo "Your QGIS MacOS Build failed:$failed ok:$ok"
	exit 1
fi
