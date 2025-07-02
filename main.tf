module "network" {
  for_each = { for vpc in var.vpc_config : vpc.network_name => vpc }
  source       = "./modules/network"
  vpc_config = each.value
}

# module "gke" {
#   source           = "./modules/gke"
#   gke_config = var.gke_config
#   depends_on = [ module.network ]
# }


data "google_compute_network" "vpc" {
  name    = "gke-vpc"
  project = var.project_id
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-service-connect-range"
  project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  address       = "192.168.0.0"
  network       = data.google_compute_network.vpc.self_link # must be the full self_link
}

resource "google_project_service" "service_networking" {
  service = "servicenetworking.googleapis.com"
  project = var.project_id
}

resource "google_service_networking_connection" "vpc_connection" {
  network                 = data.google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]

  depends_on = [
    google_project_service.service_networking,
    google_compute_global_address.private_ip_alloc
  ]
}

module "sql" {
  source     = "./modules/sql"
  sql_config = var.sql_config

  depends_on = [ module.network ]
}
