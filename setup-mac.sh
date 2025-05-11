#!/bin/bash

# Make sure we're running with bash
if [ -z "$BASH_VERSION" ]; then
    echo "This script requires bash. Please run it with bash, not sh."
    echo "Try: bash $(basename "$0")"
    exit 1
fi

# Get the directory of the script
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create an array of source and target pairs for symlinks
# Format: "source_path:target_path"
SYMLINKS=(
    "ideavim/.ideavimrc:$HOME/.ideavimrc"
    "zsh/.zshrc:$HOME/.zshrc"
)

# Determine OS-specific config paths and add them to symlinks
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Check for ghostty's preferred location on macOS
    if [ -d "$HOME/Library/Application Support/org.ghostty" ]; then
        SYMLINKS+=("ghostty:$HOME/Library/Application Support/org.ghostty/config")
    else
        # Fallback to Linux-compatible path
        SYMLINKS+=("ghostty:$HOME/.config/ghostty")
    fi
else
    # Linux paths
    SYMLINKS+=("ghostty:$HOME/.config/ghostty")
fi

# Add nvim symlink (same path on both OS)
SYMLINKS+=("nvim:$HOME/.config/nvim")

# Function to create a symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Check if the source file exists
    if [ ! -e "$source" ]; then
        echo "Source file/directory $(basename "$source") not found in $SOURCE_DIR"
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

# Create symlinks from the array
for symlink in "${SYMLINKS[@]}"; do
    # Split the string at the colon
    source_path="${symlink%%:*}"
    target_path="${symlink#*:}"
    
    create_symlink "$SOURCE_DIR/$source_path" "$target_path"
done

echo "Symlink files created!"

# Check if Homebrew is installed
install_homebrew() {
    echo "Checking for Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [ $? -eq 0 ]; then
            echo "Homebrew installed successfully."
            
            # Add Homebrew to PATH if needed (for M1/M2 Macs)
            if [[ $(uname -m) == 'arm64' ]]; then
                echo "Adding Homebrew to PATH for Apple Silicon..."
                if [[ -f /opt/homebrew/bin/brew ]]; then
                    eval "$(/opt/homebrew/bin/brew shellenv)"
                    # Add to profile for future sessions
                    if ! grep -q "eval \"\$(/opt/homebrew/bin/brew shellenv)\"" ~/.zprofile; then
                        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                    fi
                fi
            fi
            
            return 0
        else
            echo "Failed to install Homebrew."
            return 1
        fi
    else
        echo "Homebrew is already installed."
        return 0
    fi
}

install_homebrew

install_zsh() {
    echo "Installing zsh..."
    if ! command -v zsh &> /dev/null; then
        brew install zsh
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

install_node() {
    echo "Installing Node.js..."
    if command -v node &> /dev/null; then
        echo "Node.js is already installed."
        return 0
    else
        brew install node
        if [ $? -eq 0 ]; then
            echo "Node.js installed successfully."
            return 0
        else
            echo "Failed to install Node.js."
            return 1
        fi
    fi
}

install_node

install_node_packages() {
    echo "Installing node packages..."
    npm install -g \
        typescript \
        prettier \
        @tailwindcss/language-server \
        neovim
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
