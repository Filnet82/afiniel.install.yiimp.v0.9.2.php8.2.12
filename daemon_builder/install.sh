#!/bin/bash
################################################################################
#
# Current Created by : Afiniel
# web: https://afiniel.xyz
# Program:
#   Install Daemon Coin on Ubuntu 18.04/20.04
#   v0.8.9 (2023-01-04)
#
################################################################################

if [ -z "${TAG}" ]; then
	TAG=v0.9.2
fi

clear
	TEMPINSTALL="$1"
	STRATUMFILE="$2"
	EXIT="false"

	if [ -z "${STRATUMFILE}" ]; then
		echo "Starting installer..."
	else
		DISTRO="$3"
		path_stratum=${STRATUMFILE}
	fi
	
	BTCDEP="bc1q582gdvyp09038hp9n5sfdtp0plkx5x3yrhq05y"
	LTCDEP="ltc1qqw7cv4snx9ctmpcf25x26lphqluly4w6m073qw"
	ETHDEP="0x50C7d0BF9714dBEcDc1aa6Ab0E72af8e6Ce3b0aB"
	DOGEDEP="DSzcmyCRi7JeN4XUiV2qYhRQAydNv7A1Yb"

	daemonname=daemonbuilder
	namescryptinstall="DaemonBuilder % Addport"
	installtoserver=daemonbuilder
	absolutepath=/home/crypto-data

	if [ -z "${TEMPINSTALL}" ]; then
		installdirname="${absolutepath}/daemonbuilder"
	else
		installdirname="${TEMPINSTALL}"
	fi

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

	if [ -z "${STRATUMFILE}" ]; then
		source conf/daemonbuilder.sh
		source ${installdirname}/conf/prerequisite.sh
		source ${installdirname}/conf/getip.sh
	fi

	# Are we running as root?
if (( $EUID == 0 )); then

	source conf/daemonbuilder.sh

	if ! locale -a | grep en_US.utf8 > /dev/null; then
		# Generate locale if not exists
		sudo locale-gen en_US.UTF-8
	fi

	export LANGUAGE=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	export LANG=en_US.UTF-8
	export LC_TYPE=en_US.UTF-8

	# Fix so line drawing characters are shown correctly in Putty on Windows. See #744.
	export NCURSES_NO_UTF8_ACS=1

	cd ..
	sudo rm -rf ${installdirname}/
	cd ~
	clear
	exit;
else
	cd ~

	output() {
	printf "\E[0;33;40m"
	echo $1
	printf "\E[0m"
	}

	displayErr() {
	echo
	echo $1;
	echo
	exit 1;
	}

	#Add user group sudo + no password
	whoami=$(whoami)
	sudo usermod -aG sudo ${whoami}
	echo '# yiimp
	# It needs passwordless sudo functionality.
	'""''"${whoami}"''""' ALL=(ALL) NOPASSWD:ALL
	' | sudo -E tee /etc/sudoers.d/${whoami} >/dev/null 2>&1

	if [[ -f "$STORAGE_ROOT/daemon_builder/conf/info.sh" ]]; then
		source $STORAGE_ROOT/daemon_builder/conf/info.sh
		if [[ ("$VERSION" == "$TAG") ]]; then
			source ${installdirname}/conf/daemonbuilder.sh

			if ! locale -a | grep en_US.utf8 > /dev/null; then
				# Generate locale if not exists
				sudo locale-gen en_US.UTF-8
			fi

			export LANGUAGE=en_US.UTF-8
			export LC_ALL=en_US.UTF-8
			export LANG=en_US.UTF-8
			export LC_TYPE=en_US.UTF-8

			# Fix so line drawing characters are shown correctly in Putty on Windows. See #744.
			export NCURSES_NO_UTF8_ACS=1
			cd ..
			sudo rm -rf ${installdirname}/
			cd ~
			clear
			if [ -z "${STRATUMFILE}" ]; then
				exit;
			fi
			EXIT="true"
		else
			FILEINFO=true
		fi
	else
		INSTVERSION=${TAG}
	fi

	if [[ ("${INSTVERSION}" == "${TAG}" && "${EXIT}" == "false") ]]; then
		#Copy needed files
		cd ${installdirname}
		sudo mkdir -p $STORAGE_ROOT/daemon_builder/conf/

		source ${installdirname}/conf/daemonbuilder.sh
		
		FUNC=/etc/daemonbuilder.sh
		if [[ ! -f "$FUNC" ]]; then
			sudo cp -r ${installdirname}/conf/daemonbuilder.sh /etc/
			FUNCTIONFILE=daemonbuilder.sh
			source /etc/daemonbuilder.sh
		fi

		SCSCRYPT=/etc/screen-scrypt-daemonbuilder.sh
		if [[ ! -f "$SCSCRYPT" ]]; then
			hide_output sudo cp -r ${installdirname}/utils/screen-scrypt-daemonbuilder.sh /etc/
			hide_output sudo chmod +x /etc/screen-scrypt-daemonbuilder.sh
			
			#Add to contrab screen-scrypt-daemonbuilder
			(crontab -l 2>/dev/null; echo "@reboot sleep 20 && /etc/screen-scrypt-daemonbuilder.sh") | crontab -
		fi

		EDITCONFAPP=/usr/bin/editconf.py
		if [[ ! -f "$EDITCONFAPP" ]]; then
			hide_output sudo cp -r ${installdirname}/conf/editconf.py /usr/bin/
			hide_output sudo chmod +x /usr/bin/editconf.py
		fi

		hide_output sudo cp -r ${installdirname}/conf/getip.sh $STORAGE_ROOT/daemon_builder/conf

	else
		if [[ ("${EXIT}" == "false") ]]; then
			source ${installdirname}/conf/daemonbuilder.sh

			FUNC=/etc/daemonbuilder.sh
			if [[ ! -f "$FUNC" ]]; then
				sudo cp -r ${installdirname}/conf/daemonbuilder.sh /etc/
				FUNCTIONFILE=daemonbuilder.sh
			fi
		fi
	fi
	
	if [[ ("${EXIT}" == "false") ]]; then
		term_art

		# Update package and Upgrade Ubuntu
		echo
		echo -e "$CYAN => Updating system and installing required packages :$COL_RESET"
		sleep 3

		hide_output sudo apt -y update 
		hide_output sudo apt -y upgrade
		hide_output sudo apt -y autoremove
		hide_output sudo apt-get install -y software-properties-common
		hide_output sudo apt install -y dialog python3 python3-pip acl nano apt-transport-https figlet jq
		echo -e "$GREEN Done...$COL_RESET"

		sleep 3

		if ! locale -a | grep en_US.utf8 > /dev/null; then
		# Generate locale if not exists
		sudo locale-gen en_US.UTF-8
		fi

		export LANGUAGE=en_US.UTF-8
		export LC_ALL=en_US.UTF-8
		export LANG=en_US.UTF-8
		export LC_TYPE=en_US.UTF-8

		# Fix so line drawing characters are shown correctly in Putty on Windows. See #744.
		export NCURSES_NO_UTF8_ACS=1

		if [[ "${FILEINFO}" == "true" ]]; then
			if [ -z "${PATH_STRATUM}" ]; then
				DEFAULT_path_stratum=/home/crypto-data/yiimp/site/stratum
			else
				path_stratum=${PATH_STRATUM}
			fi
			
			if [ -z "${FUNCTION_FILE}" ]; then
				FUNCTIONFILE=daemonbuilder.sh
			else
				FUNCTIONFILE=${FUNCTION_FILE}
			fi

			clear
			term_art

			echo
			echo -e "$YELLOW Updating your version to $TAG! $COL_RESET"
			NEWVERSION=${TAG}

		else
			FUNC=/etc/daemonbuilder.sh
			if [[ ! -f "$FUNC" ]]; then
				source /etc/daemonbuilder.sh
				FUNCTIONFILE=daemonbuilder.sh
			fi


			if [ -z "${STRATUMFILE}" ]; then
				DEFAULT_path_stratum=/home/crypto-data/yiimp/site/stratum
			fi

			clear
			term_art
		fi

		# Installing other needed files
		echo
		echo -e "$MAGENTA => Installing other needed files : $COL_RESET"
		sleep 3

		hide_output sudo apt-get -y install dialog acl libgmp3-dev libmysqlclient-dev libcurl4-gnutls-dev libkrb5-dev libldap2-dev libidn11-dev gnutls-dev \
		librtmp-dev sendmail mutt screen git make
		hide_output sudo apt -y install pwgen unzip
		echo -e "$GREEN Done...$COL_RESET"
		sleep 3

		# Installing Package to compile crypto currency
		echo
		echo -e "$MAGENTA => Installing Package to compile crypto currency $COL_RESET"
		sleep 3

		hide_output sudo apt-get -y install build-essential libzmq5 \
		libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils cmake libboost-all-dev zlib1g-dev \
		libseccomp-dev libcap-dev libminiupnpc-dev gettext libcanberra-gtk-module libqrencode-dev libzmq3-dev \
		libqt5gui5 libqt5core5a libqt5webkit5-dev libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
		if [[ ("${DISTRO}" == "18") ]]; then
			hide_output sudo apt-get -y install libz-dev libminiupnpc10
			hide_output sudo add-apt-repository -y ppa:bitcoin/bitcoin
			hide_output sudo apt -y update && sudo apt -y upgrade
			hide_output sudo apt -y install libdb4.8-dev libdb4.8++-dev libdb5.3 libdb5.3++
		fi
		hide_output sudo apt -y install libdb5.3 libdb5.3++

		echo -e "$GREEN Done...$COL_RESET"

		# Installing Package to compile crypto currency
		echo
		echo -e "$MAGENTA => Installing additional system files required for daemons $COL_RESET"
		sleep 3

		hide_output sudo apt-get -y update
		hide_output sudo apt -y install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev libboost-all-dev libminiupnpc-dev \
		libqt5gui5 libqt5core5a libqt5webkit5-dev libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev libzmq3-dev \
		libgmp-dev cmake libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev libpgm-dev libhidapi-dev \
		libusb-1.0-0-dev libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-locale-dev libboost-program-options-dev \
		libboost-regex-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev python3 ccache doxygen graphviz default-libmysqlclient-dev \
		libnghttp2-dev librtmp-dev libssh2-1 libssh2-1-dev libldap2-dev libidn11-dev libpsl-dev libnatpmp-dev systemtap-sdt-dev qtwayland5
		if [[ ("${DISTRO}" == "18") ]]; then
			hide_output sudo apt -y install ibsqlite3-dev
		else
			hide_output sudo apt -y install libdb-dev
			hide_output sudo apt -y install libdb5.3++ libdb5.3++-dev
		fi

		echo -e "$GREEN Additional System Files Completed...$COL_RESET"

		# Updating gcc & g++ to version 8
		echo
		echo -e "$CYAN => Updating GCC & G++ ... $COL_RESET"
		sleep 3

		hide_output sudo apt-get update -y
		hide_output sudo apt-get upgrade -y
		hide_output sudo apt-get dist-upgrade -y
		hide_output sudo apt-get install build-essential software-properties-common -y
		if [[ ("${DISTRO}" == "18") ]]; then
			hide_output sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
		fi
		hide_output sudo apt-get update -y
		hide_output sudo apt-get install gcc-8 g++-8 -y
		hide_output sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 60 --slave /usr/bin/g++ g++ /usr/bin/g++-8
		hide_output sudo update-alternatives --config gcc

		echo -e "$GREEN Updated GCC & G++ Completed...$COL_RESET"
		echo
		sleep 3

			cd ~
			sudo mkdir -p ${absolutepath}/daemon_setup/tmp/

		function berkeley_pacht_4x_5x
		{
			sudo sed -i 's/__atomic_compare_exchange/__atomic_compare_exchange_db/g' ${absolutepath}/daemon_setup/tmp/$1/dbinc/atomic.h
			#if [[ ("${DISTRO}" == "20") ]]; then
			#	sudo sed -i 's/__atomic_compare_exchange/__atomic_compare_exchange_db/g' ${absolutepath}/daemon_setup/tmp/$1/dbinc/atomic.h
			#fi
		}

		if [[ ! -d "$STORAGE_ROOT/daemon_builder/berkeley/db4" ]]; then
			echo -e "$YELLOW Building Berkeley 4.8, this may take several minutes...$COL_RESET"
			sleep 3

			sudo mkdir -p $STORAGE_ROOT/daemon_builder/berkeley/db4/
			cd ${absolutepath}/daemon_setup/tmp
			hide_output sudo wget 'https://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
			hide_output sudo tar -xzvf db-4.8.30.NC.tar.gz
			cd db-4.8.30.NC/build_unix/
			hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$STORAGE_ROOT/daemon_builder/berkeley/db4/
			berkeley_pacht_4x_5x "db-4.8.30.NC"
			hide_output sudo make install
			cd ${absolutepath}/daemon_setup/tmp/
			sudo rm -r db-4.8.30.NC.tar.gz db-4.8.30.NC
			echo -e "$GREEN Berkeley 4.8 Completed...$COL_RESET"
			DONEINST=true
		fi

		if [[ ! -d "$STORAGE_ROOT/daemon_builder/berkeley/db5" ]]; then
			echo -e "$YELLOW Building Berkeley 5.1, this may take several minutes...$COL_RESET"
			sleep 3

			sudo mkdir -p $STORAGE_ROOT/daemon_builder/berkeley/db5/
			cd ${absolutepath}/daemon_setup/tmp/
			hide_output sudo wget 'https://download.oracle.com/berkeley-db/db-5.1.29.tar.gz'
			hide_output sudo tar -xzvf db-5.1.29.tar.gz
			cd db-5.1.29/build_unix/
			hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$STORAGE_ROOT/daemon_builder/berkeley/db5/
			berkeley_pacht_4x_5x "db-5.1.29/src"
			hide_output sudo make install
			cd ${absolutepath}/daemon_setup/tmp
			sudo rm -r db-5.1.29.tar.gz db-5.1.29
			echo -e "$GREEN Berkeley 5.1 Completed...$COL_RESET"
			DONEINST=true
		fi

		if [[ ! -d "$STORAGE_ROOT/daemon_builder/berkeley/db5.3" ]]; then
			echo -e "$YELLOW Building Berkeley 5.3, this may take several minutes...$COL_RESET"
			sleep 3

			sudo mkdir -p $STORAGE_ROOT/daemon_builder/berkeley/db5.3/
			cd ${absolutepath}/daemon_setup/tmp/
			hide_output sudo wget 'https://anduin.linuxfromscratch.org/BLFS/bdb/db-5.3.28.tar.gz'
			hide_output sudo tar -xzvf db-5.3.28.tar.gz
			cd db-5.3.28/build_unix/
			hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$STORAGE_ROOT/daemon_builder/berkeley/db5.3/
			berkeley_pacht_4x_5x "db-5.3.28/src"
			hide_output sudo make install
			cd ${absolutepath}/daemon_setup/tmp/
			sudo rm -r db-5.3.28.tar.gz db-5.3.28
			echo -e "$GREEN Berkeley 5.3 Completed...$COL_RESET"
			DONEINST=true
		fi

		if [[ ! -d "$STORAGE_ROOT/daemon_builder/berkeley/db6.2" ]]; then
			echo -e "$YELLOW Building Berkeley 6.2, this may take several minutes...$COL_RESET"
			sleep 3

			sudo mkdir -p $STORAGE_ROOT/daemon_builder/berkeley/db6.2/
			cd ${absolutepath}/daemon_setup/tmp/
			hide_output sudo wget 'https://download.oracle.com/berkeley-db/db-6.2.23.tar.gz'
			hide_output sudo tar -xzvf db-6.2.23.tar.gz
			cd db-6.2.23/build_unix/
			hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$STORAGE_ROOT/daemon_builder/berkeley/db6.2/
			hide_output sudo make install
			cd ${absolutepath}/daemon_setup/tmp/
			sudo rm -r db-6.2.23.tar.gz db-6.2.23
			echo -e "$GREEN Berkeley 6.2 Completed...$COL_RESET"
			DONEINST=true
		fi

		if [[ ! -d "$STORAGE_ROOT/daemon_builder/berkeley/db18" ]]; then
			echo -e "$YELLOW Building Berkeley 18, this may take several minutes...$COL_RESET"
			sleep 3

			sudo mkdir -p $STORAGE_ROOT/daemon_builder/berkeley/db18/
			cd ${absolutepath}/daemon_setup/tmp/
			hide_output sudo wget 'https://download.oracle.com/berkeley-db/db-18.1.40.tar.gz'
			hide_output sudo tar -xzvf db-18.1.40.tar.gz
			cd db-18.1.40/build_unix/
			hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$STORAGE_ROOT/daemon_builder/berkeley/db18/
			hide_output sudo make install
			cd ${absolutepath}/daemon_setup/tmp/
			sudo rm -r db-18.1.40.tar.gz db-18.1.40
			echo -e "$GREEN Berkeley 18.xx Completed...$COL_RESET"
			DONEINST=true
		fi

		if [[ ! -d "$STORAGE_ROOT/daemon_builder/openssl" ]]; then
			echo -e "$YELLOW Building OpenSSL 1.0.2g, this may take several minutes...$COL_RESET"
			sleep 3

			cd ${absolutepath}/daemon_setup/tmp/
			hide_output sudo wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2g.tar.gz --no-check-certificate
			hide_output sudo tar -xf openssl-1.0.2g.tar.gz
			cd openssl-1.0.2g
			hide_output sudo ./config --prefix=$STORAGE_ROOT/daemon_builder/openssl --openssldir=$STORAGE_ROOT/daemon_builder/openssl shared zlib
			hide_output sudo make
			hide_output sudo make install
			cd ${absolutepath}/daemon_setup/tmp/
			sudo rm -r openssl-1.0.2g.tar.gz openssl-1.0.2g
			echo -e "$GREEN OpenSSL 1.0.2g Completed...$COL_RESET"
			DONEINST=true
		fi

		if [[ "${INSTVERSION}" == "$TAG" ]]; then
			echo -e "$YELLOW Building bls-signatures, this may take several minutes...$COL_RESET"
			sleep 3

			cd ${absolutepath}/daemon_setup/tmp/
			hide_output sudo wget 'https://github.com/codablock/bls-signatures/archive/v20181101.zip'
			hide_output sudo unzip v20181101.zip
			cd bls-signatures-20181101
			hide_output sudo cmake .
			hide_output sudo make install
			cd ${absolutepath}/daemon_setup/tmp/
			sudo rm -r v20181101.zip bls-signatures-20181101
			echo -e "$GREEN bls-signatures Completed...$COL_RESET"
			DONEINST=true
		fi

		if [[ ("${DONEINST}" == "true") ]]; then
			echo
		fi

		if [[ "${INSTVERSION}" == "$TAG" ]]; then
			# Update Timezone
			echo -e "$CYAN => Update default timezone. $COL_RESET"
			sleep 3

			if [ ! -f /etc/timezone ]; then
				echo "Etc/UTC" > sudo /etc/timezone
				sudo systemctl restart rsyslog >/dev/null 2>&1
			fi
			sudo systemctl status rsyslog | sed -n "1,3p" >/dev/null 2>&1
			echo -e "$GREEN Done...$COL_RESET"
			sleep 3
		fi

		if [[ "${NEWVERSION}" == "$TAG" ]] || [[ "${INSTVERSION}" == "$TAG" ]]; then
			if [[ "${NEWVERSION}" == "$TAG" ]]; then
				echo
				# Updating Daemonbuilder
				echo -e "$YELLOW Updating daemonbuilder Coin! $COL_RESET"
				sleep 3
			else
				# Install Daemonbuilder
				echo
				echo -e "$MAGENTA => Installing daemonbuilder $COL_RESET"
				sleep 3
			fi

			cd ${installdirname}
			sudo mkdir -p $STORAGE_ROOT/daemon_builder/

			hide_output sudo cp -r ${installdirname}/utils/start.sh $STORAGE_ROOT/daemon_builder/
			hide_output sudo cp -r ${installdirname}/utils/menu.sh $STORAGE_ROOT/daemon_builder/
			hide_output sudo cp -r ${installdirname}/utils/menu1.sh $STORAGE_ROOT/daemon_builder/
			hide_output sudo cp -r ${installdirname}/utils/menu2.sh $STORAGE_ROOT/daemon_builder/
			hide_output sudo cp -r ${installdirname}/utils/menu3.sh $STORAGE_ROOT/daemon_builder/
			hide_output sudo cp -r ${installdirname}/utils/menu4.sh $STORAGE_ROOT/daemon_builder/
			hide_output sudo cp -r ${installdirname}/utils/source.sh $STORAGE_ROOT/daemon_builder/
			sleep 3
			hide_output sudo chmod +x $STORAGE_ROOT/daemon_builder/start.sh
			hide_output sudo chmod +x $STORAGE_ROOT/daemon_builder/menu.sh
			hide_output sudo chmod +x $STORAGE_ROOT/daemon_builder/menu1.sh
			hide_output sudo chmod +x $STORAGE_ROOT/daemon_builder/menu2.sh
			hide_output sudo chmod +x $STORAGE_ROOT/daemon_builder/menu3.sh
			hide_output sudo chmod +x $STORAGE_ROOT/daemon_builder/menu4.sh
			hide_output sudo chmod +x $STORAGE_ROOT/daemon_builder/source.sh
			sleep 3
			echo -e "$GREEN Done...$COL_RESET"

			if [[ "${NEWVERSION}" == "$TAG" ]]; then
				# Updating Addport
				echo -e "$YELLOW Updating Addport Coin! $COL_RESET"
				sleep 3
			else
				# Install Addport
				echo
				echo -e "$MAGENTA => Installing Addport $COL_RESET"
				sleep 3
			fi

			hide_output sudo cp -r ${installdirname}/utils/addport.sh /usr/bin/addport
			hide_output sudo chmod +x /usr/bin/addport

			if [[ "${INSTVERSION}" == "$TAG" ]]; then
				sleep 3
				echo '#!/usr/bin/env bash
				source /etc/'"${FUNCTIONFILE}"' # load our daemonbuilder.sh
				cd '"${absolutepath}"'/'"${installtoserver}"'/daemon_builder
				bash start.sh
				cd ~' | sudo -E tee /usr/bin/${daemonname} >/dev/null 2>&1
				hide_output sudo chmod +x /usr/bin/${daemonname}
			fi

			echo -e "$GREEN Done...$COL_RESET"
			sleep 5
		fi

		if [[ "${INSTVERSION}" == "$TAG" ]]; then
			# Final Directory permissions
			echo
			echo -e "$CYAN => Final Directory permissions $COL_RESET"
			sleep 3

			#Restart service
			hide_output sudo systemctl restart cron.service

			echo -e "$GREEN Done...$COL_RESET"
			sleep 5
		fi

		if [[ "${FILEINFO}" == "true" ]]; then
			echo -e "$YELLOW FINISH! Updating info file to $TAG! $COL_RESET"
			sleep 3
			if [ -z "${VERSION}" ]; then
				echo '#!/bin/sh
				USERSERVER='"${whoami}"'
				PATH_STRATUM='"${path_stratum}"'
				FUNCTION_FILE='"${FUNCTIONFILE}"'
				VERSION='"${TAG}"'
				BTCDEP='"${BTCDEP}"'
				LTCDEP='"${LTCDEP}"'
				ETHDEP='"${ETHDEP}"'
				DOGEDEP='"${DOGEDEP}"''| sudo -E tee $STORAGE_ROOT/daemon_builder/conf/info.sh >/dev/null 2>&1
				hide_output sudo chmod +x $STORAGE_ROOT/daemon_builder/conf/info.sh
			else
				if [[ ! "$VERSION" == "$TAG" ]]; then
					echo '#!/bin/sh
					USERSERVER='"${whoami}"'
					PATH_STRATUM='"${path_stratum}"'
					FUNCTION_FILE='"${FUNCTIONFILE}"'
					VERSION='"${TAG}"'
					BTCDEP='"${BTCDEP}"'
					LTCDEP='"${LTCDEP}"'
					ETHDEP='"${ETHDEP}"'
					DOGEDEP='"${DOGEDEP}"''| sudo -E tee $STORAGE_ROOT/daemon_builder/conf/info.sh >/dev/null 2>&1
					hide_output sudo chmod +x $STORAGE_ROOT/daemon_builder/conf/info.sh
				fi
				echo -e "$GREEN Done...$COL_RESET"
				sleep 5
			fi
		else
			echo -e "$YELLOW FINISH! Creating info file to Version $TAG! $COL_RESET"
			sleep 3
			echo '#!/bin/sh
			USERSERVER='"${whoami}"'
			PATH_STRATUM='"${path_stratum}"'
			FUNCTION_FILE='"${FUNCTIONFILE}"'
			VERSION='"${TAG}"'
			BTCDEP='"${BTCDEP}"'
			LTCDEP='"${LTCDEP}"'
			ETHDEP='"${ETHDEP}"'
			DOGEDEP='"${DOGEDEP}"'' | sudo -E tee $STORAGE_ROOT/daemon_builder/conf/info.sh >/dev/null 2>&1
			hide_output sudo chmod +x $STORAGE_ROOT/daemon_builder/conf/info.sh
			echo -e "$GREEN Done...$COL_RESET"
			sleep 5
		fi

		#Misc
		sudo rm -rf ${installdirname}
		sudo rm -rf ${absolutepath}/daemon_setup

		if [ -z "${STRATUMFILE}" ]; then
		cd $HOME/yiimp_install_script/yiimp_single
		fi
	fi
fi
