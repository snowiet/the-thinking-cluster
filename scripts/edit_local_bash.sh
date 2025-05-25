#!/bin/bash

# Local Bash Editor Script
# Allows editing local bash files within the project structure

# Configuration
PROJECT_ROOT="/mnt/d/documents/the-thinking-cluster"
LOCAL_BASH_DIR="$PROJECT_ROOT/config/local"
LOCAL_BASHRC="$LOCAL_BASH_DIR/bashrc.local"
LOCAL_BASHPROFILE="$LOCAL_BASH_DIR/bash_profile.local"
LOCAL_BASH_ALIASES="$LOCAL_BASH_DIR/bash_aliases.local"

# Create local bash directory if it doesn't exist
mkdir -p "$LOCAL_BASH_DIR"

# Function to create or update local file
setup_local_file() {
    local source_file=$1
    local target_file=$2
    local description=$3

    if [ ! -f "$target_file" ]; then
        echo "📝 Creating $description..."
        echo "# $description" > "$target_file"
        echo "# This file is for local bash customizations" >> "$target_file"
        echo "# It is not version controlled" >> "$target_file"
        echo "" >> "$target_file"
    fi

    # Create symlink if it doesn't exist
    local home_file="$HOME/$(basename "$target_file")"
    if [ ! -L "$home_file" ] || [ ! -e "$home_file" ]; then
        echo "🔗 Creating symlink for $(basename "$home_file")..."
        ln -sf "$target_file" "$home_file"
    fi
}

# Setup local bash files
setup_local_file "$HOME/.bashrc" "$LOCAL_BASHRC" "Local bashrc overrides"
setup_local_file "$HOME/.bash_profile" "$LOCAL_BASHPROFILE" "Local bash profile overrides"
setup_local_file "$HOME/.bash_aliases" "$LOCAL_BASH_ALIASES" "Local bash aliases"

# Add local bash directory to .gitignore if not already there
if ! grep -q "config/local/" "$PROJECT_ROOT/.gitignore" 2>/dev/null; then
    echo "📝 Adding local bash directory to .gitignore..."
    echo "config/local/" >> "$PROJECT_ROOT/.gitignore"
fi

echo "✅ Local bash setup completed!"
echo "📝 You can now edit your local bash files in: $LOCAL_BASH_DIR"
echo "🔗 These files are symlinked to your home directory" 