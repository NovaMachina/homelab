terraform {
  required_version = ">= 0.14"
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://<server-location>/api2/json"
    pm_api_token_secret = "<api-token>"
    pm_api_token_id = "root@pam!terraform"
}