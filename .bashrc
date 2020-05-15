# Environment 
# ------------------------------------------------------------

# Python
export PYTHONPATH="$HOME/bi"

# For pyenv-virtualenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

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
alias cfg='/usr/bin/git --git-dir=/Users/chrismaher/.cfg/ --work-tree=/Users/chrismaher'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias cores="sysctl -n hw.ncpu"
alias lsd="ls -1d */"
alias lsr="ls -ltr"
alias lsh="ls -lShr"
alias mvi="mv -i"

alias bashrc='vim $HOME/.bashrc'
alias gitconfig='vim $HOME/.gitconfig'
alias psqlrc='vim $HOME/.psqlrc'
alias vimrc='vim $HOME/.vimrc'

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

# paste from system clipboard to file, with "-a" (append) and "-o" (overwrite) switches
pasteto () {
    if [ $# -eq 1 ]; then
        if [ ! -f "$1" ]; then
            pbpaste > "$1"
        else
            echo "$1 already exists. Use switch \"-a\" to append or \"-o" to overwrite""
            exit 1
        fi
    elif [ $# -eq 2 ]; then
        case "$1" in
            "-a")
                pbpaste >> "$2" ;;
            "-o")
                pbpaste > "$2" ;;
        esac
    else
        echo "Could not parse arguments."
        exit 1
    fi
}

resource () { source "$bashrc" ; }

# show hidden files and directories
show_hidden () { find . -maxdepth 1 -name \.\* -print | sort ; }

targz () { tar -zcvf "${1}.tar.gz" "$1" ; }

untargz () {
    target="${2:-$(pwd)}"
    [ -d "$target" ] || mkdir -p "$target"
    tar -zxvf "$1" -C "$target"
}
