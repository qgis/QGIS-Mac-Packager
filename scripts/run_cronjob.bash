#!/usr/bin/env bash

set -o pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR/../..
DIR=$PWD
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
find $BD/* -name "*.dmg" -mtime +5 -delete

echo "clean the log directories" >> $LOG 2>&1
# remove all files older than 60 days
find $LD/* -name "*.log" -mtime +60 -delete

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

failed=
for i in nightly pr ltr; do
	echo "build $i" >> $LOG 2>&1
	if $SD/run_pkg.bash $i >> $LOG 2>&1; then
		echo "SUCCESS $i" >> $LOG 2>&1
	else
		failed="$failed $i"
		echo "FAIL $i" >> $LOG 2>&1
	fi
done

if [ -n "$failed" ]; then
	echo "Your QGIS MacOS Build failed:$failed"
	exit 1
fi
