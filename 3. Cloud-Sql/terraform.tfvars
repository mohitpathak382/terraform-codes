common_sql_config = {
  tier                   = "db-f1-micro"
  disk_type              = "PD_SSD"
  disk_size              = 10
  availability_type      = "ZONAL"
  activation_policy      = "ALWAYS"
  enable_public_ip       = true
  deletion_protection    = false
  backup_enabled         = true
  backup_start_time      = "03:00"
  point_in_time_recovery = false

  users = [
    {
      name     = "admin"
      password = "admin123"
      host     = null
    }
  ]

  databases = ["sample_db"]
}

sql_project_configs = {
  "arboreal-cosmos-461506-n6" = {
    network_name = ""
    regions = {
      "us-central1" = {
        database_versions = ["POSTGRES_15"]
        authorized_networks = [
          {
            name  = "corp"
            value = "203.0.113.0/24"
          }
        ]
      }

      "us-east1" = {
        database_versions = ["POSTGRES_15"]
      }
    }
  }
}
