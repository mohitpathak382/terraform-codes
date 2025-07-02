project_id = "arboreal-cosmos-461506-n6"
gke_config = {
  name                    = "autopilot-cluster-t1"
  project_id              = "arboreal-cosmos-461506-n6"
  region                  = "us-central1"
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
    service_account = "default"
  }
  master_authorized_networks = [
    {
      cidr_block   = "10.10.0.0/16"
      display_name = "vpc-cider-range"
    }
  ]
}

vpc_config = [ {
  auto_create_subnetworks : false,
    description : "Private GKE Vpc",
    firewall_rules : [],
    network_name : "gke-vpc",
    project_id : "arboreal-cosmos-461506-n6",
    routes : [],
    secondary_ranges : {
        "gke-cluster-subnet" : [
        { range_name : "pod", ip_cidr_range : "10.10.6.0/24" },
        { range_name : "svc", ip_cidr_range : "10.10.7.0/24" }
        ]
    },
    subnets : [
      {
        subnet_name : "gke-vpc-subnet",
        subnet_ip : "10.10.0.0/16",
        subnet_region : "us-central1",
        subnet_private_access : true,
      }
    ]
} 
]


# sql_config = {
#   project_id       = "arboreal-cosmos-461506-n6"
#   region           = "us-central1"
#   instance_name    = "my-cloudsql"
#   database_version = "MYSQL_8_0"
#   tier             = "db-f1-micro"

#   private_network     = "projects/arboreal-cosmos-461506-n6/global/networks/gke-vpc"
#   enable_public_ip    = false
#   deletion_protection = false

#   authorized_networks = []

#   # users = [
#   #   {
#   #     name     = "admin"
#   #     password = "supersecret"
#   #   }
#   # ]

#   # databases = ["appdb"]

#   backup_enabled         = true
#   backup_start_time      = "03:00"
#   point_in_time_recovery = false
# }

sql_config = {
  project_id       = "arboreal-cosmos-461506-n6"
  region           = "us-central1"
  instance_name    = "postgres-test-instance"
  database_version = "POSTGRES_15"
  tier             = "db-custom-1-3840"

  private_network  = "projects/arboreal-cosmos-461506-n6/global/networks/gke-vpc"
  enable_public_ip = false

  users = [
    {
      name     = "postgres_admin"
      password = "strongpass123"
    }
  ]

  databases = ["app_db"]

  authorized_networks = []

  backup_enabled         = true
  backup_start_time      = "03:00"
  point_in_time_recovery = true
}
