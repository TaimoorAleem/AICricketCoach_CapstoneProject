resource "google_firestore_database" "default" {
  name     = "(default)"
  type     = "FIRESTORE_NATIVE"
  location_id = "us-central1"
}
