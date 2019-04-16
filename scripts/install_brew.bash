#!/usr/bin/env bash

set -e

read -p "Are you sure to reinstall brew? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
    sudo rm -rf /usr/local/*
    sudo rm -R /Library/Java/JavaVirtualMachines/openjdk-*
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
