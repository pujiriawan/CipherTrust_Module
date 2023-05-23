variable "vsphere_password" {
  description = "vSphere login password"
  type        = string
  sensitive   = true
  default = ""
}

variable "vsphere_user" {
  description = "vSphere login username"
  type        = string
  sensitive   = true
  default = ""
}

variable "vcenter_server" {
  type = string
  sensitive = true
  description = "location of vcenter server"
  default = ""
}

variable "user_administrator_domain" {
  type = string
  sensitive = true
  description = "user for domain account"
  default = ""
}

variable "ciphertrust_ha_static_maps" {
   description = "This is variable to define how many vm ciphertrust will be created, to enable uncomment"
   type = map(object({
    vmname = string
    vs_network_data = string
    user-data = string
    script_path_ansible = string
  }))
    default = {
      "CIPHERTRUST" = {
        vmname = "CIPHERTRUST"
        vs_network_data = "VM Network"
        user-data = "userdata-CTM01.yaml"
        #location of ansible playbook in local computer or ansible controller  machine
        #ansible.cfg and inventory file must be already configured
        script_path_ansible = "/home/devops/"
      }
      #"CIPHERTRUST" = {
      #  vmname = "CIPHERTRUST"
      #  vs_network_data = "VM Network"
      #  user-data = "userdata-CTM01.yaml"
      #  script_path_ansible = "/home/devops/Ciphertrust_Manager/Configuration-Management"
      #}
    }
}

module "ciphertrust" {
  source = "git::https://github.com/pujiriawan/CipherTrust_Module"
  for_each = var.ciphertrust_ha_static_maps
  vmname = each.value.vmname
  vs_network_data = each.value.vs_network_data
  user-data = each.value.user-data
  script_path_ansible = each.value.script_path_ansible
  dc = "DC-SUPARK"
  vs_cluster = "CLTR-SUPARK"
  vs_datastore = "EMC-DS1"
  vs_host_cluster = "192.168.230.12"
  ovf_file = "http://192.168.234.90/kickstart/Thales-Ciphertrust-2-10.ovf"
}