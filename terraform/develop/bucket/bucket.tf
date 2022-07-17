resource "google_storage_bucket" "auto-expire" {
  name          = "terraform-state-servian-develop"
  location      = "EU"
  force_destroy = false
  project       = "topgun-servian" 

  lifecycle_rule {
    condition {
      age = 7
    }
    action {
      type = "Delete"
    }
  }
}
