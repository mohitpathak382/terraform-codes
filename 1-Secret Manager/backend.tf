terraform {
  backend "gcs" {
    bucket  = "terraform-state-bkt2312"
    prefix  = "terraform/state/secrets-manager"  # optional folder inside the bucket to organize states
  }
}
