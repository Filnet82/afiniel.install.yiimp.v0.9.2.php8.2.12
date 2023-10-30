#!/usr/bin/env bash

##########################################
# Created by Afiniel for Yiimpool use... #
##########################################

source /etc/functions.sh
source /etc/yiimpool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
source $HOME/yiimp_install_script/yiimp_single/.wireguard.install.cnf

echo
term_art
echo -e "$MAGENTA    <--------------------->$COL_RESET"
echo -e "$MAGENTA     <--$YELLOW Compile Stratum$MAGENTA -->$COL_RESET"
echo -e "$MAGENTA    <--------------------->$COL_RESET"
cd /home/crypto-data/yiimp/yiimp_setup

# Starting the build progress of the stratum
echo
echo -e "$MAGENTA => Building$GREEN blocknotify$MAGENTA ,$GREEN iniparser$MAGENTA ,$GREEN stratum$MAGENTA ... <= $COL_RESET"

# Generating Random Password for stratum
blckntifypass=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`

# Compil Blocknotify
cd /home/crypto-data/yiimp/yiimp_setup/yiimp/blocknotify
sudo sed -i 's/tu8tu5/'$blckntifypass'/' blocknotify.cpp
hide_output make -j$((`nproc`+1))

# Compil Stratum
cd /home/crypto-data/yiimp/yiimp_setup/yiimp/stratum
hide_output git submodule init && hide_output git submodule update
hide_output sudo make -C algos
hide_output sudo make -C sha3
hide_output sudo make -C iniparser
cd secp256k1 && chmod +x autogen.sh && hide_output ./autogen.sh && hide_output ./configure --enable-experimental --enable-module-ecdh --with-bignum=no --enable-endomorphism && hide_output make -j$((`nproc`+1))
if [[ ("$AutoExchange" == "y" || "$AutoExchange" == "Y" || "$AutoExchange" == "yes") ]]; then
sudo sed -i 's/CFLAGS += -DNO_EXCHANGE/#CFLAGS += -DNO_EXCHANGE/' $HOME/yiimp/stratum/Makefile
fi
cd /home/crypto-data/yiimp/yiimp_setup/yiimp/stratum
hide_output make -j$((`nproc`+1))

echo -e "$CYAN => Building stratum folder structure and copying files... <= $COL_RESET"
cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum
sudo cp -a config.sample/. $STORAGE_ROOT/yiimp/site/stratum/config
sudo cp -r stratum $STORAGE_ROOT/yiimp/site/stratum
sudo cp -r run.sh $STORAGE_ROOT/yiimp/site/stratum
cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp
sudo cp -r $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/blocknotify/blocknotify $STORAGE_ROOT/yiimp/site/stratum
sudo cp -r $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/blocknotify/blocknotify /usr/bin

sudo rm -r $STORAGE_ROOT/yiimp/site/stratum/config/run.sh
echo '#!/usr/bin/env bash
source /etc/yiimpool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
ulimit -n 10240
ulimit -u 10240
cd '""''"${STORAGE_ROOT}"''""'/yiimp/site/stratum
while true; do
./stratum config/$1
sleep 2
done
exec bash' | sudo -E tee $STORAGE_ROOT/yiimp/site/stratum/config/run.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/site/stratum/config/run.sh

sudo rm -r $STORAGE_ROOT/yiimp/site/stratum/run.sh
echo '#!/usr/bin/env bash
source /etc/yiimpool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
cd '""''"${STORAGE_ROOT}"''""'/yiimp/site/stratum/config/ && ./run.sh $*
' | sudo -E tee $STORAGE_ROOT/yiimp/site/stratum/run.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/site/stratum/run.sh

echo -e "$YELLOW => Updating stratum config files with database$GREEN connection$YELLOW info <= $COL_RESET"
cd $STORAGE_ROOT/yiimp/site/stratum/config

sudo sed -i 's/password = tu8tu5/password = '${blckntifypass}'/g' *.conf
sudo sed -i 's/server = yaamp.com/server = '${StratumURL}'/g' *.conf
if [[ ("$wireguard" == "true") ]]; then
  sudo sed -i 's/host = yaampdb/host = '${DBInternalIP}'/g' *.conf
else
sudo sed -i 's/host = yaampdb/host = localhost/g' *.conf
fi
sudo sed -i 's/database = yaamp/database = '${YiiMPDBName}'/g' *.conf
sudo sed -i 's/username = root/username = '${StratumDBUser}'/g' *.conf
sudo sed -i 's/password = patofpaq/password = '${StratumUserDBPassword}'/g' *.conf

#set permissions
sudo setfacl -m u:$USER:rwx $STORAGE_ROOT/yiimp/site/stratum/
sudo setfacl -m u:$USER:rwx $STORAGE_ROOT/yiimp/site/stratum/config

sleep 1.5
term_art
echo -e "$GREEN => Stratum build complete $COL_RESET"
cd $HOME/yiimp_install_script/yiimp_single