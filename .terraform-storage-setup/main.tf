terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "storage" {
  source = "../modules/storage"

  access_key  = var.access_key
  secret_key  = var.secret_key
  endpoint    = var.endpoint
  bucket_name = var.bucket_name
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "endpoint" {
  type = string
}

variable "bucket_name" {
  type    = string
  default = "terraform-state"
}

output "bucket_name" {
  value = module.storage.bucket_name
}
