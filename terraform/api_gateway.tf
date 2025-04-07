resource "google_api_gateway_api" "cricket_api" {
  api_id = "aicc_api"
}

resource "google_api_gateway_api_config" "cricket_config" {
  api      = "aicc_api"
  config_id = "config13"

  openapi_documents {
    document {
      path     = "api-spec.yaml"
      contents = file("${path.module}/api-spec.yaml")
    }
  }
}

resource "google_api_gateway_gateway" "cricket_gateway" {
  name     = "aicc-gateway2"
  api      = "aicc_api"
  api_config = "config13"
  location = "us-central1"
}
