export KUBECONFIG="${HOME}/.kube/config"

if [ ! -d "${HOME}/mongo_databases" ]; then 
  # This gets executed only once unless the path doesnt exist.
  export MONGO_DB_ROOT_PATH="${HOME}/mongo_databases"
  mkdir -pv "${MONGO_DB_ROOT_PATH}"
else
  export MONGO_DB_ROOT_PATH="${HOME}/mongo_databases"
fi

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
  if [ -x "$(whereis kubectl | awk '{ print $2 }')" ]; then
    kubectl "${@}";
    return ${?}
  else
    printf "kubectl is not installed\n"
    return 127
  fi
}

tf() {
  if [ -x "$(whereis terraform | awk '{ print $2 }')" ]; then
    terraform "${@}";
    return ${?}
  else
    printf "terraform is not installed\n"
    return 127
  fi
}

url_encode() {
  encoded_str="https://"
  for i in $(seq 0 ${#1}); do
    if [[ "${1:${i}:1}" == [[:alnum:]] ]]; then
      encoded_str="${encoded_str}%$(echo -n "${1:${i}:1}" | xxd -ps | fold -w 2 | tr -d "\n")"
    else
      encoded_str="${encoded_str}${1:${i}:1}"
    fi
  done
  printf "%s\n" "${encoded_str}"
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
  vim "${HOME}/.bash_aliases" && . "${HOME}/.bash_aliases" \
	  && printf "\"%s\", updated and sourced.\n" "$(basename "${HOME}/.bash_aliases")"; 

  return $?
}

vim() { 
  if [ -x "$(whereis nvim | awk '{ print $2 }')" ]; then
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

gh_switch_user() {
  if [ "isaacalao" = "$(gh auth status -a | grep --color=none -o isaacalao)" ]; then
    cat "${HOME}/.gitconfigs/secondary" > "${HOME}/.gitconfig" 
  else 
    cat "${HOME}/.gitconfigs/primary" > "${HOME}/.gitconfig" 
  fi

  gh auth switch || return $?
}
