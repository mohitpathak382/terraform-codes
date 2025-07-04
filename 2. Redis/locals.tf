
locals {
  redis_cluster_configs = flatten([
    for project_id, project_config in var.redis_project_configs : [
      for region in var.regions : {
        project_id = project_id
        region = region
        name = "${var.common_redis_config.name_prefix}-${project_id}-${region}"
        network = "projects/${project_id}/global/networks/${project_config.network_name}"
        psc_networks = try(project_config.region_configs[region].psc_networks, ["projects/${project_id}/global/networks/${project_config.network_name}"])
        shard_count = project_config.region_configs[region].shard_count
        replica_count = try(project_config.region_configs[region].replica_count, var.common_redis_config.replica_count)
        node_type = try(project_config.region_configs[region].node_type, var.common_redis_config.node_type)
        redis_config = try(project_config.region_configs[region].redis_config, var.common_redis_config.redis_config)
        persistence = try(project_config.region_configs[region].persistence, var.common_redis_config.persistence)
        security = try(project_config.region_configs[region].security, var.common_redis_config.security)
        backup = try(project_config.region_configs[region].backup, var.common_redis_config.backup)
        maintenance = try(project_config.region_configs[region].maintenance, var.common_redis_config.maintenance)
      }
    ]
  ])
}