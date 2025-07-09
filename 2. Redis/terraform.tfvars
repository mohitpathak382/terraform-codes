regions = ["us-central1"]

redis_project_configs = {
  arboreal-cosmos-461506-n6 = {
    network_name = "gke-vpc"
    region_configs = {
      us-central1 = {
        shard_count   = 1
        replica_count = 0
        node_type     = "REDIS_SHARED_CORE_NANO"
        subnet = "gke-subnet"
      }
    }
  }
}

common_redis_config = {
  name_prefix   = "rediscluster"
  replica_count = 0
  node_type     = "REDIS_SHARED_CORE_NANO"

  redis_config = {
    maxmemory-policy       = "allkeys-lru"
    notify-keyspace-events = "Ex"
  }

  persistence = {
    mode = "DISABLED"
  }

  security = {
    transit_encryption_mode = "TRANSIT_ENCRYPTION_MODE_DISABLED"
  }

  backup = {
    automated = null
  }

  maintenance = {
    weekly_windows = null
  }
}
