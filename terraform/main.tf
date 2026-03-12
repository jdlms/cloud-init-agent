terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.78.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true # set false if using valid TLS cert
}

resource "proxmox_virtual_environment_vm" "devbox" {
  node_name   = var.node_name
  vm_id       = var.vm_id
  name        = var.hostname
  description = "Managed by Terraform"

  clone {
    vm_id = var.clone_vm_id
    full  = true
  }

  agent {
    enabled = true
  }

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.datastore_id
    size         = var.disk_size
    interface    = "scsi0"
  }

  network_device {
    bridge = var.bridge
  }

  initialization {
    user_account {
      username = var.ci_user
      keys     = [var.ssh_public_key]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    dns {
      servers = [var.dns_server]
    }
  }
}
