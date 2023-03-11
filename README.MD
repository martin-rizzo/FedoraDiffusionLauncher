<h1 align="center">Fedora Diffusion Launcher</h1>
<p align="center">Script to resolve compatibility issues between Fedora and AUTOMATIC1111's Stable Diffusion Web UI.</p>
<p align="center">
<img alt="Platform" src="https://img.shields.io/badge/platform-fedora linux-33F">
<img alt="Language" src="https://img.shields.io/badge/language-bash-22E">
<img alt="License"  src="https://img.shields.io/github/license/martin-rizzo/FedoraDiffusionLauncher?color=11D">
<img alt="Last"     src="https://img.shields.io/github/last-commit/martin-rizzo/FedoraDiffusionLauncher">
</p>

<!---
# Fedora Diffusion Launcher
-->

This Bash script primarily addresses the compatibility issue between PyTorch
and Python v3.11 that arises during the installation of 'webui.sh'. The
incompatibility issue is indicated on the screen with the following error
message:

      ERROR: Could not find a version that satisfies the requirement torchvision==0.14.1+cu117
      (from versions: 0.1.6, 0.1.7, 0.1.8, 0.1.9, 0.2.0, 0.2.1, 0.2.2, 0.2.2.post2, 0.2.2.post3)**  
      ERROR: No matching distribution found for torchvision==0.14.1+cu117**

Additionally, the script includes some basic checks and tips during the
installation process to avoid common issues.

## What is the compatibility issue about?

This issue arises because the version of PyTorch being used does not support
Python versions higher than v3.10. Fedora 37 includes a newer version that is
incompatible, and there is no easy way to downgrade it.

This script generates a virtual environment using "Python3.10", downloads
"webui.sh" from AUTOMATIC1111's official repository, and executes it within
the virtual environment.

The script attempts to automate this process as much as possible. However,
if any human intervention is necessary, it displays easily understandable
messages.

## Development status

The script is currently in an experimental phase, and while there is a
functional version available, I am still working on making adjustments
and improvements.

Please note that using this version in production or critical environments is
not recommended, as there may be limitations and errors that I need to resolve.

Thank you for your understanding and support.

## Usage

Use this script for both the initial installation and each subsequent attempt
to launch Stable Diffusion Web UI (at least until PyTorch becomes compatible
with the version of Python included in Fedora).

To perform the initial installation, run the following commands,
replacing \<your-directory\> with a directory name of your choice:

    mkdir <your-directory>
    cd <your-directory>
    git clone https://github.com/martin-rizzo/FedoraDiffusionLauncher.git .
    ./sdlauncher.sh
    
    ### Note that the last parameter of the git clone command is a dot . ###

Once Stable Diffusion Web UI is installed, to launch it again, navigate to the
installation directory and run the script:

    cd <your-directory>
    ./sdlauncher.sh

## Lincense

Copyright (c) 2023 Martin Rizzo  
This project is licensed under the MIT license.  
See the ["LICENSE"](LICENSE) file for details.
