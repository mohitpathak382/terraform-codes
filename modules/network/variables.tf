variable "project_id" {}
variable "region" { default = "us-central1" }

variable "network_name" { 
    default = "gke-vpc"
    type = string
}
variable "subnet_cidr" { default = "10.10.0.0/16" }

variable "cluster_name" { default = "private-gke-cluster" }
variable "master_cidr" { default = "172.16.0.0/28" }
variable "node_count" { default = 2 }
variable "machine_type" { default = "e2-medium" }
variable "local_cidr_block" { }
