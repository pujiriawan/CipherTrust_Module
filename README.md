<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

No requirements.
## Usage
Basic usage of this module is as follows:
```hcl
module "example" {
	 source  = "<module-path>"

	 # Optional variables
	 dc  = ""
	 ovf_file  = ""
	 script_path_ansible  = ""
	 user-data  = ""
	 vmname  = "CIPHERTUST"
	 vs_cluster  = ""
	 vs_datastore  = ""
	 vs_host_cluster  = ""
	 vs_network_data  = "VM Network"
	 vsphere_ovf_vm_template_name  = ""
}
```
## Resources

| Name | Type |
|------|------|
| [null_resource.change_initial_password](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.inject_license](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [vsphere_virtual_machine.ciphertrust](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine) | resource |
| [vsphere_compute_cluster.cluster](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/compute_cluster) | data source |
| [vsphere_datacenter.dc](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datacenter) | data source |
| [vsphere_datastore.datastore](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datastore) | data source |
| [vsphere_host.host](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/host) | data source |
| [vsphere_network.Data](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/network) | data source |
| [vsphere_ovf_vm_template.ovf](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/ovf_vm_template) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dc"></a> [dc](#input\_dc) | vSphere Datastore name | `string` | `""` | no |
| <a name="input_ovf_file"></a> [ovf\_file](#input\_ovf\_file) | vSphere GuestOS Remote URL OVF | `string` | `""` | no |
| <a name="input_script_path_ansible"></a> [script\_path\_ansible](#input\_script\_path\_ansible) | this is script for ansible | `string` | `""` | no |
| <a name="input_user-data"></a> [user-data](#input\_user-data) | This is define for cloud init file | `string` | `""` | no |
| <a name="input_vmname"></a> [vmname](#input\_vmname) | This is define for environment vm will build | `string` | `"CIPHERTUST"` | no |
| <a name="input_vs_cluster"></a> [vs\_cluster](#input\_vs\_cluster) | vSphere Cluster name | `string` | `""` | no |
| <a name="input_vs_datastore"></a> [vs\_datastore](#input\_vs\_datastore) | vSphere Datastore name | `string` | `""` | no |
| <a name="input_vs_host_cluster"></a> [vs\_host\_cluster](#input\_vs\_host\_cluster) | vSphere Host or Cluster | `string` | `""` | no |
| <a name="input_vs_network_data"></a> [vs\_network\_data](#input\_vs\_network\_data) | This is define for network interface type | `string` | `"VM Network"` | no |
| <a name="input_vsphere_ovf_vm_template_name"></a> [vsphere\_ovf\_vm\_template\_name](#input\_vsphere\_ovf\_vm\_template\_name) | vSphere GuestOS Remote URL OVF | `string` | `""` | no |
## Outputs

No outputs.
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->