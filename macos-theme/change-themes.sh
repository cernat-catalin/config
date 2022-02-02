#!/bin/bash


MODE=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
if [[ ${MODE} == 'Dark' ]]; then
    pipenv run python3 ./nvim-theme-change.py dark
else
    pipenv run python3 ./nvim-theme-change.py light
fi
