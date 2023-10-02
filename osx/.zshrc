setopt PROMPT_SUBST;
PS1=$'[%F{116}%.%f]»[%F{195}$(git remote 2> /dev/null)%f⧸%F{112}$(__git_ps1 %s)%f]'
RPROMPT=$'%{%(?:%F{green}%f:%F{red}%f)%} jobs ➫ %j'

test -f "$HOME/<script-goes-here>" && . $_ 

source ~/.git-prompt.sh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH=$PATH:/usr/local/mybin:/opt/homebrew/opt/openvpn/sbin:/opt/homebrew/bin/nano
