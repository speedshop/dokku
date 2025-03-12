# Dokku on Hetzner Cloud with Terraform

This Terraform project automates the deployment of a Dokku server on Hetzner Cloud.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or newer)
  - Alternatively, use [mise](https://mise.jdx.dev/) or [asdf](https://asdf-vm.com/) for version management
- A Hetzner Cloud account and API token
- Hetzner Storage Box with S3 compatibility (for remote state management)

## Configuration

1. Clone this repository:
   ```
   git clone <repository-url>
   cd dokku-hetzner-terraform
   ```

2. Set up Terraform:
   - If using mise: Run `mise install` to automatically install the correct Terraform version
   - If using asdf: Run `asdf install` to install the correct Terraform version
   - Otherwise, ensure you have Terraform v1.11.1 or compatible version installed

3. Set up remote state storage:
   - Create a `backend.tfvars` file in the `terraform` directory based on the example:
     ```
     cp terraform/backend.tfvars.example terraform/backend.tfvars
     ```
   - Edit the `backend.tfvars` file with your Hetzner Storage Box credentials
   - Run the setup script to initialize the remote state storage:
     ```
     cd terraform
     ./setup-remote-state.sh
     ```

4. Create a `terraform.tfvars` file in the `terraform` directory based on the example:
   ```
   cp terraform/terraform.tfvars.example terraform/terraform.tfvars
   ```

5. Edit the `terraform.tfvars` file with your specific configuration:
   ```
   hcloud_token   = "your_hetzner_cloud_api_token"
   server_name    = "dokku-server"
   server_type    = "cx21"  # 2 vCPU, 4 GB RAM
   location       = "nbg1"  # Nuremberg, Germany
   image          = "ubuntu-22.04"
   ssh_keys       = ["your_ssh_key_name_or_id"]
   dokku_version  = "0.30.6"
   dokku_hostname = "dokku.example.com"
   ```

## Usage

1. Initialize Terraform with the remote backend:
   ```
   cd terraform
   terraform init -backend-config=backend.tfvars
   ```

2. Preview the changes:
   ```
   terraform plan
   ```

3. Apply the changes to create the infrastructure:
   ```
   terraform apply
   ```

4. After the deployment is complete, you can access your Dokku server via SSH:
   ```
   ssh root@<server_ip>
   ```

## Remote State Management

This project uses Hetzner Storage Box with S3 compatibility for remote state management. This provides several benefits:

- **Team Collaboration**: Multiple team members can work on the same infrastructure
- **State Locking**: Prevents concurrent modifications that could corrupt the state
- **Versioning**: Keeps a history of state files for backup and recovery
- **Security**: Stores sensitive state data securely, not in local files

The remote state is configured in `terraform/main.tf` and uses the credentials in `terraform/backend.tfvars`.

## Dokku Setup

After the server is provisioned, you can deploy applications to your Dokku server. Here's a basic example:

1. On your local machine, add the Dokku server as a Git remote:
   ```
   git remote add dokku dokku@<server_ip>:<app-name>
   ```

2. Deploy your application:
   ```
   git push dokku main
   ```

3. Set up SSL with Let's Encrypt:
   ```
   ssh root@<server_ip>
   dokku config:set --global DOKKU_LETSENCRYPT_EMAIL=your-email@example.com
   dokku letsencrypt:enable <app-name>
   ```

## Included Plugins

The following Dokku plugins are installed by default:

- [dokku-letsencrypt](https://github.com/dokku/dokku-letsencrypt): For SSL certificate management
- [dokku-postgres](https://github.com/dokku/dokku-postgres): For PostgreSQL database services
- [dokku-redis](https://github.com/dokku/dokku-redis): For Redis services

## Customization

You can customize the deployment by modifying the Terraform files:

- Add or remove firewall rules in `terraform.tfvars`
- Modify the server specifications in `terraform.tfvars`
- Add additional Dokku plugins in `terraform/modules/dokku/main.tf`

## Version Management

This project includes configuration files for version management tools:

- `.mise.toml`: Configuration for [mise](https://mise.jdx.dev/)
- `.tool-versions`: Configuration for [asdf](https://asdf-vm.com/)

These files ensure that the correct version of Terraform (1.11.1) is used when working with this project.

## Destroying the Infrastructure

To destroy the created infrastructure:

```
cd terraform
terraform destroy
```

**Note:** Make sure to back up any important data before destroying the infrastructure.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
