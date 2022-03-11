# something that has to do with anaconda ```````````````
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!

## Use powerline
#USE_POWERLINE="true"
## Source manjaro-zsh-configuration
#if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
#  source /usr/share/zsh/manjaro-zsh-config
#fi
## Use manjaro zsh prompt
#if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
#  source /usr/share/zsh/manjaro-zsh-prompt
#fi



__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
# <<< conda initialize <<<

# ``````````Vim configuration things`````
export vimrc="$HOME/.config/nvim/init.vim"
alias nvim="NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim"
alias vi='nvim'

#alias vim='nvim'
export VISUAL=nvim #use nvim as default editor
export VIMCONFIG=~/.config/nvim #vim configuration directory
export VIMDATA=~/.local/share/nvim # vim data directory (need to learn more about this)
alias van="man -P 'nvim +Man!'" #use vim as man pager
set -o vi #use vi editing mode in the terminal

#settings for cs50
export CC="clang"
export CFLAGS="-fsanitize=signed-integer-overflow -fsanitize=undefined -ggdb3 -O0 -std=c11 -Wall -Werror -Wextra -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable -Wshadow"

export LDLIBS="-lcs50 -lm"

export FLASK_DEBUG=1
export FLASK_APP=application.py
export API_KEY=pk_c16b282717334bbeaae03699c19a03e1

# ````````````` Not sure what these settings are for
export LIBRARY_PATH=/usr/local/lib
export C_INCLUDE_PATH=/usr/local/include
export LD_LIBRARY_PATH=/usr/local/lib
export LDFLAGS="-L/usr/local/opt/sqlite/lib"
export CPPFLAGS="-I/usr/local/opt/sqlite/include"
export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"
# ```````````````Path Settings ``````````````````
#this is supposed to help with doom emacs
#export PATH="/usr/bin:$PATH"
export PATH=$PATH:~/doom-emacs/bin
export PATH=$PATH:"/usr/local/opt/llvm/bin"
#might help for sqlite
export PATH="/usr/local/opt/sqlite/bin:$PATH"
#alacrity colorcheme
export PATH=$PATH:"/Users/jordanmandel/Library/Python/4.8/bin"
export PATH=$PATH:"$HOME/.local/bin"
export PATH="${PATH}:${HOME}/bin"

#history settings
SAVEHIST=100000 #stting the history length
HISTFILE=~/.zhistory
bindkey "^R" history-incremental-pattern-search-backward

# setting some useful environment variables
export todo="$HOME/Documents/diaries/to_do.md"
export diaries="$HOME/Documents/diaries/diaries.md"
export tododir="$HOME/Documents/diaries/"
export thoughts="$HOME/Documents/diaries/thoughts.md"
export memories="$HOME/Documents/diaries/memories.md"
export thoughtsdir="$HOME/Documents/thoughts"
export tokens=$HOME/tokens.txt
export swap="$HOME/.local/share/nvim/swap"
export exercism="$HOME/.local/share/nvim/swap"

#setting purple prompt
#PS1="%B%F{magenta}%n@%m %3~ %#%f%b "
#
PS1="%B%F{magenta}%3~ %#%f%b "

# setting other alases
alias cb=clipboard
alias python='python3'
alias ll='ls -lG'
alias ls='ls -G'
alias pd='pandoc'

defaults write -g InitialKeyRepeat -int 15 #normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

if [[ $TERM == "xterm-kitty" ]]; then
alias ssh="kitty +kitten ssh"
echo "changed ssh for kitty"
fi

mkcd () {
  mkdir "$1" && cd "$1"
}

mkcdp () {
  mkdir -p "$1" && cd "$1"
}

cpc() {
cp basic_headers.cpp $1
}
xset r rate 250 45
echo ".zshrc sourced"

