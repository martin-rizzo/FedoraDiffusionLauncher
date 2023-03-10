<h1 align="center">Fedora Diffussion Webui</h1>
<p align="center">Bash scripts to solve fedora... blah blah blah.</p>
<p align="center">
<img alt="Platform" src="https://img.shields.io/badge/platform-fedora linux-33F">
<img alt="Language" src="https://img.shields.io/badge/language-bash-22E">
<img alt="License"  src="https://img.shields.io/github/license/martin-rizzo/FedoraDiffusionWebui?color=11D">
<img alt="Last"     src="https://img.shields.io/github/last-commit/martin-rizzo/FedoraDiffusionWebui">
</p>
<!--

# Fedora Diffussion Webui -->

This is a project that enables using an application on Linux that only works with Python v3.10 or lower on a version of Fedora Linux that comes with Python v3.11 and downgrading is not possible.

## Installation

To use this application, you need to create a Python virtual environment using v3.10 with the following command:

    python3.10 -m venv virt_env_dir

Then, run the following bash script:

    ./setup.sh

This script takes care of automatically creating the virtual environment and calling the application that needs v3.10.

## Usage

Once the virtual environment is installed and configured, you can use the application as follows:

    python3.10 app.py

## Contributing

If you would like to contribute to this project, please follow these steps:

1. Fork the repository.
2. Create a new branch for your changes.
3. Make the necessary changes in your branch.
4. Submit a pull request to the main branch of the project.

## Credits

This project was developed by [your name here] and is distributed under the [your license here] license.

## Lincense

Copyright (c) 2022 Martin Rizzo  
This project is licensed under the MIT license.  
See the ["LICENSE"](LICENSE) file for details.
