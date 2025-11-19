#!/bin/bash

LOG_FILE="install.log"
echo "===== Installation Log $(date) =====" > "$LOG_FILE"

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not detected. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed."
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "Docker not found. Installing Docker Desktop..."
    brew install --cask docker
    open --background -a Docker
else
    echo "Docker already installed."
fi

echo -e "Docker:\n$(docker --version)\n" >> $LOG_FILE

if docker compose version >/dev/null 2>&1; then
    echo "Docker Compose (v2) already available."
else
    echo "Docker Compose not found. Installing standalone version..."
    brew install docker-compose
fi

echo -e "Docker Compose:\n$(docker compose version 2>/dev/null || docker-compose --version)\n" >> $LOG_FILE

PYTHON_BIN="$(command -v python3 || true)"

if [ -z "$PYTHON_BIN" ]; then
    echo "Python3 not found. Installing..."
    brew install python
    PYTHON_BIN="$(command -v python3)"
fi

echo -e "Python:\n$(python3 --version|grep Python)\n" >> $LOG_FILE

echo "Creating .venv virtual environment..."
$PYTHON_BIN -m venv .venv

echo "Activating .venv..."
source .venv/bin/activate

PIP_BIN="./.venv/bin/pip"

echo "Upgrading pip..."
$PIP_BIN install --upgrade pip

echo -e "PIP (venv):\n$($PIP_BIN --version)\n" >> $LOG_FILE

install_pkg() {
    PKG=$1
    if ! $PIP_BIN show "$PKG" 2>/dev/null; then
        echo "$PKG not found in .venv. Installing..."
        $PIP_BIN install "$PKG"
    else
        echo "$PKG already installed in .venv."
    fi
    $PIP_BIN freeze|grep "$PKG" >> $LOG_FILE
}

echo "Python packages:" >> $LOG_FILE

install_pkg django
install_pkg torch
install_pkg torchvision
install_pkg pillow
