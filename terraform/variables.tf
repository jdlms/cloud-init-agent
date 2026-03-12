variable "proxmox_endpoint" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token (format: user@realm!token-name=secret)"
  type        = string
  sensitive   = true
}

variable "ci_user" {
  description = "Username created by cloud-init (gets passwordless sudo automatically)"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for the cloud-init user"
  type        = string
}

variable "clone_vm_id" {
  description = "VM ID of the cloud-init template to clone from"
  type        = number
  default     = 9000
}

variable "node_name" {
  description = "Proxmox node to create the VM on"
  type        = string
  default     = "proxmox"
}

variable "vm_id" {
  description = "VM ID for the devbox"
  type        = number
  default     = 302
}

variable "hostname" {
  description = "Hostname for the VM"
  type        = string
  default     = "devbox"
}

variable "dns_server" {
  description = "DNS server IP for the VM"
  type        = string
  default     = "192.168.1.110"
}

variable "bridge" {
  description = "Network bridge to attach the VM to"
  type        = string
  default     = "vmbr0"
}

variable "datastore_id" {
  description = "Proxmox datastore for the VM disk"
  type        = string
  default     = "local-lvm"
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 20
}

variable "memory" {
  description = "Dedicated memory in MB"
  type        = number
  default     = 2048
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}
