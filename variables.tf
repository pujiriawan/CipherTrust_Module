variable "ovf_file" {
  type        = string
  description = "vSphere GuestOS Remote URL OVF"
  default = ""
}

variable "vsphere_ovf_vm_template_name" {
  default = ""
  description = "vSphere GuestOS Remote URL OVF"
  type        = string
}

variable "dc" {
  description = "vSphere Datastore name"
  type        = string
  default = ""
}

variable "vs_cluster" {
  description = "vSphere Cluster name"
  type        = string
  default = ""
}

variable "vs_datastore" {
  description = "vSphere Datastore name"
  type        = string
  default = ""
}

variable "vs_host_cluster" {
  description = "vSphere Host or Cluster"
  type        = string
  default = ""
}

variable "vmname" {
    type = string
    description = "This is define for environment vm will build"
    default = "CIPHERTUST"
}

variable "vs_network_data" {
    type = string
    description = "This is define for network interface type"
    default = "VM Network"
}

#variable "user-data" {
#    type = string
#    description = "This is define for cloud init file"
#    default = ""
#}

variable "script_path_ansible" {
    type = string
    description = "this is script for ansible"
    default = ""
}