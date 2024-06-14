#!/usr/bin/env bash

# para ejecutarlo directamente desde la terminal
# sh -c "$(curl -s https://raw.githubusercontent.com/FQ211776/dot/master/run_onchange_install-packages.sh)"

#  ██████╗ ██╗ ██████╗███████╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗
#  ██╔══██╗██║██╔════╝██╔════╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
#  ██████╔╝██║██║     █████╗      ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
#  ██╔══██╗██║██║     ██╔══╝      ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
#  ██║  ██║██║╚██████╗███████╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
#  ╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
#   Script to install my dotfiles
#   Author: z0mbi3
#   url: https://github.com/gh0stzk

clear

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
    gum style --foreground 35 "1. Actualizar copia remota .zshrc"
    gum style --foreground 35 "2. Editar copia local .zshrc"
    echo
    gum style --foreground 35 "3. Actualizar copia remota .gitconfig"
    gum style --foreground 35 "4. Editar copia local .gitconfig"
    echo
    gum style --foreground 35 "3. Clonar o actualizar copia local de los dotfiles originales."
    gum style --foreground 35 "4. Instalar los dotfiles originales."
    gum style --foreground 35 "5. configurar ZSH."
    gum style --foreground 35 "5. configurar Fish."
    echo
    gum style --foreground 33 "Type your selection or 'q' to return to main menu."
}

########## ---------- You must not run this as root ---------- ##########

if [ "$(id -u)" = 0 ]; then
    echo "This script MUST NOT be run as root user."
    exit 1
fi

########## ---------- ~/.zshrc ---------- ##########

add_zshrc(){
    logo "Actualizar copia remota.zshrc"
    chezmoi add -r ~/.zshrc
    sleep 2
}

mod_zshrc(){
    logo "Editar copia remota.zshrc"
    chezmoi edit ~/.zshrc --apply   
    sleep 2
}

########## ---------- ~/.gitconfig ---------- ##########

add_gitconfig(){
    logo "Actualizar copia remota.zshrc"
    chezmoi add -r ~/.gitconfig
    sleep 2
}

mod_gitconfig(){
    logo "Editar copia remota.zshrc"
    chezmoi edit ~/.gitconfig --apply   
    sleep 2
}



main() {
    check_gum
    check_dialog
    while :; do
        display_menu
        read -rp "Enter your choice: " CHOICE
        echo

        case $CHOICE in
        1) add_zshrc ;;
        2) mod_zshrc ;;
        #
        3) add_gitconfig ;;
        4) mod_gitconfig ;;
        3) Instalar_repositorio ;;
        4) Instalar_dotfiles ;;
        5) zsh_ ;;
        6) fish_ ;;
        q) clear && exit ;;
        *)
            gum style --foreground 50 "Invalid choice. Please select a valid option."
            echo
            ;;
        esac
        sleep 1
    done
}

main

# https://github.com/ymattw/ydiff
