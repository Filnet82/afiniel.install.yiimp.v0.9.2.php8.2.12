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

RESULT=$(dialog --stdout --default-item 1 --title "YiimPool Yiimp Installer $VERSION" --menu "choose an option" -1 55 7 \
    ' ' "- Do you want to install Yiimp with whireguard? -" \
    1 "Yes" \
    2 "No" \
    3 exit)

if [ "$RESULT" = "1" ]; then
    clear;
    echo '
    wireguard=true
    ' | sudo -E tee "$HOME"/yiimp_install_script/yiimp_single/.wireguard.install.cnf >/dev/null 2>&1;
    

elif [ "$RESULT" = "2" ]; then
    clear;
    echo '
    wireguard=false
    ' | sudo -E tee "$HOME"/yiimp_install_script/yiimp_single/.wireguard.install.cnf >/dev/null 2>&1;
    

elif [ "$RESULT" = "3" ]; then
    clear;
    exit;
fi
