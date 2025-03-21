#!/usr/bin/env bash
# phase-two.sh - Post-installation configuration for Hyprland dotfiles
# Author : Evrenos

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display status messages
print_status() {
    echo -e "${GREEN}[*]${NC} $1"
}

# Function to display warnings
print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Function to display errors and exit
print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Function to display step messages
print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Function to check file existence before operations
check_file_exists() {
    if [[ ! -f "$1" ]]; then
        print_error "File not found: $1"
    fi
}

# Function to check directory existence before operations
check_dir_exists() {
    if [[ ! -d "$1" ]]; then
        print_error "Directory not found: $1"
    fi
}

# Function to prompt user for confirmation
confirm_step() {
    local prompt="$1"
    local response

    read -p "$prompt (y/n): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Ask if proxychains should be used
if confirm_step "Use proxychains for network operations?"; then
    PROXY="proxychains"
    print_status "Using proxychains for network operations"

    # Check if proxychains is installed
    if ! command -v proxychains &> /dev/null; then
        print_error "Proxychains is not installed. Please install it first."
    fi
else
    PROXY=""
    print_status "Not using proxychains"
fi

# Check if required directories exist
print_step "Checking required directories"
if [[ ! -d "$HOME/Clone/HyDEco" ]]; then
    print_error "HyDEco directory not found. Please run phase-one.sh first."
fi

if [[ ! -d "$HOME/HyDE" ]]; then
    print_error "HyDE directory not found. Please run phase-one.sh first."
fi

# Step 1: Verify needed directories and files exist in HyDEco
print_step "Step 1: Verify needed files and directories in HyDEco"
if confirm_step "Proceed with verifying HyDEco files and directories?"; then
    print_status "Verifying needed directories and files in HyDEco"
    check_dir_exists "$HOME/Clone/HyDEco/Configs"
    check_dir_exists "$HOME/Clone/HyDEco/Configs/.config"
    check_dir_exists "$HOME/Clone/HyDEco/Configs/.config/alacritty"
    check_dir_exists "$HOME/Clone/HyDEco/Configs/.config/cava"
    check_dir_exists "$HOME/Clone/HyDEco/Configs/.config/fastfetch"
    check_dir_exists "$HOME/Clone/HyDEco/Configs/.config/hypr"
    check_dir_exists "$HOME/Clone/HyDEco/Configs/.config/qimgv"
    check_dir_exists "$HOME/Clone/HyDEco/Configs/.config/ghostty"

    check_file_exists "$HOME/Clone/HyDEco/Configs/.config/codium-flags.conf"
    check_file_exists "$HOME/Clone/HyDEco/Configs/.config/starship.toml"
    check_file_exists "$HOME/Clone/HyDEco/Configs/.config/kdeglobals"
    check_file_exists "$HOME/Clone/HyDEco/Configs/.config/waybar/config.jsonc"
    check_file_exists "$HOME/Clone/HyDEco/Configs/.zshrc"
    check_file_exists "$HOME/HyDE/Scripts/post-hyde.sh"
else
    print_status "Skipping file and directory verification"
fi

# Step 2: Remove specific folders and files from ~/.config if they exist
print_step "Step 2: Remove existing configuration folders and files"
if confirm_step "Proceed with removing existing configuration folders and files?"; then
    print_status "Removing existing configuration folders and files"
    rm -rf "$HOME/.config/alacritty" \
           "$HOME/.config/cava" \
           "$HOME/.config/fastfetch" \
           "$HOME/.config/hypr" \
           "$HOME/.config/qimgv" \
           "$HOME/.config/ghostty" \
           "$HOME/.config/codium-flags.conf" \
           "$HOME/.config/starship.toml" \
           "$HOME/.config/waybar/config.jsonc" \
           "$HOME/.config/kdeglobals"
else
    print_status "Skipping removal of existing configuration"
fi

# Create .config directory if it doesn't exist
print_step "Step 3: Create .config directory if needed"
if confirm_step "Proceed with creating .config directory if needed?"; then
    print_status "Creating .config directory if it doesn't exist"
    mkdir -p "$HOME/.config"
else
    print_status "Skipping .config directory creation"
fi

# Step 4: Copy folders and files from ~/Clone/HyDEco/Configs/.config to ~/.config
print_step "Step 4: Copy configuration folders and files from HyDEco"
if confirm_step "Proceed with copying configuration folders and files?"; then
    print_status "Copying configuration folders and files from HyDEco"
    cp -r "$HOME/Clone/HyDEco/Configs/.config/alacritty" \
          "$HOME/Clone/HyDEco/Configs/.config/cava" \
          "$HOME/Clone/HyDEco/Configs/.config/fastfetch" \
          "$HOME/Clone/HyDEco/Configs/.config/hypr" \
          "$HOME/Clone/HyDEco/Configs/.config/qimgv" \
          "$HOME/Clone/HyDEco/Configs/.config/ghostty" \
          "$HOME/.config/" || print_error "Failed to copy configuration directories"

    cp -f "$HOME/Clone/HyDEco/Configs/.config/codium-flags.conf" \
          "$HOME/Clone/HyDEco/Configs/.config/starship.toml" \
          "$HOME/Clone/HyDEco/Configs/.config/kdeglobals" \
          "$HOME/Clone/HyDEco/Configs/.config/waybar/config.jsonc" \
          "$HOME/.config/" || print_error "Failed to copy configuration files"

    # Verify copying was successful
    check_dir_exists "$HOME/.config/alacritty"
    check_dir_exists "$HOME/.config/cava"
    check_dir_exists "$HOME/.config/fastfetch"
    check_dir_exists "$HOME/.config/hypr"
    check_dir_exists "$HOME/.config/qimgv"
    check_dir_exists "$HOME/.config/ghostty"
    check_file_exists "$HOME/.config/codium-flags.conf"
    check_file_exists "$HOME/.config/starship.toml"
    check_file_exists "$HOME/.config/kdeglobals"
    check_file_exists "$HOME/.config/waybar/config.jsonc"
else
    print_status "Skipping configuration copying"
fi

# Step 5: Make post-hyde.sh executable
print_step "Step 5: Make post-hyde.sh executable"
if confirm_step "Proceed with making post-hyde.sh executable?"; then
    print_status "Making post-hyde.sh executable"
    chmod +x "$HOME/HyDE/Scripts/post-hyde.sh" || print_error "Failed to make post-hyde.sh executable"
else
    print_status "Skipping making post-hyde.sh executable"
fi

# Step 6: Run post-hyde.sh
print_step "Step 6: Run post-hyde.sh"
if confirm_step "Proceed with running post-hyde.sh?"; then
    print_status "Running post-hyde.sh"
    cd "$HOME/HyDE/Scripts" || print_error "Failed to change directory to $HOME/HyDE/Scripts"
    if [[ -n "$PROXY" ]]; then
        $PROXY ./post-hyde.sh || print_error "Failed to run post-hyde.sh with proxychains"
    else
        ./post-hyde.sh || print_error "Failed to run post-hyde.sh"
    fi
else
    print_status "Skipping post-hyde.sh execution"
fi

# Step 7: Remove .hyde.zshrc, .zshenv, and .zshrc from $HOME if they exist
print_step "Step 7: Remove existing zsh configuration files"
if confirm_step "Proceed with removing existing zsh configuration files?"; then
    print_status "Removing existing zsh configuration files"
    rm -f "$HOME/.hyde.zshrc" "$HOME/.zshenv" "$HOME/.zshrc"
else
    print_status "Skipping removal of zsh configuration files"
fi

# Step 8: Copy .zshrc from ~/Clone/HyDEco/Configs to $HOME
print_step "Step 8: Copy .zshrc from HyDEco"
if confirm_step "Proceed with copying .zshrc from HyDEco?"; then
    print_status "Copying .zshrc from HyDEco"
    cp -f "$HOME/Clone/HyDEco/Configs/.zshrc" "$HOME/" || print_error "Failed to copy .zshrc"

    # Verify copying was successful
    check_file_exists "$HOME/.zshrc"
else
    print_status "Skipping .zshrc copying"
fi

# Final message
print_status "Configuration complete. Please log out for changes to take effect."
print_status "Enjoy your new Hyprland environment!"