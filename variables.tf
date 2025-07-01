variable "project_id" {}
variable "region" { default = "us-central1" }

variable "network_name" { default = "gke-vpc" }
variable "subnet_cidr" { default = "10.10.0.0/16" }

variable "local_cidr_block" { description = "Your local IP CIDR block (e.g., 1.2.3.4/32)" }

variable "gke_config" {
  description = "Configuration for GKE private cluster"
  type = object({
    project_id             = string
    region                 = string
    name                   = string
    enable_autopilot       = bool
    network                = string
    subnetwork             = string
    master_ipv4_cidr_block = string
    
    enable_private_endpoint = bool
    enable_private_nodes    = bool
    release_channel         = string

    pod_range               = string
    service_range           = string
    master_authorized_networks = list(object({
      cidr_block   = string
      display_name = string
    }))

    auto_provisioning_defaults = object({
      service_account = optional(string)
    })
  })
}
