export TERM="xterm-256color" # avoid issues with some apps in alacritty or ghostty
export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.lmstudio/bin:$PATH"

export LANG=cs_CZ.UTF-8
export LC_ALL=cs_CZ.UTF-8

command_exists() { (( $+commands[$1] || $+functions[$1] )) }

# Syntax highlighting plugin
if [ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" # Linux
fi
if command_exists brew && [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # macOS
fi

if [ -d "$HOME/.cargo" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
    export ZSH="$HOME/.oh-my-zsh"
    HIST_STAMPS="dd.mm.yyyy"
    ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
    ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
    ZOXIDE_CMD_OVERRIDE="j"

    plugins=(
        colored-man-pages
        history-substring-search
        mise
        starship
        zoxide
    )

    source $ZSH/oh-my-zsh.sh
fi

if command_exists nvim; then
    export EDITOR="nvim"
else
    export EDITOR="nano"
fi

if command_exists eza; then
    alias ls="eza --group-directories-first --icons"
    alias ll="ls -lga --git"
else
    alias ll="ls -la"
fi

if command_exists batcat; then
    alias bat="batcat"
fi

alias lzd='lazydocker'
alias lzg='lazygit'

command_exists atuin && eval "$(atuin init zsh)"

if ! command_exists omz; then
    autoload -Uz compinit && compinit
fi
