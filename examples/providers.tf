################################################################################
# VMware ESXi - Provider
################################################################################

terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = ">= 2.2.0"
    }
  }
  required_version = ">= 0.13"
}

provider "vsphere" {
  user = var.vsphere_user
  password = var.vsphere_password
  vsphere_server = var.vcenter_server
  allow_unverified_ssl = true
}
