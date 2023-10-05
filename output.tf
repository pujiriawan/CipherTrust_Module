output "public_ip_address" {
  description = "CipherTrust Manager's Public IP Address"
  value = vsphere_virtual_machine.ciphertrust.*.default_ip_address
}