#!/bin/bash

readonly LOGNAME="logsetup";

ialib::loginstance() {
 printf "████████████████████ %s\n" "$(date)" >> ${LOGNAME};
}

# Usage: Logging
#   o or ok is OK
#   e or err is ERROR
#   i or info is INFO
#   w or warn is WARN
#   * or no arg is NORMAL
ialib::log() {
  local cosmetic;
  local cosmetic_reset="\x1B[0m";
# local cosmetic_bold="\x1B[1m";
# local cosmetic_italicize="\x1B[3m";
# local cosmetic_underline="\x1B[4m";

  case "${2}" in
    o|ok)
      cosmetic="\x1B[32m";;
    e|err)
      cosmetic="\x1B[31m";;
    i|info)
      cosmetic="\x1B[34m";;
    w|warn)
      cosmetic="\x1B[33m";;
    *)
      cosmetic="${cosmetic_reset}";;
  esac;

  printf "${cosmetic}%s${cosmetic_reset}\n" "${1}" | tee -a ${LOGNAME};
}

# Usage: Creates links to config files
ialib::linkconf() {
  for file in "${1}"/.*;
  do
    if [ -f "${file}" ]; then
      ln -sfv "${file}" "${2}"
    fi
  done;
}

# Usage: Prompts user, reads input, if input matches glob patterns then yield 0 if not then 1 
ialib::prompt() {
  local ans;
  printf "\e[33m%s [y/N]\e[0m\e[34m " "$1";
  read -n 1 -r ans;

  if [ -z "$ans" ]; then
    if [[ ! $ans = "" ]]; then # Reset and mv cursor to the beginning of the line up 1
      printf "\e[0m\n";
    else
      printf "\e[0m\r\e[1A";
    fi
  fi
  
  [[ "$ans" = [Yy]* ]] && return 0 || return 1;
}

# Usage: Gets the architecture of the processor
ialib::getarch() {
  local arch;
  arch="$(uname -p | tr "[:upper:]" "[:lower:]")"
  if [ "${arch}" = "unknown" ]; then
    uname -m | tr "[:upper:]" "[:lower:]";
  else
    printf "%s\n" "${arch}"
  fi
}

# Usage: Gets the operating system type
ialib::getos() {
  uname | tr "[:upper:]" "[:lower:]";
}

# load_viz() {     
#   [ "$#" -eq  0 ] && printf "%s" "$# args provided!\n" && return 1;
#   ( "${@}" >> /dev/null 2>&1 )& # Bg subshell
#   global_pidn="$!"; # Acquire the process number
# 
#   if [[ "$#" -gt 0 ]]; then
#     loadchar=("/" "-" "\\" "|");
#     viz_flag=0; i=0; j=0;
#     row=$(($(stty size | awk '{print $1}')));
#     printf "\e[?1049h\e[0m\e[2J\e[%s;0H\e[?25l" "${row}"
#     stty -echo
#     
#     while true; do
#       row=$(($(stty size | awk '{print $1}')));
#       col=$(($(stty size | awk '{print $2}')));
#         
#       printf "\e[2J\e[48;5;$((235+i))m%${col}s\e[${row};0H%s %s\e[40m\e[0m\r" ""\
#           "$1" "${loadchar[$((j % ${#loadchar[@]}))]}";
#         
#       if [[ $((i)) == 4 || $viz_flag == 1 ]]; then
#         if [ $i -gt 0 ]; then
#           viz_flag=1;
#           i=$((i-1)); 
#         else 
#           i=0; viz_flag=0;
#         fi
#       else
#         [ $i -lt 4 ] && i=$((i+1));
#       fi
#     
#       ps -p "${global_pidn}" -o pid= > /dev/null 2>&1; # Check if process exists 
# 
#       [[ "$?" = 1 ]] && printf "\e[0KFinished \e[32m✓\e[0m\r" &&\
#         sleep .2 && break;
# 
#       j=$((j+1));
#       sleep 0.1;
#     done
#     
#     stty echo
#     printf "\e[?1049l\e[?25h"
#   else
#     printf "usage: load_viz cmd \x1B[4mcmdarg\x1B[0m \x1B[4m...\x1B[0m\n\tload_viz echo Hi\n";
#   fi
#   
#   return 0;
# }
# load_viz $@;
# load_viz dd if=/dev/random iflag=fullblock bs=1G count=1 of=rand.txt;
