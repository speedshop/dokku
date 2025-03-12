output "server_id" {
  description = "ID of the created server"
  value       = module.hetzner.server_id
}

output "server_name" {
  description = "Name of the created server"
  value       = module.hetzner.server_name
}

output "server_ip" {
  description = "IPv4 address of the created server"
  value       = module.hetzner.server_ip
}

output "server_status" {
  description = "Status of the created server"
  value       = module.hetzner.server_status
}

output "floating_ip" {
  description = "Floating IP address (if created)"
  value       = module.hetzner.floating_ip
}

output "dokku_hostname" {
  description = "Hostname configured for Dokku"
  value       = var.dokku_hostname
}

output "dokku_version" {
  description = "Installed Dokku version"
  value       = var.dokku_version
}

output "firewall_id" {
  description = "ID of the created firewall"
  value       = module.hetzner.firewall_id
}
