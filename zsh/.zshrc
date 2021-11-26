# TODO Add Documentation
##### Configuration #####
zmodload zsh/zprof


UNAME_OUTPUT="$(uname -s)"
case "${UNAME_OUTPUT}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    *)          MACHINE="UNKNOWN:${UNAME_OUTPUT}"
esac


export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dieter"
source $ZSH/oh-my-zsh.sh
alias tmux="env TERM=xterm-256color tmux -2"
stty -ixon

export ANDROID_SDK_ROOT=/home/catalin/Android/Sdk
export BROWSER="/usr/bin/firefox"

local pwd="%{$fg[red]%}%c%{$reset_color%}"
PROMPT='${time} ${pwd} $(git_prompt_info)'

PATH=$PATH:~/.local/bin
PATH=$PATH:~/.poetry/bin
PATH=$PATH:~/.cargo/bin


##### Functions #####


resource() {
    source ~/.zshrc
}

ezsh() {
    nvim ~/.zshrc
}

envim() {
    nvim ~/.config/nvim/init.lua
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


##### Notes #####


notes() {

    if [[ $# -eq 0 ]]; then
        # No parameters passed. Open notes
        cd ~/vimwiki
        nvim -c 'VimwikiIndex'
    elif [[ ${1} == "pull" ]]; then
        cd ~/vimwiki
        git pull
    elif [[ ${1} == "commit" ]]; then
        cd ~/vimwiki
        _notes_commit
    elif [[ ${1} == "push" ]]; then
        _notes_push ${2}
    elif [[ ${1} == "view" ]]; then
        _notes_view
    elif [[ ${1} == "compile" ]]; then
        _notes_compile
    elif [[ ${1} == "watch" ]]; then
        _notes_watch
    else
        echo "Not a valid option"
    fi
}

_notes_commit() {
    cd ~/vimwiki

    commit_message="Notes default commit message"
    if [[ $# == 1 ]]; then
        commit_message="${1}"
    fi

    git add .
    git commit -m "${commit_message}"
}

_notes_push() {
    cd ~/vimwiki

    commit_message="Notes default commit message"
    if [[ $# == 1 ]]; then
        commit_message="${1}"
    fi

    git add .
    git commit -m "${commit_message}"
    git push
}

_notes_compile() {
    PROJECT_DIRECTORY=~/Documents/projects/notes_exporter
    INPUT_DIRECTORY=~/vimwiki
    OUTPUT_DIRECTORY=~/vimwiki_html
    START=`date +%s`

    npm --prefix ${PROJECT_DIRECTORY} run compile:markdown -- --input_directory=${INPUT_DIRECTORY} --output_directory=${OUTPUT_DIRECTORY}

    END=`date +%s`
    RUNTIME=$( echo "$END - $START" | bc -l )
    echo "Converted notes in ${RUNTIME} seconds"
}

_notes_view() {
    INDEX_PAGE=~/vimwiki_html/index.html

    if [[ ${MACHINE} == "Mac" ]]; then
        open ${INDEX_PAGE}
    else
        firefox ${INDEX_PAGE}
    fi
}

_notes_watch() {
    PROJECT_DIRECTORY=~/Documents/projects/notes_exporter
    INPUT_DIRECTORY=~/vimwiki
    OUTPUT_DIRECTORY=~/vimwiki_html
    START=`date +%s`

    npm --prefix ${PROJECT_DIRECTORY} run watch:markdown -- --input_directory=${INPUT_DIRECTORY} --output_directory=${OUTPUT_DIRECTORY}
}


##### Conda #####
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/catalin/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/catalin/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/catalin/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/catalin/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

# If on MacOS (M1) add homebrew binaries to path
if [[ ${MACHINE} == "Mac" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Source picnic work file if it exists
if [[ -f ~/.picnicrc ]]; then
    source ~/.picnicrc
fi
