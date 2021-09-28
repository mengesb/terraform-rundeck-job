terraform {
  required_version = "~> 1.0.0"

  required_providers {
    rundeck = {
      version = "~> 0.4.2"
      source  = "rundeck/rundeck"
    }
  }
}

provider "rundeck" {
  url         = var.url         # RUNDECK_API
  api_version = var.api_version # RUNDECK_URL
  auth_token  = var.auth_token  # RUNDECK_AUTH_TOKEN
}
