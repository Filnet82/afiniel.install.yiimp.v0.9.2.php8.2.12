#####################################################
# Created by afiniel for crypto use...
#####################################################

source /etc/functions.sh
source /etc/yiimpool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf

if [[ ! -e '$STORAGE_ROOT/yiimp/yiimp_setup/yiimp' ]]; then
sudo rm -r $STORAGE_ROOT/yiimp/yiimp_setup/yiimp
sudo git clone ${YiiMPRepo} $STORAGE_ROOT/yiimp/yiimp_setup/yiimp
else
sudo git clone ${YiiMPRepo} $STORAGE_ROOT/yiimp/yiimp_setup/yiimp
fi

echo -e "$CYAN Updating Stratum... $COL_RESET"

# Compil Stratum
cd /home/crypto-data/yiimp/yiimp_setup/yiimp/stratum

sudo git submodule init && sudo git submodule update
sudo make -C algos
sudo make -C sha3
sudo make -C iniparser
cd secp256k1 && sudo chmod +x autogen.sh && sudo ./autogen.sh && sudo ./configure --enable-experimental --enable-module-ecdh --with-bignum=no --enable-endomorphism && sudo make -j$((`nproc`+1))
if [[ ("$AutoExchange" == "y" || "$AutoExchange" == "Y" || "$AutoExchange" == "yes" || "$AutoExchange" == "Yes" || "$AutoExchange" == "YES") ]]; then
sudo sed -i 's/CFLAGS += -DNO_EXCHANGE/#CFLAGS += -DNO_EXCHANGE/' /home/crypto-data/yiimp/yiimp_setup/yiimp/stratum/Makefile
fi

cd /home/crypto-data/yiimp/yiimp_setup/yiimp/stratum
sudo make -j$((`nproc`+1))

sudo mv stratum $STORAGE_ROOT/yiimp/site/stratum

cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/web/yaamp/core/functions/
cp -r yaamp.php $STORAGE_ROOT/yiimp/site/web/yaamp/core/functions

echo -e "$YELLOW Stratum build$GREEN complete... $COL_RESET"
cd $HOME/yiimp_install_script/yiimp_upgrade
