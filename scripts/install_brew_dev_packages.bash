#!/usr/bin/env bash

set -e

brew install git
brew install cmake
brew install ninja
brew install pkg-config
brew install wget
brew install bash-completion
brew install curl
brew install gnu-sed
brew install coreutils
brew install ccache
brew install libtool
brew install astyle
brew install help2man
brew install autoconf
brew install automake
brew install parallel
brew install texinfo # makeinfo (bison receipt)
brew install expect # unbuffer (for QGIS spell check)
brew install the_silver_searcher # ag (for QGIS spell check)
brew install mutt # for cronjob
brew install htop # for display on terminal (optional)
brew install rust # for python cryptography

pip3 install dmgbuild
pip3 install autopep8 # for QGIS prepare commit
pip3 install pillow # for image_creator.py
pip3 install transifex-client # for qgis pull_tx script

# Setup
ccache --set-config=max_size=2.0G