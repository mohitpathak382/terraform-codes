variable "cluster" {
  description = "Core configuration for the Redis cluster"
  type = object({
    project_id = string
    region     = string
    name       = string
    # psc_networks  = list(string)
    shard_count   = number
    replica_count = number
    node_type     = string
  })
}

variable "network" {
  description = "Network configuration including PSC networks"
  type = object({
    psc_networks = list(string)
  })
}

variable "redis_config" {
  description = "Custom Redis configuration"
  type        = map(string)
  default     = {}
}

variable "persistence" {
  description = "Persistence configuration"
  type = object({
    mode = string
  })
  default = {
    mode = "DISABLED"
  }
}

variable "security" {
  description = "Security settings including transit encryption"
  type = object({
    transit_encryption_mode = optional(string)
  })
  default = {}
}

variable "backup" {
  description = "Backup configuration"
  type = object({
    automated = optional(object({
      retention_days = optional(string)
      start_hour     = optional(number)
    }))
  })
  default = {}
}

variable "maintenance" {
  description = "Maintenance policy settings"
  type = object({
    weekly_windows = optional(list(object({
      day        = string
      start_hour = number
    })))
  })
  default = {}
}
