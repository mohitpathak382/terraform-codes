variable "sql_config" {
  description = "Cloud SQL configuration block"
  type = object({
    project_id       = string
    region           = string
    instance_name    = string
    database_version = string
    tier             = string

    availability_type   = optional(string)
    disk_type           = optional(string)
    disk_size           = optional(number)
    activation_policy   = optional(string)
    deletion_protection = optional(bool)
    enable_public_ip    = optional(bool)
    private_network     = optional(string)

    authorized_networks = optional(list(object({
      name  = string
      value = string
    })))

    backup_enabled         = optional(bool)
    backup_start_time      = optional(string)
    point_in_time_recovery = optional(bool)

    users = optional(list(object({
      name     = string
      password = string
      host     = optional(string)
    })))

    databases = optional(list(string))
  })
}
