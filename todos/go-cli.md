# Future: Go CLI

## Goal

Single binary that replaces Terraform + Ansible with zero external dependencies. Users download one tool and go from nothing to a fully bootstrapped dev VM.

## Core Commands

- **`init`** — Interactive config wizard. Prompts for infrastructure target (Proxmox vs local), VM specs (CPU, RAM, disk), SSH key path, and which AI coding tool to install. Writes a single config file (e.g., `cloud-init-agent.yaml`).
- **`deploy`** — Creates the VM and bootstraps it end-to-end: provision infrastructure, wait for SSH, install packages, configure the AI coding tool. Idempotent — safe to re-run.
- **`ssh`** — Connects to the VM using stored state (IP + key). No need to look up addresses manually.
- **`destroy`** — Tears down the VM and cleans up state.

## Infrastructure Targets

### Proxmox Cloud-Init (current functionality)
- Communicate via the Proxmox REST API using `go-proxmox` or direct HTTP calls
- Clone a cloud-init template, inject SSH keys and network config
- Detect the VM's IP automatically via QEMU guest agent

### Local VM Creation
- Use libvirt/QEMU (via `libvirt-go` bindings) or VirtualBox (via `VBoxManage` CLI)
- Download a cloud image (Ubuntu/Debian), create a VM, attach a cloud-init ISO
- Useful for local development and testing without a Proxmox server

## Key Go Libraries

- `github.com/luthermonson/go-proxmox` — Proxmox API client
- `golang.org/x/crypto/ssh` — SSH connections for bootstrapping
- `github.com/digitalocean/go-libvirt` — libvirt bindings for local VMs
- `gopkg.in/yaml.v3` — config file parsing

## Benefits Over Current Approach

- **Zero deps**: No Terraform, Ansible, Python, or provider plugins to install
- **Single config file**: One YAML file instead of Terraform HCL + Ansible playbooks + inventory
- **Automatic IP detection**: No manual step to find the VM's address
- **No manual steps**: `deploy` goes from zero to SSH-ready in one command
- **Portable**: Single static binary works on Linux, macOS, Windows

## Architecture Notes

- **State file**: Store VM metadata (ID, IP, status, target type) in a local JSON file (e.g., `.cloud-init-agent.state.json`)
- **Idempotency**: Each bootstrap step should check whether it's already been applied before running (e.g., skip package install if the tool binary already exists)
- **Config schema**: Version the config format so future changes don't break existing configs
- **Error handling**: If `deploy` fails mid-way, re-running it should pick up where it left off
