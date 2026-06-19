output "oci_firewall_ip_ocid" {
  description = "OCI Network Firewall private IP address OCID. Used as the entry point to the hub VCN through the firewall."
  value       = module.core_lz.oci_firewall_ip_ocid
}