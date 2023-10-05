data "vsphere_datacenter" "dc" {
  name = var.dc
}

data "vsphere_compute_cluster" "cluster" {
name = var.vs_cluster
datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vs_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "Data" {
  name          = var.vs_network_data
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = var.vs_host_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_ovf_vm_template" "ovf" {
  name = var.vmname
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id   = data.vsphere_host.host.id
  disk_provisioning = "thin"
  enable_hidden_properties = "true"
  remote_ovf_url   = var.ovf_file
  ip_protocol       = "IPv4"
  ovf_network_map = {
     "VM Network" = data.vsphere_network.Data.id
    }
}

data "template_file" "connection_node_ciphertrust" {
  template = "${file("${path.module}/templates/connection_node_ciphertrust.tpl")}"
}

resource "vsphere_virtual_machine" "ciphertrust" {
  datacenter_id = data.vsphere_datacenter.dc.id
  name = var.vmname
  num_cpus         = data.vsphere_ovf_vm_template.ovf.num_cpus
  memory           = data.vsphere_ovf_vm_template.ovf.memory
  guest_id         = data.vsphere_ovf_vm_template.ovf.guest_id
  resource_pool_id = data.vsphere_ovf_vm_template.ovf.resource_pool_id
  datastore_id     = data.vsphere_ovf_vm_template.ovf.datastore_id
  host_system_id   = data.vsphere_ovf_vm_template.ovf.host_system_id
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  scsi_type = "lsilogic"
  network_interface {
    network_id = data.vsphere_network.Data.id
  }
  ovf_deploy {
    allow_unverified_ssl_cert = true
    disk_provisioning    = data.vsphere_ovf_vm_template.ovf.disk_provisioning 
    remote_ovf_url       = data.vsphere_ovf_vm_template.ovf.remote_ovf_url
    enable_hidden_properties = data.vsphere_ovf_vm_template.ovf.enable_hidden_properties
    ip_protocol          = data.vsphere_ovf_vm_template.ovf.ip_protocol
    ovf_network_map = data.vsphere_ovf_vm_template.ovf.ovf_network_map
  }

  cdrom {
    client_device = true
  }

  vapp {
    properties = {
      user-data = var.user-data
    }
  }

  extra_config = {
   "guestinfo.userdata"          =  var.user-data
   "guestinfo.userdata.encoding" = "base64"
 }

 lifecycle {
    ignore_changes = [
      annotation,
      disk[0].io_share_count,
      disk[1].io_share_count,
      disk[2].io_share_count,
      vapp[0].properties,
    ]
  }
}


# Generate Ciphertrust Connection node for ansible
resource "local_file" "connection_node" {
depends_on = [vsphere_virtual_machine.ciphertrust]
content  = "${data.template_file.connection_node_ciphertrust.rendered}"
filename = var.file_path
}

# This is ansible playbook will call ansible collection create by Thales Team https://github.com/thalescpl-io/CDSP_Orchestration
resource "null_resource" "change_initial_password" {
    depends_on = [local_file.connection_node]
    provisioner "local-exec" {
    working_dir = var.script_path_ansible
    command = "sleep 600; ansible-playbook resetInitialPassword.yml"
    }
  }


resource "null_resource" "inject_license" {
    depends_on = [null_resource.change_initial_password]
    provisioner "local-exec" {
    working_dir = var.script_path_ansible
    #command = "ansible-playbook ciphertrust_inject_license.yml"
    command = "echo 'Succesfully Deploy Ciphertrust Manager'"
    }
  }