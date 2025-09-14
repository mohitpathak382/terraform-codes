project_id  = "quantiphi-test-470710"
region      = "us-central1"
zone        = "us-central1-a"
subnetwork  = "default"

frontend_config = {
  count          = 3
  # machine_type   = "e2-medium"
  startup_script = "echo 'helO' "
  
  tags           = ["frontend"]
  labels         = {
    role = "frontend"
  }
} 
