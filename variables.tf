variable "project_id" {
  description = "The id of the GCP Project"
  type        = string
}


variable "gke_config" {
  description = "Configuration for GKE private cluster"
  type = object({
    project_id              = string
    region                  = string
    name                    = string
    enable_autopilot        = bool
    network                 = string
    subnetwork              = string
    master_ipv4_cidr_block  = string
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

variable "vpc_config" {
  description = "List of configuration for VPC"
  type =list(object({
    auto_create_subnetworks                = optional(bool)
    description                            = optional(string)

    firewall_rules = optional(list(object({
      name        = string
      description = string
      direction   = string
      priority    = number
      ranges      = list(string)

      allow = list(object({
        protocol = string
        ports    = list(string)
      }))

      deny = list(object({
        protocol = string
        ports    = list(string)
      }))
    })))

    network_name = string
    project_id   = string

    routes = optional(list(object({
      name              = string
      dest              = string
      next_hop_ip       = optional(string)
      next_hop_instance = optional(string)
    })))

    secondary_ranges = optional(map(list(object({
      range_name    = string
      ip_cidr_range = string
    }))))

    subnets = list(object({
      subnet_name           = string
      subnet_ip             = string
      subnet_region         = string
      subnet_private_access = bool
    }))
  }))
}

variable "sql_config" {
  description = "Cloud SQL configuration block"
  type = object({
    project_id       = string
    region           = string
    instance_name    = string
    database_version = string
    tier             = string

    availability_type        = optional(string)
    disk_type                = optional(string)
    disk_size                = optional(number)
    activation_policy        = optional(string)
    deletion_protection      = optional(bool)
    enable_public_ip         = optional(bool)
    private_network          = optional(string)

    authorized_networks = optional(list(object({
      name  = string
      value = string
    })))

    backup_enabled              = optional(bool)
    backup_start_time           = optional(string)
    point_in_time_recovery      = optional(bool)

    users = optional(list(object({
      name     = string
      password = string
      host     = optional(string)
    })))

    databases = optional(list(string))
  })
}

