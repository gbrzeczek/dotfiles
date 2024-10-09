#!/bin/bash

# Define the files to symlink
declare -A files=(
    ["ideavim/.ideavimrc"]="$HOME/.ideavimrc"
    ["alacritty/alacritty.toml"]="$HOME/.config/alacritty/alacritty.toml"
    ["alacritty/catppuccin-mocha.toml"]="$HOME/.config/alacritty/catppuccin-mocha.toml"
)

# Get the directory of the script
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to create a symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Check if the source file exists
    if [ ! -f "$source" ]; then
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

echo "Dotfiles setup complete!"

