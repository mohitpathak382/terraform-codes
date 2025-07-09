module "redis_clusters" {
  source = "../modules/redis-cluster"

  for_each = {
    for config in local.redis_cluster_configs : "${config.project_id}-${config.region}" => config
  }

  cluster = {
    project_id = each.value.project_id
    region     = each.value.region
    name       = each.value.name
    # psc_networks  = each.value.psc_networks
    shard_count   = each.value.shard_count
    replica_count = each.value.replica_count
    node_type     = each.value.node_type
  }

  network      = { psc_networks = each.value.network }
  redis_config = each.value.redis_config
  persistence  = each.value.persistence
  security     = each.value.security
  backup       = each.value.backup
  maintenance  = each.value.maintenance
}
