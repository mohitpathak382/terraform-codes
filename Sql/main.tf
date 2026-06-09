terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.sql_config.project_id
  region  = var.sql_config.region
}

module "cloudsql" {
  source = "git::https://github.com/mohitpathak382/terraform-codes.git//modules/sql?"
  version = "v1.0.2"

  sql_config = var.sql_config
}