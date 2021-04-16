#!/usr/bin/env bash

set -e

read -p "Are you sure to reinstall brew? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
    sudo rm -rf /usr/local/*
    sudo rm -R /Library/Java/JavaVirtualMachines/openjdk-*
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
