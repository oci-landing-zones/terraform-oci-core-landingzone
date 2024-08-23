# ------------------------------------------------------
# ----- Networking - Hub
#-------------------------------------------------------
variable "hub_deployment_option" {
  type    = string
  default = "No"
}
variable "existing_drg_ocid" {
  type    = string
  default = null
}
# Determines where the Hub VCN routes traffic to for inbound internal (cross-vcn) traffic (East/West).
# The value is the private OCID of the indoor Network Load Balancer.
variable "hub_vcn_east_west_entry_point_ocid" {
  type    = string
  default = null
}
# Determines where the Hub VCN routes traffic to for inbound external traffic (North South).
# The value is the private OCID of the outdoor Network Load Balancer.
variable "hub_vcn_north_south_entry_point_ocid" {
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
# ------------------------------------------------------
# ----- Networking - Firewall settings
#-------------------------------------------------------
variable "hub_vcn_deploy_firewall_option" {
  type    = string
  default = "No"
}

variable "fw_instance_name_prefix" {
  type    = string
  default = "firewall-instance"
}

variable "fw_instance_shape" {
  type    = string
  default = "VM.Optimized3.Flex"
}

variable "fw_instance_flex_shape_memory" {
  type    = number
  default = 56
}

variable "fw_instance_flex_shape_cpu" {
  type    = number
  default = 2
}

variable "fw_instance_boot_volume_size" {
  type    = number
  default = 60
}

variable "fw_instance_public_rsa_key" {
  type    = string
  default = null
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