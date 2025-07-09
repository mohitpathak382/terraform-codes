gke_project_configs = {
  "arboreal-cosmos-461506-n6" = {
    network_name = "gke-vpc"
    regions = {
      "us-central1" = {
        subnet_name         = "gke-vpc-subnet"
        pods_range_name     = "pods-range"
        services_range_name = "services-range"
        master_cidr         = "172.16.0.0/28" # Keep minimal for control plane
        service_account     = "gke-autopilot-sa@arboreal-cosmos-461506-n6.iam.gserviceaccount.com"
        authorized_networks = [
          {
            cidr_block   = "10.10.0.0/16"
            display_name = "internal-access"
          },
          {
            cidr_block   = "35.235.240.0/20" # Required for IAP if needed
            display_name = "iap"
          }
        ]
      },
      "us-eas1" = {
        master_cidr     = "172.16.0.0/28" # Keep minimal for control plane
        service_account = "gke-autopilot-sa@arboreal-cosmos-461506-n6.iam.gserviceaccount.com"
        authorized_networks = [
          {
            cidr_block   = "10.10.0.0/16"
            display_name = "internal-access"
          },
          {
            cidr_block   = "35.235.240.0/20" # Required for IAP if needed
            display_name = "iap"
          }
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
  binary_authorization_mode   = "ALWAYS_DENY"
}
