project_id       = "arboreal-cosmos-461506-n6"
local_cidr_block = "34.126.65.25/32"
gke_config = {
  name                    = "autopilot-cluster-t1"
  region                  = "us-central1"
  project_id              = "arboreal-cosmos-461506-n6"
  network                 = "projects/arboreal-cosmos-461506-n6/global/networks/gke-vpc"
  subnetwork              = "projects/arboreal-cosmos-461506-n6/regions/us-central1/subnetworks/gke-vpc-subnet"
  pod_range               = "pods-range"
  service_range           = "services-range"
  enable_autopilot        = true
  enable_private_endpoint = true
  enable_private_nodes    = true
  master_ipv4_cidr_block  = "172.16.0.0/28"
  release_channel         = "REGULAR"
  auto_provisioning_defaults = {
    service_account         = "default"
    }
  master_authorized_networks = [
    {
      cidr_block   = "10.10.0.0/16"
      display_name = "vpc-cider-range"
    }
  ]
}
