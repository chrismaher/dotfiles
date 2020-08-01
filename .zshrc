# Environment
# ------------------------------------------------------------

setopt AUTO_CD

setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS

# zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.sh
# fpath=(~/.zsh $fpath)

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    autoload -Uz compinit && compinit
fi

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

# what's the difference from set -o vi?
# bindkey -v

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%b'

setopt PROMPT_SUBST

PROMPT='%B%* %~%(?.%F{green}.%F{red}) →%b %f'
export RPROMPT='%F{6}${vcs_info_msg_0_}'

export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# added by Snowflake SnowSQL installer v1.2
export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH

source "${HOME}/.shrc"

# Aliases
# ------------------------------------------------------------

alias resource="source ${HOME}/.zshrc"
alias cat='bat'

# Functions
# ------------------------------------------------------------

# automatically ls with each cd
autoload -U add-zsh-hook
add-zsh-hook -Uz chpwd (){ ls; }
export PATH="/usr/local/sbin:$PATH"
