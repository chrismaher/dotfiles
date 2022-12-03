# Environment 
# ------------------------------------------------------------

# Python
export PYTHONPATH="$HOME/bi"

# For pyenv-virtualenv
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# AWS CLI
export PATH=~/.local/bin:$PATH

# Postgres
export PGDATA='/usr/local/var/postgresql@9.6'
export PGHOST=localhost
export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"

# RVM
export PATH="$PATH:$HOME/.rvm/bin"
# Load RVM into a shell session as a function
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Bash prompt
export PS1='\T \w$(__git_ps1 " (%s)") \$ '

# silence 'default interactive shell...' message
export BASH_SILENCE_DEPRECATION_WARNING=1
# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

export EDITOR=/usr/local/bin/vim

# Use vim bindings
set -o vi

export bashrc="$HOME/.bashrc"
export psqlrc="$HOME/.psqlrc"

# Source external settings
source "$HOME/.extras.sh";

# to expand aliases in non-interactive shells:
shopt -s expand_aliases

# git tab completion
if [ -f "$(brew --prefix)"/etc/bash_completion.d/git-completion.bash ]; then
      . "$(brew --prefix)"/etc/bash_completion.d/git-completion.bash
fi
source "$HOME"/.git-prompt.sh

# Aliases
# ------------------------------------------------------------

# dotfile version control
alias cfg="/usr/bin/git --git-dir=${HOME}/.cfg/ --work-tree=${HOME}"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ack="ack --pager='less -R -X'"
alias chx="chmod +x"
alias cp="cp -i"
alias cores="sysctl -n hw.ncpu"
alias diff="/usr/local/Cellar/diffutils/3.7/bin/diff --color -u"
alias lsd="ls -1d */"
alias lsr="ls -ltr"
alias lss="ls -lShr"
alias mv="mv -i"
alias wcl="wc -l"

alias bashrc='vim $HOME/.bashrc'
alias gitconfig='vim $HOME/.gitconfig'
alias psqlrc='vim $HOME/.psqlrc'
alias vimrc='vim $HOME/.vimrc'

# remove __pycache__ directories
alias rmpyc='find . -type d -name '__pycache__' -exec rm -rf {} \;'

# Sandbox virtualenv 
alias venv='source $HOME/venv/bin/activate'

alias vpaste="pbpaste | vim -"

# tmux
alias tat="tmux a -t"
alias tns="tmux new -s"
alias tls="tmux ls"

# macOS sleep setting 
alias sleepon="sudo systemsetup -setcomputersleep 1"
alias sleepoff="sudo systemsetup -setcomputersleep Never"
alias getsleep="sudo systemsetup -getcomputersleep"

alias lower="tr '[:upper:]' '[:lower:]'"
alias upper="tr '[:lower:]' '[:upper:]'"

# Functions
# ------------------------------------------------------------

body () {
    IFS= read -r header
    printf '%s\n' "$header"
    "$@"
}

# recursive search for name containing
findn () { find . -name \*${1}\* ; }

# recursive search for file containing
greprl () { grep -rl "$1" . ; }

# recursive search, filtered by file extention
greprli () { grep -rl --include \*.${1} "$2" . ; }

# recursive search, filtered by file extention
greprlx () { grep -rl --exclude-dir \*.${1} "$2" . ; }

last_command () {
    fc -ln "$1" "$1" | sed '1s/^[[:space:]]*//' | tr -d '\n' | pbcopy
}

# ls "glob" or "grep"
lsg () { ls -dltr *${1}* ; }

mcd () { mkdir -p "$1" && cd "$1" ; }

pasteto () { pbpaste > "$1" ; }

resource () { source "$bashrc" ; }

# show hidden files and directories
show_hidden () { find . -maxdepth 1 -name \.\* -print | sort ; }

targz () { tar -zcvf "${1}.tar.gz" "$1" ; }

untargz () {
    target="${2:-$(pwd)}"
    [ -d "$target" ] || mkdir -p "$target"
    tar -zxvf "$1" -C "$target"
}

body () {
    IFS= read -r header
    printf '%s\n' "$header"
    "$@"
}

@@ () {
    eval "$(echo "!!" | gsed 's/\w*$//')${@}"
}

# LookML utils
sql () {
    gsed '/sql:/,/;;/!d;/;;/q' "$1" | gsed '1d; $d'
}
