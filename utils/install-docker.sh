#!/bin/bash

# Docker Installation Script for Ubuntu 22.04 LTS
# Based on official Docker documentation: https://docs.docker.com/engine/install/ubuntu/
# Author: Claude AI Assistant
# Date: $(date +%Y-%m-%d)

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_warning "This script should not be run as root. Please run as a regular user with sudo privileges."
        read -p "Do you want to continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Check Ubuntu version
check_ubuntu_version() {
    log_info "Checking Ubuntu version..."
    
    if [[ ! -f /etc/os-release ]]; then
        log_error "Cannot determine OS version. /etc/os-release not found."
        exit 1
    fi
    
    source /etc/os-release
    
    if [[ "$ID" != "ubuntu" ]]; then
        log_error "This script is designed for Ubuntu. Detected OS: $ID"
        exit 1
    fi
    
    case "$VERSION_ID" in
        "22.04")
            log_success "Ubuntu 22.04 LTS (Jammy) detected - supported version"
            ;;
        "24.04"|"24.10")
            log_success "Ubuntu $VERSION_ID detected - supported version"
            ;;
        *)
            log_warning "Ubuntu $VERSION_ID detected. This script is optimized for Ubuntu 22.04, but may work."
            read -p "Do you want to continue? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
            ;;
    esac
}

# Check system architecture
check_architecture() {
    log_info "Checking system architecture..."
    ARCH=$(dpkg --print-architecture)
    
    case "$ARCH" in
        amd64|armhf|arm64|s390x|ppc64el)
            log_success "Architecture $ARCH is supported"
            ;;
        *)
            log_error "Unsupported architecture: $ARCH"
            log_error "Docker supports: amd64, armhf, arm64, s390x, ppc64el"
            exit 1
            ;;
    esac
}

# Uninstall conflicting packages
uninstall_conflicting_packages() {
    log_info "Removing conflicting packages..."
    
    local packages=(
        "docker.io"
        "docker-doc" 
        "docker-compose"
        "docker-compose-v2"
        "podman-docker"
        "containerd"
        "runc"
    )
    
    for pkg in "${packages[@]}"; do
        if dpkg -l | grep -q "^ii.*$pkg "; then
            log_info "Removing $pkg..."
            sudo apt-get remove -y "$pkg" || log_warning "Failed to remove $pkg (may not be installed)"
        fi
    done
    
    log_success "Conflicting packages removal completed"
}

# Update package index
update_package_index() {
    log_info "Updating package index..."
    sudo apt-get update
    log_success "Package index updated"
}

# Install prerequisites
install_prerequisites() {
    log_info "Installing prerequisites..."
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    log_success "Prerequisites installed"
}

# Set up Docker repository
setup_docker_repository() {
    log_info "Setting up Docker repository..."
    
    # Create keyrings directory
    sudo install -m 0755 -d /etc/apt/keyrings
    
    # Add Docker's official GPG key
    log_info "Adding Docker's GPG key..."
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    # Add the repository to Apt sources
    log_info "Adding Docker repository..."
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package index with new repository
    sudo apt-get update
    
    log_success "Docker repository setup completed"
}

# Install Docker Engine
install_docker() {
    log_info "Installing Docker Engine and components..."
    
    # Install Docker packages
    sudo apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
    
    log_success "Docker Engine installation completed"
}

# Start and enable Docker service
start_docker_service() {
    log_info "Starting and enabling Docker service..."
    
    sudo systemctl start docker
    sudo systemctl enable docker
    
    log_success "Docker service started and enabled"
}

# Verify Docker installation
verify_installation() {
    log_info "Verifying Docker installation..."
    
    # Check Docker version
    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version)
        log_success "Docker installed: $DOCKER_VERSION"
    else
        log_error "Docker command not found"
        return 1
    fi
    
    # Test Docker with hello-world
    log_info "Testing Docker with hello-world container..."
    if sudo docker run --rm hello-world > /dev/null 2>&1; then
        log_success "Docker is working correctly!"
    else
        log_error "Docker test failed"
        return 1
    fi
}

# Configure Docker for non-root user
configure_non_root_access() {
    log_info "Configuring Docker for non-root user access..."
    
    # Add current user to docker group
    sudo usermod -aG docker "$USER"
    
    log_success "User $USER added to docker group"
    log_warning "You need to log out and log back in (or restart) for group changes to take effect"
    log_info "Alternatively, run: newgrp docker"
}

# Display post-installation information
show_post_install_info() {
    echo
    log_success "Docker installation completed successfully!"
    echo
    echo -e "${BLUE}========================= POST-INSTALLATION NOTES =========================${NC}"
    echo -e "${GREEN}✓${NC} Docker Engine installed and running"
    echo -e "${GREEN}✓${NC} Docker Compose plugin installed"
    echo -e "${GREEN}✓${NC} Docker Buildx plugin installed"
    echo
    echo -e "${YELLOW}IMPORTANT:${NC}"
    echo -e "• To use Docker without sudo, log out and log back in, or run: ${BLUE}newgrp docker${NC}"
    echo -e "• To test non-root access: ${BLUE}docker run hello-world${NC}"
    echo -e "• Docker service will start automatically on boot"
    echo
    echo -e "${BLUE}Useful commands:${NC}"
    echo -e "• Check Docker status: ${GREEN}sudo systemctl status docker${NC}"
    echo -e "• View Docker info: ${GREEN}docker info${NC}"
    echo -e "• View Docker version: ${GREEN}docker --version${NC}"
    echo -e "• Docker Compose version: ${GREEN}docker compose version${NC}"
    echo
    echo -e "${BLUE}Documentation:${NC}"
    echo -e "• Docker docs: ${GREEN}https://docs.docker.com/${NC}"
    echo -e "• Ubuntu install guide: ${GREEN}https://docs.docker.com/engine/install/ubuntu/${NC}"
    echo -e "• Post-install steps: ${GREEN}https://docs.docker.com/engine/install/linux-postinstall/${NC}"
    echo -e "========================================================================"
}

# Main installation function
main() {
    echo -e "${BLUE}======================================================================${NC}"
    echo -e "${BLUE}            Docker Installation Script for Ubuntu 22.04 LTS            ${NC}"
    echo -e "${BLUE}======================================================================${NC}"
    echo
    
    # Pre-installation checks
    check_root
    check_ubuntu_version
    check_architecture
    
    echo
    log_info "Starting Docker installation process..."
    echo
    
    # Installation steps
    uninstall_conflicting_packages
    update_package_index
    install_prerequisites
    setup_docker_repository
    install_docker
    start_docker_service
    verify_installation
    configure_non_root_access
    
    # Show completion message
    show_post_install_info
}

# Error handling
trap 'log_error "Installation failed at line $LINENO. Command: $BASH_COMMAND"' ERR

# Run main function
main "$@"