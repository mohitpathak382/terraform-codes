variable "regions" {
  description = "List of GCP regions used across all projects"
  type        = list(string)
}

variable "redis_project_configs" {
  description = "Map of Redis project configurations including network and region settings"
  type = map(object({
    network_name = string
    region_configs = map(object({
      shard_count   = number
      replica_count = optional(number)
      node_type     = optional(string)
      # psc_networks  = optional(list(string))
      redis_config = optional(map(string))
      persistence = optional(object({
        mode = string
      }))
      security = optional(object({
        transit_encryption_mode = optional(string)
      }))
      backup = optional(object({
        automated = optional(object({
          retention_days = optional(string)
          start_hour     = optional(number)
        }))
      }))
      maintenance = optional(object({
        weekly_windows = optional(list(object({
          day        = string
          start_hour = number
        })))
      }))
    }))
  }))
}

variable "common_redis_config" {
  description = "Common Redis configuration applied to all clusters"
  type = object({
    name_prefix   = string
    replica_count = number
    node_type     = string
    redis_config  = map(string)
    persistence = object({
      mode = string
    })
    security = object({
      transit_encryption_mode = string
    })
    backup = object({
      automated = optional(object({
        retention_days = string
        start_hour     = number
      }))
    })
    maintenance = object({
      weekly_windows = optional(list(object({
        day        = string
        start_hour = number
      })))
    })
  })
}
