variable "api_version" {
  type        = number
  description = "value"
  default     = null

  validation {
    condition     = var.api_version == null || can(regex("[[:digit:]]+", var.api_version))
    error_message = "Variable api_version must be a number, or null and use environment variable RUNDECK_API_VERSION."
  }
}

variable "auth_token" {
  type        = string
  sensitive   = true
  description = "value"
  default     = null

  validation {
    condition     = var.auth_token == null || can(regex("[[:alnum:]]+", var.auth_token))
    error_message = "Variable auth_token must be an alpha-numeric string, or null and use environment variable RUNDECK_AUTH_TOKEN."
  }
}

variable "url" {
  type        = string
  description = "value"
  default     = null

  validation {
    condition     = var.url == null || can(regex("^https?://", var.url))
    error_message = "Variable url must be an alpha-numeric starting with http:// or https://, or null and use environment variable RUNDECK_URL."
  }
}
