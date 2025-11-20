#!/bin/bash

set -e

LOG_FILE="install.log"
echo "===== Installation Log $(date) =====" > "$LOG_FILE"

echo "Updating package lists..."
sudo apt-get update -y

# -----------------------------
# Install Docker
# -----------------------------
if ! command -v docker >/dev/null 2>&1; then
    echo "Docker not found. Installing Docker..."

    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo systemctl enable docker
    sudo systemctl start docker
else
    echo "Docker already installed."
fi

echo -e "Docker:\n$(docker --version)\n" >> "$LOG_FILE"

# -----------------------------
# Install Docker Compose plugin
# -----------------------------
if docker compose version >/dev/null 2>&1; then
    echo "Docker Compose v2 already available."
else
    echo "Docker Compose not available. Installing..."
    sudo apt-get install -y docker-compose-plugin
fi

echo -e "Docker Compose:\n$(docker compose version 2>/dev/null)\n" >> "$LOG_FILE"

# -----------------------------
# Install Python3
# -----------------------------
if ! command -v python3 >/dev/null 2>&1; then
    echo "Python3 not found. Installing..."
    sudo apt-get install -y python3 python3-venv python3-pip
fi

PYTHON_BIN="$(command -v python3)"
echo -e "Python:\n$($PYTHON_BIN --version)\n" >> "$LOG_FILE"

echo "Upgrading pip..."
$PYTHON_BIN -m pip install --upgrade pip

echo -e "PIP:\n$($PYTHON_BIN -m pip --version)\n" >> "$LOG_FILE"

# -----------------------------
# Install Python packages
# -----------------------------
install_pkg() {
    PKG=$1
    if ! $PYTHON_BIN -m pip show "$PKG" >/dev/null 2>&1; then
        echo "$PKG not found. Installing..."
        $PYTHON_BIN -m pip install "$PKG"
    else
        echo "$PKG already installed."
    fi
    $PYTHON_BIN -m pip freeze | grep -i "^$PKG" >> "$LOG_FILE"
}

echo "Python packages:" >> "$LOG_FILE"

install_pkg django
install_pkg torch
install_pkg torchvision
install_pkg pillow

echo "===== Installation completed ====="
echo "All logs saved to $LOG_FILE"
