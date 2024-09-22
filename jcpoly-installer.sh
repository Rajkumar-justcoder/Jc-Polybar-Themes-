#!/bin/bash

# Colors
CRE=$(tput setaf 1) # Red
CYE=$(tput setaf 3) # Yellow
CGR=$(tput setaf 2) # Green
CBL=$(tput setaf 4) # Blue
BLD=$(tput bold)
CNC=$(tput sgr0)

# Functions
logo() {
    local text="${1:?}"
    echo -en "\n\n"
    printf ' %s [%s%s %s%s %s]%s\n\n' "${CRE}" "${CNC}" "${CYE}" "${text}" "${CNC}" "${CRE}" "${CNC}"
}

# Variables
backup_folder=~/.polybarbackup
date=$(date +%Y%m%d-%H%M%S)
home_dir=$HOME
current_dir=$(pwd)



# Check if running as root
if [ "$(id -u)" = 0 ]; then
    echo " Warning: Root access detected. Aborting script."
    exit 1
fi

# Check if running from HOME directory
if [ "$current_dir" != "$home_dir" ]; then
    printf "%s%s Warning: Script must be executed from the HOME directory.%s\n" "${BLD}" "${CYE}" "${CNC}"
    exit 1
fi

# Welcome message
logo "Polybar Installer"
printf '%s%sInitializing Polybar installation sequence...\n\n' "${BLD}" "${CGR}"
sleep 1

# Ask for confirmation
while true; do
    read -rp " Engage Polybar Theme installation? [y/N]: " ans
    case $ans in
        [Yy]* ) break ;;
        [Nn]* ) exit ;;
        * ) printf " Error: Invalid input. Please respond with 'y' or 'n'\n\n" ;;
    esac
done

clear

# Ask if PolyBar is installed
while true; do
    read -rp " PolyBar installed? [y/N]: " ans
    case $ans in
        [Yy]* ) break ;;
        [Nn]* ) exit ;;
        * ) printf " Error: Invalid input. Please respond with 'y' or 'n'\n\n" ;;
    esac
done
clear



logo "Downloading dotfiles"

repo_url="https://github.com/Rajkumar-justcoder/Jc-Polybar-Themes-.git"
repo_dir="$HOME/polybarthememaker"

# Verifies if the folder of the repository exists, and if it does, deletes it
if [ -d "$repo_dir" ]; then
    printf "Removing existing dotfiles repository\n"
    rm -rf "$repo_dir"
fi

# Clone the repository
printf "Cloning dotfiles from %s\n" "$repo_url"
git clone --depth=1 "$repo_url" "$repo_dir"
sleep 2
clear




# Prepare folders
logo "Backup Sequence Initiated"
printf "\nBackup files will be stored in %s%s%s/.polybarbackup%s \n\n" "${BLD}" "${CRE}" "$HOME" "${CNC}"
sleep 10

[ ! -d "$backup_folder" ] && mkdir -p "$backup_folder"

for folder in polybar; do
    if [ -d "$HOME/.config/$folder" ]; then
        mv "$HOME/.config/$folder" "$backup_folder/${folder}_$date" 2>> jcloger.log && \
        printf "%s%s%s folder backed up successfully at %s%s/%s_%s%s\n" "${BLD}" "${CGR}" "$folder" "${CBL}" "$backup_folder" "$folder" "$date" "${CNC}"
    else
        printf "%s%s%s folder does not exist, %sno backup needed%s\n" "${BLD}" "${CGR}" "$folder" "${CYE}" "${CNC}"
    fi
done

printf "%s%sBackup sequence complete.%s\n\n" "${BLD}" "${CGR}" "${CNC}"
sleep 5

# Copy dotfiles
logo "Polybar Installation Sequence"
printf "Copying files to respective directories..\n"

[ ! -d ~/.config ] && mkdir -p ~/.config

for dirs in ~/polybarthememaker/config/*; do
    dir_name=$(basename "$dirs")
    cp -R "${dirs}" ~/.config/ 2>> jcloger.log && \
    printf "%s%s%s %sconfiguration installed succesfully%s\n" "${BLD}" "${CYE}" "${dir_name}" "${CGR}" "${CNC}"
done

printf "\n\n%s%sPolybar installation complete.%s\n" "${BLD}" "${CGR}" "${CNC}"
printf "\n\n%s%sAdd ~/.config/polybar/polybarstarter.sh file to your autostart session.%s\n" "${BLD}" "${CGR}" "${CNC}"
printf "\n\n%s%sTo Change Theme run ~/.config/polybar/themeswitcher.sh and select theme.\nTheme preview can be found out on preview folder in polybar config folder.%s\n" "${BLD}" "${CGR}" "${CNC}"
printf "\n\n%s%sFor help run ~/.config/polybar/help.sh%s\n" "${BLD}" "${CGR}" "${CNC}"

sleep 5