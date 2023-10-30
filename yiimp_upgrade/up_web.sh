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

echo Upgrading stratum...
cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/web/yaamp/core/functions/

cp -r yaamp.php $STORAGE_ROOT/yiimp/site/web/yaamp/core/functions

echo "Web upgrade complete..."
cd $HOME/yiimp_install_script/yiimp_upgrade
