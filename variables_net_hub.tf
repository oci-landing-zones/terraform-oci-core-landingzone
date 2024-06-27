# ------------------------------------------------------
# ----- Networking - Hub
#-------------------------------------------------------
variable "hub_options" {
  type    = string
  default = "No"
}
variable "existing_drg_ocid" {
  type    = string
  default = null
}
# This determines where the Hub VCN routes traffic to internally. 
# The value should be the OCID of a firewall or a load balancer front ending a firewall.
variable "hub_vcn_ingress_route_table_network_entity_ocid" {
  type    = string
  default = null
}
variable "hub_vcn_name" {
  type    = string
  default = null
}
variable "hub_vcn_cidrs" {
  type    = list(string)
  default = ["192.168.0.0/26"]
}
variable "hub_vcn_dns" {
  type    = string
  default = null
}
variable "hub_vcn_attach_to_drg" {
  type    = bool
  default = true
}
variable "customize_hub_vcn_subnets" {
  type    = bool
  default = false
}
# -------------------------------------------
# ----- Networking - Hub Web Subnet
#--------------------------------------------
variable "hub_vcn_web_subnet_name" {
  type    = string
  default = null
}
variable "hub_vcn_web_subnet_cidr" {
  type    = string
  default = null
}
variable "hub_vcn_web_subnet_dns" {
  type    = string
  default = null
}
variable "hub_vcn_web_subnet_is_private" {
  type    = bool
  default = false
}
variable "hub_vcn_web_subnet_jump_host_allowed_cidrs" {
  type    = list(string)
  default = []
}
# -------------------------------------------
# ----- Networking - Hub Mgmt Subnet
#--------------------------------------------
variable "hub_vcn_mgmt_subnet_name" {
  type    = string
  default = null
}
variable "hub_vcn_mgmt_subnet_cidr" {
  type    = string
  default = null
}
variable "hub_vcn_mgmt_subnet_dns" {
  type    = string
  default = null
}
variable "hub_vcn_mgmt_subnet_external_allowed_cidrs_for_http" {
  type    = list(string)
  default = []
}
variable "hub_vcn_mgmt_subnet_external_allowed_cidrs_for_ssh" {
  type    = list(string)
  default = []
}
# -------------------------------------------
# ----- Networking - Hub Outdoor Subnet
#--------------------------------------------
variable "hub_vcn_outdoor_subnet_name" {
  type    = string
  default = null
}
variable "hub_vcn_outdoor_subnet_cidr" {
  type    = string
  default = null
}
variable "hub_vcn_outdoor_subnet_dns" {
  type    = string
  default = null
}
# -------------------------------------------
# ----- Networking - Hub Indoor Subnet
#--------------------------------------------
variable "hub_vcn_indoor_subnet_name" {
  type    = string
  default = null
}
variable "hub_vcn_indoor_subnet_cidr" {
  type    = string
  default = null
}
variable "hub_vcn_indoor_subnet_dns" {
  type    = string
  default = null
}