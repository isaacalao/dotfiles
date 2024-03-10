#!/bin/env bash

# DESCRIPTION: Automate the installation of my environment on supported platforms
# https://www.shellcheck.net/

# MISC
printf "████████████████████ %s\n" "$(date)" >> setuplog.txt; # Distinguish each setup instance

# GLOBAL VARIABLES
OSTYPE=$(uname | tr "[:upper:]" "[:lower:]");
ARCH=$(uname -p | tr "[:upper:]" "[:lower:]");
DISTRO=

# FUNCTIONS
# Usage: prompt user, read input, if input matches glob patterns then yield 0 if not then 1 
ask_prompt() {
    unset ans;

    while [ -z "$ans" ]; do
	printf "\e[33m%s [y/N]\e[0m\e[34m " "$1";
	read -n 1 -r ans;
	if [[ ! $ans = "" ]]; then # Reset and mv cursor to the beginning of the line up 1
	    printf "\e[0m\n";
	else
	    printf "\e[0m\r\e[1A";
	fi 
    done

    [[ "$ans" = [Yy]* ]] && return 0 || return 1;
}

# Loading visualizer 
load_viz() {     
    [ "$#" -eq  0 ] && printf "$# args provided!\n" && return 1;
    ("$@" >> setuplog.txt 2>&1;)& # Bg subshell
    pidn="$!"; # Acquire the process number
	
    if [[ "$#" -gt 0 ]]; then
	loadchar=("/" "-" "\\" "|");
	viz_flag=0; i=0; j=0;
	printf "\e[?1049h\e[?25l"
	stty -echo

	for (( ;; )) do
	    row=$(($(stty size | awk '{print $1}')));
	    col=$(($(stty size | awk '{print $2}')));
	    
	    printf "\e[48;5;$((235+i))m%${col}s\e[${row};0H%s %s\e[40m\e[0m\r" "" "$1" "${loadchar[$((j % ${#loadchar[@]}))]}";
	    
	    if [[ $((i)) == 4 || $viz_flag == 1 ]]; then
		if [ $i -gt 0 ]; then
		    viz_flag=1;
		    i=$((i-1)); 
		else 
		    i=0; viz_flag=0;
		fi
	    else
		[ $i -lt 4 ] && i=$((i+1));
	    fi

	    ps -p "$pidn" -o pid= > /dev/null 2>&1; # Check if process exists 
	    [[ "$?" = 1 ]] && printf "\e[0KFinished \e[32m✓\e[0m\r" && sleep .2 && break;
	    j=$((j+1))
	    sleep 0.1;
	done

	stty echo
	printf "\e[?1049l\e[?25h"
    else
	printf "usage: load_viz cmd \x1B[4mcmdarg\x1B[0m \x1B[4m...\x1B[0m\n\tload_viz echo Hi\n";
    fi
    
    return 0;
}

init_brew() {
    printf "\e[33mChecking for brew on %s-%s [%s].\e[0m\n" "$DISTRO" "$OSTYPE" "$ARCH";
	
    if ! brew --version >> setuplog.txt 2>&1; then 
	printf "\e[31mHOMEBREW IS NOT INSTALLED!\e[0m\n";
	if ask_prompt "Do you want to install it?"; then
			
	    if [[ "$OSTYPE" = "darwin" && "$ARCH" = "arm" ]]; then # OSX M1/2
              	/bin/bash -c "$(curl -fsSL https://raw.github.com/Homebrew/install/HEAD/install.sh)";
		printf "\e[33mAdding Homebrew to your PATH:\e[0m\n";
		echo "eval $(/opt/homebrew/bin/brew shellenv)" >> "$HOME"/.zprofile;
    		eval "$(/opt/homebrew/bin/brew shellenv)";
		. "$HOME"/.zprofile;

	    elif [[ "$OSTYPE" = "linux" ]]; then # Linux x86_64
		printf "\e[33mInstalling build tools (requires sudo).\e[0m\n";
		if [[ "$DISTRO" = "rhel" || "$DISTRO" = "fedora" ]]; then
		    # <wip: 1>
		    sudo yum groupinstall 'Development Tools';
		    sudo yum install procps-ng file; 
		elif [[ "$DISTRO" = "kali" || "$DISTRO" = "ubuntu" || $DISTRO = "debian" ]]; then
		    sudo apt-get install build-essential procps file;
		fi
		/bin/bash -c "$(curl -fsSL https://raw.github.com/Homebrew/install/HEAD/install.sh)";
		printf "\e[33mAdding Homebrew to your PATH.\e[0m\n";
		echo "eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> "$HOME"/.bash_profile;
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)";
		. "$HOME"/.bash_profile;
		printf "\e[33mInstalling GCC.\e[0m\n";
		brew install gcc;
	    fi
	else
	    return 0;
	fi
    else
	printf "\e[32mHOMEBREW IS ALREADY INSTALLED!\e[0m\n";
    fi
    
    ask_prompt "Do you want to initiate brew bundle (may require sudo)?" && brew bundle;
    return 0;
}

# OSTYPE ARCH CHECK
# load_viz sleep 4;
# load_viz dd if=/dev/random iflag=fullblock bs=1G count=1 of=rand.txt;

[[ "$ARCH" = "unknown" ]] && ARCH=$(uname -m | tr "[:upper:]" "[:lower:]");

if [[ "$OSTYPE" = "darwin" ]]; then
    init_brew;
elif [[ "$OSTYPE" = "linux" ]]; then
    DISTRO="$(cat < /etc/os-release | grep -w ID | cut -d "=" -f 2 | cut -d "\"" -f 2)";
    [[ "$ARCH" = "x86_64" ]] && init_brew || printf "\e[31m%s-%s [%s] is not supported.\e[0m\n" "$DISTRO" "$OSTYPE" "$ARCH";
else
    printf "\e[31m%s [%s] is not supported.\e[0m\n" "$OSTYPE" "$ARCH";
fi

# ...
ask_prompt "Do you want to remove setuplog?" && printf "\e[33mremoved\e[0m: %s\n" "$(rm -v ./setuplog.txt)";

unset OSTYPE ARCH DISTRO;
unset -f ask_prompt load_viz init_brew;

exit 0; 
