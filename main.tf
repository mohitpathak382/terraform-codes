module "network" {
  for_each = { for vpc in var.vpc_config : vpc.network_name => vpc }
  source       = "./modules/network"
  vpc_config = each.value
}

module "gke" {
  source           = "./modules/gke"
  gke_config = var.gke_config
  depends_on = [ module.network ]
}

