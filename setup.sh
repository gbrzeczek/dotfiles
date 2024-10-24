#!/bin/bash

# Define the files to symlink
declare -A files=(
    ["ideavim/.ideavimrc"]="$HOME/.ideavimrc"
    ["alacritty/alacritty.toml"]="$HOME/.config/alacritty/alacritty.toml"
    ["alacritty/catppuccin-mocha.toml"]="$HOME/.config/alacritty/catppuccin-mocha.toml"
    ["nvim"]="$HOME/.config/nvim"
    ["hyprland"]="$HOME/.config/hypr"
    ["waybar"]="$HOME/.config/waybar"
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

install_alacritty() {
    echo "Installing Alacritty..."
    if ! command -v alacritty &> /dev/null; then
        sudo dnf install -y alacritty
        if [ $? -eq 0 ]; then
            echo "Alacritty installed successfully."
            echo "Setting Alacritty as default shell..."
            chsh -s /bin/zsh
            return 0
        else
            echo "Failed to install Alacritty."
            return 1
        fi
    else
        echo "Alacritty is already installed."
        return 0
    fi
}

install_alacritty

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

install_wlogout() {
    echo "Installing wlogout..."
    if ! command -v wlogout &> /dev/null; then
        sudo dnf install -y wlogout
        if [ $? -eq 0 ]; then
            echo "wlogout installed successfully."
            return 0
        else
            echo "Failed to install wlogout."
            return 1
        fi
    else
        echo "wlogout is already installed."
        return 0
    fi
}

install_wlogout

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

install_zsh() {
    echo "Installing zsh..."
    if ! command -v zsh &> /dev/null; then
        sudo dnf install -y zsh
        if [ $? -eq 0 ]; then
            echo "zsh installed successfully."
            return 0
        else
            echo "Failed to install zsh."
            return 1
        fi
    else
        echo "zsh is already installed."
        return 0
    fi
}

install_zsh

install_oh_my_zsh() {
    echo "Installing Oh My Zsh..."
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh is already installed."
        return 0
    else
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        if [ $? -eq 0 ]; then
            echo "Oh My Zsh installed successfully."
            return 0
        else
            echo "Failed to install Oh My Zsh."
            return 1
        fi
    fi
}

install_oh_my_zsh

install_npm() {
    echo "Installing npm..."
    if command -v npm &> /dev/null; then
        echo "npm is already installed."
        return 0
    else
        sudo dnf install -y npm
        if [ $? -eq 0 ]; then
            echo "npm installed successfully."
            return 0
        else
            echo "Failed to install npm."
            return 1
        fi
    fi
}

install_npm

install_node_packages() {
    echo "Installing node packages..."
    sudo npm install -g @angular/language-service typescript typescript-language-server @vue/language-server @vue/typescript-plugin

    if [ $? -eq 0 ]; then
        echo "Node packages installed successfully."
        return 0
    else
        echo "Node package installation failed."
        return 1
    fi
}

install_node_packages

echo "Dotfiles setup complete!"

