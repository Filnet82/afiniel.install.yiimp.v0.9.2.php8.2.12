#!/bin/env bash

#
# This is the main menu
#
# Author: Afiniel
#
# Updated: 2023-03-16
#

source /etc/yiimpooldonate.conf
source /etc/functions.sh

RESULT=$(dialog --stdout --default-item 1 --title "YiimPool Yiimp Upgrader $VERSION" --menu "choose an option" -1 55 7 \
    ' ' "- Do you want to upgrade Yiimp Stratum? -" \
    1 "Yes" \
    2 exit)

if [ "$RESULT" = "1" ]; then
    clear;
    cd $HOME/yiimp_install_script/yiimp_upgrade
    source single.sh

elif [ "$RESULT" = "2" ]; then
    clear;
    echo "You have chosen to exit the Yiimp Upgrader. Type: yiimpool anytime to start the menu again.";
    exit;
fi