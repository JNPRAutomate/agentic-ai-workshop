#!/bin/bash

# Python 3.10+ and UV Installation Script
# Checks for Python 3.10+ and installs UV package manager
# Author: Claude AI Assistant
# Date: $(date +%Y-%m-%d)

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

# Function to compare version numbers
version_compare() {
    local version1=$1
    local version2=$2
    
    # Convert versions to comparable format (remove dots, pad with zeros)
    local v1=$(echo "$version1" | sed 's/\.//g' | sed 's/^/000/' | sed 's/.*\(...\)$/\1/')
    local v2=$(echo "$version2" | sed 's/\.//g' | sed 's/^/000/' | sed 's/.*\(...\)$/\1/')
    
    if [[ $v1 -ge $v2 ]]; then
        return 0  # version1 >= version2
    else
        return 1  # version1 < version2
    fi
}

# Check if Python3 is installed
check_python3_installed() {
    log_step "Checking if Python 3 is installed..."
    
    if command -v python3 &> /dev/null; then
        PYTHON3_PATH=$(which python3)
        log_success "Python 3 found at: $PYTHON3_PATH"
        return 0
    else
        log_error "Python 3 is not installed"
        return 1
    fi
}

# Check Python3 version
check_python3_version() {
    log_step "Checking Python 3 version..."
    
    # Get Python version
    PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
    REQUIRED_VERSION="3.10.0"
    
    log_info "Detected Python version: $PYTHON_VERSION"
    log_info "Required minimum version: $REQUIRED_VERSION"
    
    # Extract major.minor version for comparison
    PYTHON_MAJOR_MINOR=$(echo "$PYTHON_VERSION" | cut -d'.' -f1-2)
    REQUIRED_MAJOR_MINOR=$(echo "$REQUIRED_VERSION" | cut -d'.' -f1-2)
    
    if version_compare "$PYTHON_MAJOR_MINOR" "$REQUIRED_MAJOR_MINOR"; then
        log_success "Python version $PYTHON_VERSION meets requirement (>= $REQUIRED_VERSION)"
        return 0
    else
        log_error "Python version $PYTHON_VERSION is below required version $REQUIRED_VERSION"
        return 1
    fi
}

# Install Python 3.10+ on Ubuntu
install_python3_ubuntu() {
    log_step "Installing Python 3.10+ on Ubuntu..."
    
    # Update package index
    log_info "Updating package index..."
    sudo apt-get update
    
    # Install Python 3.10+
    log_info "Installing Python 3.10+..."
    sudo apt-get install -y python3 python3-pip python3-venv python3-dev
    
    # Verify installation
    if check_python3_installed && check_python3_version; then
        log_success "Python 3.10+ installation completed"
        return 0
    else
        log_error "Python 3.10+ installation failed"
        return 1
    fi
}

# Offer to install Python if not available or version too old
handle_python_installation() {
    local python_missing=$1
    local version_too_old=$2
    
    if [[ $python_missing -eq 1 ]]; then
        log_warning "Python 3 is not installed on this system"
    elif [[ $version_too_old -eq 1 ]]; then
        log_warning "Python 3 version is too old (< 3.10)"
    fi
    
    echo
    echo -e "${YELLOW}Options:${NC}"
    echo "1. Install/upgrade Python 3.10+ automatically (Ubuntu/Debian)"
    echo "2. Install manually and re-run this script"
    echo "3. Exit"
    echo
    
    read -p "Choose an option (1-3): " -n 1 -r
    echo
    echo
    
    case $REPLY in
        1)
            if [[ -f /etc/debian_version ]] || [[ -f /etc/ubuntu_version ]] || command -v apt-get &> /dev/null; then
                install_python3_ubuntu
                return $?
            else
                log_error "Automatic installation only supported on Ubuntu/Debian systems"
                log_info "Please install Python 3.10+ manually for your distribution"
                return 1
            fi
            ;;
        2)
            log_info "Please install Python 3.10+ manually and re-run this script"
            log_info "For Ubuntu/Debian: sudo apt-get install python3"
            log_info "For other distributions, consult your package manager documentation"
            exit 0
            ;;
        3)
            log_info "Exiting..."
            exit 0
            ;;
        *)
            log_error "Invalid option. Exiting..."
            exit 1
            ;;
    esac
}

# Check if uv is already installed
check_uv_installed() {
    log_step "Checking if uv is already installed..."
    
    if command -v uv &> /dev/null; then
        UV_VERSION=$(uv --version 2>/dev/null | cut -d' ' -f2)
        log_success "uv is already installed (version: $UV_VERSION)"
        
        read -p "Do you want to reinstall/update uv? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            return 1  # Reinstall
        else
            return 0  # Skip installation
        fi
    else
        log_info "uv is not installed"
        return 1  # Install
    fi
}

# Install uv
install_uv() {
    log_step "Installing uv package manager..."
    
    # Check if curl is available
    if ! command -v curl &> /dev/null; then
        log_error "curl is required but not installed"
        log_info "Please install curl first:"
        log_info "  Ubuntu/Debian: sudo apt-get install curl"
        log_info "  CentOS/RHEL: sudo yum install curl"
        exit 1
    fi
    
    log_info "Downloading and executing uv installation script..."
    log_info "Command: curl -LsSf https://astral.sh/uv/install.sh | sh"
    
    # Download and execute the installation script
    if curl -LsSf https://astral.sh/uv/install.sh | sh; then
        log_success "uv installation script executed successfully"
    else
        log_error "uv installation failed"
        return 1
    fi
    
    # Source the shell configuration to make uv available
    if [[ -f "$HOME/.bashrc" ]]; then
        source "$HOME/.bashrc" 2>/dev/null || true
    fi
    
    if [[ -f "$HOME/.zshrc" ]]; then
        source "$HOME/.zshrc" 2>/dev/null || true
    fi
    
    # Add uv to PATH for current session if not already there
    if [[ -d "$HOME/.cargo/bin" ]] && [[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]]; then
        export PATH="$HOME/.cargo/bin:$PATH"
        log_info "Added $HOME/.cargo/bin to PATH for current session"
    fi
}

# Verify uv installation
verify_uv_installation() {
    log_step "Verifying uv installation..."
    
    # Check if uv command is available
    if command -v uv &> /dev/null; then
        UV_VERSION=$(uv --version 2>/dev/null | head -n1)
        UV_PATH=$(which uv)
        log_success "uv is working: $UV_VERSION"
        log_success "uv location: $UV_PATH"
        
        # Test basic uv functionality
        log_info "Testing uv functionality..."
        if uv --help > /dev/null 2>&1; then
            log_success "uv help command works correctly"
            return 0
        else
            log_error "uv help command failed"
            return 1
        fi
    else
        log_error "uv command not found after installation"
        log_warning "You may need to restart your terminal or run: source ~/.bashrc"
        return 1
    fi
}

# Display post-installation information
show_post_install_info() {
    echo
    log_success "Setup completed successfully!"
    echo
    echo -e "${BLUE}========================= INSTALLATION SUMMARY =========================${NC}"
    
    # Python information
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
        PYTHON_PATH=$(which python3)
        echo -e "${GREEN}✓${NC} Python 3: $PYTHON_VERSION (at $PYTHON_PATH)"
    fi
    
    # UV information
    if command -v uv &> /dev/null; then
        UV_VERSION=$(uv --version 2>/dev/null | head -n1)
        UV_PATH=$(which uv)
        echo -e "${GREEN}✓${NC} uv: $UV_VERSION (at $UV_PATH)"
    fi
    
    echo
    echo -e "${BLUE}Usage Examples:${NC}"
    echo -e "• Check Python version: ${GREEN}python3 --version${NC}"
    echo -e "• Check uv version: ${GREEN}uv --version${NC}"
    echo -e "• Create new project: ${GREEN}uv init my-project${NC}"
    echo -e "• Install package: ${GREEN}uv add requests${NC}"
    echo -e "• Run Python script: ${GREEN}uv run script.py${NC}"
    echo
    echo -e "${BLUE}Documentation:${NC}"
    echo -e "• uv documentation: ${GREEN}https://docs.astral.sh/uv/${NC}"
    echo -e "• Python documentation: ${GREEN}https://docs.python.org/3/${NC}"
    echo
    echo -e "${YELLOW}Note:${NC} If uv is not found, restart your terminal or run: ${CYAN}source ~/.bashrc${NC}"
    echo -e "========================================================================"
}

# Main function
main() {
    echo -e "${BLUE}======================================================================${NC}"
    echo -e "${BLUE}              Python 3.10+ and UV Installation Script                ${NC}"
    echo -e "${BLUE}======================================================================${NC}"
    echo
    
    local python_missing=0
    local version_too_old=0
    
    # Check Python 3 installation
    if ! check_python3_installed; then
        python_missing=1
    elif ! check_python3_version; then
        version_too_old=1
    else
        log_success "Python 3.10+ requirement satisfied"
    fi
    
    # Handle Python installation if needed
    if [[ $python_missing -eq 1 ]] || [[ $version_too_old -eq 1 ]]; then
        handle_python_installation $python_missing $version_too_old
    fi
    
    echo
    
    # Check and install uv
    if ! check_uv_installed; then
        install_uv
        verify_uv_installation
    else
        log_success "uv is already available and ready to use"
    fi
    
    # Show completion summary
    show_post_install_info
}

# Error handling
trap 'log_error "Script failed at line $LINENO. Command: $BASH_COMMAND"' ERR

# Run main function
main "$@"
