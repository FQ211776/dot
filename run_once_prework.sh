#!/bin/bash
set -e

CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
CBL=$(tput setaf 4)
BLD=$(tput bold)
CNC=$(tput sgr0)

logo() {

    local text="${1:?}"
    echo -en "
	               %%%
	        %%%%%//%%%%%
	      %%************%%%
	  (%%//############*****%%
	%%%%%**###&&&&&&&&&###**//
	%%(**##&&&#########&&&##**
	%%(**##*****#####*****##**%%%
	%%(**##     *****     ##**
	   //##   @@**   @@   ##//
	     ##     **###     ##
	     #######     #####//
	       ###**&&&&&**###
	       &&&         &&&
	       &&&////   &&
	          &&//@@@**
	            ..***
    z0mbi3 Dotfiles\n\n"
    printf ' %s [%s%s %s%s %s]%s\n\n' "${CRE}" "${CNC}" "${CYE}" "${text}" "${CNC}" "${CRE}" "${CNC}"
}

# Function to display the menu
display_menu() {
    clear
    gum style --foreground 212 --border double --padding "1 1" --margin "1 1" --align center "Initial System Setup"
    echo
    gum style --foreground 142 "Hello $USER, please select an option. Press 'i' for the Wiki."
    echo
    gum style --foreground 35 "1. Configurar SSH"
    gum style --foreground 35 "2. Clonar .gitconfig"
    gum style --foreground 35 "3. Configurar GPG"
    gum style --foreground 35 "q. Salir"
}

Instalar_paquetes_adicionales() {

    logo "Instando: git github-cli hub diff-so-fancy gum dialog"

    dependencias=(git github-cli hub diff-so-fancy gum dialog)

    is_installed() {
        pacman -Q "$1" &>/dev/null
    }

    printf "%s%sChecking for required packages...%s\n" "${BLD}" "${CBL}" "${CNC}"
    for paquete in "${dependencias[@]}"; do
        if ! is_installed "$paquete"; then
            if sudo pacman -S "$paquete" --noconfirm >/dev/null 2>>RiceError.log; then
                printf "%s%s%s %shas been installed succesfully.%s\n" "${BLD}" "${CYE}" "$paquete" "${CBL}" "${CNC}"
                sleep 1
            else
                printf "%s%s%s %shas not been installed correctly. See %sRiceError.log %sfor more details.%s\n" "${BLD}" "${CYE}" "$paquete" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
                sleep 1
            fi
        else
            printf '%s%s%s %sis already installed on your system!%s\n' "${BLD}" "${CYE}" "$paquete" "${CGR}" "${CNC}"
            sleep 1
        fi
    done

    sleep 2
    clear

}

Configurar_ssh() {
    Instalar_paquetes_adicionales
    gh auth login
}

Clone_gitconfig() {
    ########## ---------- Cloning the Rice! ---------- ##########

    repo_dir="$HOME/my-dev-branch"

    # Verifies if the folder of the repository exists, and if it does, deletes it
    if [ -d "$repo_dir" ]; then
        printf "Removing existing dotfiles repository\n"
        rm -rf "$repo_dir"
    fi

    # Clone the repository
    # TODO hacer que la instalacion sea con curl sin clonar el repositorio
    printf "Cloning dotfiles from %s\n" "$repo_url"
    git clone --depth=1 -b my-dev-branch git@github.com:FQ211776/dotfiles_arch.git "$HOME"/my-dev-branch
    cp -f "$HOME"/my-dev-branch/custom/home/.gitconfig "$HOME"
    sleep 2
    clear

    ########## ---------- Preparing Folders ---------- ##########

    # Verifies if the archive user-dirs.dirs doesn't exist in ~/.config
    if [ ! -e "$HOME/.config/user-dirs.dirs" ]; then
        xdg-user-dirs-update
    fi

}

Configurar_gpg() {
    ########## ---------- Add GPG Key ---------- ##########
    gh auth refresh -s write:gpg_key
    gpg --gen-key
    sleep 2
    gpg --list-keys
    printf "copia la GPG y agregala a Github con el siguiente comando-\n"
    printf "gpg --armor --export *** | gh gpg-key add -\n"
    printf "cuando se abra geany la agregas a tu gitconfig-\n"
    sleep 15
    printf "gpg --armor --export *** | gh gpg-key add -\n"
    #gpg --armor --export *** | gh gpg-key add -
    geany "$HOME"/.gitconfig

    rm -rf ~/test && mkdir ~/test && cd ~/test && git init && echo "test" >>test && git add test && git commit -m "test" && git log --show-signature && cd .. && rm -rf test

}

main() {

    while :; do
        display_menu
        read -rp "Enter your choice: " CHOICE
        echo

        case $CHOICE in
        1) Configurar_ssh ;;
        2) Clone_gitconfig ;;
        3) Configurar_gpg ;;
        q) clear && exit ;;
        *)
            gum style --foreground 50 "Invalid choice. Please select a valid option."
            echo
            ;;
        esac
        sleep 1
    done
}

Instalar_paquetes_adicionales
main
