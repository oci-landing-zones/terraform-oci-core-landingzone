# ------------------------------------------------------
# ----- Networking - Hub
#-------------------------------------------------------
variable "hub_deployment_option" {
  type    = string
  default = "No"
  description = "Choose one of the available options for deploying a Hub & Spoke topology. All the VCNs that attach to the DRG join the topology as spokes."
}
variable "existing_drg_ocid" {
  type    = string
  default = null
  description = "Enter the OCID of an existing DRG that you want to reuse for deploying the topology."
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
  description = "Enter the private OCID of the Indoor Network Load Balancer, where all inter-VCN (East/West) traffic is sent to in the Hub VCN."
}
variable "hub_vcn_cidrs" {
  type    = list(string)
  default = ["192.168.0.0/26"]
  description = "Enter the CIDR blocks for the Hub VCN."
}
variable "hub_vcn_dns" {
  type    = string
  default = null
  description = "Enter the Hub VCN DNS name."
}
# ------------------------------------------------------
# ----- Networking - Firewall settings
#-------------------------------------------------------
variable "hub_vcn_deploy_firewall_option" {
  type    = string
  default = "No"
  description = "Choose one of the available firewall options for deploying in the Hub VCN. Costs are incurred."
}

variable "fw_instance_name_prefix" {
  type    = string
  default = "firewall-instance"
  description = "Enter a common prefix to firewall name. To this common prefix, numbers 1 and 2 are appended the corresponding instance."
}

variable "fw_instance_shape" {
  type    = string
  default = "VM.Optimized3.Flex"
  description = "Select the instance shape for the firewall."
}

variable "fw_instance_flex_shape_memory" {
  type    = number
  default = 56
  description = "Enter the amount of memory (in GB) for the selected flex shape. Applicable to flexible shapes only."
}

variable "fw_instance_flex_shape_cpu" {
  type    = number
  default = 2
  description = "Enter the number of OCPUs for the selected flex shape. Applicable to flexible shapes only."
}

variable "fw_instance_boot_volume_size" {
  type    = number
  default = 60
  description = "Enter the boot volume size (in GB) for the firewall instances."
}

variable "fw_instance_public_rsa_key" {
  type    = string
  default = null
  description = "Enter a Public SSH Key to Login to Compute Instance."
}

variable "customize_hub_vcn_subnets" {
  type    = bool
  default = false
  description = "Check to customize default subnets settings."
}

# -------------------------------------------
# ----- Networking - Hub Web Subnet
#--------------------------------------------
variable "hub_vcn_web_subnet_name" {
  type    = string
  default = null
  description = "Enter the Web subnet name."
}
variable "hub_vcn_web_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Web subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "hub_vcn_web_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Web subnet DNS name. Use only letters and numbers, no special characters."
}
variable "hub_vcn_web_subnet_is_private" {
  type    = bool
  default = false
  description = "Check to make the Web subnet private. It is public by default."
}
variable "hub_vcn_web_subnet_jump_host_allowed_cidrs" {
  type    = list(string)
  default = []
  description = "These CIDRs are allowed to SSH into the Web subnet via a jump host eventually deployed in the Web subnet. Leave empty for no access."
}
# -------------------------------------------
# ----- Networking - Hub Mgmt Subnet
#--------------------------------------------
variable "hub_vcn_mgmt_subnet_name" {
  type    = string
  default = null
  description = "Enter the Mgmt subnet Name."
}
variable "hub_vcn_mgmt_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Mgmt subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "hub_vcn_mgmt_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Mgmt subnet DNS name. Use only letters and numbers, no special characters."
}
variable "hub_vcn_mgmt_subnet_external_allowed_cidrs_for_http" {
  type    = list(string)
  default = []
  description = "Enter the CIDR blocks allowed to connect to Mgmt subnet over HTTP. Leave empty for no access."
}
variable "hub_vcn_mgmt_subnet_external_allowed_cidrs_for_ssh" {
  type    = list(string)
  default = []
  description = "Enter the CIDR blocks allowed to connect to Mgmt subnet over SSH. Leave empty for no access."
}
# -------------------------------------------
# ----- Networking - Hub Outdoor Subnet
#--------------------------------------------
variable "hub_vcn_outdoor_subnet_name" {
  type    = string
  default = null
  description = "Enter the Outdoor subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "hub_vcn_outdoor_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Outdoor subnet DNS name. Use only letters and numbers, no special characters."
}
variable "hub_vcn_outdoor_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Outdoor subnet DNS name. Use only letters and numbers, no special characters."
}
# -------------------------------------------
# ----- Networking - Hub Indoor Subnet
#--------------------------------------------
variable "hub_vcn_indoor_subnet_name" {
  type    = string
  default = null
  description = "Enter the Indoor subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "hub_vcn_indoor_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Indoor subnet DNS name. Use only letters and numbers, no special characters."
}
variable "hub_vcn_indoor_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Indoor subnet DNS name. Use only letters and numbers, no special characters."
}