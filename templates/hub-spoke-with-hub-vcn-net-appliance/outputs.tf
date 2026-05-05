output "nlb_private_ip_addresses" {
  description = "NLB private IP addresses OCIDs. These are used as entry points to the hub VCN through the firewall."
  value       = module.core_lz_fortinet.nlb_private_ip_addresses
}