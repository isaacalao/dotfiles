#!/bin/env bash

# USAGE: Automate the installation of my environment on supported platforms

# REFERENCE: https://www.shellcheck.net/

# MISC
printf "████████████████████\n" >> setuplog.txt; # Distinguish each setup instance

# GLOBAL VARIABLES
OSTYPE=$(uname | tr "[:upper:]" "[:lower:]");
ARCH=$(uname -p | tr "[:upper:]" "[:lower:]");
DISTRO=

# FUNCTIONS
ask_prompt() { # Usage: prompt user, read input, if input matches glob patterns then yield 0:success, if not 1:failure
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

load_viz() { # Should only be used for commands that do not expend too much time and require sudo
	("$@" >> setuplog.txt 2>&1;) & # Run a command in a subshell in the background and redirect stdout/err to setuplog
	pidn="$!";                     # Acquire the process id number
	
	if [[ "$#" -gt 0 ]]; then
		loadchar=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" "▇" "▆" "▅" "▄" "▃" "▁")
		for (( i=1; ;i++ )); do
			sleep 0.1;
			printf "\t\e[33mWaiting on %s %s\e[0m\r" "$1" "${loadchar[$((i % ${#loadchar[@]}))]}";
			[[ "$i" == "${#loadchar}" ]] && i=1;
			ps -p "$pidn" -o pid= > /dev/null 2>&1; # Check if process exists 
			[[ "$?" = 1 ]] && printf "\t\e[0K\e[33mFinished \e[0m\e[32m✓\e[0m\r\n" && break;
		done
	else
		printf "Usage: load_viz <command> [...]\n\tload_viz echo Hi\n";
	fi
 return 0;
}

init_brew() {
	printf "\e[33mChecking for brew on %s-%s [%s].\e[0m\n" "$DISTRO" "$OSTYPE" "$ARCH";
	
	if ! brew --version >> setuplog.txt 2>&1; then # Redirect stdout/err to setuplog while checking
		
		printf "\e[31mHOMEBREW IS NOT INSTALLED!\e[0m\n"
		if ask_prompt "Do you want to install it?"; then
			
			if [[ "$OSTYPE" = "darwin" && "$ARCH" = "arm" ]]; then # OSX M1/2
              		  
			  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
			  printf "\e[33mAdding Homebrew to your PATH:\e[0m\n"
			  echo "eval $(/opt/homebrew/bin/brew shellenv)" >> "$HOME"/.zprofile;
    		  	  eval "$(/opt/homebrew/bin/brew shellenv)";
			  . "$HOME"/.zprofile;
			elif [[ "$OSTYPE" = ["gnu""linux"]*["gnu""linux"] ]]; then # Linux x86_64

			 printf "\e[33mInstalling build tools (requires sudo).\e[0m\n"
			 if [[ "$DISTRO" = ["rhel""fedora"]* ]]; then
			  # <wip: 1>
			  sudo yum groupinstall 'Development Tools'
			  sudo yum install procps-ng curl file git
			 elif [[ "$DISTRO" = ["kali""ubuntu""debian"]* ]]; then
			  sudo apt-get update;  # update and upgrade (typically for fresh installs)
			  sudo apt-get upgrade; # apt (newer) | apt-get (older)
			  sudo apt-get install build-essential procps curl file git;
			 fi
			 
			 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";

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
		printf "\e[32mHOMEBREW IS ALREADY INSTALLED!\e[0m\n"
	fi
	
	ask_prompt "Do you want to initiate brew bundle (may require sudo)?" && brew bundle;
	ask_prompt "Do you want to remove setuplog?" && printf "\e[33mremoved\e[0m: %s\n" "$(rm -v ./setuplog.txt)";
  
 return 0;
}

# OSTYPE CHECK
# load_viz sleep 4;
# load_viz dd if=/dev/random iflag=fullblock bs=1G count=1 of=rand.txt;

if [[ "$OSTYPE" = "darwin" ]]; then
	init_brew;
elif [[ "$OSTYPE" = ["gnu""linux"]*["gnu""linux"] ]]; then
	DISTRO="$(cat < /etc/os-release | grep -w ID | cut -d "=" -f 2 | cut -d "\"" -f 2)"
	printf "\e[34mImplementation here is WIP.\e[0m\n";
	init_brew;
else
	printf "\e[31m%s is not supported.\e[0m\n" "$OSTYPE";
fi

# ...

unset OSTYPE ARCH DISTRO;
unset -f ask_prompt load_viz init_brew;

exit 0;
