variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

variable "server_name" {
  description = "Name of the Dokku server"
  type        = string
  default     = "dokku-server"
}

variable "server_type" {
  description = "Hetzner Cloud server type"
  type        = string
  default     = "cx21" # 2 vCPU, 4 GB RAM
}

variable "location" {
  description = "Hetzner Cloud datacenter location"
  type        = string
  default     = "nbg1" # Nuremberg, Germany
}

variable "image" {
  description = "Base OS image to use"
  type        = string
  default     = "ubuntu-22.04"
}

variable "ssh_keys" {
  description = "List of SSH key IDs or names to be added to the server"
  type        = list(string)
  default     = []
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key file for provisioning"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "dokku_version" {
  description = "Dokku version to install"
  type        = string
  default     = "0.30.6" # Specify the version you want to install
}

variable "dokku_hostname" {
  description = "Hostname for the Dokku server"
  type        = string
}

variable "dokku_deploy_key" {
  description = "SSH public key for deploying to Dokku (optional)"
  type        = string
  default     = ""
}

variable "create_floating_ip" {
  description = "Whether to create a floating IP for the Dokku server"
  type        = bool
  default     = false
}

variable "firewall_rules" {
  description = "Firewall rules for the Dokku server"
  type = list(object({
    direction       = string
    protocol        = string
    port            = string
    source_ips      = list(string)
    destination_ips = list(string)
  }))
  default = [
    {
      direction       = "in"
      protocol        = "tcp"
      port            = "22"
      source_ips      = ["0.0.0.0/0", "::/0"]
      destination_ips = []
    },
    {
      direction       = "in"
      protocol        = "tcp"
      port            = "80"
      source_ips      = ["0.0.0.0/0", "::/0"]
      destination_ips = []
    },
    {
      direction       = "in"
      protocol        = "tcp"
      port            = "443"
      source_ips      = ["0.0.0.0/0", "::/0"]
      destination_ips = []
    }
  ]
}
