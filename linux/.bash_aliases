export KUBECONFIG="${HOME}/.kube/config"

if [ ! -d "${HOME}/mongo_databases" ]; then 
  # This gets executed only once unless the path doesnt exist.
  export MONGO_DB_ROOT_PATH="${HOME}/mongo_databases"
  mkdir -pv "${MONGO_DB_ROOT_PATH}"
else
  export MONGO_DB_ROOT_PATH="${HOME}/mongo_databases"
fi

# Aesthetics
case "${1}" in 
  *)
   export ACCENT_COLOR="007afa" # BLUE 
   #export ACCENT_COLOR="8c8c8c" # GRAPHITE
   #export ACCENT_COLOR="a54fa6" # PURPLE
  ;;&
  yabai)
    exit
  ;;
esac

# Aliases
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


mytmux () {
  MY_TMUX_SESSION="💻";
  MY_TMUX_EDITOR_NAME="Neovim "
  MY_TMUX_SPOTIFY="Spotify "
  
  if ! tmux has-session -t "${MY_TMUX_SESSION}" 2> /dev/null; then
    tmux new-session -d -s "${MY_TMUX_SESSION}" -n "${MY_TMUX_EDITOR_NAME}" && \
      tmux send-keys -t "${MY_TMUX_SESSION}:${MY_TMUX_EDITOR_NAME}" "vim -" C-m && \
      tmux split-window -t "${MY_TMUX_SESSION}:${MY_TMUX_EDITOR_NAME}" && \
      tmux send-keys -t "${MY_TMUX_SESSION}:${MY_TMUX_EDITOR_NAME}" "btop" C-m && \
      tmux split-window -h -t "${MY_TMUX_SESSION}:${MY_TMUX_EDITOR_NAME}";
  
    tmux new-window -t "${MY_TMUX_SESSION}" -n "${MY_TMUX_SPOTIFY}" && \
      tmux send-keys -t "${MY_TMUX_SESSION}:${MY_TMUX_SPOTIFY}" "spotify" C-m;
  
    tmux select-window -t "${MY_TMUX_SESSION}:${MY_TMUX_EDITOR_NAME}";
  fi
  
  
  tmux attach-session -t "${MY_TMUX_SESSION}";
}
