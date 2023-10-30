#!/usr/bin/env bash
#########################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by Afiniel for Yiimpool use...
# This script is intended to be run like this:
#
# curl https://raw.githubusercontent.com/afiniel/yiimp_install_script/master/install.sh | bash
#
#########################################################

if [ -z "${TAG}" ]; then
	TAG=v0.9.2
fi

echo 'VERSION='"${TAG}"'' | sudo -E tee /etc/yiimpoolversion.conf >/dev/null 2>&1

# Clone the Yiimp Install Script repository if it doesn't exist.
if [ ! -d $HOME/yiimp_install_script ]; then
	if [ ! -f /usr/bin/git ]; then
		echo Installing git . . .
		apt-get -q -q update
		DEBIAN_FRONTEND=noninteractive apt-get -q -q install -y git < /dev/null
		clear
		echo

	fi
	
	echo Downloading Yiimpool Installer ${TAG}. . .
	git clone \
		-b ${TAG} --depth 1 \
		https://github.com/afiniel/yiimp_install_script \
		"$HOME"/yiimp_install_script \
		< /dev/null 2> /dev/null

	echo
fi


cd $HOME/yiimp_install_script/

# Update it.
sudo chown -R $USER $HOME/yiimp_install_script/.git/
if [ "${TAG}" != `git describe --tags` ]; then
	echo Updating Yiimpool Installer to ${TAG} . . .
	git fetch --depth 1 --force --prune origin tag ${TAG}
	if ! git checkout -q ${TAG}; then
		echo "Update failed. Did you modify something in `pwd`?"
		exit
	fi
	echo
fi

# Start setup script.
bash $HOME/yiimp_install_script/install/start.sh
