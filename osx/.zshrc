setopt PROMPT_SUBST;

PS1=$'\x1B[37m$(git remote 2> /dev/null)\x1B[0m—\x1B[34m$(__git_ps1 %s)\x1B[0m of \x1B[36m%.\x1B[0m %{%(?:%F{green}%f:%F{red}%f)%} ➫ %j\n\$ '

test -f "$HOME/<script-goes-here>" && . $_ 

source ~/.git-prompt.sh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH=$PATH:/usr/local/mybin:/opt/homebrew/opt/openvpn/sbin:/opt/homebrew/bin/nano
