#!/usr/bin/env bash

##################################################################################
# This is the entry point for configuring the system.                            #
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox   #
# Updated by Afiniel for yiimpool use...                                         #
##################################################################################

source /etc/functions.sh
source /etc/yiimpool.conf

set -eu -o pipefail

function print_error {
	read line file <<<$(caller)
	echo "An error occurred in line $line of file $file:" >&2
	sed "${line}q;d" "$file" >&2
}
trap print_error ERR
term_art
echo -e "$MAGENTA    <---------------------------------------->$COL_RESET"
echo -e "$MAGENTA     <--$YELLOW Install DaemonBuilder Requirements$MAGENTA -->$COL_RESET"
echo -e "$MAGENTA    <---------------------------------------->$COL_RESET"

cd $HOME/yiimp_install_script/daemon_builder
source start.sh

set +eu +o pipefail
cd $HOME/yiimp_install_script/yiimp_single