#!/bin/bash

# Define the files to symlink
declare -A files=(
    ["hyprland"]="$HOME/.config/hypr"
    ["waybar"]="$HOME/.config/waybar"
    ["rofi"]="$HOME/.config/rofi"
)

# Get the directory of the script
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to create a symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Check if the source file exists
    if [ ! -e "$source" ]; then
        echo "Source file $(basename "$source") not found in $SOURCE_DIR"
        return 1
    fi

    # Check if the target directory exists
    local target_dir=$(dirname "$target")
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
        echo "Created directory: $target_dir"
    fi

    # Check if the target already exists
    if [ -e "$target" ]; then
        # If it's already a symlink, remove it
        if [ -L "$target" ]; then
            rm "$target"
        else
            # If it's a regular file, rename it as a backup
            mv "$target" "${target}.backup"
        fi
    fi

    # Create the symlink
    ln -s "$source" "$target"
    echo "Created symlink for $(basename "$source")"
    return 0
}

echo "Creating symlink files..."

# Create symlinks for each file
for file in "${!files[@]}"; do
    source="$SOURCE_DIR/$file"
    target="${files[$file]}"
    create_symlink "$source" "$target"
done

echo "Symlink files created!"

install_hyprland() {
    echo "Installing Hyprland..."
    if ! command -v Hyprland &> /dev/null; then
        sudo dnf install -y hyprland
        if [ $? -eq 0 ]; then
            echo "Hyprland installed successfully."
            return 0
        else
            echo "Failed to install Hyprland."
            return 1
        fi
    else
        echo "Hyprland is already installed."
        return 0
    fi
}

install_hyprland

install_hyprpaper() {
    echo "Installing Hyprpaper..."
    if ! command -v hyprpaper &> /dev/null; then
        sudo dnf install -y hyprpaper
        if [ $? -eq 0 ]; then
            echo "Hyprpaper installed successfully."
            return 0
        else
            echo "Failed to install Hyprpaper."
            return 1
        fi
    else
        echo "Hyprpaper is already installed."
        return 0
    fi
}

install_hyprpaper

install_waybar() {
    echo "Installing Waybar..."
    if ! command -v waybar &> /dev/null; then
        sudo dnf install -y waybar
        if [ $? -eq 0 ]; then
            echo "Waybar installed successfully."
            return 0
        else
            echo "Failed to install Waybar."
            return 1
        fi
    else
        echo "Waybar is already installed."
        return 0
    fi
}

install_waybar

install_pamixer() {
    echo "Installing pamixer..."
    if ! command -v pamixer &> /dev/null; then
        sudo dnf install -y pamixer
        if [ $? -eq 0 ]; then
            echo "pamixer installed successfully."
            return 0
        else
            echo "Failed to install pamixer."
            return 1
        fi
    else
        echo "pamixer is already installed."
        return 0
    fi
}

install_pamixer

install_blueman() {
    echo "Installing blueman..."
    if ! command -v blueman-applet &> /dev/null; then
        sudo dnf install -y blueman
        if [ $? -eq 0 ]; then
            echo "blueman installed successfully."
            return 0
        else
            echo "Failed to install blueman."
            return 1
        fi
    else
        echo "blueman is already installed."
        return 0
    fi
}

install_blueman

install_network_manager_applet() {
    echo "Installing network manager applet..."
    if ! command -v blueman-applet &> /dev/null; then
        sudo dnf install -y blueman
        if [ $? -eq 0 ]; then
            echo "network manager applet installed successfully."
            return 0
        else
            echo "Failed to install network manager applet."
            return 1
        fi
    else
        echo "network manager applet is already installed."
        return 0
    fi
}

install_network_manager_applet

install_rofi() {
    echo "Installing rofi..."
    if ! command -v rofi &> /dev/null; then
        sudo dnf install -y rofi-wayland
        if [ $? -eq 0 ]; then
            echo "rofi installed successfully."
            return 0
        else
            echo "Failed to install rofi."
            return 1
        fi
    else
        echo "rofi is already installed."
        return 0
    fi
}

install_rofi

echo "Hyprland dotfiles setup complete!"

