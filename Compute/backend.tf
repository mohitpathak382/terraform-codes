terraform {
  backend "gcs" {
    bucket  = "terraform-state-bkt2312"
    prefix  = "terraform/state/compute"  # optional folder inside the bucket to organize states
  }
}
