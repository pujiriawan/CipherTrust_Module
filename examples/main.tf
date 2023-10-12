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


locals {
for_each = var.ciphertrust_ha_static_maps
cm-userdata01 = <<USERDATA1
#cloud-config
keysecure:
  default-ca:
    CN: each.value.vmname
    emails:
      - administrator@bank.local
    names:
      - C: ID  
        ST: DKI Jakarta
        L: Jakarta
        O: IT Security Team
        OU: Digital Security
    dns-names:
      - each.value.vmname
    ip-addresses:
      -  each.value.ip_address
  default-server-cert:
    CN: Cloud Init Server 
    emails: 
      - administrator@bank.local
    names:
      - C: ID
        ST: DKI Jakarta
        L: Jakarta
        O: IT Security Team
        OU: Digital Security
    dns-names:
      -  each.value.vmname
    ip-addresses:
      -  each.value.ip_address
  netcfg:
    iface:
      name: ens160
      type: static
      address: each.value.ip_address
      netmask: 255.255.255.128
      gateway: 192.168.234.126
      dns1: 192.168.234.90
diskenc:
  encrypt: true
ssh_authorized_keys:
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwOca/RquSuLrz4wjiR46C8whH7Q0nIp0qIkNk2RzfSW/NjnZ5V5L9nOAXruczck6Dy/S26QP1hLFTr7p6MkTv7oS8h/Wor82qOOdM7SnoTiyb/FsNbiI7ynGqRanin/O67Vjil1a2knMHYn3R8lZirsDdnCeFBGNbNULqYJRqeu7cDA2O7hiXrCS5Ww892X+mLlPCS2Z7iguWHtNR4jwQvVfYM85yi0TeJXijVdFztc5YVV2ybpH4UoWIbKik1OB/PtWOFJFfqik4Vu8hkMq1XEJvkGbgPu2CIaTf7kDKc9HRb3mysYpL0vNRgHJyNE3Q2ojmqWVAVQWvDcOd1g86m6GT+pHOLTHOAdaZdcgF407uh8fL5i/8asiyp+hPiY8iwz9LOFFNXgh5KfFfuNKxKh9vXpT/yQupqWRfneorTwOL9AJ4OP+e99lPIZL1LQk5aFvD3mPh7gniiqkOCgW10+1SRUJ3t+0StGONc+qRq+Tkpm0qpJtdXqbjDQwD9I0= devops@PUJI-AUTOMATION-BOX
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0dOkGs29ZESkUQ7V0Rt0lvjUQ9d06WddUyxSevwOaceC38HCbZD+movZFGxVzf3cCxs+8JJTh27LKwROIAlx48JflNt8rKa6AAANzP6HihA6Q4X8NencLqAfoN6yAkqt6ssbmEKUqpmwjkF9LfOvwkH4pgjs5WsX1BqOoR7v7+ZWNMa28/l2kqHCdbBjLh7E0jSQDU44Wh/uZdsZHvfBLUUlMThujhbdD+xEwgtqMLAPTjsC0UzkJovyVAvWuHnX5jf5JlgAo5SsURVVPzCc0GVcfxey2X/qpJGkd5G0nl5x5s6EatVSI4LREdFgh3WrSU8yqaIMkTYdnniNZ0ZJ0wLC7Me8mmUFyoj50klZCvdyNage8JIT0pzRBmHaGSWCbj8pTYS/CtnJiYA9zweJo/CZYN/CiE8yc+Xh4Mi0Yry2deEdyt2g/STKSnzI7NqxaGfVjgyYYX7EpvAIe/vHQdGmZmDMMddJAE4I7JMPYgS/e3+Big9giwZcNhpYDnDs= noni_princess@Nonis-MacBook-Air.local
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWs7lH0mohTejHS9UTmiBByqP7yjw3+QHGZ5v9QgoDCs1Q5zsJgSkabT29gw68HfyqsomjecFBQAI5AdAUeb6+m8frfaRt/Vq/c/vCyLqh76r7QPeTHU3IIkBnn2BT+BsC11WL3gIU3IU2IiQOuR7moNzhPUhGMf3TpZRjJY0v+46dOV4YzVy0Gx3OzOANZpxMN9jbcvLp6VUIi3jYDaA6ojTrm34PcV6078/BKnThU75iutCoiAh1Wjwl+i1i82bJQY0TP/niOgwkSlnhHGk+HVRIAqNWSsF1F/dmXDTZVqhgJBHwPV/DTKIL7/pQ1FIsRDgcAXcOwVp82xeajzsmUq8k9nibCZOOkL3ZPfqULhc/0o6jW35vIxYTikmsDaLeQiJ1O7Ng8a8o7T8tMBEITUgwIzEzR5WA7ZGg1W9MNBtiMwA16dQqCoqejWTYqSZd3p6S4rceMAO9kuu4OPW2dEk3N++6PEMShX1h7laOlzM/aNAF9H7EErYhjPzMhpk= muhammad nahri@LEARNINGBYDOING

USERDATA1

cm-userdata02 = <<USERDATA2
#cloud-config
keysecure:
  default-ca:
    CN: each.value.vmname
    emails:
      - administrator@bank.local
    names:
      - C: ID  
        ST: DKI Jakarta
        L: Jakarta
        O: IT Security Team
        OU: Digital Security
    dns-names:
      - each.value.vmname
    ip-addresses:
      -  each.value.ip_address
  default-server-cert:
    CN: Cloud Init Server 
    emails: 
      - administrator@bank.local
    names:
      - C: ID
        ST: DKI Jakarta
        L: Jakarta
        O: IT Security Team
        OU: Digital Security
    dns-names:
      -  each.value.vmname
    ip-addresses:
      -  each.value.ip_address
  netcfg:
    iface:
      name: ens160
      type: static
      address:  each.value.ip_address
      netmask: 255.255.255.128
      gateway: 192.168.234.126
      dns1: 192.168.234.90
diskenc:
  encrypt: true
ssh_authorized_keys:
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwOca/RquSuLrz4wjiR46C8whH7Q0nIp0qIkNk2RzfSW/NjnZ5V5L9nOAXruczck6Dy/S26QP1hLFTr7p6MkTv7oS8h/Wor82qOOdM7SnoTiyb/FsNbiI7ynGqRanin/O67Vjil1a2knMHYn3R8lZirsDdnCeFBGNbNULqYJRqeu7cDA2O7hiXrCS5Ww892X+mLlPCS2Z7iguWHtNR4jwQvVfYM85yi0TeJXijVdFztc5YVV2ybpH4UoWIbKik1OB/PtWOFJFfqik4Vu8hkMq1XEJvkGbgPu2CIaTf7kDKc9HRb3mysYpL0vNRgHJyNE3Q2ojmqWVAVQWvDcOd1g86m6GT+pHOLTHOAdaZdcgF407uh8fL5i/8asiyp+hPiY8iwz9LOFFNXgh5KfFfuNKxKh9vXpT/yQupqWRfneorTwOL9AJ4OP+e99lPIZL1LQk5aFvD3mPh7gniiqkOCgW10+1SRUJ3t+0StGONc+qRq+Tkpm0qpJtdXqbjDQwD9I0= devops@PUJI-AUTOMATION-BOX
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0dOkGs29ZESkUQ7V0Rt0lvjUQ9d06WddUyxSevwOaceC38HCbZD+movZFGxVzf3cCxs+8JJTh27LKwROIAlx48JflNt8rKa6AAANzP6HihA6Q4X8NencLqAfoN6yAkqt6ssbmEKUqpmwjkF9LfOvwkH4pgjs5WsX1BqOoR7v7+ZWNMa28/l2kqHCdbBjLh7E0jSQDU44Wh/uZdsZHvfBLUUlMThujhbdD+xEwgtqMLAPTjsC0UzkJovyVAvWuHnX5jf5JlgAo5SsURVVPzCc0GVcfxey2X/qpJGkd5G0nl5x5s6EatVSI4LREdFgh3WrSU8yqaIMkTYdnniNZ0ZJ0wLC7Me8mmUFyoj50klZCvdyNage8JIT0pzRBmHaGSWCbj8pTYS/CtnJiYA9zweJo/CZYN/CiE8yc+Xh4Mi0Yry2deEdyt2g/STKSnzI7NqxaGfVjgyYYX7EpvAIe/vHQdGmZmDMMddJAE4I7JMPYgS/e3+Big9giwZcNhpYDnDs= noni_princess@Nonis-MacBook-Air.local
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWs7lH0mohTejHS9UTmiBByqP7yjw3+QHGZ5v9QgoDCs1Q5zsJgSkabT29gw68HfyqsomjecFBQAI5AdAUeb6+m8frfaRt/Vq/c/vCyLqh76r7QPeTHU3IIkBnn2BT+BsC11WL3gIU3IU2IiQOuR7moNzhPUhGMf3TpZRjJY0v+46dOV4YzVy0Gx3OzOANZpxMN9jbcvLp6VUIi3jYDaA6ojTrm34PcV6078/BKnThU75iutCoiAh1Wjwl+i1i82bJQY0TP/niOgwkSlnhHGk+HVRIAqNWSsF1F/dmXDTZVqhgJBHwPV/DTKIL7/pQ1FIsRDgcAXcOwVp82xeajzsmUq8k9nibCZOOkL3ZPfqULhc/0o6jW35vIxYTikmsDaLeQiJ1O7Ng8a8o7T8tMBEITUgwIzEzR5WA7ZGg1W9MNBtiMwA16dQqCoqejWTYqSZd3p6S4rceMAO9kuu4OPW2dEk3N++6PEMShX1h7laOlzM/aNAF9H7EErYhjPzMhpk= muhammad nahri@LEARNINGBYDOING

USERDATA2
}