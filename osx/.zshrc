tput reset # Clears last login prompt

source ~/.git-prompt.sh
tune=(/var/mp3/tunes/*);

for idx in $(seq $#tune);
do
 [[ $(echo $tune[$idx] | grep "Chime2") ]] && (afplay $tune[$idx] &) > /dev/null 2>&1
done

unset idx tune;

setopt PROMPT_SUBST;
PS1=$'[%F{116}%.%f]»[%F{195}$(git remote 2> /dev/null)%f⧸%F{112}$(__git_ps1 %s)%f]'
RPROMPT=$'%{%(?:%F{green}%f:%F{red}%f)%} jobs ➫ %j'

wttr() { curl "https://wttr.in/$1"; }
chtsh() { curl "https://cht.sh/$1"; }
mkcd() { mkdir -p "$1" && cd "$1" || return; }

alias ls="exa"
alias cat="bat"
alias clr="clear"
alias tree="exa --tree"
alias nano="nano -l"
alias openvpn="sudo openvpn"
alias keycast="open -a Keycastr"
alias pbclear="pbcopy < /dev/null"
alias bpy-docs="open /opt/homebrew/Caskroom/blender/BPY\ API/index.html"
#alias discord="(/Applications/Discord\ PTB.app/Contents/MacOS/Discord\ PTB &) > /dev/null 2>&1"
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH=$PATH:/usr/local/mybin:/opt/homebrew/opt/openvpn/sbin:/opt/homebrew/bin/nano
