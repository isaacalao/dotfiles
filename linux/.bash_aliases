export KUBECONFIG="${HOME}/.kube/config"

alias kns="k get ns"
alias kctx="kubectx"
alias kconf="k config view"
alias kdbg="k debug"
alias cat="batcat"
alias dirs="dirs -v"
alias tree="exa --tree"
alias ls="exa --tree -L 1"
alias diff="diff --color=always"

k() {
  if [ -e "$(whereis kubectl | awk '{ print $2 }')" ]; then
    kubectl "${@}";
    return ${?}
  else
    printf "kubectl is not installed\n"
    return 127
  fi
}

mkcd() { 
  mkdir -p "$@" && cd "${_}" || return $? 
}

mknote() {
  local num_line=1
  printf "Press ctrl-d to exit.\nNOTE:\n"
  printf "%s" "${num_line} " 
  while read -r line; do
    num_line=$((num_line+1))
    printf "%s" "${num_line} " 
    if [ ${#@} -gt 0 ]; then
      printf "%s" "${line}\n" >> "${1}" 
    fi
  done
}

wttr() { 
  curl -s "https://wttr.in/${1}"; return $? 
}

chtsh() { 
  IFS="/"; curl -s "https://cht.sh/${*}"; return $? 
}

editalias() { 
  vim "$HOME/.bash_aliases" && . "$HOME/.bash_aliases" \
	  && printf "\"%s\", updated and sourced.\n" "$(basename "${HOME}/.bash_aliases")"; 

  return $?
}

vim() { 
  if [ -e "$(which nvim)" ]; then
    if [ ${#@} -gt 0 ]; then
      nvim "${@}"
    else
      nvim "${PWD}"
    fi
    return ${?}
  else
    printf "nvim is not installed\n"
    return 127
  fi
}
