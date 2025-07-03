variable "gke_config" {
  description = "Configuration for GKE private cluster"
  type = object({
    project_id                 = string
    region                     = string
    name                       = string
    network                    = string
    subnetwork                 = string
    release_channel            = string
    enable_autopilot           = bool
    enable_private_nodes       = bool
    enable_private_endpoint    = bool
    deletion_protection        = bool
    pod_range                  = string
    service_range              = string
    master_ipv4_cidr_block     = string
    master_authorized_networks = list(object({
      cidr_block   = string
      display_name = string
    }))
    service_account = optional(string)
  })
}
