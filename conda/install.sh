#!/usr/bin/env bash
#
# bootstrap installs things.

set -e

echo ''

info() {
    printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user() {
    printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success() {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
    echo ''
    exit
}

install_miniconda_linux() {
    if ! type conda &>/dev/null; then
        info "installing miniconda for linux"
        mkdir -p "$HOME/miniconda3"
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $HOME/miniconda3/miniconda.sh
        bash "$HOME/miniconda3/miniconda.sh" -b -u -p "$HOME/miniconda3"
        rm -rf "$HOME/miniconda3/miniconda.sh"
        "$HOME/miniconda3/bin/conda" init bash
        success "installed miniconda on lnux"
    else
        conda_version=$(conda --version)
        info "$conda_version already installed."
    fi
}

install_miniconda_macos_arm64() {
    if ! type conda &>/dev/null; then
        info "installing miniconda for Mac OSX ARM64"
        mkdir -p "$HOME/miniconda3"
        curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -o $HOME/miniconda3/miniconda.sh
        bash "$HOME/miniconda3/miniconda.sh" -b -u -p "$HOME/miniconda3"
        rm -rf "$HOME/miniconda3/miniconda.sh"
        "$HOME/miniconda3/bin/conda" init zsh
        success "installed miniconda on Mac OSX ARM64"
    else
        conda_version=$(conda --version)
        info "$conda_version already installed."
    fi
}

install_miniconda_macos_x86_64() {
    if ! type conda &>/dev/null; then
        info "installing miniconda for Mac OSX X86_64"
        mkdir -p "$HOME/miniconda3"
        curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -o $HOME/miniconda3/miniconda.sh
        bash "$HOME/miniconda3/miniconda.sh" -b -u -p "$HOME/miniconda3"
        rm -rf "$HOME/miniconda3/miniconda.sh"
        "$HOME/miniconda3/bin/conda" init zsh
        success "installed miniconda on Mac OSX X86_64"
    else
        conda_version=$(conda --version)
        info "$conda_version already installed."

    fi
}

install_mamba() {
    if ! type mamba &>/dev/null; then
        info "Installing mamba inside conda base environment"
        source "$HOME/miniconda3/bin/activate"
        "$HOME/miniconda3/bin/conda" install -c conda-forge mamba -y

        if [[ $OSTYPE == "darwin"* ]]; then
            "$HOME/miniconda3/bin/mamba" init zsh
        else
            "$HOME/miniconda3/bin/mamba" init bash
        fi

    else
        mamba_version=$(mamba --version | head -n 1)
        info "$mamba_version already installed."
    fi
}

if [[ $OS == "linux-gpu" ]]; then
    install_miniconda_linux
elif [[ $OS == "Darwin-arm64" ]]; then
    install_miniconda_macos_arm64
elif [[ $OS == "Darwin-x86_64" ]]; then
    install_miniconda_macos_x86_64
else
    echo "Conda install not configured for OS: $OSTYPE"
fi

install_mamba
