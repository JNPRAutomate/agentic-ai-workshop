# Workshop VM Provisioning with Ansible

This directory contains playbooks for provisioning workshop VMs — either a single VM directly or multiple isolated VMs via KVM on a bare-metal host.

## Prerequisites

1. **Control machine** (your laptop):
   - Ansible installed (`pip install ansible` or `brew install ansible`)
   - Ansible collections: `ansible-galaxy collection install community.libvirt ansible.posix`
   - SSH access to the target VM/host as a user with sudo privileges

2. **Target VM** (single-VM mode):
   - Ubuntu 22.04 LTS
   - SSH server running
   - A user with sudo access (default: `labuser`)

3. **Bare-metal host** (multi-user KVM mode):
   - Ubuntu 22.04 or 24.04 LTS
   - VT-x/AMD-V support
   - SSH access as root
   - Operator's public key at `~/.ssh/id_rsa.pub`

4. **cRPD Docker image** (Juniper proprietary):
   - Obtain `crpd-25.2R1.9.tgz` from Juniper
   - Place it in `ansible/files/crpd-25.2R1.9.tgz`

5. **cRPD license file**:
   - Obtain `DemolabJUNOS.cRPD.lic` from Juniper
   - Place it in `ansible/files/DemolabJUNOS.cRPD.lic`
   - Required by use cases UC3, UC4, and UC8

## Playbooks

| Playbook | Purpose |
|----------|---------|
| `setup-workshop-vm.yml` | Provision a single VM with all workshop dependencies |
| `setup-kvm-host.yml` | Install KVM on a bare-metal host, create N guest VMs, configure NAT/port forwarding |
| `teardown-kvm-host.yml` | Destroy all guest VMs, remove iptables rules, clean up |

## Single-VM Quick Start

```bash
# 1. Edit inventory to point to your VM
vi ansible/inventory.ini

# 2. Place cRPD image and license
cp /path/to/crpd-25.2R1.9.tgz ansible/files/
cp /path/to/DemolabJUNOS.cRPD.lic ansible/files/

# 3. Run the playbook
ansible-playbook -i inventory.ini setup-workshop-vm.yml
```

## Multi-User KVM Quick Start

Spin up N isolated VMs on a single bare-metal server. Each VM gets its own Docker, ContainerLab, and MCP servers — no conflicts between users.

```bash
# 1. Edit inventory-host.ini with your bare-metal host
vi ansible/inventory-host.ini

# 2. Place cRPD image and license
cp /path/to/crpd-25.2R1.9.tgz ansible/files/
cp /path/to/DemolabJUNOS.cRPD.lic ansible/files/

# 3. Create guest VMs (default: 10)
ansible-playbook -i inventory-host.ini setup-kvm-host.yml -e workshop_vm_count=10

# 4. Provision all VMs with workshop environment
ansible-playbook -i inventory-workshop.ini setup-workshop-vm.yml

# 5. Users SSH to their assigned VM
ssh -p 2201 labuser@<host-public-ip>   # User 1
ssh -p 2202 labuser@<host-public-ip>   # User 2
# ...

# 6. Tear down after workshop
ansible-playbook -i inventory-host.ini teardown-kvm-host.yml -e workshop_vm_count=10
```

### KVM Variables

Override any of these with `-e`:

| Variable | Default | Description |
|----------|---------|-------------|
| `workshop_vm_count` | `10` | Number of VMs to create |
| `workshop_vm_cpus` | `2` | vCPUs per VM |
| `workshop_vm_memory_mb` | `4096` | RAM per VM (MB) |
| `workshop_vm_disk_gb` | `50` | Disk per VM (GB) |
| `workshop_ssh_port_start` | `2201` | First host-side SSH port |
| `workshop_host_address` | `dedicated.netzolt.com` | Host address for inventory |

## What It Sets Up

| Component | Details |
|-----------|---------|
| **User** | `claude` (uid 1001) with Docker and clab_admins groups |
| **Docker** | Docker CE with compose and buildx plugins |
| **ContainerLab** | Latest version from containerlab.dev |
| **Python** | System Python 3.10+ with UV package manager |
| **SSH Keys** | `id_rsa_claude` keypair for container access |
| **Workspace** | Cloned from `JNPRAutomate/agentic-ai-workshop` |
| **Junos MCP** | Cloned from `Juniper/junos-mcp-server` with venv |
| **Linux MCP** | Cloned from `JNPRAutomate/linux-mcp-server` (V1.0 tag) with venv |
| **Docker Images** | `crpd:25.2R1.9` and `alpine:3.22.1` |
| **cRPD License** | Deployed to UC3, UC4, UC8 license directories |

## Skip cRPD Image Loading

If the cRPD image is already loaded or you want to load it separately:

```bash
ansible-playbook -i inventory.ini setup-workshop-vm.yml --skip-tags crpd
```

## Post-Setup Verification

SSH into the VM as `claude` and verify:

```bash
ssh claude@your-vm
docker ps
clab version
python3 --version
uv --version
ls ~/workspace/ ~/mcps/
```
