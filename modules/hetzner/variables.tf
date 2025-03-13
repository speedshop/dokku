variable "server_name" {
  description = "Name of the server"
  type        = string
  default     = "server"
}

variable "server_type" {
  description = "Hetzner Cloud server type"
  type        = string
  default     = "cx21" # 2 vCPU, 4 GB RAM
}

variable "location" {
  description = "Hetzner Cloud datacenter location"
  type        = string
  default     = "ash" # Ashland
}

variable "image" {
  description = "Base OS image to use"
  type        = string
  default     = "ubuntu-22.04"
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key file for provisioning"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "ssh_public_key" {
  description = "SSH public key to add to Hetzner Cloud"
  type        = string
}

variable "firewall_rules" {
  description = "Firewall rules for the server"
  type = list(object({
    direction       = string
    protocol        = string
    port            = string # can be a single port "22" or a range "60000-61000"
    source_ips      = list(string)
  }))
  default = [
    {
      direction       = "in"
      protocol        = "tcp"
      port            = "22"
      source_ips      = ["0.0.0.0/0", "::/0"]
    },
    {
      direction       = "in"
      protocol        = "udp"
      port            = "60000-61000"
      source_ips      = ["0.0.0.0/0", "::/0"]
    },
    {
      direction       = "in"
      protocol        = "tcp"
      port            = "80"
      source_ips      = ["0.0.0.0/0", "::/0"]
    },
    {
      direction       = "in"
      protocol        = "tcp"
      port            = "443"
      source_ips      = ["0.0.0.0/0", "::/0"]
    }
  ]
}

variable "create_floating_ip" {
  description = "Whether to create a floating IP for the server"
  type        = bool
  default     = false
}
