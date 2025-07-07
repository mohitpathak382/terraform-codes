

vpc_config = [{
  project_id              = "arboreal-cosmos-461506-n6"
  network_name            = "gke-vpc"
  auto_create_subnetworks = false
  description             = "Private GKE VPC"
  subnets = [
    {
      subnet_name           = "gke-vpc-subnet"
      subnet_ip             = "10.10.0.0/16"
      subnet_region         = "us-central1"
      subnet_private_access = true
    }
  ]

  secondary_ranges = {
    # MUST match the subnet_name above exactly
    "gke-vpc-subnet" = [
      { range_name = "pods-range", ip_cidr_range = "10.30.6.0/24" },
      { range_name = "services-range", ip_cidr_range = "10.20.7.0/24" }
    ]
  }

  firewall_rules = []
  routes         = []
}]