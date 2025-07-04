variable "vpc_config" {
  description = "List of configuration for VPC"
  type = object({
    auto_create_subnetworks = optional(bool)
    description             = optional(string)

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
  })
}