# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
# [Work] Source picnic work file if it exists
if [[ -f ~/.picnicrc ]]; then
  source ~/.picnicrc
fi

alias ll='ls'

resource() {
  source ~/.bashrc
}

json-format() {
  file=${1}
  jq '.' ${file} >${file}.tmp && mv ${file}.tmp ${file}
}

url-encode() {
  jq -rn --arg x "${1}" '$x|@uri'
}

# Function to show git branch in prompt
git_prompt_info() {
  # Get the branch name, redirecting errors if not in a git repo
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  # If a branch name was found, print it in parentheses
  if [[ -n "$branch" ]]; then
    echo "($branch)"
  fi
}

# Set your preferred editor
export VISUAL=nvim
export EDITOR="$VISUAL" # Good practice to set both

# Enable vi-style command-line editing
set -o vi

# Bind 'vv' in vi command mode to edit the current command line
bind -m vi-command '"vv": edit-and-execute-command'

# Setup pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

lazy_nvm_load() {
  # Check if NVM_DIR is set and valid
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    # Unset the temporary alias/function to prevent a loop
    unset -f nvm node npm npx

    # Source the official NVM scripts
    . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  else
    echo "NVM is not installed or NVM_DIR is not set correctly."
    return 1 # Return an error code
  fi
}

# Define the NVM_DIR path beforehand
export NVM_DIR="$HOME/.config/nvm"

# Set up the aliases to trigger lazy loading
nvm() { lazy_nvm_load && nvm "$@"; }
node() { lazy_nvm_load && node "$@"; }
npm() { lazy_nvm_load && npm "$@"; }
npx() { lazy_nvm_load && npx "$@"; }

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
