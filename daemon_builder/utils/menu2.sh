#!/usr/bin/env bash
#####################################################
# Updated by Afiniel
# Menu: Add Coin to Dedicated Port and run stratum
#####################################################

source /etc/daemonbuilder.sh
source $STORAGE_ROOT/daemon_builder/conf/info.sh

cd ~
clear

sudo addport

echo -e "$CYAN --------------------------------------------------------------------------- 	$COL_RESET"
echo -e "$RED    Type ${daemonname} at anytime to Add Port & run Stratum				$COL_RESET"
echo -e "$CYAN --------------------------------------------------------------------------- 	$COL_RESET"
exit
