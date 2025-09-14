# variable "dynamic_secrets" {
#   description = "Map of secrets to create in Secret Manager"
#   type        = map(string)
#   default     = {}
# } 

# # Create the secrets 
# resource "google_secret_manager_secret" "dynamic_secrets" {
#   for_each  = var.dynamic_secrets
 
#   project   = var.project_id 
#   secret_id = each.key

#   replication {
#     user_managed {
#       replicas {
#         location = "us-central1"
#       }
#     }
#   }
# }

# # Upload the corresponding secret values
# resource "google_secret_manager_secret_version" "dynamic_secret_versions" {
#   for_each     = var.dynamic_secrets
#   secret       = google_secret_manager_secret.dynamic_secrets[each.key].id
#   secret_data  = each.value
# }
