##### Config #####

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="dieter"

plugins=(git tmux)

source $ZSH/oh-my-zsh.sh
alias tmux="env TERM=xterm-256color tmux -2"

stty -ixon

local pwd="%{$fg[red]%}%c%{$reset_color%}"
PROMPT='${time} ${pwd} $(git_prompt_info)'


export ANDROID_SDK_ROOT=/home/catalin/Android/Sdk

PATH=$PATH:~/.local/bin
PATH=$PATH:~/.poetry/bin


##### Functions #####


resource() {
    source ~/.zshrc
}

ezsh() {
    nvim ~/.zshrc
}

envim() {
    nvim ~/.config/nvim/init.vim
}

config_check() {
    sh ~/Documents/config/scripts/config_check.sh "$@"
}

track() {
    bash "/home/catalin/Documents/projects/p_tracker/scripts/track.sh" "$@"
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


notes() {
    cd ~/vimwiki
    nvim -c 'VimwikiIndex'
}


##### Conda #####


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/catalin/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/catalin/miniconda3/etc/profile.d/conda.sh" ]; then
# . "/home/catalin/anaconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
    else
        export PATH="/home/catalin/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

export BROWSER="/usr/bin/firefox"
