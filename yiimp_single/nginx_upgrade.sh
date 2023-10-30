#!/usr/bin/env bash

#####################################################
# Created by afiniel for crypto use...
#####################################################

source /etc/functions.sh
source /etc/yiimpool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
source $HOME/yiimp_install_script/yiimp_single/.wireguard.install.cnf
cd $HOME/yiimp_install_script/yiimp_single

set -eu -o pipefail

function print_error {
    read line file <<<$(caller)
    echo "An error occurred in line $line of file $file:" >&2
    sed "${line}q;d" "$file" >&2
}
trap print_error ERR
term_art
echo -e "$MAGENTA <----------------------------------> $COL_RESET"
echo -e "$MAGENTA Database$YELLOW build and tweak$GREEN completed $COL_RESET"
echo -e "$MAGENTA <----------------------------------> $COL_RESET"
echo -e "$GREEN Passwords can be found in$RED $STORAGE_ROOT/yiimp/.my.cnf $COL_RESET $COL_RESET"

if [[ ("$wireguard" == "true") ]]; then
source $STORAGE_ROOT/yiimp/.wireguard.conf
fi

# NGINX upgrade TODO: CLEAN UP
echo -e "$YELLOW => Upgrading NGINX  <= $COL_RESET"

# Grab Nginx key and proper mainline package for distro
echo "deb http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list >/dev/null 2>&1

sudo curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add - >/dev/null 2>&1
hide_output sudo apt-get update
hide_output sudo apt-get install -y nginx

# Make additional conf directories, move and generate needed configurations.
sudo mkdir -p /etc/nginx/yiimpool
#sudo mkdir -p /etc/nginx/sites-available
#sudo mkdir -p /etc/nginx/sites-enabled

sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
sudo cp -r nginx_confs/nginx.conf /etc/nginx/
sudo cp -r nginx_confs/general.conf /etc/nginx/yiimpool
sudo cp -r nginx_confs/php_fastcgi.conf /etc/nginx/yiimpool
sudo cp -r nginx_confs/security.conf /etc/nginx/yiimpool
sudo cp -r nginx_confs/letsencrypt.conf /etc/nginx/yiimpool

# Removing default nginx site configs.
#sudo rm -r /etc/nginx/conf.d/default.conf
sudo rm -r /etc/nginx/sites-enabled/default
sudo rm -r /etc/nginx/sites-available/default*

echo -e "$GREEN NGINX upgrade complete.$COL_RESET"
restart_service nginx
restart_service php7.3-fpm

set +eu +o pipefail

cd $HOME/yiimp_install_script/yiimp_single
