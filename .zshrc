# --- Starship Prompt ---
eval "$(starship init zsh)"

# --- Zoxide (smarter cd) ---
eval "$(zoxide init zsh)"

# --- fzf (fuzzy finder) ---
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# --- Aliases ---
alias ls='eza --icons'
alias la='eza -a --icons'
alias ll='eza -l --icons'
alias cat='bat --style=plain'
alias update='sudo pacman -Syu'

# --- Keybindings ---
bindkey -e

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS