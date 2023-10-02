# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Functions
wttr() { curl "https://wttr.in/$1"; }
chtsh() { curl "https://cht.sh/$1"; }
mkcd() { mkdir -p "$@" && cd "$_" || return; }
editprofile() { vim ~/.zprofile }
#play_tune() {
# tune=(/var/mp3/tunes/*);
#
# for idx in $(seq $#tune); 
# do
#  [[ $(echo $tune[$idx] | grep "Chime2") ]] && (afplay $tune[$idx] &) > /dev/null 2>&1
# done
#
# unset idx tune;
#}

# Aliases
alias ls="exa --tree -L 1 -lh"
alias cat="bat"
alias clr="clear"
alias tree="exa --tree"
alias nano="nano -l"
alias openvpn="sudo openvpn"
alias keycast="open -a Keycastr"
alias pbclear="pbcopy < /dev/null"
alias bpy-docs="open /opt/homebrew/Caskroom/blender/BPY\ API/index.html"
#alias discord="(/Applications/Discord\ PTB.app/Contents/MacOS/Discord\ PTB &) > /dev/null 2>&1"
