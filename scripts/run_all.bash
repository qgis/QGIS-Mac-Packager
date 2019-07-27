#!/bin/bash

set -e

# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
for i in ltr pr nightly; do
	if ! $DIR/run_pkg.bash $i; then
		echo "BUILDING $i FAILED [$?]"
	fi
done
