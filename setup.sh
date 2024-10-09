#!/bin/bash

# Define the files to symlink
declare -A files=(
    ["ideavim/.ideavimrc"]="$HOME/.ideavimrc"
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

# Create symlinks for each file
for file in "${!files[@]}"; do
    source="$SOURCE_DIR/$file"
    target="${files[$file]}"
    create_symlink "$source" "$target"
done

echo "Dotfiles setup complete!"

