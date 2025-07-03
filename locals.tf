locals {
  gke_cluster_configs = flatten([
    for project_id in var.project_ids : [
      for region in var.regions : {
        project_id                 = project_id
        region                     = region
        name                       = "${var.common_config.name_prefix}-${region}"
        network                    = var.project_network_map[project_id].network
        subnetwork                 = var.project_network_map[project_id].subnetwork
        release_channel            = var.common_config.release_channel
        enable_autopilot           = var.common_config.enable_autopilot
        enable_private_nodes       = var.common_config.enable_private_nodes
        enable_private_endpoint    = var.common_config.enable_private_endpoint
        deletion_protection        = try(var.common_config.deletion_protection, false)
        pod_range                  = var.pod_range_map[project_id][region]
        service_range              = var.service_range_map[project_id][region]
        master_ipv4_cidr_block     = var.master_cidr_map[project_id][region]
        master_authorized_networks = try(var.authorized_networks_map[project_id][region], [])
        service_account            = try(var.service_account_map[project_id][region], null)
      }
    ]
  ])
}
