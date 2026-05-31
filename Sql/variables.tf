variable "sql_config" {
  description = "Cloud SQL instance configuration"

  type = object({
    instance_name         = string
    project_id            = string
    region                = string
    database_version      = string
    tier                  = string

    availability_type     = optional(string)
    disk_type             = optional(string)
    disk_size             = optional(number)
    deletion_protection   = optional(bool)
    private_network       = optional(string)
  })
}