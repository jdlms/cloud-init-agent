# Devbox

A Proxmox cloud-init VM provisioned via Terraform and bootstrapped with Ansible. Comes with Claude Code, GitHub CLI, and Tailscale SSH.

## Prerequisites

- Proxmox host with a Debian 12 cloud-init template (default VM ID `9000` — see [cloud-init template setup](https://pve.proxmox.com/wiki/Cloud-Init_Support))
- Proxmox API token
- Terraform and Ansible installed locally
- A Tailscale auth key (generate at https://login.tailscale.com/admin/settings/keys)
- A GitHub personal access token
- An Anthropic API key

## What gets installed

- Node.js 22 LTS
- Claude Code (`@anthropic-ai/claude-code`)
- GitHub CLI (authenticated via PAT)
- Tailscale (SSH enabled)
- QEMU guest agent
- Base tools: curl, git, vim, htop, build-essential, jq

## Usage

### 1. Create the VM

```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
# Fill in: proxmox_endpoint, proxmox_api_token, ci_user, ssh_public_key
cd terraform && terraform init && terraform apply
```

### 2. Get the VM's IP

```bash
# Via Proxmox (requires guest agent to be running)
ssh root@proxmox "qm guest cmd 302 network-get-interfaces"

# Or check the Proxmox UI under the VM's Summary tab
```

### 3. Set up Ansible secrets

```bash
cp ansible/secrets.yml.example ansible/secrets.yml
# Fill in: github_pat, anthropic_api_key, tailscale_auth_key
ansible-vault encrypt ansible/secrets.yml
```

### 4. Set up Ansible inventory

```bash
cp ansible/inventory.ini.example ansible/inventory.ini
# Fill in the VM IP and your ci_user
```

### 5. Bootstrap

```bash
ansible-playbook -i ansible/inventory.ini ansible/bootstrap.yml --ask-vault-pass
```

### 6. Connect

```bash
# Via Tailscale SSH (after bootstrap completes)
ssh your-user@devbox
```

## Configuration

### Terraform variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `proxmox_endpoint` | yes | — | Proxmox API URL |
| `proxmox_api_token` | yes | — | API token (`user@realm!token=secret`) |
| `ci_user` | yes | — | Username created by cloud-init |
| `ssh_public_key` | yes | — | SSH public key for the user |
| `clone_vm_id` | no | `9000` | Cloud-init template VM ID |
| `node_name` | no | `proxmox` | Proxmox node name |
| `vm_id` | no | `302` | VM ID |
| `hostname` | no | `devbox` | VM hostname |
| `dns_server` | no | `192.168.1.110` | DNS server IP |
| `bridge` | no | `vmbr0` | Network bridge |
| `datastore_id` | no | `local-lvm` | Storage for the VM disk |
| `disk_size` | no | `20` | Disk size in GB |
| `memory` | no | `2048` | RAM in MB |
| `cpu_cores` | no | `2` | CPU cores |

### Ansible variables

| Variable | Where | Description |
|----------|-------|-------------|
| `devbox_user` | `bootstrap.yml` vars | User for GitHub CLI auth (should match `ci_user`) |
| `github_pat` | `secrets.yml` (vault) | GitHub personal access token |
| `anthropic_api_key` | `secrets.yml` (vault) | Anthropic API key |
| `tailscale_auth_key` | `secrets.yml` (vault) | Tailscale auth key |

## File structure

```
devbox/
├── README.md
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── output.tf
│   └── terraform.tfvars.example
└── ansible/
    ├── bootstrap.yml
    ├── inventory.ini.example
    └── secrets.yml.example
```

## Tear down

```bash
cd terraform && terraform destroy
```
