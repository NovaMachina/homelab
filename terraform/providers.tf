terraform {
  required_version = ">= 0.14"
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

variable "proxmox_url" {
  type = string
  default = "https://localhost"
}

variable "proxmox_token_secret" {
  type = string
  default = "api_token"
}

variable "proxmox_token_id" {
  type = string
  default = "root@pam!terraform"
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "${format("%s%s", var.proxmox_url, "/api2/json")}"
    pm_api_token_secret = var.proxmox_token_secret
    pm_api_token_id = var.proxmox_token_id
}