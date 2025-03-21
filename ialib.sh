#!/bin/bash

LOGNAME="logsetup";

ialib::loginstance() {
 printf "████████████████████ %s\n" "$(date)" >> ${LOGNAME};
}

# Usage: Gets the operating system type
ialib::getos() {
  uname | tr "[:upper:]" "[:lower:]";
}

# Usage: Gets the architecture of the processor
ialib::getarch() {
  local arch;
  arch="$(uname -p | tr "[:upper:]" "[:lower:]")"
  if [[ "${arch}" = "unknown" ]]; then
    uname -m | tr "[:upper:]" "[:lower:]";
  else
    printf "%s\n" "${arch}"
  fi
}

# Usage: Gets the distribution type
ialib::getdistro() {
  if [ -f "/etc/os-release" ]; then
    grep -w "ID" "/etc/os-release" | tr -d "A-Z=";
  fi
}

# Usage: Logs command output
#
# Args:
#  cmd, cmd_args? 
#
# Returns: Exit code of command
ialib::logcmd() {
  set -o pipefail;
  local errno;

  printf "\x1B[46;30m CMD \x1B[0m %s\n" "${*:0:2} ...">> "${LOGNAME}"
  
  "${@}" 2>&1 | \
    while read -r line; do
      printf "%s\n" "${line}"
      printf "\x1B[47;30m %s \x1B[0m %s\n" "$(date +%y-%m-%d_%H:%M:%S)" "${line}" >> "${LOGNAME}"
    done;

  errno=${?};

  set +o pipefail;
  return ${errno};
}

# Usage: Logging
#
# Args:
#   type?: (string), output?: (string) 
#
#   Log Types:
#     o or ok is OK
#     e or err is ERROR
#     i or info is INFO
#     w or warn is WARN
#     * (catch all) is NORMAL
#
# Returns: Exit code of previous command
ialib::log() {
  local errno="$?";
  local newline="\n";
  local cosmetic_label;
  local cosmetic_reset="\x1B[0m";

  case "${1}" in
    o|ok)
      cosmetic_label="\x1B[42;30m OK ${cosmetic_reset}"
      ;;
    e|err)
      cosmetic_label="\x1B[41;30m ERR ${cosmetic_reset}"
      ;;
    i|info)
      cosmetic_label="\x1B[44;30m INFO ${cosmetic_reset}"
      ;;
    w|warn)
      cosmetic_label="\x1B[43;30m WARN ${cosmetic_reset}"
      ;;
    p|prompt)
      cosmetic_label="\x1B[47;30m PROMPT ${cosmetic_reset}"
      ;;
    *)
      cosmetic_label="${cosmetic_reset}"
      ;;
  esac;
  
  if [[ "${1}" == "prompt" || "${1}" == "p" ]]; then
    printf "${cosmetic_label} %s" "${@:2}" 
    printf "${cosmetic_label} %s${newline}" "${@:2}" >> "${LOGNAME}";
  else
    printf "${cosmetic_label} %s${newline}" "${@:2}" | tee -a "${LOGNAME}";
  fi

  return ${errno}
}

# Usage: Prompts user, reads input, if input matches glob patterns then yield 0 if not then 1 
ialib::prompt() {
  local ans;
  ialib::log prompt "$1 [y/N] ";
  read -n 1 -r ans;

  if [[ ! $ans = "" ]]; then # Reset and mv cursor to the beginning of the line up 1
    printf "\e[0m\n";
  else
    printf "\e[0m\r\e[1A";
  fi
  
  [[ "$ans" = [Yy]* ]] && return 0 || return 1;
}

# Usage: Creates links to config files
ialib::linkconf() {
  for file in "${1}"/.*zsh*;
  do
    if [ -f "${file}" ]; then
      ialib::prompt "Do you want to create a link for $(basename "${file}")?" && \
      printf "\x1B[47m %6s \x1B[0m %s\n" " " "Linked $(ln -sfv "${file}" "${2}")" | tee -a "${LOGNAME}"
    fi
  done;
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
