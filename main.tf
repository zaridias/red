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
  is_ui_read_only = true
  account_id = data.cloudflare_account.zaridias.account_id
}