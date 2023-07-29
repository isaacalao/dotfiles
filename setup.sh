#!/bin/bash

# Reference: https://www.shellcheck.net/

# FUNCTIONS

 load_anim() {

   if [[ $# = 2 ]]; then
     loadchar=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" "▇" "▆" "▅" "▄" "▃" "▁")
     for i in $(seq "${1}"); do
        sleep 0.1
        printf "\t\e[33mWaiting %s\e[0m\r" "${loadchar[$((i%${#loadchar[@]}+1))]}"
     done
   else
        printf "☹\n"
   fi
 }

# PLATFORM CHECK

platform=$(uname | tr "[:upper:]" "[:lower:]")

load_anim "20"

if [[ "$platform" = "darwin" ]]; 
then
	printf "\e[33mChecking for brew... on %s\e[0m\n" "$platform";
	if [[ $(brew -v; echo $?) = 127 ]]; then 
	 printf "\e[31mHOMEBREW IS NOT INSTALLED!\e[0m\n\e[33mDo you want to install? [y/N]:\e[0m\e[34m "
	 read -r ans; printf "\e[0m"
	 if [[ "${ans}" = [Yy]* ]]; then
	  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	 fi
	else
	 printf "\e[32mHOMEBREW IS INSTALLED!\e[0m"
	fi 
elif [[ "$platform" = ["gnu""linux"]*["gnu""linux"] ]]; 
then
	printf "\e[34mNo implementation here yet.\e[0m";
else
	printf "\e[31m%s is not supported.\e[0m" "$platform";
fi

unset load_anim platform; exit;
