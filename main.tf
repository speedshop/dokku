terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45.0"
    }
  }
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket = "speedshop-terraform-state"
    key    = "dokku/terraform.tfstate"
    region = "us-east-1" # Placeholder, not used with Hetzner
    endpoints = {
      s3 = "https://hel1.your-objectstorage.com"
    }
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    skip_region_validation      = true
    #skip_metadata_api_check     = true
    use_path_style = true
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

module "dokku" {
  source = "./modules/dokku"

  server_name          = var.server_name
  server_type          = var.server_type
  location             = var.location
  image                = var.image
  ssh_private_key_path = var.ssh_private_key_path
  dokku_version        = var.dokku_version
  dokku_hostname       = var.dokku_hostname
  dokku_deploy_key     = var.dokku_deploy_key
  firewall_rules       = var.firewall_rules
  create_floating_ip   = var.create_floating_ip
  ssh_public_key       = var.ssh_public_key
}

resource "null_resource" "test_backend" {
  provisioner "local-exec" {
    command = "echo 'Testing backend state save'"
  }
}

output "dokku_server_ip" {
  value = module.dokku.server_ip
}

output "dokku_server_status" {
  value = module.dokku.server_status
}
