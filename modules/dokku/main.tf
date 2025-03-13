module "hetzner" {
  source = "../hetzner"

  server_name          = var.server_name
  server_type          = var.server_type
  location             = var.location
  image                = var.image
  ssh_private_key_path = var.ssh_private_key_path
  firewall_rules       = var.firewall_rules
  create_floating_ip   = var.create_floating_ip
  ssh_public_key       = var.ssh_public_key
}

# Provision Dokku on the server
resource "null_resource" "dokku_provisioner" {
  depends_on = [module.hetzner]

  connection {
    type        = "ssh"
    user        = "root"
    host        = module.hetzner.server_ip
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "apt-get update",
      "apt-get install -y apt-transport-https ca-certificates curl software-properties-common mosh",
      "apt-get install -y locales && locale-gen en_US.UTF-8",
      "rm -rf bootstrap.sh",
      # Install Dokku
      "wget https://raw.githubusercontent.com/dokku/dokku/v${var.dokku_version}/bootstrap.sh",
      "DOKKU_TAG=v${var.dokku_version} bash bootstrap.sh",

      # Configure Dokku
      "echo '${var.dokku_hostname}' > /home/dokku/HOSTNAME",
      "echo 'export DOKKU_HOSTNAME=${var.dokku_hostname}' >> /home/dokku/.dokkurc/HOSTNAME",

      # Install Dokku plugins
      "dokku plugin:install-dependencies --core",
      "dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git",

      # Set up SSH key for deployments (if provided)
      "${var.dokku_deploy_key != "" ? "echo \"${var.dokku_deploy_key}\" | dokku ssh-keys:add deploy" : "echo 'No deploy key path provided'"}",

      # Final system updates
      "apt-get upgrade -y",
      "apt-get autoremove -y"
    ]
  }
}
