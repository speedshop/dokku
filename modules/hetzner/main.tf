terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45.0"
    }
  }
}

resource "hcloud_server" "server" {
  name        = var.server_name
  server_type = var.server_type
  location    = var.location
  image       = var.image
  ssh_keys    = var.ssh_keys

  # Prevent destroying the server accidentally
  lifecycle {
    prevent_destroy = true
  }
}

# Create a firewall for the server
resource "hcloud_firewall" "server" {
  name = "${var.server_name}-firewall"

  dynamic "rule" {
    for_each = var.firewall_rules
    content {
      direction  = rule.value.direction
      protocol   = rule.value.protocol
      port       = rule.value.port
      source_ips = rule.value.source_ips
    }
  }
}

# Attach the firewall to the server
resource "hcloud_firewall_attachment" "server" {
  firewall_id = hcloud_firewall.server.id
  server_ids  = [hcloud_server.server.id]
}

# Create a floating IP if requested
resource "hcloud_floating_ip" "server" {
  count         = var.create_floating_ip ? 1 : 0
  type          = "ipv4"
  server_id     = hcloud_server.server.id
  description   = "${var.server_name} floating IP"
  home_location = var.location
}

# Assign the floating IP to the server
resource "null_resource" "floating_ip_assignment" {
  count = var.create_floating_ip ? 1 : 0

  depends_on = [hcloud_floating_ip.server]

  connection {
    type        = "ssh"
    user        = "root"
    host        = hcloud_server.server.ipv4_address
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "ip addr add ${hcloud_floating_ip.server[0].ip_address}/32 dev eth0",
      "echo 'auto eth0:1' >> /etc/network/interfaces",
      "echo 'iface eth0:1 inet static' >> /etc/network/interfaces",
      "echo 'address ${hcloud_floating_ip.server[0].ip_address}' >> /etc/network/interfaces",
      "echo 'netmask 255.255.255.255' >> /etc/network/interfaces"
    ]
  }
}
