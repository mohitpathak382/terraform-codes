gke_project_configs = {
  "arboreal-cosmos-461506-n6" = {
    network_name = "gke-vpc"
    regions = {
      "us-central1" = {
        subnet_name         = "gke-subnet"
        pods_range_name     = "pods-range"
        services_range_name = "services-range"
        master_cidr         = "172.16.0.0/28" # Keep minimal for control plane
        service_account     = ""
        authorized_networks = [
        ]
      }
    }
  }
}

common_gke_config = {
  name_prefix                 = "autopilot-cluster-t1"
  release_channel             = "REGULAR"
  enable_autopilot            = true
  enable_private_nodes        = true
  enable_private_endpoint     = true
  deletion_protection         = false
  enable_binary_authorization = true
  binary_authorization_mode   = "PROJECT_SINGLETON_POLICY_ENFORCE"
}
