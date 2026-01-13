# ==========================================
# 1. CORE ANTIDOTE SETTINGS
# ==========================================
ANTIDOTE_DIR="$HOME/.antidote"
if [[ ! -d $ANTIDOTE_DIR ]]; then
  git clone --depth=1 https://github.com/getantidote/antidote.git $ANTIDOTE_DIR
fi

# --- 2. LOAD PLUGINS ---
source $ANTIDOTE_DIR/antidote.zsh
antidote load

# --- 3. KEYBINDINGS & OPTIONS ---
# Fix backspace/delete issues in some terminals
bindkey '^[[3~' delete-char
# Enable history search with arrow keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

setopt no_beep
setopt appendhistory

# ==========================================
# 2. SHELL ENVIRONMENT & HISTORY
# ==========================================
# Use absolute paths for stability in Stow
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Fixes for completions
fpath=($HOME/.zsh-complete $fpath)
autoload -Uz compinit

# ==========================================
# 3. EXTERNAL TOOLS & INITIALIZATION (Evals)
# ==========================================
# Keep evals together at the top to ensure they are available for functions
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(batman --export-env)"
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
eval "$(starship init zsh)"

# FZF initialization
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ==========================================
# 4. PATH MANAGEMENT
# ==========================================

# Standard system paths
export PATH=$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# App specific paths
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.autojump/bin"
# export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"
# export PATH="$PATH:$HOME/.modular/bin"
export PATH="$PATH:/usr/local/cuda/bin"
export PATH="$PATH:$HOME/.opencode/bin"
# export PATH="$PATH:$HOME/Tools/protobuf/bin"

# ==========================================
# 5. HARDWARE & GRAPHICS (SteamVR / CUDA)
# ==========================================
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __NV_PRIME_RENDER_OFFLOAD=1
export __VK_LAYER_NV_optimus=NVIDIA_only
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json
export CUDA_ROOT=/usr/local/cuda
export CUDA_VER=12.8

# Library Paths (LD_LIBRARY_PATH)
export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu:/usr/local/cuda/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$HOME/Tools/TensorRT-10.13.3.9/lib:$LD_LIBRARY_PATH

# ==========================================
# 6. APP SPECIFIC CONFIGS
# ==========================================
export EDITOR='nvim'
export AZURE_DEV_COLLECT_TELEMETRY=no
export FD=/usr/bin/fdfind
export MANPAGER="less -R --use-color -Dd+r -Du+b"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Cargo / Rust
. "$HOME/.cargo/env"

# Atuin / Autojump
. "$HOME/.atuin/bin/env"
[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh

# ==========================================
# 7. SECRETS & ALIASES (The External Files)
# ==========================================
if [ -f ~/.zsh_aliases ]; then . ~/.zsh_aliases; fi
if [ -f ~/.zshrc_secrets ]; then source ~/.zshrc_secrets; fi

# ==========================================
# 8. FUNCTIONS & KEYBINDINGS
# ==========================================

# Pet (Snippet Manager) Functions
function prev() {
  PREV=$(fc -lrn | head -n 1)
  sh -c "pet new `printf %q "$PREV"`"
}
function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
bindkey '^s' pet-select

# Copy Last Path to Clipboard
# Linked to Ctrl+G
copy_last_path_to_clipboard() {
    local previous_command=$(fc -ln -1)
    local last_path=$(echo $previous_command | awk '{for(i=NF; i>0; i--) if ($i ~ /^[~.\/]/) {print $i; exit}}')
    if [[ -n $last_path ]]; then
        last_path=${last_path/#\~/$HOME}
        local resolved_path=$(realpath -m "$last_path" 2>/dev/null || echo "$last_path")
        echo -e "\nCopied: $resolved_path"
        echo -n "$resolved_path" | wl-copy
    fi
    zle -I
}
zle -N copy_last_path_to_clipboard
bindkey '^g' copy_last_path_to_clipboard
