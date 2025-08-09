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

# Set the prompt using BASH's special characters
# \t - Time (HH:MM:SS)
# \[\e[31m\] - Start red color (non-printing)
# \W - Basename of the current directory
# \[\e[0m\] - Reset color (non-printing)
# \$ - Prompt symbol ($ for user, # for root)
PS1='\t \[\e[31m\]\W\[\e[0m\] $(git_prompt_info) \$ '

# Set your preferred editor
export VISUAL=nvim
export EDITOR="$VISUAL" # Good practice to set both

# Enable vi-style command-line editing
set -o vi

# Bind 'vv' in vi command mode to edit the current command line
bind -m vi-command '"vv": edit-and-execute-command'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
