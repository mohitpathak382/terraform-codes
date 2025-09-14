project_id  = "your-gcp-project-id"
region      = "us-central1"
zone        = "us-central1-a"
subnetwork  = "default"

frontend_config = {
  count          = 3
  machine_type   = "e2-medium"
  startup_script = "echo 'hel' "
  
  tags           = ["frontend"]
  labels         = {
    role = "frontend"
  }
} 

backend_config = {
  count          = 4
  machine_type   = "e2-standard-4"
  startup_script = "echo 'hel' "
  tags           = ["backend"]
  labels         = {
    role = "backend"
  }
}
