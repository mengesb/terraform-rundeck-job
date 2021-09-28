#
# Terraform:: terraform-rundeck-job
# Plan:: providers.tf
#

terraform {
  required_version = "~> 1.0.0"

  required_providers {
    rundeck = {
      version = "~> 0.4.1-pre"
      source  = "rundeck/rundeck"
    }
  }
}
