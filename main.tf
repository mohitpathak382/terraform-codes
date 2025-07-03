module "network" {
  for_each = { for vpc in var.vpc_config : vpc.network_name => vpc }
  source       = "./modules/network"
  vpc_config = each.value
}

module "gke_clusters" {
  source = "./modules/gke"

  for_each = {
    for config in local.gke_cluster_configs : "${config.project_id}-${config.region}" => config
  }

  gke_config = {
    project_id                 = each.value.project_id
    region                     = each.value.region
    name                       = each.value.name
    network                    = each.value.network
    subnetwork                 = each.value.subnetwork
    release_channel            = each.value.release_channel
    enable_autopilot           = each.value.enable_autopilot
    enable_private_nodes       = each.value.enable_private_nodes
    enable_private_endpoint    = each.value.enable_private_endpoint
    deletion_protection        = each.value.deletion_protection
    pod_range                  = each.value.pod_range
    service_range              = each.value.service_range
    master_ipv4_cidr_block     = each.value.master_ipv4_cidr_block
    master_authorized_networks = each.value.master_authorized_networks
    service_account            = each.value.service_account
  }
  depends_on = [ module.network ]
}


# module "sql" {
#   source     = "./modules/sql"
#   sql_config = var.sql_config

#   depends_on = [ module.network ]
# }
