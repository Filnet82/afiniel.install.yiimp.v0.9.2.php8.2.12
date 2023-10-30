#!/usr/bin/env bash

#########################################
# Created by Afiniel for Yiimpool use...#
#########################################

source /etc/functions.sh
source $STORAGE_ROOT/yiimp/.yiimp.conf
source /etc/yiimpooldonate.conf
cd $HOME/yiimp_install_script/yiimp_single

term_art
echo -e "$MAGENTA    <----------------------------->$COL_RESET"
echo -e "$MAGENTA     <--$YELLOW Starting Server Cleanup$MAGENTA -->$COL_RESET"
echo -e "$MAGENTA    <----------------------------->$COL_RESET"
echo
echo -e "$YELLOW => Installing cron screens to crontab <= $COL_RESET"

(
    crontab -l 2>/dev/null
    echo "@reboot sleep 20 && /home/crypto-data/yiimp/starts/screens.start.sh"
) | crontab -
if [[ ("$CoinPort" == "no") ]]; then
    (
        crontab -l 2>/dev/null
        echo "@reboot sleep 20 && /home/crypto-data/yiimp/starts/stratum.start.sh"
    ) | crontab -
fi

(
    crontab -l 2>/dev/null
    echo "@reboot sleep 20 && /etc/screen-scrypt-daemonbuilder.sh"
) | crontab -
(
    crontab -l 2>/dev/null
    echo "@reboot source /etc/functions.sh"
) | crontab -
(
    crontab -l 2>/dev/null
    echo "@reboot source /etc/yiimpool.conf"
) | crontab -
sudo cp -r first_boot.sh $STORAGE_ROOT/yiimp/

echo -e "$GREEN Crontab system complete$COL_RESET"
echo
echo -e "$MAGENTA => Creating YiiMP Screens startup script <= $COL_RESET"

echo '#!/usr/bin/env bash
source /etc/yiimpool.conf
source /etc/yiimpooldonate.conf
source /etc/functions.sh
# Ugly way to remove junk coins from initial YiiMP database on first boot
source $STORAGE_ROOT/yiimp/.yiimp.conf
if [[ ! -e '$STORAGE_ROOT/yiimp/first_boot.sh' ]]; then
echo
else
source $STORAGE_ROOT/yiimp/first_boot.sh
fi
################################################################################
# Author: afiniel                                                              #
#                                                                              #
#                                                                              #
# Program: yiimp screen startup script                                         #
#                                                                              #
# BTC Donation: $BTCDON                                                        #
#                                                                              #
################################################################################
sudo chmod 777 $STORAGE_ROOT/yiimp/site/log/.
sudo chmod 777 $STORAGE_ROOT/yiimp/site/log/debug.log
LOG_DIR=$STORAGE_ROOT/yiimp/site/log
CRONS=$STORAGE_ROOT/yiimp/site/crons
screen -dmS main bash $CRONS/main.sh
screen -dmS loop2 bash $CRONS/loop2.sh
screen -dmS blocks bash $CRONS/blocks.sh
screen -dmS debug tail -f $LOG_DIR/debug.log
' | sudo -E tee $STORAGE_ROOT/yiimp/starts/screens.start.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/starts/screens.start.sh

echo
echo -e "$MAGENTA => Creating Stratum screens start script <= $COL_RESET"

echo '#!/usr/bin/env bash
source /etc/yiimpool.conf
source /etc/yiimpooldonate.conf
source /etc/functions.sh
################################################################################
# Author: afiniel                                                              #
#                                                                              #
#                                                                              #
# Program: yiimp stratum startup script                                        #
#                                                                              #
# BTC Donation: $BTCDON                                                        #
#                                                                              #
################################################################################
source $STORAGE_ROOT/yiimp/.yiimp.conf
STRATUM_DIR=$STORAGE_ROOT/yiimp/site/stratum
LOG_DIR=$STORAGE_ROOT/yiimp/site/log
screen -dmS 0x10 bash $STRATUM_DIR/run.sh 0x10
screen -dmS a5a bash $STRATUM_DIR/run.sh a5a
screen -dmS aergo bash $STRATUM_DIR/run.sh aergo
screen -dmS allium bash $STRATUM_DIR/run.sh allium
screen -dmS anime bash $STRATUM_DIR/run.sh anime
screen -dmS argon2 bash $STRATUM_DIR/run.sh argon2
screen -dmS argon2d250 bash $STRATUM_DIR/run.sh argon2d250
screen -dmS argon2d500 bash $STRATUM_DIR/run.sh argon2d500
screen -dmS argon2d4096 bash $STRATUM_DIR/run.sh argon2d4096
screen -dmS argon2d16000 bash $STRATUM_DIR/run.sh argon2d16000
screen -dmS astralhash bash $STRATUM_DIR/run.sh astralhash
screen -dmS bastion bash $STRATUM_DIR/run.sh bastion
screen -dmS bcd bash $STRATUM_DIR/run.sh bcd
screen -dmS bitcore bash $STRATUM_DIR/run.sh bitcore
screen -dmS blake bash $STRATUM_DIR/run.sh blake
screen -dmS blake2s bash $STRATUM_DIR/run.sh blake2s
screen -dmS blakecoin bash $STRATUM_DIR/run.sh blakecoin
screen -dmS bmw512 bash $STRATUM_DIR/run.sh bmw512
screen -dmS c11 bash $STRATUM_DIR/run.sh c11
screen -dmS cosa bash $STRATUM_DIR/run.sh cosa
screen -dmS cpupower bash $STRATUM_DIR/run.sh cpupower
screen -dmS curvehash bash $STRATUM_DIR/run.sh curvehash
screen -dmS decred bash $STRATUM_DIR/run.sh decred
screen -dmS dedal bash $STRATUM_DIR/run.sh dedal
screen -dmS deep bash $STRATUM_DIR/run.sh deep
screen -dmS dmdgr bash $STRATUM_DIR/run.sh dmdgr
screen -dmS fresh bash $STRATUM_DIR/run.sh fresh
screen -dmS geek bash $STRATUM_DIR/run.sh geek
screen -dmS gr bash $STRATUM_DIR/run.sh gr
screen -dmS heavyhash bash $STRATUM_DIR/run.sh heavyhash
screen -dmS hive bash $STRATUM_DIR/run.sh hive
screen -dmS hmq1725 bash $STRATUM_DIR/run.sh hmq1725
screen -dmS honeycomb bash $STRATUM_DIR/run.sh honeycomb
screen -dmS hsr bash $STRATUM_DIR/run.sh hsr
screen -dmS jeonghash bash $STRATUM_DIR/run.sh jeonghash
screen -dmS jha bash $STRATUM_DIR/run.sh jha
screen -dmS keccak bash $STRATUM_DIR/run.sh keccak
screen -dmS keccakc bash $STRATUM_DIR/run.sh keccakc
screen -dmS lbk3 bash $STRATUM_DIR/run.sh lbk3
screen -dmS lbry bash $STRATUM_DIR/run.sh lbry
screen -dmS luffa bash $STRATUM_DIR/run.sh luffa
screen -dmS lyra2 bash $STRATUM_DIR/run.sh lyra2
screen -dmS lyra2TDC bash $STRATUM_DIR/run.sh lyra2TDC
screen -dmS lyra2v2 bash $STRATUM_DIR/run.sh lyra2v2
screen -dmS lyra2v3 bash $STRATUM_DIR/run.sh lyra2v3
screen -dmS lyra2vc0ban bash $STRATUM_DIR/run.sh lyra2vc0ban
screen -dmS lyra2z bash $STRATUM_DIR/run.sh lyra2z
screen -dmS lyra2z330 bash $STRATUM_DIR/run.sh lyra2z330
screen -dmS m7m bash $STRATUM_DIR/run.sh m7m
screen -dmS megabtx bash $STRATUM_DIR/run.sh megabtx
screen -dmS megamec bash $STRATUM_DIR/run.sh megamec
screen -dmS mike bash $STRATUM_DIR/run.sh mike
screen -dmS minotaur bash $STRATUM_DIR/run.sh minotaur
screen -dmS minotaurx bash $STRATUM_DIR/run.sh minotaurx
screen -dmS myrgr bash $STRATUM_DIR/run.sh mygr
screen -dmS neoscrypt bash $STRATUM_DIR/run.sh neoscrypt
screen -dmS nist5 bash $STRATUM_DIR/run.sh nist5
screen -dmS pawelhash bash $STRATUM_DIR/run.sh pawelhash
screen -dmS penta bash $STRATUM_DIR/run.sh penta
screen -dmS phi bash $STRATUM_DIR/run.sh phi
screen -dmS phi2 bash $STRATUM_DIR/run.sh phi2
screen -dmS phi5 bash $STRATUM_DIR/run.sh phi5
screen -dmS pipe bash $STRATUM_DIR/run.sh pipe
screen -dmS polytimos bash $STRATUM_DIR/run.sh polytimos
screen -dmS power2b bash $STRATUM_DIR/run.sh power2b
screen -dmS quark bash $STRATUM_DIR/run.sh quark
screen -dmS qubit bash $STRATUM_DIR/run.sh qubit
screen -dmS rainforest bash $STRATUM_DIR/run.sh rainforest
screen -dmS renesis bash $STRATUM_DIR/run.sh renesis
screen -dmS scrypt bash $STRATUM_DIR/run.sh scrypt
screen -dmS scryptn bash $STRATUM_DIR/run.sh scryptn
screen -dmS sha3d bash $STRATUM_DIR/run.sh sha3d
screen -dmS sha256 bash $STRATUM_DIR/run.sh sha256
screen -dmS sha256t bash $STRATUM_DIR/run.sh sha256t
screen -dmS sha512256d bash $STRATUM_DIR/run.sh sha512256d
screen -dmS sib bash $STRATUM_DIR/run.sh sib
screen -dmS skein bash $STRATUM_DIR/run.sh skein
screen -dmS skunk bash $STRATUM_DIR/run.sh skunk
screen -dmS sonoa bash $STRATUM_DIR/run.sh sonoa
screen -dmS timetravel bash $STRATUM_DIR/run.sh timetravel
screen -dmS tribus bash $STRATUM_DIR/run.sh tribus
screen -dmS vanilla bash $STRATUM_DIR/run.sh vanilla
screen -dmS veltor bash $STRATUM_DIR/run.sh veltor
screen -dmS velvet bash $STRATUM_DIR/run.sh velvet
screen -dmS vitalium bash $STRATUM_DIR/run.sh vitalium
screen -dmS whirlpool bash $STRATUM_DIR/run.sh whirlpool
screen -dmS x11 bash $STRATUM_DIR/run.sh x11
screen -dmS x11evo bash $STRATUM_DIR/run.sh x11evo
screen -dmS x11k bash $STRATUM_DIR/run.sh x11k
screen -dmS x11kvs bash $STRATUM_DIR/run.sh x11kvs
screen -dmS x12 bash $STRATUM_DIR/run.sh x12
screen -dmS x13 bash $STRATUM_DIR/run.sh x13
screen -dmS x14 bash $STRATUM_DIR/run.sh x14
screen -dmS x15 bash $STRATUM_DIR/run.sh x15
screen -dmS x16r bash $STRATUM_DIR/run.sh x16r
screen -dmS x16rt bash $STRATUM_DIR/run.sh x16rt
screen -dmS x16rv2 bash $STRATUM_DIR/run.sh x16rv2
screen -dmS x16s bash $STRATUM_DIR/run.sh x16s
screen -dmS x17 bash $STRATUM_DIR/run.sh x17
screen -dmS x18 bash $STRATUM_DIR/run.sh x18
screen -dmS x20r bash $STRATUM_DIR/run.sh x20r
screen -dmS x21s bash $STRATUM_DIR/run.sh x21s
screen -dmS x22i bash $STRATUM_DIR/run.sh x22i
screen -dmS x25x bash $STRATUM_DIR/run.sh x25x
screen -dmS xevan bash $STRATUM_DIR/run.sh xevan
screen -dmS yescrypt bash $STRATUM_DIR/run.sh yescrypt
screen -dmS yescryptR8 bash $STRATUM_DIR/run.sh yescryptR8
screen -dmS yescryptR16 bash $STRATUM_DIR/run.sh yescryptR16
screen -dmS yescryptR32 bash $STRATUM_DIR/run.sh yescryptR32
screen -dmS yespower bash $STRATUM_DIR/run.sh yespower
screen -dmS yespowerARWN bash $STRATUM_DIR/run.sh yespowerARWN
screen -dmS yespowerIC bash $STRATUM_DIR/run.sh yespowerIC
screen -dmS yespowerIOTS bash $STRATUM_DIR/run.sh yespowerIOTS
screen -dmS yespowerLITB bash $STRATUM_DIR/run.sh yespowerLITB
screen -dmS yespowerLTNCG bash $STRATUM_DIR/run.sh yespowerLTNCG
screen -dmS yespowerMGPC bash $STRATUM_DIR/run.sh yespowerMGPC
screen -dmS yespowerR16 bash $STRATUM_DIR/run.sh yespowerR16
screen -dmS yespowerSUGAR bash $STRATUM_DIR/run.sh yespowerSUGAR
screen -dmS yespowerTIDE bash $STRATUM_DIR/run.sh yespowerURX
screen -dmS yespowerURX bash $STRATUM_DIR/run.sh yespowerURX
' | sudo -E tee $STORAGE_ROOT/yiimp/starts/stratum.start.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/starts/stratum.start.sh

echo '
source /etc/yiimpool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
LOG_DIR=$STORAGE_ROOT/yiimp/site/log
CRONS=$STORAGE_ROOT/yiimp/site/crons
STRATUM_DIR=$STORAGE_ROOT/yiimp/site/stratum
' | sudo -E tee $STORAGE_ROOT/yiimp/.prescreens.start.conf >/dev/null 2>&1

echo "source /etc/yiimpool.conf" | hide_output tee -a ~/.bashrc
echo "source $STORAGE_ROOT/yiimp/.prescreens.start.conf" | hide_output tee -a ~/.bashrc
echo -e "$YELLOW YiiMP Screens$GREEN Added$COL_RESET"

sudo rm -r $STORAGE_ROOT/yiimp/yiimp_setup

# Fixing exbitron that make white screen and update main.php
cd $HOME/yiimp_install_script/yiimp_single/yiimp_confs
sudo rm -r /home/crypto-data/yiimp/site/web/yaamp/ui/main.php
sudo rm -r /home/crypto-data/yiimp/site/web/yaamp/core/trading/exbitron_trading.php
sudo rm -r /home/crypto-data/yiimp/site/web/yaamp/modules/site/coin_form.php

sudo cp -r main.php /home/crypto-data/yiimp/site/web/yaamp/ui
sudo cp -r exbitron_trading.php /home/crypto-data/yiimp/site/web/yaamp/core/trading
sudo cp -r coin_form.php /home/crypto-data/yiimp/site/web/yaamp/modules/site

cd $HOME/yiimp_install_script/yiimp_single