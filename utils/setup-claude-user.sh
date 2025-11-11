#!/bin/bash

# Claude User Setup Script
# Creates a claude user with Docker and ContainerLab permissions

set -e  # Exit on any error

USERNAME="claude"

echo "Creating user: $USERNAME"

# Create user with home directory
sudo useradd -m -s /bin/bash "$USERNAME"

# Add to groups
echo "Adding $USERNAME to group: docker"
sudo usermod -a -G docker "$USERNAME"

# Add to groups
echo "Adding $USERNAME to group: clab_admins"
sudo usermod -a -G clab_admins "$USERNAME"

# Verify creation
echo "User creation complete!"
echo "User details:"
id "$USERNAME"

# Create folder workspace
mkdir -pv /home/claude/workspace/
chown -R $USERNAME:$USERNAME /home/claude/workspace/

# List home dir contents
echo "Home directory contents:"
ls -la "/home/$USERNAME"

# Add SSH related files to /home/$USERNAME/.ssh/ folder
mkdir -p /home/$USERNAME/.ssh

cp utils/id_rsa_claude /home/$USERNAME/.ssh/
cp utils/id_rsa_claude.pub /home/$USERNAME/.ssh/
cp utils/ssh.config /home/$USERNAME/.ssh/config
cp utils/authorized_keys /home/$USERNAME/.ssh/authorized_keys

chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/id_rsa_claude
chmod 644 /home/$USERNAME/.ssh/id_rsa_claude.pub
chmod 600 /home/$USERNAME/.ssh/authorized_keys
chmod 664 /home/$USERNAME/.ssh/config


chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

# List SSH config dir contents
echo "Home directory contents:"
ls -la "/home/$USERNAME/.ssh/"

echo ""
echo "✅ User $USERNAME is ready to use!"
echo "Switch to user with: su - $USERNAME"
