output "server_id" {
  description = "ID of the created server"
  value       = hcloud_server.server.id
}

output "server_name" {
  description = "Name of the created server"
  value       = hcloud_server.server.name
}

output "server_ip" {
  description = "IPv4 address of the created server"
  value       = hcloud_server.server.ipv4_address
}

output "server_status" {
  description = "Status of the created server"
  value       = hcloud_server.server.status
}

output "floating_ip" {
  description = "Floating IP address (if created)"
  value       = var.create_floating_ip ? hcloud_floating_ip.server[0].ip_address : null
}

output "firewall_id" {
  description = "ID of the created firewall"
  value       = hcloud_firewall.server.id
}
