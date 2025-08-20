TERM=xterm-256color

export GOPATH=$HOME/go

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/Apps:/var/lib/flatpak/exports/bin:/opt/nvim/:$GOPATH/bin:/home/huijiro/.dotnet/tools:$PATH

export EDITOR="nvim"

# External exports file
if [[ -r $HOME/.zshexports ]]; then
  source $HOME/.zshexports
fi

# User configuration

# fnm
FNM_PATH="/home/huijiro/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

eval "$(fnm env --use-on-cd)"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Load completions
autoload -U compinit && compinit

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  nvm
  zsh-autosuggestions
)

bindkey -v 

# History - Enhanced for better searching
HISTSIZE=50000              # Increased history size
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_reduce_blanks    # Remove extra whitespace
setopt hist_verify          # Show command before executing from history
setopt inc_append_history   # Add commands immediately, not on exit

# Make completion non case sensitive
zstyle ':autocomplete:*' default-context history-incremental-search-backward

# Turso
export PATH="/home/huijiro/.turso:$PATH"

eval "$(starship init zsh)"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/huijiro/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/home/huijiro/.bun/_bun" ] && source "/home/huijiro/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PATH:/home/huijiro/.local/bin"

# FZF Configuration for command history
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border --margin=1 --padding=1"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo {} | wl-copy)+abort' --header 'Press ? to toggle preview, Ctrl+Y to copy'"

# Enhanced history search function
fzf_history() {
  local selected_command
  selected_command=$(fc -rl 1 | awk '{$1="";print substr($0,2)}' | fzf --query="$LBUFFER" --no-sort --exact)
  
  if [[ -n "$selected_command" ]]; then
    LBUFFER="$selected_command"
  fi
  
  zle reset-prompt
}

# Register the widget and bind to Ctrl+R
zle -N fzf_history
bindkey '^R' fzf_history

# Alternative: show history with timestamps
fzf_history_with_time() {
  local selected_command
  selected_command=$(fc -il 1 | fzf --query="$LBUFFER" --no-sort --exact --with-nth="4.." --preview-window="down:3:wrap" --preview="echo {4..}" | awk '{for(i=4;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/[[:space:]]*$//')
  
  if [[ -n "$selected_command" ]]; then
    LBUFFER="$selected_command"
  fi
  
  zle reset-prompt
}

# Bind to Ctrl+Alt+R for timestamp version
zle -N fzf_history_with_time  
bindkey '^[^R' fzf_history_with_time

# Function to search history across all tmux sessions
fzf_global_history() {
  local selected_command
  # Combine current shell history with tmux capture-pane from all sessions
  {
    fc -rl 1 | awk '{$1="";print substr($0,2)}'
    if command -v tmux &> /dev/null && [[ -n "$TMUX" ]]; then
      tmux list-sessions -F '#S' 2>/dev/null | while read session; do
        tmux list-windows -t "$session" -F '#I' 2>/dev/null | while read window; do
          tmux list-panes -t "$session:$window" -F '#P' 2>/dev/null | while read pane; do
            tmux capture-pane -t "$session:$window.$pane" -p 2>/dev/null | grep -E '^\$' | sed 's/^\$ //'
          done
        done
      done
    fi
  } | sort -u | fzf --query="$LBUFFER" --no-sort --exact

  if [[ -n "$selected_command" ]]; then
    LBUFFER="$selected_command"
  fi
  
  zle reset-prompt
}

# Bind to Ctrl+Shift+R for global search  
zle -N fzf_global_history
bindkey '^[[R' fzf_global_history

# Autosuggestions configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#565f89,bold"  # Match your theme
ZSH_AUTOSUGGEST_STRATEGY=(history completion)      # Use both history and completion
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50                 # Limit buffer size for performance

# Accept autosuggestions with Ctrl+Y (like nvim pickers)
bindkey '^Y' autosuggest-accept

# Additional autosuggestion keybindings
bindkey '^[f' autosuggest-accept                # Alt+F to accept suggestion
bindkey '^[w' autosuggest-execute               # Alt+W to accept and execute
bindkey '^[c' autosuggest-clear                 # Alt+C to clear suggestion

# Additional completion keybindings for consistency
bindkey '^I' expand-or-complete                 # Tab for completion
bindkey '^[[Z' reverse-menu-complete            # Shift+Tab for reverse completion
