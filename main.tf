provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source       = "./modules/network"
  network_name = var.network_name
  region       = var.region
  subnet_cidr  = var.subnet_cidr
  local_cidr_block = var.local_cidr_block
  project_id = var.project_id 
}

module "gke" {
  source           = "./modules/gke"
  gke_config = var.gke_config
}

