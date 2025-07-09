# Input variable for configuring the GKE cluster
variable "gke_config" {
  description = "Configuration for the GKE cluster"
  type = object({
    project_id              = string   # GCP project ID where the cluster will be created
    region                  = string   # Region for the GKE cluster
    name                    = string   # Name of the GKE cluster
    network                 = string   # Name or self-link of the VPC network
    subnetwork              = string   # Name or self-link of the subnetwork (must include secondary IP ranges)
    release_channel         = string   # GKE release channel (e.g., STABLE, REGULAR, RAPID)
    enable_autopilot        = bool     # Whether to use Autopilot mode
    enable_private_nodes    = bool     # Whether nodes should have internal IPs only
    enable_private_endpoint = bool     # Restrict master API to internal access only
    deletion_protection     = bool     # Prevent cluster deletion (recommended for production)
    pod_range               = string   # Name of the secondary range for Pods in the subnetwork
    service_range           = string   # Name of the secondary range for Services in the subnetwork
    master_ipv4_cidr_block  = string   # CIDR range for the master control plane
    service_account             = optional(string) # (Optional) IAM service account for node auto-provisioning
    enable_binary_authorization = bool             # Whether to enable Binary Authorization
    binary_authorization_mode   = string           # Binary Authorization evaluation mode (e.g., ALWAYS_ALLOW, ALWAYS_DENY)
  })
}
