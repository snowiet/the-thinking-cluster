#!/bin/bash

# Setup script for version-controlled bashrc

# Configuration
PROJECT_ROOT="/mnt/d/documents/the-thinking-cluster"
BASHRC_SOURCE="$PROJECT_ROOT/config/bashrc"
BASHRC_TARGET="$HOME/.bashrc"
BASHRC_LOCAL="$HOME/.bashrc.local"

# Create backup of existing .bashrc if it exists
if [ -f "$BASHRC_TARGET" ]; then
    echo "📦 Creating backup of existing .bashrc..."
    cp "$BASHRC_TARGET" "${BASHRC_TARGET}.backup-$(date +%Y%m%d-%H%M%S)"
fi

# Create local bashrc if it doesn't exist
if [ ! -f "$BASHRC_LOCAL" ]; then
    echo "📝 Creating local bashrc override file..."
    echo "# Local bashrc overrides" > "$BASHRC_LOCAL"
    echo "# Add your machine-specific configurations here" >> "$BASHRC_LOCAL"
    echo "# This file is not version controlled" >> "$BASHRC_LOCAL"
fi

# Create symlink
echo "🔗 Creating symlink for .bashrc..."
ln -sf "$BASHRC_SOURCE" "$BASHRC_TARGET"

echo "✅ Bashrc setup completed!"
echo "📝 Local overrides can be added to: $BASHRC_LOCAL" 