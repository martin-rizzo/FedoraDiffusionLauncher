#!/usr/bin/env bash
#  Bash script to download and run stable diffusion while
#  resolving compatibility issues between Fedora and
#  AUTOMATIC1111's Stable Diffusion Web UI.
#
#  https://github.com/martin-rizzo/FedoraDiffusionLauncher
#  by Martin Rizzo


# Compatible version of python to use (must be <= 3.10)
COMPATIBLE_PYTHON='python3.10'

# AUTOMATIC1111's repository
SDWEBUI_REPO_URL='https://github.com/AUTOMATIC1111/stable-diffusion-webui.git'
SDWEBUI_REPO_TITLE="AUTOMATIC1111's stable-diffusion-webui"

# Stable Diffusion WebUI local configuration
SDWEBUI_LOCAL_URL='http://127.0.0.1:7860'
SDWEBUI_LOCAL_NAME='stable-diffusion-webui'
VIRT_ENV_NAME='venv'

#---------------------------------- HELPERS ---------------------------------#

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
    elif [[ $1 == warn ]]; then
        echo -e "\033[33m ! $2\033[0m"
    elif [[ $1 == error ]]; then
        echo -e "\033[31m x $2\033[0m"
    elif [[ $1 == wait ]]; then
        echo -e "\033[33m . $2...\033[0m"
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

# Function that checks if a Git repo has been cloned already, and if not, clones it.
# Usage: ensure_cloned <repo_url> <repo_name> <local_dir>
# Arguments:
#   - repo_url : the URL of the Git repository to be cloned.
#   - repo_name: the name of the Git repository to be cloned.
#   - local_dir: the local directory where the repository should be cloned to.
#
function ensure_cloned() {
    local repo_url=$1 repo_name=$2 local_dir=$3
    if [[ ! -d "$local_dir" ]]; then
        echoex wait "cloning remote repository"
        git clone "$repo_url" "$local_dir"
        echoex check "$repo_name repo cloned in:"
        echoex  "     $local_dir"
    else
        echoex check "$repo_name repo already cloned"
    fi
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
    elif [[ ! -e "$venv_dir/bin/$python" ]]; then
        echoex warn "a different version of python was selected ($python)"
        echoex wait "recreating virtual environment"
        rm -Rf "$venv_dir"
        "$python" -m venv "$venv_dir"
        echoex check "virtual environment recreated for $python"
    else
        echoex check 'virtual environment already exists'
    fi
}

# Function that delays the launch of a URL until the URL can be successfully
# connected to.
# Usage: open_url_when_available <url>
# Arguments:
#   - url: the URL to be launched.
#
function open_url_when_available() {
    local url="$1" count=0
    if ! command -v xdg-open &> /dev/null; then
      return
    fi
    while [[ $count -le 15 ]] && ! wget --spider "$url" 2>&1 | grep -q 'connected'
    do
        count=$((count+1))
        sleep 2
    done
    if [[ $count -le 10 ]]; then
        xdg-open "$url"
    fi
}

#================================== START ==================================#

echo
echo 'Fedora Diffusion Launcher'
echo '-------------------------'
ensure_command wget
ensure_command git
ensure_command "$COMPATIBLE_PYTHON"
ensure_cloned  "$SDWEBUI_REPO_URL" "$SDWEBUI_REPO_TITLE" "$PWD/$SDWEBUI_LOCAL_NAME"

ensure_virt_env "$PWD/$VIRT_ENV_NAME" "$COMPATIBLE_PYTHON"
echoex check "activating virtual environment with $COMPATIBLE_PYTHON"
source "$PWD/$VIRT_ENV_NAME/bin/activate"

open_url_when_available "$SDWEBUI_LOCAL_URL" &

echoex wait 'launching webui.sh'
cd "$PWD/$SDWEBUI_LOCAL_NAME"
python_cmd=$(which python) ./webui.sh

