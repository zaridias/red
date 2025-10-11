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