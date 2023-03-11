#!/usr/bin/env bash
#  Bash script to download and run stable diffusion resolving compatibility
#  issues between Fedora and AUTOMATIC1111's Stable Diffusion Web UI.
#  https://github.com/martin-rizzo/FedoraDiffusionLauncher
#  by Martin Rizzo

# Compatible version of python (must be <= 3.10)
COMP_PYTHON='python3.10'
WEBUI_SH_URL='https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh'
VIRT_ENV_DIR='.venv-'$COMP_PYTHON


# Function that allows printing messages with different formats.
# Usage: echoex [check|error|wait] <message>
# Arguments:
#   - check: shows the message in green with a checkmark symbol in front.
#   - error: shows the message in red with an X symbol in front.
#   - wait : shows the message in yellow with a dash symbol in front.
#   - message: the message to be displayed.
#
function echoex() {
    if [[ $1 == check ]]; then
        echo -e "\033[32m \xE2\x9C\x94 $2\033[0m"
    elif [[ $1 == error ]]; then
        echo -e "\033[31m x $2\033[0m"
    elif [[ $1 == wait ]]; then
        echo -e "\033[33m - $2...\033[0m"
    else
        echo -e "$1"
    fi
}

# Function that checks whether a given command is available in the system
# and prints an error message with installation instructions if it is not.
# Usage: ensure_command <command>
# Arguments:
#   - command: the name of the command to be checked.
#
function ensure_command() {
    if ! command -v $1 &> /dev/null; then
        echoex error "$1 is not available!"
        echoex "   you can try to install '$1' using the following command:"
        echoex "   > sudo dnf install $1\n"
        exit 1
    else
        echoex check "$1 is installed"
    fi
}

# Function that downloads a file from a remote URL and ensures that
# it is available locally.
# Usage: ensure_download <local_file> <remote_url>
# Arguments:
#   - local_file: the name and path of the file to be saved locally.
#   - remote_url: the URL of the file to be downloaded.
#
function ensure_download() {
    local local_file=$1 remote_url=$2
    if [[ ! -e "$local_file" ]]; then
        echoex wait 'downloading'
        wget -q --show-progress "$remote_url"
        if [[ ! -f "$local_file" ]]; then
            echo error "can not download $local_file\n"
            exit 1
        fi
        echoex check "$local_file downloaded"
    else
        echoex check "$local_file already downloaded"
    fi
    chmod a+x "$local_file"
}

# Function that checks whether a virtual environment exists, and creates
# a new one if it doesn't.
# Usage: ensure_virt_env <venv_dir> <python>
# Arguments:
#   - venv_dir: the path of the virtual environment dir to be checked.
#   - python  : the Python interpreter that will create the v. environment.
#
function ensure_virt_env() {
    local venv_dir=$1 python=$2
    if [[ ! -d "$venv_dir" ]]; then
        echoex wait 'creating virtual environment'
        "$python" -m venv "$venv_dir"
        echoex check 'new virtual environment created:'
        echoex  "     $venv_dir"
    else
        echoex check 'virtual environment already exists'
    fi
}

ensure_command wget
ensure_command git
ensure_command "$COMP_PYTHON"
ensure_download webui.sh "$WEBUI_SH_URL"
ensure_virt_env "$PWD/$VIRT_ENV_DIR" "$COMP_PYTHON"

echoex check "activating virtual environment with $COMP_PYTHON"
source "$VIRT_ENV_DIR/bin/activate"

echoex wait 'launching webui.sh'
python_cmd=$(which python) ./webui.sh

