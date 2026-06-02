# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# ------------------------------------------------------
# ----- Networking - Hub
#-------------------------------------------------------
variable "hub_deployment_option" {
  type        = string
  default     = "No cross-VCN or on-premises connectivity"
  description = "The available options for hub deployment. Valid values: 'No cross-VCN or on-premises connectivity', 'VCN or on-premises connectivity routing via DRG (DRG will be created)', 'VCN or on-premises connectivity routing via DRG (existing DRG)', 'VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)', 'VCN or on-premises connectivity routed through DMZ VCN with Network Virtual Appliance existing DRG (DMZ VCN will be created and DRG ID required)', 'No cross-VCN with on-premises connectivity using an existing DRG', 'No cross-VCN with on-premises connectivity using a new DRG'. All the VCNs that attach to the DRG join the topology as spokes."
}
variable "hub_deployment" {
  type        = number
  default     = 0
  description = "The available options for hub deployment as an integer. 'No cross-VCN or on-premises connectivity' = 0, 'VCN or on-premises connectivity routing via DRG (DRG will be created)' = 1, 'VCN or on-premises connectivity routing via DRG (existing DRG)' = 2, 'VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)' = 3, 'VCN or on-premises connectivity routed through DMZ VCN with Network Virtual Appliance existing DRG (DMZ VCN will be created and DRG ID required)' = 4, 'No cross-VCN with on-premises connectivity using an existing DRG' = 5, 'No cross-VCN with on-premises connectivity using a new DRG' = 6"
}

variable "enable_cross_vcn_constrained_nsgs" {
  type        = bool
  default     = true
  description = "When true, Landing Zone provisions constrained NSGs that enable DRG-attached and routable VCNs to connect with each other according to Landing Zone provided rules. Enabled by default. For migration to open cross-VCN NSGs, first enable enable_cross_vcn_open_nsg while keeping this true, then disable this in a second apply."
}

variable "enable_cross_vcn_open_nsg" {
  type        = bool
  default     = false
  description = "When true, Landing Zone provisions an open NSG that enables DRG-attached and routable VCNs to fully connect with each other. Open and constrained cross-VCN NSGs can coexist to support a two-apply migration. For Hub VCN, the open NSG is created when requested and left unattached by default."
}

variable "define_hub_vcn_additional_nsgs" {
  type        = bool
  default     = false
  description = "When true, Landing Zone provisions additional Hub VCN NSGs from hub_vcn_additional_nsgs."
}

variable "hub_vcn_additional_nsgs" {
  type        = any
  default     = {}
  nullable    = true
  description = "Additional NSGs for the Hub VCN. Accepts either a native HCL map/object or a JSON object string. Only used when define_hub_vcn_additional_nsgs is true."

  validation {
    condition = (
      var.hub_vcn_additional_nsgs == null ||
      try(trimspace(tostring(var.hub_vcn_additional_nsgs)) == "", false) ||
      can(keys(var.hub_vcn_additional_nsgs)) ||
      can(keys(jsondecode(var.hub_vcn_additional_nsgs)))
    )
    error_message = "VALIDATION FAILURE: hub_vcn_additional_nsgs must be null, empty, a map/object, or a JSON object string."
  }
}

variable "existing_drg_ocid" {
  type        = string
  default     = null
  description = "The OCID of an existing DRG that you want to reuse for hub deployment. Only applicable if hub_deployment_option is 'VCN or on-premises connectivity routing via DRG (existing DRG)' or 'VCN or on-premises connectivity routed through DMZ VCN with Network Virtual Appliance existing DRG (DMZ VCN will be created and DRG ID required)'."
}
variable "hub_vcn_east_west_entry_point_ocid" {
  type        = string
  default     = null
  description = "The OCID of the private IP address of the Indoor Network Load Balancer, where inbound internal cross-vcn traffic (East/West) traffic is sent to in the Hub VCN."
}
variable "hub_vcn_north_south_entry_point_ocid" {
  type        = string
  default     = null
  description = "The OCID of the private IP address of the Outdoor Network Load Balancer, where all inbound Internet (North/South) traffic is sent to in the Hub VCN."
}
variable "hub_vcn_name" {
  type        = string
  default     = null
  description = "The Hub VCN name."
}
variable "hub_vcn_cidrs" {
  type        = list(string)
  default     = ["192.168.0.0/24"]
  description = "List of CIDR blocks for the Hub VCN."
  validation {
    condition     = alltrue([for v in var.hub_vcn_cidrs : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for hub_vcn_cidrs variable: all values must be in valid CIDR notation (e.g., 10.0.0.0/20)."
  }
}
# ------------------------------------------------------
# ----- Networking - Firewall settings
#-------------------------------------------------------
variable "hub_vcn_deploy_net_appliance_option" {
  type        = string
  default     = "Don't deploy any network appliance at this time"
  description = "The network appliance option for deploying in the Hub VCN. Valid values: 'Don't deploy any network appliance at this time' (default), 'Marketplace Image', 'User-Provided Virtual Network Appliance', and 'OCI Native Firewall'. Costs are incurred. For 'Marketplace Image', users are required to provide either net_appliance_marketplace_image_ocid or net_appliance_marketplace_image_name (with optional net_appliance_marketplace_image_version) variables. For 'User-Provided Virtual Network Appliance', users are required to provide net_appliance_image_ocid variable."
}

variable "net_appliance_image_vendor" {
  type        = string
  default     = null
  description = "The image vendor for the network appliance. Applicable when hub_vcn_deploy_net_appliance_option is set to 'Marketplace Image' or 'User-Provided Virtual Network Appliance'. Used to select the default Network Load Balancer health checker. Valid values are: 'PaloAlto', 'Fortinet', 'Other'."
  validation {
    condition     = contains(["PALOALTO", "FORTINET", "OTHER"], upper(coalesce(var.net_appliance_image_vendor, "OTHER")))
    error_message = "VALIDATION FAILURE: Validation failure for net_appliance_image_vendor: it must be null or one of: \"PaloAlto\", \"Fortinet\", \"Other\" (case insensitive)."
  }
}

variable "net_appliance_marketplace_image_ocid" {
  type        = string
  default     = null
  description = "The marketplace image OCID for the network appliance. Applicable when hub_vcn_deploy_net_appliance_option is set to 'Marketplace Image'. Marketplace image information can be obtained by running the example in https://github.com/oci-landing-zones/terraform-oci-modules-workloads/tree/main/marketplace-images/examples/marketplace-images. NOTE THAT BY DEPLOYING A MARKETPLACE IMAGE USING TERRAFORM YOU ARE IMPLICITLY AGREEING WITH OCI MARKETPLACE TERMS FOR THE PRICING MODEL THAT APPLY TO THE SELECTED IMAGE."
  validation {
    condition     = var.net_appliance_marketplace_image_ocid == null || can(regex("^ocid1\\.image\\.[a-z0-9]+\\..[a-zA-Z0-9]{60}$", var.net_appliance_marketplace_image_ocid))
    error_message = "VALIDATION FAILURE: Validation failure for net_appliance_marketplace_image_ocid: it must be null or a valid OCI marketplace image OCID (e.g. ocid1.image.<realm>..<unique_id>)."
  }
}

variable "net_appliance_marketplace_image_name" {
  type        = string
  default     = null
  description = "The marketplace image name for the network appliance. Applicable when hub_vcn_deploy_net_appliance_option is set to 'Marketplace Image'. Valid names with BYOL pricing model: 'Palo Alto Networks VM-Series Firewall', 'Fortinet FortiGate Firewall'. Marketplace image information can be obtained by running the example in https://github.com/oci-landing-zones/terraform-oci-modules-workloads/tree/main/marketplace-images/examples/marketplace-images. NOTE THAT BY DEPLOYING A MARKETPLACE IMAGE USING TERRAFORM YOU ARE IMPLICITLY AGREEING WITH OCI MARKETPLACE TERMS FOR THE PRICING MODEL THAT APPLY TO THE SELECTED IMAGE."
}

variable "net_appliance_marketplace_image_version" {
  type        = string
  default     = null
  description = "The marketplace image version for the network appliance. Applicable when hub_vcn_deploy_net_appliance_option is set to 'Marketplace Image' and net_appliance_marketplace_image_name is provided. If not provided, the latest version of the specified Marketplace image is be used. Marketplace image information can be obtained by running the example in https://github.com/oci-landing-zones/terraform-oci-modules-workloads/tree/main/marketplace-images/examples/marketplace-images. NOTE THAT BY DEPLOYING A MARKETPLACE IMAGE USING TERRAFORM YOU ARE IMPLICITLY AGREEING WITH OCI MARKETPLACE TERMS FOR THE PRICING MODEL THAT APPLY TO THE SELECTED IMAGE."
}

variable "enable_native_firewall_threat_log" {
  type        = bool
  default     = false
  description = "Enable OCI Native Firewall Threat Log."
}

variable "enable_native_firewall_traffic_log" {
  type        = bool
  default     = false
  description = "Enable OCI Native Firewall Traffic Log."
}

variable "oci_nfw_ip_ocid" {
  type        = string
  default     = null
  description = "The OCID of OCI Network Firewall private IP address."
}

variable "oci_nfw_policy_ocid" {
  type        = string
  default     = null
  description = "The OCID of OCI Network Firewall policy."
}

variable "net_appliance_name_prefix" {
  type        = string
  default     = "net-appliance-instance"
  description = "Common prefix to network appliance name. To this common prefix, numbers 1 and 2 are appended to the corresponding instance."
}

variable "net_appliance_shape" {
  type        = string
  default     = "VM.Standard2.8"
  description = "The instance shape for the network appliance nodes."
}

variable "net_appliance_flex_shape_memory" {
  type        = number
  default     = 56
  description = "The amount of memory (in GB) for the selected flex shape. Applicable to flexible shapes only."
}

variable "net_appliance_flex_shape_cpu" {
  type        = number
  default     = 4
  description = "The number of OCPUs for the selected flex shape. Applicable to flexible shapes only."
}

variable "net_appliance_boot_volume_size" {
  type        = number
  default     = 60
  description = "The boot volume size (in GB) for the Network Appliance instances."
}

variable "net_appliance_public_rsa_key" {
  type        = string
  default     = null
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
  type        = bool
  default     = false
  description = "Whether to customize default subnets settings of the Hub VCN. Applicable to RMS deployments only, used for UI displaying."
}

# -------------------------------------------
# ----- Networking - Hub Web Subnet
#--------------------------------------------
variable "hub_vcn_web_subnet_name" {
  type        = string
  default     = null
  description = "The Hub VCN Web subnet name."
}
variable "hub_vcn_web_subnet_cidr" {
  type        = string
  default     = null
  description = "The Hub VCN Web subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.hub_vcn_web_subnet_cidr == null || can(cidrhost(var.hub_vcn_web_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for hub_vcn_web_subnet_cidr variable: value must be in valid CIDR notation (e.g., 192.168.0.0/24)."
  }
}
variable "hub_vcn_web_subnet_is_private" {
  type        = bool
  default     = false
  description = "Whether the Web subnet private. It is public by default."
}
variable "hub_vcn_external_allowed_cidrs_into_web_tier" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "The list of external CIDR blocks allowed for ingress packets into the Hub VCN App Load Balancer Network Security Group. Effective only when hub_vcn_web_subnet_is_private is false. Use this to limit the range of IP addresses that can access the Hub VCN web tier."
  validation {
    condition     = length(var.hub_vcn_external_allowed_cidrs_into_web_tier) == 0 ? true : alltrue([for v in var.hub_vcn_external_allowed_cidrs_into_web_tier : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for hub_vcn_external_allowed_cidrs_into_web_tier variable: all values must be in valid CIDR notation (e.g., 178.231.15.71/32)."
  }
}
variable "hub_vcn_web_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:443"]
  description = "The list of protocols and destination ports allowed for ingress packets into the Hub VCN App Load Balancer Network Security Group. These ports are allowed from onprem_cidrs plus hub_vcn_external_allowed_cidrs_into_web_tier when the Hub VCN Web subnet is public, and from onprem_cidrs when it is private. Each list value is a colon-separated entry like 'TCP:443'."
  validation {
    condition     = length(var.hub_vcn_web_ingress_destination_ports) == 0 ? true : alltrue([for v in var.hub_vcn_web_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for hub_vcn_web_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
# -------------------------------------------
# ----- Networking - Hub Mgmt Subnet
#--------------------------------------------
variable "hub_vcn_mgmt_subnet_name" {
  type        = string
  default     = null
  description = "The Hub VCN Management subnet Name."
}
variable "hub_vcn_mgmt_subnet_cidr" {
  type        = string
  default     = null
  description = "The Hub VCN Management subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.hub_vcn_mgmt_subnet_cidr == null || can(cidrhost(var.hub_vcn_mgmt_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for hub_vcn_mgmt_subnet_cidr variable: value must be in valid CIDR notation (e.g., 192.168.0.0/24)."
  }
}
variable "fw_mgmt_interface_ports" {
  type        = list(string)
  default     = ["TCP:22", "TCP:443"]
  description = "The list of protocols and ports allowed into Firewall Management interface by the CIDRs provided in variable allowed_onprem_cidrs_to_fw_mgmt_interface. Each value is a colon-separated entry like \"TCP:22\"."
  validation {
    condition     = length(var.fw_mgmt_interface_ports) == 0 ? true : alltrue([for v in var.fw_mgmt_interface_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for fw_mgmt_interface_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
# -------------------------------------------
# ----- Networking - Hub Outdoor Subnet
#--------------------------------------------
variable "hub_vcn_outdoor_subnet_name" {
  type        = string
  default     = null
  description = "The Hub VCN Outdoor subnet name."
}
variable "hub_vcn_outdoor_subnet_cidr" {
  type        = string
  default     = null
  description = "The Hub VCN Outdoor subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.hub_vcn_outdoor_subnet_cidr == null || can(cidrhost(var.hub_vcn_outdoor_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for hub_vcn_outdoor_subnet_cidr variable: value must be in valid CIDR notation (e.g., 192.168.0.0/24)."
  }
}
# -------------------------------------------
# ----- Networking - Hub Indoor Subnet
#--------------------------------------------
variable "hub_vcn_indoor_subnet_name" {
  type        = string
  default     = null
  description = "The Hub VCN Indoor subnet name."
}
variable "hub_vcn_indoor_subnet_cidr" {
  type        = string
  default     = null
  description = "The Hub VCN Indoor subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.hub_vcn_indoor_subnet_cidr == null || can(cidrhost(var.hub_vcn_indoor_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for hub_vcn_indoor_subnet_cidr variable: value must be in valid CIDR notation (e.g., 192.168.0.0/24)."
  }
}
# -------------------------------------------
# ----- Networking - Hub Jumphost Subnet
#--------------------------------------------
variable "add_hub_vcn_jumphost_subnet" {
  type        = bool
  default     = false
  description = "Whether to add an optional private subnet for jump hosts. The subnet is also used for Bastion Service deployment (when enabled by deploy_bastion_service variable)."
}
variable "hub_vcn_jumphost_subnet_name" {
  type        = string
  default     = null
  description = "The Hub VCN Jump Host subnet Name."
}
variable "hub_vcn_jumphost_subnet_cidr" {
  type        = string
  default     = null
  description = "The Hub VCN Jump Host subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.hub_vcn_jumphost_subnet_cidr == null || can(cidrhost(var.hub_vcn_jumphost_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for hub_vcn_jumphost_subnet_cidr variable: value must be in valid CIDR notation (e.g., 192.168.0.0/24)."
  }
}

# -------------------------------------------
# ----- Networking - Additional Networks
#--------------------------------------------
variable "workloadvcn_ocids_public_access" {
  type        = list(string)
  description = "A list of externally-managed VCN OCIDs that require public connectivity. The VCNs provided here attach to the DRG as a spoke and are routeable from the web subnet in the Hub VCN."
  default     = []
}
variable "workloadvcn_ocids_onprem_access" {
  type        = list(string)
  description = "A list of externally-managed VCN OCIDs that require on-premises connectivity. The VCNs provided here attach to the DRG as a spoke and are routeable from the on-premises network."
  default     = []
}
# -------------------------------------------
# ----- Networking - Internet Gateway
#--------------------------------------------
variable "hub_vcn_enable_internet_gateway" {
  type        = bool
  description = "When checked, access from the Internet is enabled into the Hub VCN via an Internet Gateway. When unchecked, an Internet Gateway is not deployed and access from Internet is blocked."
  default     = true
}
