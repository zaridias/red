terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 5.11.0"
    }
  }
}

data "cloudflare_account" "zaridias" {
  filter = {
    name = "Pridgenryanjeremy@gmail.com"
  }
}

resource "cloudflare_zero_trust_organization" "amg45" {
  name = "amg45coupe"
  auth_domain = "amg45coupe.cloudflareaccess.com"
  is_ui_read_only = true
  auto_redirect_to_identity = true
  allow_authenticate_via_warp = true
  account_id = data.cloudflare_account.zaridias.account_id
}