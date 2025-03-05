resource "google_storage_bucket" "media_bucket" {
  name     = "aicc-proj-1.firebasestorage.app"
  location = "US-CENTRAL1"

  uniform_bucket_level_access = true #IAM

  lifecycle_rule {
    condition {
      age = 90 # delete vids after 90 days
      matches_prefix = ["videos/"]
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket_iam_member" "allow_cloudrun_access" {
  bucket = google_storage_bucket.media_bucket.name
  role = "roles/storage.objectAdmin" #Full read write access will be provisioned for the cloud run service account
  member   = "serviceAccount:174827312206-compute@developer.gserviceaccount.com"
}
