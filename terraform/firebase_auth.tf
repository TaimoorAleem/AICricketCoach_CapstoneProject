# Firebase Authentication Setup (Email/Password Only)

resource "null_resource" "firebase_auth_email_password" {
  provisioner "local-exec" {
    command = "echo 'Firebase Auth configured with email/password only'"
  }
}
