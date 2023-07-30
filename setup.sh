#!/bin/bash

# USAGE: Automate the installation of my environment on supported platforms

# REFERENCE: https://www.shellcheck.net/

# FUNCTIONS

 load_viz() {

   # Precept(s):
   # state = {true:1|false:0}

   ("$@" >> setup_log.txt 2>&1) & # Run a command in a subshell in the background and output stdout/err into a file 
   pidn="$!" # Acquire the process id number
   state=1 # true/false state
   if [[ $# > 0 ]]; then
     loadchar=( "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" "▇" "▆" "▅" "▄" "▃" "▁" ) 
     for (( i=1; "$state" == 1; i++ )); do
        sleep 0.1
        printf "\t\e[33mWaiting %s\e[0m\r" "${loadchar[$((i%${#loadchar[@]}))]}"
	[[ "$i" == 10 ]] && i=1
	ps $pidn > /dev/null 2>&1; [[ $? = 1 ]] && state=0
     done
   else
        printf "Usage: load_viz <command> [...]\n\tload_viz echo Hi\n"
   fi
 }

# PLATFORM CHECK

platform=$(uname | tr "[:upper:]" "[:lower:]")

if [[ "$platform" = "darwin" ]]; 
then
	printf "\e[33mChecking for brew... on %s\e[0m\n" "$platform";
	if [[ $(brew -v; echo $?) = 127 ]]; then 
	 printf "\e[31mHOMEBREW IS NOT INSTALLED!\e[0m\n\e[33mDo you want to install it? [y/N] \e[0m\e[34m "
	 read -r ans; printf "\e[0m"
	 if [[ "${ans}" = [Yy]* ]]; then
	  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	 fi
	else
	 printf "\e[32mHOMEBREW IS ALREADY INSTALLED!\e[0m\n\e[33mInitiating brew bundle (may require sudo).\e[0m\n"
	 load_viz brew bundle
	fi 
elif [[ "$platform" = ["gnu""linux"]*["gnu""linux"] ]]; 
then
	printf "\e[34mNo implementation here yet.\e[0m\n";
else
	printf "\e[31m%s is not supported.\e[0m\n" "$platform";
fi

# ...

unset load_viz platform; exit;
