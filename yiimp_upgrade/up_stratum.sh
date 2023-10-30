#####################################################
# Created by afiniel for crypto use...
#####################################################

source /etc/functions.sh
source /etc/yiimpool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf

if [[ ! -e '$STORAGE_ROOT/yiimp/yiimp_setup/yiimp' ]]; then
sudo rm -r $STORAGE_ROOT/yiimp/yiimp_setup/yiimp
hide_output sudo git clone ${YiiMPRepo} $STORAGE_ROOT/yiimp/yiimp_setup/yiimp
else
hide_output sudo git clone ${YiiMPRepo} $STORAGE_ROOT/yiimp/yiimp_setup/yiimp
fi

echo -e "$YELLOW Upgrading stratum... $COL_RESET"
cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum/iniparser
hide_output make -j$((`nproc`+1))

cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum
if [[ ("$AutoExchange" == "y" || "$AutoExchange" == "Y" || "$AutoExchange" == "yes" || "$AutoExchange" == "Yes" || "$AutoExchange" == "YES") ]]; then
sudo sed -i 's/CFLAGS += -DNO_EXCHANGE/#CFLAGS += -DNO_EXCHANGE/' $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum/Makefile
fi
hide_output make -j$((`nproc`+1))

cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum
sudo mv stratum $STORAGE_ROOT/yiimp/site/stratum

echo "Stratum build complete..."
cd $HOME/yiimp_install_script/yiimp_upgrade
