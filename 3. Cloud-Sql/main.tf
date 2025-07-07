module "cloud_sql_instances" {
  for_each = {
    for cfg in local.sql_instance_configs : cfg.instance_key => cfg
  }

  source = "./modules/sql"

  sql_config = merge(
    var.common_sql_config,
    {
      project_id          = each.value.project_id
      region              = each.value.region
      instance_name       = each.value.instance_name
      database_version    = each.value.database_version
      private_network     = each.value.private_network
      authorized_networks = each.value.authorized_networks
    }
  )
}
