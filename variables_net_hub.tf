# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# ------------------------------------------------------
# ----- Networking - Hub
#-------------------------------------------------------
variable "hub_deployment_option" {
  type    = string
  default = "No cross-VCN or on-premises connectivity"
  description = "The available options for hub deployment. Valid values: 'No cross-VCN or on-premises connectivity', 'VCN or on-premises connectivity routing via DRG (DRG will be created)', 'VCN or on-premises connectivity routing via DRG (existing DRG)', 'VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)', 'VCN or on-premises connectivity routed through DMZ VCN with Network Virtual Appliance existing DRG (DMZ VCN will be created and DRG ID required)'. All the VCNs that attach to the DRG join the topology as spokes."
}
variable "existing_drg_ocid" {
  type    = string
  default = null
  description = "The OCID of an existing DRG that you want to reuse for hub deployment. Only applicable if hub_deployment_option is 'VCN or on-premises connectivity routing via DRG (existing DRG)' or 'VCN or on-premises connectivity routed through DMZ VCN with Network Virtual Appliance existing DRG (DMZ VCN will be created and DRG ID required)'."
}
variable "hub_vcn_east_west_entry_point_ocid" {
  type    = string
  default = null
  description = "The OCID of a private address the Hub VCN routes traffic to for inbound internal cross-vcn traffic (East/West). This variable is to be assigned with the OCID of the indoor network load balancer's private IP address."
}
variable "hub_vcn_north_south_entry_point_ocid" {
  type    = string
  default = null
  description = "The OCID of a private address the Hub VCN routes traffic to for inbound external traffic (North/South). This variable is to be assigned with the OCID of the outdoor network load balancer's private IP address."
}
variable "hub_vcn_name" {
  type    = string
  default = null
  description = "The Hub VCN name."
}
variable "hub_vcn_cidrs" {
  type    = list(string)
  default = ["192.168.0.0/26"]
  description = "List of CIDR blocks for the Hub VCN."
}
# ------------------------------------------------------
# ----- Networking - Firewall settings
#-------------------------------------------------------
variable "hub_vcn_deploy_net_appliance_option" {
  type    = string
  default = "Don't deploy any network appliance at this time"
  description = "The network appliance option for deploying in the Hub VCN. Valid values: 'Don't deploy any network appliance at this time' (default), 'Palo Alto Networks VM-Series Firewall', 'Fortinet FortiGate Firewall'. Costs are incurred."
}

variable "net_appliance_name_prefix" {
  type    = string
  default = "net-appliance-instance"
  description = "Common prefix to network appliance name. To this common prefix, numbers 1 and 2 are appended to the corresponding instance."
}

variable "net_appliance_shape" {
  type    = string
  default = "VM.Optimized3.Flex"
  description = "The instance shape for the network appliance nodes."
}

variable "net_appliance_flex_shape_memory" {
  type    = number
  default = 56
  description = "The amount of memory (in GB) for the selected flex shape. Applicable to flexible shapes only."
}

variable "net_appliance_flex_shape_cpu" {
  type    = number
  default = 2
  description = "The number of OCPUs for the selected flex shape. Applicable to flexible shapes only."
}

variable "net_appliance_boot_volume_size" {
  type    = number
  default = 60
  description = "The boot volume size (in GB) for the Network Appliance instances."
}

variable "net_appliance_public_rsa_key" {
  type    = string
  default = null
  description = "The SSH public key to login to Network Appliance Compute instance."
}

variable "net_appliance_image_ocid" {
  type        = string
  default     = null
  description = "The custom image ocid of the user-provided virtual network appliance."
}

# variable "net_appliance_image_compartment_ocid" {
#   type        = string
#   default     = null
#   description = "The compartment ocid of the network appliance image resource."
# }

variable "customize_hub_vcn_subnets" {
  type    = bool
  default = false
  description = "Whether to customize default subnets settings of the Hub VCN. Only applicable to RMS deployments."
}

# -------------------------------------------
# ----- Networking - Hub Web Subnet
#--------------------------------------------
variable "hub_vcn_web_subnet_name" {
  type    = string
  default = null
  description = "The Hub VCN Web subnet name."
}
variable "hub_vcn_web_subnet_cidr" {
  type    = string
  default = null
  description = "The Hub VCN Web subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "hub_vcn_web_subnet_is_private" {
  type    = bool
  default = false
  description = "Whether the Web subnet private. It is public by default."
}
variable "hub_vcn_web_subnet_jump_host_allowed_cidrs" {
  type    = list(string)
  default = []
  description = "List of CIDRs allowed to SSH into the Web subnet via a jump host eventually deployed in the Web subnet. Leave empty for no access."
}
# -------------------------------------------
# ----- Networking - Hub Mgmt Subnet
#--------------------------------------------
variable "hub_vcn_mgmt_subnet_name" {
  type    = string
  default = null
  description = "The Hub VCN Management subnet Name."
}
variable "hub_vcn_mgmt_subnet_cidr" {
  type    = string
  default = null
  description = "The Hub VCN Management subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "hub_vcn_mgmt_subnet_external_allowed_cidrs_for_http" {
  type    = list(string)
  default = []
  description = "List of CIDR blocks allowed to connect to Management subnet over HTTP. Leave empty for no access."
}
variable "hub_vcn_mgmt_subnet_external_allowed_cidrs_for_ssh" {
  type    = list(string)
  default = []
  description = "List of CIDR blocks allowed to connect to Management subnet over SSH. Leave empty for no access."
}
# -------------------------------------------
# ----- Networking - Hub Outdoor Subnet
#--------------------------------------------
variable "hub_vcn_outdoor_subnet_name" {
  type    = string
  default = null
  description = "The Hub VCN Outdoor subnet name."
}
variable "hub_vcn_outdoor_subnet_cidr" {
  type    = string
  default = null
  description = "The Hub VCN Outdoor subnet CIDR block. It must be within the VCN CIDR blocks."
}
# -------------------------------------------
# ----- Networking - Hub Indoor Subnet
#--------------------------------------------
variable "hub_vcn_indoor_subnet_name" {
  type    = string
  default = null
  description = "The Hub VCN Indoor subnet name."
}
variable "hub_vcn_indoor_subnet_cidr" {
  type    = string
  default = null
  description = "The Hub VCN Indoor subnet CIDR block. It must be within the VCN CIDR blocks."
}