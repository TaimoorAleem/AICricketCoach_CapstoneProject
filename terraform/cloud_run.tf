resource "google_cloud_run_service" "container" {
  name     = "my-app-image"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/aicc-proj-1/my-app-image:latest"

        env {
          name = "FIREBASE_CREDENTIALS"
          value_from {
            secret_key_ref {
              name = "firebase-creds"
              key  = "1"
            }
          }
        }
      }
    }
  }
}
