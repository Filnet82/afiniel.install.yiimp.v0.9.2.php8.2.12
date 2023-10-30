#!/bin/env bash

#
# This is the main menu For Daemon Builder
#
# Author: Afiniel
#
# Updated: 2023-03-20
#

source /etc/yiimpoolversion.conf
source /etc/daemonbuilder.sh
source $STORAGE_ROOT/daemon_builder/conf/info.sh

cd $STORAGE_ROOT/daemon_builder

LATESTVER=$(curl -sL 'https://api.github.com/repos/Afiniel/yiimp_install_script/releases/latest' | jq -r '.tag_name')


if [[ ("{$LATESTVER}" > "{$VERSION}" && "${LATESTVER}" != "null") ]]; then
    echo "New version available: ${LATESTVER}"
    echo "Your version: ${VERSION}"
    echo "Do you want to update? (y/n)"
    read -r UPDATE
    if [[ ("${UPDATE}" == "y" || "${UPDATE}" == "Y") ]]; then
        echo "Updating..."
        cd $HOME/yiimp_install_script
        git pull
        echo "Update complete!"
        exit 0
    fi
    else
        RESULT=$(dialog --stdout --title "DaemonBuilder $VERSION" --menu "Choose an option" 13 60 8 \
        1 "Build Coin Daemon From Source Code" \
        2 exit)

        if [ "$RESULT" = "1" ]; then
            clear;
            cd $STORAGE_ROOT/daemon_builder
            source menu1.sh
        fi

        if [ "$RESULT" = "2" ]; then
            clear;
            echo "You have chosen to exit the Daemon Builder. Type: daemonbuilder anytime to start the menu again.";
            exit;
        fi
fi