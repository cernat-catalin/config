# TODO Add Documentation
##### Configuration #####

# Uncomment to enable profiling
# And the last line in this file as well
# zmodload zsh/zprof

plugins=(zsh-syntax-highlighting vi-mode)

# Disable underline of zsh-syntax-highlighting
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none


# Check OS type
UNAME_OUTPUT="$(uname -s)"
case "${UNAME_OUTPUT}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    *)          MACHINE="UNKNOWN:${UNAME_OUTPUT}"
esac


# The following line disables oh my zsh updates.
# The start-up time of a shell session is greatly increased as a result.
export DISABLE_AUTO_UPDATE=true
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dieter"
source $ZSH/oh-my-zsh.sh
alias tmux="env TERM=xterm-256color tmux -2"
alias rgf='rg --files | rg'
stty -ixon

export ANDROID_SDK_ROOT=/home/catalin/Android/Sdk
export BROWSER="/usr/bin/firefox"

local pwd="%{$fg[red]%}%c%{$reset_color%}"
PROMPT='${time} ${pwd} $(git_prompt_info)'

PATH=$PATH:~/.local/bin
PATH=$PATH:~/.poetry/bin
PATH=$PATH:~/.cargo/bin
PATH=$PATH:~/.local/share/sofancy
PATH=$PATH:~/projects/zig_binary
PATH=$PATH:~/projects/zls/zig-out/bin


##### Helpers #####

resource() {
    source ~/.zshrc
}

ezsh() {
    nvim ~/.zshrc
}

envim() {
    nvim ~/.config/nvim/init.lua
}

cppr() {
    specific_file=${1}

    if [[ $specific_file != "" && ${specific_file:t:e} == "" ]]; then
        specific_file="${specific_file}.cpp"
    fi

    if [[ $specific_file != "" && -f ${specific_file} ]]; then
        g++ -O3 ${specific_file:t} -o ${specific_file:t:r} && "./${specific_file:t:r}"
        return 0
    else
        echo "No such file: ${specific_file}"
        return 0
    fi

    for file in ./*
    do
        if [[ -f ${file} && ${file:t:e} == "cpp" ]]; then
            g++ -O3 ${file:t} -o ${file:t:r} && "./${file:t:r}"
            return 0
        fi
    done
}

json-format() {
    file=${1}
    jq '.' ${file} > ${file}.tmp && mv ${file}.tmp ${file}
}


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ -f /opt/homebrew/opt/chruby/share/chruby/chruby.sh ]]; then
    source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
fi

[ -f "/Users/catalincernat/.ghcup/env" ] && source "/Users/catalincernat/.ghcup/env" # ghcup-env


# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
export SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_DUPS

# [MAC-M1] Add homebrew binaries to path
if [[ ${MACHINE} == "Mac" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi


# [Work] Source picnic work file if it exists
if [[ -f ~/.picnicrc ]]; then
    source ~/.picnicrc
fi

# Pressing `vv` in normal mode in the terminal
# alows to edit the line in nvim
export VISUAL=nvim
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd "vv" edit-command-line


# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# zprof
