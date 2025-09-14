resource "google_secret_manager_secret" "my_secret" {
  name     = "my-secret-name"
  project  = "quantiphi-test-470710"
  secret_id = "test133"
  replication{

  }
}

resource "google_secret_manager_secret_version" "my_secret_version" {
  secret      = google_secret_manager_secret.my_secret.id
  secret_data = var.mysql_root_password
}
