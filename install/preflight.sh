#!/bin/env bash

##################################################################################
# This is the entry point for configuring the system.                            #
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox   #
# Updated by Afiniel for yiimpool use...                                         #
##################################################################################
if [ "$(lsb_release -d | sed 's/.*:\s*//' | sed 's/20\.04\.[0-9]/20.04/')" == "Ubuntu 20.04 LTS" ]; then
  DISTRO=20
  sudo chmod g-w /etc /etc/default /usr

elif [ "$(lsb_release -d | sed 's/.*:\s*//' | sed 's/18\.04\.[0-9]/18.04/')" == "Ubuntu 18.04 LTS" ]; then
  DISTRO=18
  sudo chmod g-w /etc /etc/default /usr

elif [ "$(lsb_release -d | sed 's/.*:\s*//' | sed 's/16\.04\.[0-9]/16.04/')" == "Ubuntu 16.04 LTS" ]; then
  DISTRO=16
  sudo chmod g-w /etc /etc/default /usr

else
  echo "This script only supports Ubuntu 16.04 LTS, 18.04 LTS, and 20.04 LTS."
  exit
fi

# Check if swap is needed.

SWAP_MOUNTED=$(cat /proc/swaps | tail -n+2)
SWAP_IN_FSTAB=$(grep "swap" /etc/fstab)
ROOT_IS_BTRFS=$(grep "\/ .*btrfs" /proc/mounts)
TOTAL_PHYSICAL_MEM=$(head -n 1 /proc/meminfo | awk '{print $2}')
AVAILABLE_DISK_SPACE=$(df / --output=avail | tail -n 1)
if
  [ -z "$SWAP_MOUNTED" ] &&
    [ -z "$SWAP_IN_FSTAB" ] &&
    [ ! -e /swapfile ] &&
    [ -z "$ROOT_IS_BTRFS" ] &&
    [ $TOTAL_PHYSICAL_MEM -lt 1536000 ] &&
    [ $AVAILABLE_DISK_SPACE -gt 5242880 ]
then
  echo "Adding a swap file to the system..."

  # Allocate and activate the swap file. Allocate in 1KB chunks
  # doing it in one go could fail on low memory systems
  sudo fallocate -l 3G /swapfile
  if [ -e /swapfile ]; then
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
  fi

  # Check if swap is mounted then activate on boot
  if swapon -s | grep -q "\/swapfile"; then
    echo "/swapfile  none swap sw 0  0" | sudo tee -a /etc/fstab
  else
    echo "ERROR: Swap allocation failed"
  fi
fi

ARCHITECTURE=$(uname -m)
if [ "$ARCHITECTURE" != "x86_64" ]; then
  if [ -z "$ARM" ]; then
    echo "Yiimpool Installer only supports x86_64 and will not work on any other architecture, like ARM or 32-bit OS."
    echo "Your architecture is $ARCHITECTURE"
    exit
  fi
fi

# Set STORAGE_USER and STORAGE_ROOT to default values (crypto-data and /home/crypto-data), unless
# we've already got those values from a previous run.
if [ -z "$STORAGE_USER" ]; then
  STORAGE_USER=$([[ -z "$DEFAULT_STORAGE_USER" ]] && echo "crypto-data" || echo "$DEFAULT_STORAGE_USER")
fi
if [ -z "$STORAGE_ROOT" ]; then
  STORAGE_ROOT=$([[ -z "$DEFAULT_STORAGE_ROOT" ]] && echo "/home/$STORAGE_USER" || echo "$DEFAULT_STORAGE_ROOT")
fi
