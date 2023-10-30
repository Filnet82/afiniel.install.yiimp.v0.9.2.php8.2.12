#!/usr/bin/env bash

##########################################
# Created by Afiniel for Yiimpool use... #
##########################################

# Load configuration files
source "$HOME/yiimp_install_script/yiimp_single/.wireguard.install.cnf"
source "$STORAGE_ROOT/yiimp/.wireguard.conf"
source "/etc/functions.sh"
source "/etc/yiimpool.conf"

# Display banner
term_art
echo -e "$MAGENTA    <-------------------------->$COL_RESET"
echo -e "$MAGENTA     <--$YELLOW Installing WireGuard$MAGENTA -->$COL_RESET"
echo -e "$MAGENTA    <-------------------------->$COL_RESET"

# Add WireGuard repository and install packages
sudo add-apt-repository ppa:wireguard/wireguard -y
sudo apt-get update -y
sudo apt-get install wireguard-dkms wireguard-tools -y

# Generate WireGuard keys
wg_private_key=$(wg genkey)
wg_public_key=$(echo "$wg_private_key" | wg pubkey)

# Create WireGuard configuration file
wg_config="/etc/wireguard/wg0.conf"
sudo tee "$wg_config" >/dev/null <<EOL
[Interface]
PrivateKey = $wg_private_key
ListenPort = 6121
SaveConfig = true
Address = ${DBInternalIP}/24
EOL

# Start WireGuard and enable at boot
sudo systemctl start wg-quick@wg0
sudo systemctl enable wg-quick@wg0

# Allow incoming connections on WireGuard port
ufw_allow 6121

# Display WireGuard public key and IP
dbpublic="${PUBLIC_IP}"
mypublic="${wg_public_key}"
echo -e "Public Ip: ${dbpublic}\nPublic Key: ${mypublic}" | sudo -E tee "$STORAGE_ROOT/yiimp/.wireguard_public.conf" >/dev/null 2>&1

echo
echo -e "$GREEN WireGuard setup completed $COL_RESET"

# Change directory to yiimp_single
cd "$HOME/yiimpool/yiimp_single"
