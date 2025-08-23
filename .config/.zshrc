

# --- Variables & Exports ---
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
export EDITOR="nvim"
export BAT_THEME="Catppuccin Mocha"

# --- Zinit Plugin Manager Setup ---
# Install zinit if it doesn't exist
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source zinit
source "${ZINIT_HOME}/zinit.zsh"

# --- Zsh Completions ---
autoload -U compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
setopt globdots
setopt interactive_comments

# --- Zsh Plugins (Loaded with Zinit) ---
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# --- Zinit Snippets (Pre-configured settings from Oh My Zsh) ---
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found
zinit cdreplay -q

# --- Shell History Settings ---
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=$HISTSIZE
setopt inc_append_history
setopt share_history

# --- Keybindings ---
bindkey -e
bindkey '^W' backward-kill-word # ctrl+backspace
bindkey '^[[H' beginning-of-line # home
bindkey '^[[F' end-of-line     # end
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# --- Custom Prompt ---
unset ZSH_THEME # We are building our own prompt, so disable themes.

function build_prompt() {
  local NEWLINE=$'\n'
  local git_info=""
  if git rev-parse --git-dir &>/dev/null 2>&1; then
    local branch=$(git branch --show-current 2>/dev/null)
    [[ -n $branch ]] && git_info=" %F{#f9e2af}⎇ $branch%f"
  fi
  PROMPT="${NEWLINE}%F{#6c7086}刀 %F{#cdd6f4}$(date +%H:%M) %F{#fab3actory}%2~${git_info} %F{#94e2d5}◈%f "
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd build_prompt

# --- Clean startup message (This works automatically with your username!) ---
NEWLINE=$'\n'
echo -e "${NEWLINE}\033[38;2;148;226;213m◆ welcome back, $(whoami) ◆\033[0m"

# --- Aliases (Your custom shortcuts) ---
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias ls='eza -aH --icons=auto --color=always --group-directories-first'
alias t='eza --tree -al --icons=auto --color=always --level=4 --git-ignore -I ".DS_Store|*.tmp|node_modules"'
alias l='eza -alhH --icons=auto --color=always --time-style=long-iso --git --group-directories-first --sort=modified'
alias vim='nvim'
alias vi='nvim'
alias p='sudo pacman'
alias clip='wl-copy'
alias mkdir='mkdir -p'

# --- Yazi File Manager Integration ---
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# --- Tool Initialization ---
eval "$(zoxide init --cmd cd zsh)"

# --- Bun Runtime (FIXED PATH) ---
# This now correctly uses $HOME to find your bun installation
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# --- Other Path Exports ---
export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:$(go env GOPATH)/bin
