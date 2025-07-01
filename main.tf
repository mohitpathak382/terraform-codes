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
  cluster_name     = var.cluster_name
  region           = var.region
  network          = module.network.network_name
  subnetwork       = module.network.subnetwork_name
  master_cidr      = var.master_cidr
  node_count       = var.node_count
  machine_type     = var.machine_type
  local_cidr_block = var.local_cidr_block
}
