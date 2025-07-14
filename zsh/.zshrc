export LANG="cs_CZ.UTF-8"
export LC_ALL="cs_CZ.UTF-8"

export TERM="xterm-256color" # avoid issues with some apps in alacritty or ghostty
export PATH="$HOME/.local/bin:$PATH"

command_exists() {
	command -v "$@" > /dev/null 2>&1 && [ -x "$(command -v $@)" ]
}

if [ -d "$HOME/.local/share/fnm" ]; then
    export FNM_HOME="$HOME/.local/share/fnm"
    export PATH="$FNM_HOME:$PATH"
fi

if [ -d "$HOME/.cargo" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
    export ZSH="$HOME/.oh-my-zsh"
    HIST_STAMPS="dd.mm.yyyy"
    ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
    ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

    plugins=(
        colored-man-pages
        history-substring-search
    )

    source $ZSH/oh-my-zsh.sh
fi

# Syntax highlighting plugin
if [ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" # Linux
fi
if command_exists brew && [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # macOS
fi

if command_exists micro; then
    export EDITOR="micro"
else
    export EDITOR="nano"
fi

if command_exists eza; then
    alias ls="eza --group-directories-first --icons"
    alias ll="ls -la --git"
else
    alias ll="ls -la"
fi

command_exists zoxide && eval "$(zoxide init --cmd j zsh)"
command_exists fnm && eval "$(fnm env --use-on-cd)"
command_exists fzf && eval "$(fzf --zsh)"
command_exists starship && eval "$(starship init zsh)"

autoload -Uz compinit && compinit

if command_exists tmux && [ -n "$PS1" ] && [ -z "$TMUX" ] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
  tmux new-session -A -s main
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/petr/.lmstudio/bin"
# End of LM Studio CLI section

