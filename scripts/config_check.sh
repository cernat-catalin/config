REPO_FOLDER=$(cd "$(dirname "${BASH_SOURCE[0]}")" ; cd .. ; pwd -P)
NVIM_FOLDER=$(eval echo "~/.config/nvim")
TMUX_FOLDER=$(eval echo "~")
ZSH_FOLDER=$(eval echo "~")
I3WM_FOLDER=$(eval echo "~/.i3")


CONFIRMED=0
ask_for_confirmation() {
    echo -e "${1}\nConfirm[Yy]: \c"
    read
    if [[ ${REPLY} =~ ^[Yy]$ ]]; then
        CONFIRMED=1
    else
        CONFIRMED=0
    fi
}


INPUT_MESSAGE=""
ask_for_message() {
    echo -e "${1}\c"
    read
    INPUT_MESSAGE=${REPLY}
}


move_from_local_to_repo() {
    echo -e "\nMoving configuration files from local to repository..."

    echo "===== Neovim ===== "
    (set -x; cp -r ${NVIM_FOLDER}/ftplugin ${REPO_FOLDER}/nvim)
    (set -x; cp -r ${NVIM_FOLDER}/spell ${REPO_FOLDER}/nvim)
    (set -x; cp -r ${NVIM_FOLDER}/settings ${REPO_FOLDER}/nvim)
    (set -x; cp -r ${NVIM_FOLDER}/plug-config ${REPO_FOLDER}/nvim)
    (set -x; cp ${NVIM_FOLDER}/init.vim ${REPO_FOLDER}/nvim)

    echo "===== Tmux ====="
    (set -x; cp ${TMUX_FOLDER}/.tmux.conf ${REPO_FOLDER}/tmux)

    echo "===== Zsh ====="
    (set -x; cp ${ZSH_FOLDER}/.zshrc ${REPO_FOLDER}/zsh)

    echo "===== I3WM ====="
    (set -x; cp ${I3WM_FOLDER}/config ${REPO_FOLDER}/i3wm)
}


move_from_repo_to_local() {
    echo -e "\nMoving configuration files from repository to local..."

    echo "===== Neovim ====="
    (set -x; cp -r ${REPO_FOLDER}/nvim/ftplugin ${NVIM_FOLDER})
    (set -x; cp -r ${REPO_FOLDER}/nvim/spell ${NVIM_FOLDER})
    (set -x; cp -r ${REPO_FOLDER}/nvim/settings ${NVIM_FOLDER})
    (set -x; cp -r ${REPO_FOLDER}/nvim/plug-config ${NVIM_FOLDER})
    (set -x; cp ${REPO_FOLDER}/nvim/init.vim ${NVIM_FOLDER})

    echo "===== Tmux ====="
    (set -x; cp ${REPO_FOLDER}/tmux/.tmux.conf ${TMUX_FOLDER})

    echo "===== Zsh ====="
    (set -x; cp ${REPO_FOLDER}/zsh/.zshrc ${ZSH_FOLDER})

    echo "===== I3WM ====="
    (set -x; cp ${REPO_FOLDER}/i3wm/config ${I3WM_FOLDER})
}


diff_local_and_repo() {
    echo -e "\nDoing a diff between local and repository..."

    echo "===== Neovim ===== "
    (set -x; diff ${NVIM_FOLDER}/ftplugin ${REPO_FOLDER}/nvim/ftplugin)
    (set -x; diff ${NVIM_FOLDER}/spell ${REPO_FOLDER}/nvim/spell)
    (set -x; diff ${NVIM_FOLDER}/settings ${REPO_FOLDER}/nvim/settings)
    (set -x; diff ${NVIM_FOLDER}/plug-config ${REPO_FOLDER}/nvim/plug-config)
    (set -x; diff ${NVIM_FOLDER}/init.vim ${REPO_FOLDER}/nvim/init.vim)

    echo "===== Tmux ====="
    (set -x; diff ${TMUX_FOLDER}/.tmux.conf ${REPO_FOLDER}/tmux/.tmux.conf)

    echo "===== Zsh ====="
    (set -x; diff ${ZSH_FOLDER}/.zshrc ${REPO_FOLDER}/zsh/.zshrc)

    echo "===== I3WM ====="
    (set -x; diff ${I3WM_FOLDER}/config ${REPO_FOLDER}/i3wm/config)
}


commit_and_push() {
    echo -e "\nPerforming commit and push in the repository"
    GIT_STATUS_OUTPUT=$(set -x; cd ${REPO_FOLDER}; git status --porcelain)
    if [[ -n ${GIT_STATUS_OUTPUT} ]]; then
        echo "Found changes!"
        ask_for_message "Enter commit message: "
        echo
        (set -x; cd ${REPO_FOLDER}; git add .)
        (set -x; cd ${REPO_FOLDER}; git commit -m "${INPUT_MESSAGE}")
        (set -x; cd ${REPO_FOLDER}; git push)
    else
        echo "There are no changes to commit and push"
    fi
}


if [[ ${1} == "local_to_repo" ]]; then
    echo "Local to repository"
    ask_for_confirmation "\nYou are you sure you want to override repository files with local versions?"
    if [[ ${CONFIRMED} == 1 ]]; then
        move_from_local_to_repo

    ask_for_confirmation "\nDo you and to also commit and push the changes?"
    if [[ ${CONFIRMED} == 1 ]]; then
        commit_and_push
    else
        echo -e "\nDid not commit and push!"
    fi
    echo -e "\nDone!"

    else
        echo -e "\nAborting..."
    fi
elif [[ ${1} == "repo_to_local" ]]; then
    echo "Repository to local"
    ask_for_confirmation "\nYou are you sure you want to override local files with repository versions?"
    if [[ ${CONFIRMED} ]]; then
        move_from_repo_to_local
        echo -e "\nDone!"
    else
        echo -e "\nAborting..."
    fi
elif [[ ${1} == "diff" ]]; then
    diff_local_and_repo
else
    echo -e "Invalid option provided. Valid options:\n\
        * 'local_to_repo' - move files from local to repository\n\
        * 'repo_to_local' - move files from repository to local\n\
        * 'diff' - do a diff between local and repository"
fi
