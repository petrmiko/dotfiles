export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP="$ZSH/cache/.zcompdump-$(hostname)"

export PATH="$HOME/.local/bin:$PATH"
export EDITOR="micro"

if [ -d "$HOME/.local/share/fnm" ]; then
    export FNM_HOME="$HOME/.local/share/fnm"
    export PATH="$FNM_HOME:$PATH"
fi

ZSH_THEME="agnoster"
HIST_STAMPS="dd.mm.yyyy"
export FZF_DEFAULT_OPTS="--multi --preview=\"bat --color=always {}\""

plugins=(
    history-substring-search
)

source $ZSH/oh-my-zsh.sh

eval "$(zoxide init --cmd j zsh)"
eval "$(fnm env --use-on-cd)"
eval "$(fzf --zsh)"

autoload -U compinit && compinit -u

alias ls="eza --group-directories-first --icons"
alias ll="ls -la --git"
