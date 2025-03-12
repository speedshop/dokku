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
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key file for provisioning"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "firewall_rules" {
  description = "Firewall rules for the server"
  type = list(object({
    direction       = string
    protocol        = string
    port            = string
    source_ips      = list(string)
    destination_ips = optional(list(string), [])
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
