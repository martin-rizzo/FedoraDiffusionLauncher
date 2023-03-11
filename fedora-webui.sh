#!/usr/bin/env bash

OLD_PYTHON='python3.10'
VIRT_ENV_DIR='.venv-'$OLD_PYTHON
WEBUI_SH_URL='https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh'

## ANSI CODES ##
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
NC='\033[0m'

function echoex() {
    if [[ $1 == check ]]; then
        echo -e "$GREEN \xE2\x9C\x94 $2$NC"
    elif [[ $1 == error ]]; then
        echo -e "$RED x $2$NC"
    elif [[ $1 == wait ]]; then
        echo -e "$YELLOW - $2...$NC"
    else
        echo -e "$1"
    fi
}

function command_exists() {
    if ! command -v $1 &> /dev/null; then
        echoex error "$1 is not available!"
        echoex "   you can try to install '$1' using the following command:"
        echoex "   > sudo dnf install $1\n"
        exit 1
    else
        echoex check "$1 is installed"
    fi
}

function ensure_virt_env() {
    if [[ ! -d "$VIRT_ENV_DIR" ]]; then
        echoex wait 'creating virtual environment'
        "$OLD_PYTHON" -m venv "$VIRT_ENV_DIR"
        echoex check 'new virtual environment created:'
        echoex  "     $PWD/$VIRT_ENV_DIR"
    else
        echoex check 'virtual environment already exists'
    fi
}

function ensure_download() {
    local local_name=$1 remote_url=$2
    echoex wait 'downloading'
    wget -q --show-progress "$remote_url"
    if [[ ! -f "$local_name" ]]; then
        echo error "can not download $local_name]\n"
        exit 1
    fi
    chmod a+x "$local_name"
    echoex check "$local_name downloaded"
}

command_exists wget
command_exists git
command_exists $OLD_PYTHON
ensure_download webui.sh "$WEBUI_SH_URL"
ensure_virt_env

echoex check "activating virtual environment with $OLD_PYTHON"
source "$VIRT_ENV_DIR/bin/activate"

echoex wait 'launching webui.sh'
python_cmd=$(which python) ./webui.sh

