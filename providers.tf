#
# Terraform:: terraform-rundeck-job
# Plan:: providers.tf
#

terraform {
  required_version = "~> 1.0.0"

  experiments = [module_variable_optional_attrs]

  required_providers {
    rundeck = {
      version = "~> 0.5.0"
      source  = "rundeck/rundeck"
    }
  }
}
