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

RESULT=$(dialog --stdout --nocancel --default-item 1 --title "YiimPool Menu $VERSION" --menu "Choose an option" -1 55 7 \
    ' ' "- Install Yiimp -" \
    1 "Yiimp Single Server" \
    ' ' "- Upgrade Yiimp Stratum -" \
    2 "Upgrade Stratum" \
    3 exit)

if [ "$RESULT" = "1" ]; then
    clear;
    cd $HOME/yiimp_install_script/yiimp_single
    source start.sh

elif [ "$RESULT" = "2" ]; then
    clear;
    cd $HOME/yiimp_install_script/yiimp_upgrade
    source start.sh

elif [ "$RESULT" = "3" ]; then
    clear;
    exit;
fi