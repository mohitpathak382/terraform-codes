variable "regions" {
  description = "List of GCP regions used across all projects"
  type        = list(string)
}

variable "redis_project_configs" {
  description = "Map of Redis project configurations including network and region-specific shard/subnetwork settings"
  type = map(object({
    network_name = string
    region_configs = map(object({
      shard_count     = number
      subnet = string
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
