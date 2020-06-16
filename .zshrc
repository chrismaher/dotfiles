# Environment 
# ------------------------------------------------------------

setopt AUTO_CD

setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS

fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.zsh

setopt prompt_subst
. ~/.git-prompt.sh
export RPROMPT=$'$(__git_ps1 "%s")'

autoload -Uz compinit && compinit

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

# what's the difference from set -o vi?
# bindkey -v

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

PROMPT='%B%* %~%(?.%F{green}.%F{red}) →%b %f'

# function zle-line-init zle-keymap-select {
#     RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
#     RPS2=$RPS1
#     zle reset-prompt
# }
# zle -N zle-line-init
# zle -N zle-keymap-select

export MANPAGER="sh -c 'col -bx | bat -l man -p'"

source "${HOME}/.shrc"

# Aliases 
# ------------------------------------------------------------

alias resource="source ${HOME}/.zshrc"
alias cat='bat'
