#!/usr/bin/env bash

#########################################
# Created by Afiniel for Yiimpool use...#
#########################################

source /etc/functions.sh
source /etc/yiimpool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
source $HOME/yiimp_install_script/yiimp_single/.wireguard.install.cnf

# Create main.sh
echo '#!/usr/bin/env bash
PHP_CLI='"'"''"php -d max_execution_time=120"''"'"'
DIR='""''"${STORAGE_ROOT}"''""'/yiimp/site/web/
cd ${DIR}
date
echo started in ${DIR}
while true; do
${PHP_CLI} runconsole.php cronjob/run
sleep 90
done
exec bash' | sudo -E tee $STORAGE_ROOT/yiimp/site/crons/main.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/site/crons/main.sh

cd $HOME/yiimp_install_script/yiimp_single
