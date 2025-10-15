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

resource "cloudflare_zero_trust_device_default_profile" "this" {
  account_id = data.cloudflare_account.zaridias.account_id
  allow_mode_switch = false
  allow_updates = false
  register_interface_ip_with_dns = true
  allowed_to_leave = false
  auto_connect = 10
  disable_auto_fallback = true
  exclude = []
  service_mode_v2 = {
    mode = "warp"
    port = 5627
  }
  warp_mode = "masque"
}

resource "cloudflare_zero_trust_device_settings" "example_zero_trust_device_settings" {
  account_id = data.cloudflare_account.zaridias.account_id
  disable_for_time = 0
  gateway_proxy_enabled = true
  gateway_udp_proxy_enabled = true
  root_certificate_installation_enabled = true
  use_zt_virtual_ip = true
}
