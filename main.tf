terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 5.11.0"
    }
  }
}

locals {
  virtual_networks = [
    "dev",
    "google"
  ]
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

resource "cloudflare_zero_trust_tunnel_cloudflared_virtual_network" "vnet" {
  for_each = toset(local.virtual_networks)
  name = each.key
  account_id = data.cloudflare_account.zaridias.account_id
}

data "cloudflare_zero_trust_tunnel_cloudflared_virtual_network" "development" {
  filter = {
    name = "dev"
  }
  account_id = data.cloudflare_account.zaridias.account_id
}

resource "cloudflare_zero_trust_gateway_policy" "development_allow_github" {
  account_id  = data.cloudflare_account.zaridias.account_id
  name        = "Development - Allow Github"
  description = "Ensure access to the application comes from authorized WARP clients"
  precedence  = 1000
  enabled     = true
  action      = "allow"
  traffic     = "any(net.sni.domains[*] == \"github.com\")"
}

resource "cloudflare_zero_trust_gateway_policy" "development_default_block" {
  account_id  = data.cloudflare_account.zaridias.account_id
  name        = "Development - Default Block"
  description = "Ensure access to the application comes from authorized WARP clients"
  precedence  = 1900
  enabled     = true
  action      = "block"
  traffic     = "any(net.vnet_id == \"${data.cloudflare_zero_trust_tunnel_cloudflared_virtual_network.development.id}\")"
}