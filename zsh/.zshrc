export ZSH="$HOME/.oh-my-zsh"

export PATH="$HOME/.local/bin:$PATH"
export EDITOR="micro"
export FZF_DEFAULT_OPTS="--multi --preview=\"bat --color=always {}\""

if [ -d "$HOME/.local/share/fnm" ]; then
    export FNM_HOME="$HOME/.local/share/fnm"
    export PATH="$FNM_HOME:$PATH"
fi

if [ -d "$HOME/.cargo" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

HIST_STAMPS="dd.mm.yyyy"
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

plugins=(
    history-substring-search
)

source $ZSH/oh-my-zsh.sh

command_exists() {
	command -v "$@" > /dev/null 2>&1 && [ -x "$(command -v $@)" ]
}

eval "$(zoxide init --cmd j zsh)"
eval "$(fzf --zsh)"
command_exists fnm && eval "$(fnm env --use-on-cd)"
command_exists starship && eval "$(starship init zsh)"

autoload -Uz compinit && compinit

if command_exists eza; then
    alias ls="eza --group-directories-first --icons"
    alias ll="ls -la --git"
else
    alias ll="ls -la"
fi
