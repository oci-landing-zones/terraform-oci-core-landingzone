# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
# --------------------------------------------------------------------------
# ----- Networking - On-Premises Connectivity - CPE
#---------------------------------------------------------------------------

variable "cpe_config" {
  type        = string
  default     = "Use Existing"
  description = "Options to determine CPE configuration which are 'Create New Customer-Premises Equipment' or 'Use Existing'"
}

variable "existing_cpe_ocid" {
  type        = string
  default     = ""
  description = "OCID of the existing Customer-Premises Equipment (CPE) object."
}

variable "cpe_name" {
  type        = string
  default     = ""
  description = "Display name of the Customer-Premises Equipment (CPE)."
}

variable "cpe_ip_address" {
  type        = string
  default     = ""
  description = "Public IP address used by the Customer-Premises Equipment (CPE) so that a VPN connection can be established."
}

variable "cpe_device_shape_vendor" {
  type        = string
  default     = ""
  description = "Name of the device shape vendor used by the Customer-Premises Equipment (CPE). See the list of verified CPE devices for more information."
}

# --------------------------------------------------------------------------
# ----- Networking - On-Premises Connectivity - IPSec 
#---------------------------------------------------------------------------

variable "ipsec_config" {
  type        = string
  default     = "Use Existing IPSec Connection"
  description = "Options to determine IPSec VPN and tunnel creation which are 'Create New IPSec Connection' or 'Use Existing IPSec Connection'"
}

variable "existing_ipsec_ocid" {
  type        = string
  default     = ""
  description = "OCID of the existing IPSec connection VPN, required if using an existing IPSec connection."
}

variable "ipsec_vpn_name" {
  type        = string
  default     = ""
  description = "Display name of the IPSec VPN."
}

variable "ipsec_customer_bgp_asn" {
  type        = string
  default     = ""
  description = "Customer on-premises network's Autonomous System Number."
}

variable "ipsec_tunnel1_customer_interface_ip" {
  type        = string
  default     = ""
  description = "The first IP CIDR block used on the customer side for BGP peering for IPSec Tunnel 1."
}

variable "ipsec_tunnel1_oracle_interface_ip" {
  type        = string
  default     = ""
  description = "The first IP CIDR block provided by OCI for BGP peering for IPSec Tunnel 1."
}

variable "ipsec_tunnel1_shared_secret" {
  type        = string
  default     = ""
  description = "The IPSec Tunnel 1's shared secret (pre-shared key). If not provided, Oracle will generate one automatically."
}

variable "ipsec_tunnel1_ike_version" {
  type        = string
  default     = ""
  description = "Version of the internet key exchange (IKE), if using a CPE IKE identifier. Supported values are 'V1' or 'V2'."
}

variable "ipsec_tunnel2_customer_interface_ip" {
  type        = string
  default     = ""
  description = "The second IP CIDR block used on the customer side for BGP peering for IPSec Tunnel 2."
}

variable "ipsec_tunnel2_oracle_interface_ip" {
  type        = string
  default     = ""
  description = "The second IP CIDR block provided by OCI for BGP peering for IPSec Tunnel 2."
}

variable "ipsec_tunnel2_shared_secret" {
  type        = string
  default     = ""
  description = "The IPSec Tunnel 1's shared secret (pre-shared key). If not provided, Oracle will generate one automatically."
}

variable "ipsec_tunnel2_ike_version" {
  type        = string
  default     = ""
  description = "Version of the internet key exchange (IKE), if using a CPE IKE identifier. Supported values are 'V1' or 'V2'."
}
# --------------------------------------------------------------------------
# ----- Networking - On-Premises Connectivity - FastConnect Virtual Circuit
#---------------------------------------------------------------------------

variable "on_premises_connection_option" {
  type        = string
  default     = "None"
  description = "The option for connecting to on-premises. Valid options are 'None', 'FastConnect Virtual Circuit', 'IPSec VPN', or 'FastConnect and IPSec VPN'"
}
variable "fastconnect_virtual_circuit_config" {
  type        = string
  default     = ""
  description = "Creates New FastConnect Virtual Circuit or connects existing VC (Valid values include 'Create New FastConnect Virtual Circuit', 'Use Existing')."
}

variable "existing_fastconnect_virtual_circuit_ocid" {
  type        = string
  default     = ""
  description = "The OCID of the existing FastConnect Virtual Circuit."
}

variable "fastconnect_virtual_circuit_name" {
  type        = string
  default     = ""
  description = "The name for the FastConnect virtual circuit."
}

variable "fastconnect_virtual_circuit_type" {
  type        = string
  default     = "PRIVATE"
  description = "The type of IP addresses used in the Fast Connect virtual circuit. Accepted values are PRIVATE, PUBLIC."
}

variable "fastconnect_virtual_circuit_bandwidth_shape" {
  type        = string
  default     = "1 Gbps"
  description = "Bandwidth level (shape) of the Fast Connect virtual circuit."
  validation {
    condition     = length(regexall("^\\d+\\sGbps$", var.fastconnect_virtual_circuit_bandwidth_shape)) > 0
    error_message = "The bandwidth shape of the FC virtual circuit must be in the form '<number> Gbps', e.g., '1 Gbps', '10 Gbps'"
  }
}

variable "fastconnect_virtual_circuit_bandwidth_custom_shape" {
  type        = string
  default     = "1 Gbps"
  description = "Custom bandwidth level (shape) of the FastConnect virtual circuit. For example: '5 Gbps'"
  validation {
    condition     = length(regexall("^\\d+\\sGbps$", var.fastconnect_virtual_circuit_bandwidth_custom_shape)) > 0
    error_message = "The bandwidth shape of the FC virtual circuit must be in the form '<number> Gbps', e.g. '2 Gbps', '5 Gbps'"
  }
}

variable "fastconnect_virtual_circuit_customer_asn" {
  type        = string
  default     = null
  description = "Your BGP ASN (either public or private). Provide this value only if there is a BGP session that goes from your edge router to Oracle. Otherwise, leave this empty or null. Can be a 2-byte or 4-byte ASN."
}

variable "fastconnect_virtual_circuit_customer_bgp_peering_ip" {
  type        = string
  default     = null
  description = "The BGP IPv4 address for the edge router on the other end of the BGP session from Oracle. Must use a subnet mask from /28 to /31."
}

variable "fastconnect_virtual_circuit_oracle_bgp_peering_ip" {
  type        = string
  default     = null
  description = "The IPv4 address for Oracle's end of the BGP session. Must use a subnet mask from /28 to /31."
}

variable "fastconnect_virtual_circuit_routing_policy" {
  type        = list(string)
  default     = null
  description = "Defines the BGP relationship for exchanging routes. (Valid values include REGIONAL, GLOBAL)."
}

variable "fastconnect_virtual_circuit_provider_service_id" {
  type        = string
  default     = null
  description = "The OCID of the service offered by the provider (if you're connecting via a provider)."
}

variable "fastconnect_virtual_circuit_provider_service_key_name" {
  type        = string
  default     = null
  description = "The service key name offered by the provider for FastConnect virtual circuit."
}

variable "fastconnect_virtual_circuit_cross_connect_or_cross_connect_group_id" {
  type        = string
  default     = null
  description = "The OCID of the cross-connect or cross-connect group used for cross-connect mapping."
}

variable "fastconnect_virtual_circuit_bgp_md5auth_key" {
  type        = string
  default     = null
  description = "The key for BGP MD5 authentication. Only applicable if your system requires MD5 authentication. If empty or not set (null), that means you don't use BGP MD5 authentication."
}

variable "fastconnect_virtual_circuit_vlan" {
  type        = string
  default     = null
  description = "The number of the specific VLAN (on the cross-connect or cross-connect group) that is assigned to FastConnect virtual circuit."
}

variable "fastconnect_virtual_circuit_ip_mtu" {
  type        = number
  default     = null
  description = "The MTU value to assign to the FastConnect virtual circuit. Supported values are: 1500, 9000. Default is 1500."
}

variable "fastconnect_virtual_circuit_is_bfd_enabled" {
  type        = bool
  default     = false
  description = "Set to true to enable BFD for IPv4 BGP peering, or set to false to disable BFD. If this is not set, the default is false."
}

