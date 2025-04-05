resource "google_cloud_run_service" "ApiContainer" {
  name     = "my-app-image"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/aicc-proj-1/my-app-image:latest"
        timeoutSeconds="500"

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
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "0"
        "autoscaling.knative.dev/maxScale" = "5"
      }
    }
  }
}
resource "google_cloud_run_service" "VpContainer" {
  name     = "my-vp-app"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/aicc-proj-1/my-vp-app:v3"
        timeoutSeconds="500"
        resources {
          limits {
            cpu: "4000m"
            memory: "2Gi"

          }
        }
        startup_probe {
          failure_threshold = "3"
        }

        env {
          name = "ROBOFLOW_CREDENTIALS"
          value_from {
            secret_key_ref {
              name = "roboflow-creds-creds"
              key  = "1"
            }
          }
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "0"
        "autoscaling.knative.dev/maxScale" = "5"
      }
    }
  }
}