#
# Terraform:: terraform-rundeck-job
# Plan:: providers.tf
#

terraform {
  required_version = "~> 0.14.0"

  experiments = [module_variable_optional_attrs]

  required_providers {
    rundeck = {
      version = "~> 0.4.0"
      source  = "terraform-providers/rundeck"
    }
  }
}