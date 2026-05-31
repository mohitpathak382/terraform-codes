sql_config = {
  instance_name       = "my-postgres-instance"
  project_id          = "my-gcp-project"
  region              = "asia-south1"
  database_version    = "POSTGRES_15"
  tier                = "db-f1-micro"

  availability_type   = "ZONAL"
  disk_type           = "PD_SSD"
  disk_size           = 20
  deletion_protection = false
}