#!/bin/bash

set -e

# 2019 Jürgen Fischer (jef at norbit dot de)
# GNU General Public License 2 any later version

PKG=$1
shift

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

mkdir -p $DIR/../../builds/${PKG}
cd $DIR/../../builds/${PKG}

[ -d qgis ] || git clone https://github.com/qgis/QGIS.git qgis
cd qgis

git fetch origin

# Get latest release branch
RELBRANCH=$(git ls-remote --heads origin | sed -e '/\^{}$/d' -ne 's#^.*refs/heads/release-#release-#p' | sort -V | tail -1)
RELBRANCH=${RELBRANCH#*/}

LTRTAG=$(git ls-remote --tags origin | sed -e '/\^{}$/d' -ne 's#^.*refs/tags/ltr-#ltr-#p' | sort -V | tail -1)

LTRBRANCH=$(git branch -r --contains $LTRTAG | fgrep " origin/release-")
LTRBRANCH=${LTRBRANCH#*/}

if [ "$RELBRANCH" = "$LTRBRANCH" ]; then
        LTRTAG=$(git ls-remote --tags origin | sed -e '/\^{}$/d' -ne 's#^.*refs/tags/ltr-#ltr-#p' | sort -V | tail -2 | head -1 )
        LTRBRANCH=$(git branch -r --contains $LTRTAG | fgrep " origin/release-")
        LTRBRANCH=${LTRBRANCH#*/}
fi

case $PKG in
pr)
	BRANCH=$RELBRANCH
	;;

ltr)
	BRANCH=$LTRBRANCH
	;;

nightly)
	BRANCH=master
	;;

nightly2)
  # TODO change back to master when https://github.com/qgis/QGIS/pull/37918 is merged
	BRANCH=macos_deployment_fixes
	;;

*)
	echo "usage: $0 {nightly|nightly2|pr|ltr}"
	exit 1
	;;

esac

git checkout $BRANCH
git pull

MAJOR=$(sed -ne 's/SET(CPACK_PACKAGE_VERSION_MAJOR "\([0-9]*\)")/\1/p' CMakeLists.txt)
MINOR=$(sed -ne 's/SET(CPACK_PACKAGE_VERSION_MINOR "\([0-9]*\)")/\1/p' CMakeLists.txt)
PATCH=$(sed -ne 's/SET(CPACK_PACKAGE_VERSION_PATCH "\([0-9]*\)")/\1/p' CMakeLists.txt)

if [ $PKG = "nightly" ]; then
	TAG=master
	git reset --hard
	if ! PATH=$(dirname /usr/local/Cellar/qt/*/bin/qmake):$PATH scripts/pull_ts.sh; then
		echo "Pulling translations failed [$?]"
		rm -rvf i18n doc/TRANSLATORS
		git checkout
	fi
elif [ $PKG = "nightly2" ]; then
  TAG=master
	git reset --hard
	# TODO tx https://github.com/qgis/QGIS/issues/37034
else
	TAG=final-${MAJOR}_${MINOR}_${PATCH}

	if [ -f ../$TAG ]; then
		if [ -f ../rebuild ]; then
			echo REBUILDING $TAG
		else
			echo $TAG already built
			exit 0
		fi
	elif [ -d ../build ]; then
		rm -rf ../build
	fi
fi

cd ..

if [ -f building ]; then
        echo "Already building $PKG"
        exit 0
fi

trap "rm $PWD/building" EXIT
touch building

QGISAPP="QGIS${MAJOR}.${MINOR}.app"
BD=$DIR/../../builds/${PKG}

echo "BUILDING ${PKG}"
if [ $PKG = "nightly2" ]; then
  $DIR/run_build2.bash \
    ${TAG} \
    ${PKG} \
    "$@"
else
  $DIR/run_build.bash \
    $BD \
    ${TAG} \
    ${PKG} \
    ${QGISAPP} "$@"
fi

if [ "$PKG" = "nightly" ]; then
	cd $BD/qgis
	rm -rf i18n doc/TRANSLATORS
	git checkout
else
	touch ${TAG}
fi
