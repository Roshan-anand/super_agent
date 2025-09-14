#!/bin/bash

# Agent OS Base Installation Script
# This script installs Agent OS to the current directory

set -e  # Exit on error

# Initialize flags
OVERWRITE_INSTRUCTIONS=false
OVERWRITE_STANDARDS=false
OVERWRITE_CONFIG=false

# Base URL for raw GitHub content
BASE_URL="https://raw.githubusercontent.com/buildermethods/agent-os/main"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --overwrite-instructions)
            OVERWRITE_INSTRUCTIONS=true
            shift
            ;;
        --overwrite-standards)
            OVERWRITE_STANDARDS=true
            shift
            ;;
        --overwrite-config)
            OVERWRITE_CONFIG=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --overwrite-instructions    Overwrite existing instruction files"
            echo "  --overwrite-standards       Overwrite existing standards files"
            echo "  --overwrite-config          Overwrite existing config.yml"
            echo "  -h, --help                  Show this help message"
            echo ""
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

echo ""
echo "🚀 Agent OS Base Installation"
echo "============================="
echo ""

# Set installation directory to current directory
CURRENT_DIR=$(pwd)
INSTALL_DIR="$CURRENT_DIR/.agent-os"

echo "📍 The Agent OS base installation will be installed in the current directory ($CURRENT_DIR)"
echo ""

echo "📁 Creating base directories..."
echo ""
mkdir -p "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR/setup"

# Download functions.sh to its permanent location and source it
echo "📥 Downloading setup functions..."
curl -sSL "${BASE_URL}/setup/functions.sh" -o "$INSTALL_DIR/setup/functions.sh"
source "$INSTALL_DIR/setup/functions.sh"

echo ""
echo "📦 Installing the latest version of Agent OS from the Agent OS GitHub repository..."

# Install /instructions, /standards, and /commands folders and files from GitHub
install_from_github "$INSTALL_DIR" "$OVERWRITE_INSTRUCTIONS" "$OVERWRITE_STANDARDS"

# Download config.yml
echo ""
echo "📥 Downloading configuration..."
download_file "${BASE_URL}/config.yml" \
    "$INSTALL_DIR/config.yml" \
    "$OVERWRITE_CONFIG" \
    "config.yml"

# Download setup/project.sh
echo ""
echo "📥 Downloading project setup script..."
download_file "${BASE_URL}/setup/project.sh" \
    "$INSTALL_DIR/setup/project.sh" \
    "true" \
    "setup/project.sh"
chmod +x "$INSTALL_DIR/setup/project.sh"

# Success message
echo ""
echo "✅ Agent OS base installation has been completed."
echo ""

# Dynamic project installation command
PROJECT_SCRIPT="$INSTALL_DIR/setup/project.sh"
echo "--------------------------------"
echo ""
echo "To install Agent OS in a project, run:"

echo "   cd <project-directory>"
echo "   $PROJECT_SCRIPT"

echo "--------------------------------"

echo "📍 Base installation files installed to:"
echo "   $INSTALL_DIR/instructions/      - Agent OS instructions"
echo "   $INSTALL_DIR/standards/         - Development standards"
echo "   $INSTALL_DIR/commands/          - Command templates"
echo "   $INSTALL_DIR/config.yml         - Configuration"
echo "   $INSTALL_DIR/setup/project.sh   - Project installation script"

echo "--------------------------------"

echo "Next steps:"

echo "1. Customize your standards in $INSTALL_DIR/standards/"

echo "2. Configure project types in $INSTALL_DIR/config.yml"

echo "3. Navigate to a project directory and run: $PROJECT_SCRIPT"

echo "--------------------------------"

echo "Refer to the official Agent OS docs at:"
echo "https://buildermethods.com/agent-os"

echo "Keep building! 🚀"

echo ""
