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

    ip_configuration {
      ipv4_enabled    = true
    #   private_network = try(var.sql_config.private_network, null)
    }
  }
}