#!/usr/bin/env bash

set -o pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BD=$DIR/builds
LD=$DIR/logs
LOG=$LD/qgis_${TIMESTAMP}.log
SD=$DIR/qgis-mac-packager/scripts

echo "Starting CRONJOB ${TIMESTAMP} ${LOG}" > $LOG 2>&1

echo "Manage ENV" >> $LOG 2>&1
export PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:$PATH

echo "Create dirs " >> $LOG 2>&1
mkdir -p $LD
mkdir -p $BD
touch $LOG

echo "clean the build directories" >> $LOG 2>&1
# remove all dmg files older than X days
find $BD/*/*.dmg -mtime +5 -exec rm {} \;

echo "clean the log directories" >> $LOG 2>&1
# remove all files older than 60 days
find $LD/* -mtime +60 -exec rm {} \;

echo "Check GIT repo" >> $LOG 2>&1
cd $DIR/qgis-mac-packager
git fetch origin | tee -a $LOG
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse origin)

if [ $LOCAL = $REMOTE ]; then
    echo "GIT Up-to-date" >> $LOG 2>&1

    exit_status_ltr=0
    exit_status_pr=0
else
    echo "update qgis-mac-packager" >> $LOG 2>&1
    git rebase origin/master >> $LOG 2>&1

    echo "rebuild LTR" >> $LOG 2>&1
    $SD/run_ltr.bash >> $LOG 2>&1
    exit_status_ltr=$?

    echo "rebuild PR" >> $LOG 2>&1
    $SD/run_pr.bash >> $LOG 2>&1
    exit_status_pr=$?
fi

echo "always build NIGHTLY" >> $LOG 2>&1
$SD/run_nightly.bash >> $LOG 2>&1
exit_status_nightly=$?

if [ $exit_status_ltr -eq 0 -a $exit_status_pr -eq 0 -a $exit_status_nightly -eq 0 ]; then
    echo "SUCCESS" >> $LOG 2>&1
else
    echo "FAIL" >> $LOG 2>&1
    echo "Your nighly QGIS MacOS Build failed"
fi
exit $exit_status