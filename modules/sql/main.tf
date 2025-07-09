resource "google_sql_database_instance" "instance" {
  name                = var.sql_config.instance_name
  project             = var.sql_config.project_id
  region              = var.sql_config.region
  database_version    = var.sql_config.database_version
  deletion_protection = try(var.sql_config.deletion_protection, false)

  settings {
    tier              = var.sql_config.tier
    availability_type = try(var.sql_config.availability_type, "ZONAL")
    disk_type         = try(var.sql_config.disk_type, "PD_SSD")
    disk_size         = try(var.sql_config.disk_size, 10)
    activation_policy = try(var.sql_config.activation_policy, "ALWAYS")

    ip_configuration {
      ipv4_enabled    = try(var.sql_config.enable_public_ip, false)
      private_network = try(var.sql_config.private_network, null)

      dynamic "authorized_networks" {
        for_each = var.sql_config.authorized_networks != null ? var.sql_config.authorized_networks : []
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }

    }

    backup_configuration {
      enabled                        = try(var.sql_config.backup_enabled, true)
      start_time                     = try(var.sql_config.backup_start_time, "12:00")
      point_in_time_recovery_enabled = try(var.sql_config.point_in_time_recovery, false)
    }
  }
}

resource "google_sql_user" "users" {
  for_each = { for u in try(var.sql_config.users, []) : u.name => u }

  name     = each.value.name
  project  = var.sql_config.project_id
  instance = google_sql_database_instance.instance.name
  password = each.value.password
  host     = try(each.value.host, null)
}

resource "google_sql_database" "databases" {
  for_each = toset(try(var.sql_config.databases, []))

  name     = each.key
  project  = var.sql_config.project_id
  instance = google_sql_database_instance.instance.name
}  