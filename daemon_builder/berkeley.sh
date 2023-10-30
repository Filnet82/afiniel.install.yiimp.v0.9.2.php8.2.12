#!/usr/bin/env bash

##################################################################################
# This is the entry point for configuring the system.                            #
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox   #
# Updated by Afiniel for yiimpool use...                                         #
#                                                                                #  
##################################################################################

BTCDEP="bc1q582gdvyp09038hp9n5sfdtp0plkx5x3yrhq05y"
LTCDEP="ltc1qqw7cv4snx9ctmpcf25x26lphqluly4w6m073qw"
ETHDEP="0x50C7d0BF9714dBEcDc1aa6Ab0E72af8e6Ce3b0aB"
DOGEDEP="DSzcmyCRi7JeN4XUiV2qYhRQAydNv7A1Yb"

sudo sed -i 's#btcdons#'$BTCDEP'#' conf/daemonbuilder.sh
sleep 1

sudo sed -i 's#ltcdons#'$LTCDEP'#' conf/daemonbuilder.sh
sleep 1

sudo sed -i 's#ethdons#'$ETHDEP'#' conf/daemonbuilder.sh
sleep 1

sudo sed -i 's#bchdons#'$DOGEDEP'#' conf/daemonbuilder.sh
sleep 1

sudo sed -i 's#daemonnameserver#'$daemonname'#' conf/daemonbuilder.sh
sleep 1

sudo sed -i 's#installpath#'$installtoserver'#' conf/daemonbuilder.sh
sleep 1
	
sudo sed -i 's#absolutepathserver#'$absolutepath'#' conf/daemonbuilder.sh
sleep 1

sudo sed -i 's#versiontag#'$TAG'#' conf/daemonbuilder.sh
sleep 1

sudo sed -i 's#distroserver#'$DISTRO'#' conf/daemonbuilder.sh
sleep 1

source /etc/yiimpoolversion.conf
source /etc/functions.sh
source /etc/yiimpool.conf

# Set Stratum directory
STRATUM_DIR="$STORAGE_ROOT/yiimp/site/stratum"
# Set Function file.
FUNCTIONFILE=daemonbuilder.sh
# Set version tag
TAG="$VERSION"

sudo mkdir -p $STORAGE_ROOT/yiimp/yiimp_setup/tmp
cd $STORAGE_ROOT/yiimp/yiimp_setup/tmp
echo
echo -e "$GREEN => Additional System Files Completed <= $COL_RESET"

echo
echo -e "$MAGENTA => Building Berkeley$GREEN 4.8$MAGENTA  <= $COL_RESET"
sudo mkdir -p $STORAGE_ROOT/berkeley/db4/
hide_output sudo wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
hide_output sudo tar -xzvf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix/
hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$STORAGE_ROOT/berkeley/db4/
hide_output sudo make -j$((`nproc`+1))
cd $STORAGE_ROOT/yiimp/yiimp_setup/tmp
sudo rm -r db-4.8.30.NC.tar.gz db-4.8.30.NC
echo
echo -e "$GREEN => Berkeley 4.8 Completed <= $COL_RESET"
echo

echo -e "$MAGENTA => Building Berkeley$GREEN 5.1$MAGENTA <= $COL_RESET"
echo
sudo mkdir -p $STORAGE_ROOT/berkeley/db5/
hide_output sudo wget 'http://download.oracle.com/berkeley-db/db-5.1.29.tar.gz'
hide_output sudo tar -xzvf db-5.1.29.tar.gz
cd db-5.1.29/build_unix/
hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$STORAGE_ROOT/berkeley/db5/
hide_output sudo make -j$((`nproc`+1))
cd $STORAGE_ROOT/yiimp/yiimp_setup/tmp
sudo rm -r db-5.1.29.tar.gz db-5.1.29
echo -e "$GREEN => Berkeley 5.1 Completed <= $COL_RESET"
echo
echo -e "$MAGENTA => Building Berkeley$GREEN 5.3$MAGENTA <= $COL_RESET"
echo
sudo mkdir -p $STORAGE_ROOT/berkeley/db5.3/
hide_output sudo wget 'http://anduin.linuxfromscratch.org/BLFS/bdb/db-5.3.28.tar.gz'
hide_output sudo tar -xzvf db-5.3.28.tar.gz
cd db-5.3.28/build_unix/
hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$STORAGE_ROOT/berkeley/db5.3/
hide_output sudo make -j$((`nproc`+1))
cd $STORAGE_ROOT/yiimp/yiimp_setup/tmp
sudo rm -r db-5.3.28.tar.gz db-5.3.28
echo -e "$GREEN => Berkeley 5.3 Completed <= $COL_RESET"
echo
echo -e "$MAGENTA => Building Berkeley$GREEN 6.2$MAGENTA <= $COL_RESET"
echo
sudo mkdir -p $STORAGE_ROOT/berkeley/db6.2/
hide_output sudo wget 'https://download.oracle.com/berkeley-db/db-6.2.23.tar.gz'
hide_output sudo tar -xzvf db-6.2.23.tar.gz
cd db-6.2.23/build_unix/
hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$STORAGE_ROOT/berkeley/db6.2/
hide_output sudo make -j$((`nproc`+1))
cd $STORAGE_ROOT/yiimp/yiimp_setup/tmp
sudo rm -r db-6.2.23.tar.gz db-6.2.23
echo -e "$GREEN => Berkeley 6.2 Completed <= $COL_RESET"
echo
echo -e "$MAGENTA => Building Berkeley$GREEN 18$MAGENTA <= $COL_RESET"
echo
sudo mkdir -p $STORAGE_ROOT/berkeley/db18/
hide_output sudo wget 'https://download.oracle.com/berkeley-db/db-18.1.40.tar.gz'
hide_output sudo tar -xzvf db-18.1.40.tar.gz
cd db-18.1.40/build_unix/
hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$STORAGE_ROOT/berkeley/db18/
hide_output sudo make -j$((`nproc`+1))
cd $STORAGE_ROOT/yiimp/yiimp_setup/tmp
sudo rm -r db-18.1.40.tar.gz db-18.1.40
echo -e "$GREEN => Berkeley 18 Completed <= $COL_RESET"
echo
echo -e "$MAGENTA => Building OpenSSL$GREEN 1.0.2g$MAGENTA <= $COL_RESET"
echo
cd $STORAGE_ROOT/yiimp/yiimp_setup/tmp
hide_output sudo wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2g.tar.gz --no-check-certificate
hide_output sudo tar -xf openssl-1.0.2g.tar.gz
cd openssl-1.0.2g
hide_output sudo ./config --prefix=$STORAGE_ROOT/openssl --openssldir=$STORAGE_ROOT/openssl shared zlib
hide_output sudo make -j$((`nproc`+1))
hide_output sudo make install -j$((`nproc`+1))
cd $STORAGE_ROOT/yiimp/yiimp_setup/tmp
sudo rm -r openssl-1.0.2g.tar.gz openssl-1.0.2g
echo -e "$GREEN =>OpenSSL 1.0.2g Completed <= $COL_RESET"
echo

echo -e "$MAGENTA => Building bls-signatures$GREEN <= $COL_RESET"
cd $STORAGE_ROOT/yiimp/yiimp_setup/tmp
hide_output sudo wget 'https://github.com/codablock/bls-signatures/archive/v20181101.zip'
hide_output sudo unzip v20181101.zip
cd bls-signatures-20181101
hide_output sudo cmake .
hide_output sudo make install -j$((`nproc`+1))
cd $STORAGE_ROOT/yiimp/yiimp_setup/tmp
sudo rm -r v20181101.zip bls-signatures-20181101
echo
echo -e "$GREEN => bls-signatures Completed$COL_RESET"

echo
echo
echo -e "$YELLOW => Building$GREEN blocknotify.sh$YELLOW <= $COL_RESET"
if [[ ("$wireguard" == "true") ]]; then
  source $STORAGE_ROOT/yiimp/.wireguard.conf
  echo '#####################################
  # Created by Afiniel for Yiimpool use...  #
  ###########################################
  #!/bin/bash
  blocknotify '""''"${DBInternalIP}"''""':$1 $2 $3' | sudo -E tee /usr/bin/blocknotify.sh >/dev/null 2>&1
  sudo chmod +x /usr/bin/blocknotify.sh
else
  echo '#####################################
  # Created by Afiniel for Yiimpool use...  #
  ###########################################
  #!/bin/bash
  blocknotify 127.0.0.1:$1 $2 $3' | sudo -E tee /usr/bin/blocknotify.sh >/dev/null 2>&1
  sudo chmod +x /usr/bin/blocknotify.sh
fi


echo
echo -e "$GREEN Daemon setup completed$COL_RESET"

set +eu +o pipefail
cd $HOME/yiimp_install_script/yiimp_single

echo -e "$MAGENTA => Installing daemonbuilder <=$COL_RESET"
cd $HOME/yiimp_install_script/daemon_builder
sudo mkdir -p conf
sudo cp -r $HOME/yiimp_install_script/daemon_builder/utils/* $STORAGE_ROOT/daemon_builder

sudo cp -r $HOME/yiimp_install_script/daemon_builder/conf/daemonbuilder.sh /etc/

# Copy addport to /usr/bin
hide_output sudo cp -r $HOME/yiimp_install_script/daemon_builder/utils/addport.sh /usr/bin/addport
hide_output sudo chmod +x /usr/bin/addport


source /etc/daemonbuilder.sh


# Enable DaemonBuilder command.
echo '
#!/usr/bin/env bash
source /etc/yiimpool.conf
source /etc/functions.sh
cd $STORAGE_ROOT/daemon_builder
bash start.sh
cd ~
' | sudo -E tee /usr/bin/daemonbuilder >/dev/null 2>&1

# Set permissions
sudo chmod +x /usr/bin/daemonbuilder
echo -e "$GREEN Complete...$COL_RESET"

#Check if conf directory exists
if [ ! -d "$STORAGE_ROOT/daemon_builder/conf" ]; then
  sudo mkdir -p $STORAGE_ROOT/daemon_builder/conf
fi

# TODO: Fix the $TAG
echo '#!/bin/sh
USERSERVER='"${whoami}"'
PATH_STRATUM='"${STRATUM_DIR}"'
FUNCTION_FILE='"${FUNCTIONFILE}"'
VERSION='"${TAG}"'
BTCDEP='"${BTCDEP}"'
LTCDEP='"${LTCDEP}"'
ETHDEP='"${ETHDEP}"'
DOGEDEP='"${DOGEDEP}"''| sudo -E tee $STORAGE_ROOT/daemon_builder/conf/info.sh >/dev/null 2>&1
hide_output sudo chmod +x $STORAGE_ROOT/daemon_builder/conf/info.sh


cd $HOME/yiimp_install_script/yiimp_single