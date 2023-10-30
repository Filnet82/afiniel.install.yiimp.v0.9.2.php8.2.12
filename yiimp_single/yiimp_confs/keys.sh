#!/usr/bin/env bash

#####################################################
# Created by Afiniel for Yiimpool use...
#####################################################

source /etc/functions.sh
source /etc/yiimpool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
source $HOME/yiimp_install_script/yiimp_single/.wireguard.install.cnf

#Create keys file
echo '<?php
// Sample config file to put in /etc/yiimp/keys.php
define('"'"'YIIMP_MYSQLDUMP_USER'"'"', '"'"''"${YiiMPPanelName}"''"'"');
define('"'"'YIIMP_MYSQLDUMP_PASS'"'"', '"'"''"${PanelUserDBPassword}"''"'"');
define('"'"'YIIMP_MYSQLDUMP_PATH'"'"', '"'"''"${STORAGE_ROOT}/yiimp/site/backup"''"'"');
// Keys required to create/cancel orders and access your balances/deposit addresses
define('"'"'EXCH_ALTMARKETS_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_BITSTAMP_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_BITTREX_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_BITZ_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_BLEUTRADE_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_CEXIO_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_CREX24_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_DELIONDEX_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_EXBITRON_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_ESCODEX_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_GATEIO_SECRET'"'"', '"'"''"'"'); 
define('"'"'EXCH_GRAVIEX_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_KRAKEN_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_YOBIT_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_SHAPESHIFT_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_BTER_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_EMPOEX_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_JUBI_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_ALCUREX_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_BINANCE_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_HITBTC_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_KUCOIN_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_LIVECOIN_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_CRYPTOWATCH_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_STOCKSEXCHANGE_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_TRADEOGRE_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_TRADESATOSHI_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_TXBIT_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_SWIFTEX_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_UNNAMED_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_BIBOX_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_ALTILLY_SECRET'"'"', '"'"''"'"');
' | sudo -E tee /etc/yiimp/keys.php >/dev/null 2>&1
cd $HOME/yiimp_install_script/yiimp_single
