variable "gke_project_configs" {
  description = "Map of GKE project configurations including network and cluster settings"
  type = map(object({
    network_name        = string
    subnet_name         = string
    pods_range_name     = string
    services_range_name = string
    regions = map(object({
      subnet_name         = string
      pods_range_name     = string
      services_range_name = string
      master_cidr         = string
      service_account     = string
      authorized_networks = list(object({
        cidr_block   = string
        display_name = string
      }))
    }))
  }))
}

variable "common_gke_config" {
  description = "Common GKE configuration applied to all clusters"
  type = object({
    name_prefix                 = string
    release_channel             = string
    enable_autopilot            = bool
    enable_private_nodes        = bool
    enable_private_endpoint     = bool
    deletion_protection         = bool
    enable_binary_authorization = bool
    binary_authorization_mode   = string
  })
  validation {
    condition     = contains(["ALWAYS_DENY", "ALWAYS_ALLOW"], var.common_gke_config.binary_authorization_mode)
    error_message = "Binary authorization mode must be 'ALWAYS_DENY' or 'ALWAYS_ALLOW'."
  }
}