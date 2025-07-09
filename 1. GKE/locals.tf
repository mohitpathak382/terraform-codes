locals {
  gke_cluster_configs = flatten([
    for project_id, project_config in var.gke_project_configs : [
      for region, region_config in project_config.regions : {
        project_id                  = project_id
        region                      = region
        name                        = "${var.common_gke_config.name_prefix}-${region}"
        network                     = "projects/${project_id}/global/networks/${project_config.network_name}"
        subnetwork                  = "projects/${project_id}/regions/${region}/subnetworks/${region_config.subnet_name}"
        release_channel             = var.common_gke_config.release_channel
        enable_autopilot            = var.common_gke_config.enable_autopilot
        enable_private_nodes        = var.common_gke_config.enable_private_nodes
        enable_private_endpoint     = var.common_gke_config.enable_private_endpoint
        deletion_protection         = try(var.common_gke_config.deletion_protection, false)
        pod_range                   = region_config.pods_range_name
        service_range               = region_config.services_range_name
        master_ipv4_cidr_block      = region_config.master_cidr
        master_authorized_networks  = try(region_config.authorized_networks, [])
        service_account             = try(region_config.service_account, null)
        enable_binary_authorization = try(region_config.enable_binary_authorization, false)
        binary_authorization_mode   = try(region_config.binary_authorization_mode, "ALWAYS_DENY")
      }
    ]
  ])
}