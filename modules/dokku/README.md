# Dokku Terraform Module

This Terraform module deploys a Dokku server on Hetzner Cloud with common plugins and configurations. It uses the Hetzner module for infrastructure provisioning and adds Dokku-specific configuration.

## Features

- Provisions a Hetzner Cloud server using the Hetzner module
- Installs and configures Dokku
- Installs common Dokku plugins (Let's Encrypt, Postgres, Redis)
- Sets up SSH access for deployments

## Usage

```hcl
module "dokku" {
  source = "./modules/dokku"

  server_name     = "my-dokku-server"
  server_type     = "cx21"
  location        = "nbg1"
  image           = "ubuntu-22.04"
  ssh_keys        = ["your-ssh-key-id"]
  ssh_private_key_path = "~/.ssh/id_rsa"
  dokku_version   = "0.30.6"
  dokku_hostname  = "dokku.example.com"
  dokku_deploy_key = "ssh-rsa AAAA..."  # Optional
  create_floating_ip = false

  # Optional: Custom firewall rules
  firewall_rules = [
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "22"
      source_ips = ["0.0.0.0/0", "::/0"]
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "80"
      source_ips = ["0.0.0.0/0", "::/0"]
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "443"
      source_ips = ["0.0.0.0/0", "::/0"]
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "8080"
      source_ips = ["0.0.0.0/0", "::/0"]
    }
  ]
}

output "dokku_server_ip" {
  value = module.dokku.server_ip
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| server_name | Name of the Dokku server | `string` | `"dokku-server"` | no |
| server_type | Hetzner Cloud server type | `string` | `"cx21"` | no |
| location | Hetzner Cloud datacenter location | `string` | `"nbg1"` | no |
| image | Base OS image to use | `string` | `"ubuntu-22.04"` | no |
| ssh_keys | List of SSH key IDs or names to be added to the server | `list(string)` | n/a | yes |
| ssh_private_key_path | Path to the SSH private key file for provisioning | `string` | `"~/.ssh/id_rsa"` | no |
| dokku_version | Dokku version to install | `string` | `"0.30.6"` | no |
| dokku_hostname | Hostname for the Dokku server | `string` | n/a | yes |
| dokku_deploy_key | SSH public key for deploying to Dokku (optional) | `string` | `""` | no |
| create_floating_ip | Whether to create a floating IP for the Dokku server | `bool` | `false` | no |
| firewall_rules | Firewall rules for the Dokku server | `list(object)` | Default SSH, HTTP, HTTPS rules | no |

## Outputs

| Name | Description |
|------|-------------|
| server_id | ID of the created server |
| server_name | Name of the created server |
| server_ip | IPv4 address of the created server |
| server_status | Status of the created server |
| floating_ip | Floating IP address (if created) |
| dokku_hostname | Hostname configured for Dokku |
| dokku_version | Installed Dokku version |
| firewall_id | ID of the created firewall |

## Post-Deployment

After deploying the server, you can:

1. SSH into the server:
   ```
   ssh root@<server_ip>
   ```

2. Deploy an application:
   ```
   # On your local machine
   git remote add dokku dokku@<server_ip>:<app-name>
   git push dokku main
   ```

3. Set up SSL with Let's Encrypt:
   ```
   # On the server
   dokku config:set --global DOKKU_LETSENCRYPT_EMAIL=your-email@example.com
   dokku letsencrypt:enable <app-name>
   ```

## Notes

- The server provisioning may take a few minutes to complete
- Dokku requires a domain name for proper functionality
- Make sure your SSH key is properly configured in Hetzner Cloud
