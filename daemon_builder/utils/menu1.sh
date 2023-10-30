#!/bin/env bash

# This is the main menu for Daemon Builder
# Author: Afiniel
# Updated: 2023-03-22

# Source necessary configuration files
source /etc/daemonbuilder.sh
source "$STORAGE_ROOT/daemon_builder"

# Function to set Berkeley configuration
set_berkeley_config() {
    clear
    echo "Configuring Berkeley $1 for coin installation..."
    echo "autogen=true" > "$STORAGE_ROOT/daemon_builder/.daemon_builder.my.cnf"
    echo "berkeley=\"$1\"" >> "$STORAGE_ROOT/daemon_builder/.daemon_builder.my.cnf"
    source source.sh
}

# Function to set other installation options
set_other_config() {
    clear
    case $1 in
        5)
            echo "Configuring coin installation with makefile.unix..."
            echo "autogen=false" > "$STORAGE_ROOT/daemon_builder/.daemon_builder.my.cnf"
            echo "unix=true" >> "$STORAGE_ROOT/daemon_builder/.daemon_builder.my.cnf"
            ;;
        6)
            echo "Configuring coin installation with CMake file & DEPENDS folder..."
            echo "autogen=false" > "$STORAGE_ROOT/daemon_builder/.daemon_builder.my.cnf"
            echo "cmake=true" >> "$STORAGE_ROOT/daemon_builder/.daemon_builder.my.cnf"
            ;;
        7)
            echo "Configuring coin installation with UTIL folder containing BUILD.sh..."
            echo "buildutil=true" > "$STORAGE_ROOT/daemon_builder/.daemon_builder.my.cnf"
            echo "autogen=true" >> "$STORAGE_ROOT/daemon_builder/.daemon_builder.my.cnf"
            ;;
        8)
            echo "Configuring precompiled coin installation (LINUX version required)..."
            echo "precompiled=true" > "$STORAGE_ROOT/daemon_builder/.daemon_builder.my.cnf"
            ;;
    esac
    source source.sh
}

# Display the menu and process user choice
while true; do
    RESULT=$(dialog --stdout --title "DaemonBuilder $VERSION" --menu "Choose an option" 16 60 9 \
        ' ' "- Install coin with Berkeley autogen file -" \
        1 "Berkeley 4.8" \
        2 "Berkeley 5.1" \
        3 "Berkeley 5.3" \
        4 "Berkeley 6.2" \
        ' ' "- Other choices -" \
        5 "Install coin with makefile.unix file" \
        6 "Install coin with CMake file & DEPENDS folder" \
        7 "Install coin with UTIL folder contains BUILD.sh" \
        8 "Install precompiled coin (LINUX version)" \
        9 "Exit")

    case $RESULT in
        1|2|3|4) set_berkeley_config "$RESULT";;
        5|6|7|8) set_other_config "$RESULT";;
        9)
            clear
            echo "You have chosen to exit the Daemon Builder. Type: daemonbuilder anytime to start the menu again."
            exit
            ;;
        *)
            clear
            echo "Invalid choice. Please select a valid option."
            ;;
    esac
done
