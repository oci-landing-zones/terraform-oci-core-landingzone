# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# ------------------------------------------------------
# ----- Networking - Three-tier VCN 1
#-------------------------------------------------------
variable "add_tt_vcn1" {
  type        = bool
  default     = false
  description = "Whether to add a VCN configured for three-tier workload deployments, with up to four subnets: web (public by default), application (private), database (private). An optional subnet (private by default) for bastion deployment is also available. The added VCN is labelled 'TT-VCN-1'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Network topology."
}
variable "tt_vcn1_name" {
  type        = string
  default     = null
  description = "The VCN name. If unassigned, a default name is provided. VCN label: TT-VCN-1."
}
variable "tt_vcn1_cidrs" {
  type        = list(string)
  default     = ["10.0.0.0/20"]
  description = "The list of CIDR blocks for the VCN."
  validation {
    condition     = alltrue([for v in var.tt_vcn1_cidrs : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn1_cidrs variable: all values must be in valid CIDR notation (e.g., 10.0.0.0/20)."
  }
}
variable "tt_vcn1_attach_to_drg" {
  type        = bool
  default     = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}
variable "tt_vcn1_routable_vcns" {
  type        = list(string)
  default     = []
  description = "The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Network topology where a DRG is deployed as the hub. Valid values: TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3."
  validation {
    condition     = length(var.tt_vcn1_routable_vcns) == 0 ? true : (length(var.tt_vcn1_routable_vcns) == 0 || alltrue([for label in var.tt_vcn1_routable_vcns : contains(["TT-VCN-2", "TT-VCN-3", "EXA-VCN-1", "EXA-VCN-2", "EXA-VCN-3", "OKE-VCN-1", "OKE-VCN-2", "OKE-VCN-3"], label)]))
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn1_routable_vcns variable: it must be empty or contain only valid VCN labels: \"TT-VCN-2\",\"TT-VCN-3\",\"EXA-VCN-1\",\"EXA-VCN-2\",\"EXA-VCN-3\",\"OKE-VCN-1\",\"OKE-VCN-2\",\"OKE-VCN-3\"."
  }
}
variable "define_tt_vcn1_additional_nsgs" {
  type        = bool
  default     = false
  description = "When true, Landing Zone provisions additional TT-VCN-1 NSGs from tt_vcn1_additional_nsgs."
}
variable "tt_vcn1_additional_nsgs" {
  type        = any
  default     = {}
  nullable    = true
  description = "Additional NSGs for TT-VCN-1. Accepts either a native HCL map/object or a JSON object string. Only used when define_tt_vcn1_additional_nsgs is true."

  validation {
    condition = (
      var.tt_vcn1_additional_nsgs == null ||
      try(trimspace(tostring(var.tt_vcn1_additional_nsgs)) == "", false) ||
      can(keys(var.tt_vcn1_additional_nsgs)) ||
      can(keys(jsondecode(var.tt_vcn1_additional_nsgs)))
    )
    error_message = "VALIDATION FAILURE: tt_vcn1_additional_nsgs must be null, empty, a map/object, or a JSON object string."
  }
}
variable "customize_tt_vcn1_subnets" {
  type        = bool
  default     = false
  description = "If true, allows for the customization of default subnets settings. Applicable to RMS deployments only, used for UI displaying."
}
variable "tt_vcn1_web_subnet_name" {
  type        = string
  default     = null
  description = "The Web subnet name."
}
variable "tt_vcn1_web_subnet_cidr" {
  type        = string
  default     = null
  description = "The Web subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.tt_vcn1_web_subnet_cidr == null || can(cidrhost(var.tt_vcn1_web_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn1_web_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.0.0.0/24)."
  }
}
variable "tt_vcn1_web_subnet_is_private" {
  type        = bool
  default     = false
  description = "Whether the Web subnet private. It is public by default."
}
variable "tt_vcn1_external_allowed_cidrs_into_web_tier" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "The list of external CIDRs blocks allowed for ingress packets into tt_vcn1 VCN LBR Network Security Group. Use this to limit the range of IP addresses that can access the web tier."
  validation {
    condition     = length(var.tt_vcn1_external_allowed_cidrs_into_web_tier) == 0 ? true : alltrue([for v in var.tt_vcn1_external_allowed_cidrs_into_web_tier : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn1_external_allowed_cidrs_into_web_tier variable: all values must be in valid CIDR notation (e.g., 178.231.15.71/32)."
  }
}
variable "tt_vcn1_web_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:443"]
  description = "The list of protocols and destination ports allowed for ingress packets into LBR Network Security Group. Each list value is a colon-separated entry like 'TCP:443'."
  validation {
    condition     = length(var.tt_vcn1_web_ingress_destination_ports) == 0 ? true : alltrue([for v in var.tt_vcn1_web_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn1_web_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
variable "tt_vcn1_app_subnet_name" {
  type        = string
  default     = null
  description = "The Application subnet name."
}
variable "tt_vcn1_app_subnet_cidr" {
  type        = string
  default     = null
  description = "The Application subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.tt_vcn1_app_subnet_cidr == null || can(cidrhost(var.tt_vcn1_app_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn1_app_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.0.0.0/24)."
  }
}
variable "tt_vcn1_app_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:80"]
  description = "The list of protocols and destination ports allowed for ingress packets into App Network Security Group. Each list value is a colon-separated entry like 'TCP:80'."
  validation {
    condition     = length(var.tt_vcn1_app_ingress_destination_ports) == 0 ? true : alltrue([for v in var.tt_vcn1_app_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn1_app_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
variable "tt_vcn1_db_subnet_name" {
  type        = string
  default     = null
  description = "The Database subnet name."
}
variable "tt_vcn1_db_subnet_cidr" {
  type        = string
  default     = null
  description = "The Database subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.tt_vcn1_db_subnet_cidr == null || can(cidrhost(var.tt_vcn1_db_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn1_db_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.0.0.0/24)."
  }
}
variable "tt_vcn1_db_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:1521", "TCP:1522"]
  description = "The list of protocols and destination ports allowed for ingress packets into DB Network Security Group. Each list value is a colon-separated entry like 'TCP:1521'."
  validation {
    condition     = length(var.tt_vcn1_db_ingress_destination_ports) == 0 ? true : alltrue([for v in var.tt_vcn1_db_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn1_db_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
variable "deploy_tt_vcn1_bastion_subnet" {
  type        = bool
  default     = false
  description = "Whether to deploy a subnet where you can further deploy OCI Bastion service or a jump host."
}
variable "tt_vcn1_bastion_subnet_name" {
  type        = string
  default     = null
  description = "The Bastion subnet name."
}
variable "tt_vcn1_bastion_subnet_cidr" {
  type        = string
  default     = null
  description = "The Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.tt_vcn1_bastion_subnet_cidr == null || can(cidrhost(var.tt_vcn1_bastion_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn1_bastion_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.0.0.0/24)."
  }
}
variable "tt_vcn1_bastion_is_access_via_public_endpoint" {
  type        = bool
  default     = false
  description = "If true, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed."
}
variable "tt_vcn1_bastion_subnet_allowed_cidrs" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access."
  validation {
    condition     = length(var.tt_vcn1_bastion_subnet_allowed_cidrs) == 0 ? true : alltrue([for v in var.tt_vcn1_bastion_subnet_allowed_cidrs : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn1_bastion_subnet_allowed_cidrs variable: all values must be in valid CIDR notation (e.g., 10.0.0.0/20)."
  }
}
variable "tt_vcn1_onprem_route_enable" {
  type        = bool
  default     = false
  description = "This will drive the creation of the routes and security list rules."
}
variable "add_tt_vcn2" {
  type        = bool
  default     = false
  description = "Whether to add a second VCN configured for three-tier workload deployments, with up to four subnets: web (public by default), application (private), database (private). An optional subnet (private by default) for bastion deployment is also available. The added VCN is labelled 'TT-VCN-2'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Network topology."
}

# ------------------------------------------------------
# ----- Networking - Three-tier VCN 2
#-------------------------------------------------------
variable "tt_vcn2_name" {
  type        = string
  default     = null
  description = "The VCN name. If unassigned, a default name is provided. Label: TT-VCN-2."
}
variable "tt_vcn2_cidrs" {
  type        = list(string)
  default     = ["10.1.0.0/20"]
  description = "The list of CIDR blocks for the VCN."
  validation {
    condition     = alltrue([for v in var.tt_vcn2_cidrs : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn2_cidrs variable: all values must be in valid CIDR notation (e.g., 10.1.0.0/20)."
  }
}
variable "tt_vcn2_attach_to_drg" {
  type        = bool
  default     = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}
variable "tt_vcn2_routable_vcns" {
  type        = list(string)
  default     = []
  description = "The VCN labels that this VCN can send traffic to. Only applicable for Network topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3."
  validation {
    condition     = length(var.tt_vcn2_routable_vcns) == 0 ? true : (length(var.tt_vcn2_routable_vcns) == 0 || alltrue([for label in var.tt_vcn2_routable_vcns : contains(["TT-VCN-1", "TT-VCN-3", "EXA-VCN-1", "EXA-VCN-2", "EXA-VCN-3", "OKE-VCN-1", "OKE-VCN-2", "OKE-VCN-3"], label)]))
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn2_routable_vcns variable: it must be empty or contain only valid VCN labels: \"TT-VCN-1\",\"TT-VCN-3\",\"EXA-VCN-1\",\"EXA-VCN-2\",\"EXA-VCN-3\",\"OKE-VCN-1\",\"OKE-VCN-2\",\"OKE-VCN-3\"."
  }
}
variable "define_tt_vcn2_additional_nsgs" {
  type        = bool
  default     = false
  description = "When true, Landing Zone provisions additional TT-VCN-2 NSGs from tt_vcn2_additional_nsgs."
}
variable "tt_vcn2_additional_nsgs" {
  type        = any
  default     = {}
  nullable    = true
  description = "Additional NSGs for TT-VCN-2. Accepts either a native HCL map/object or a JSON object string. Only used when define_tt_vcn2_additional_nsgs is true."

  validation {
    condition = (
      var.tt_vcn2_additional_nsgs == null ||
      try(trimspace(tostring(var.tt_vcn2_additional_nsgs)) == "", false) ||
      can(keys(var.tt_vcn2_additional_nsgs)) ||
      can(keys(jsondecode(var.tt_vcn2_additional_nsgs)))
    )
    error_message = "VALIDATION FAILURE: tt_vcn2_additional_nsgs must be null, empty, a map/object, or a JSON object string."
  }
}
variable "customize_tt_vcn2_subnets" {
  type        = bool
  default     = false
  description = "If true, allows for the customization of default subnets settings. Applicable to RMS deployments only, used for UI displaying."
}
variable "tt_vcn2_web_subnet_name" {
  type        = string
  default     = null
  description = "The Web subnet name."
}
variable "tt_vcn2_web_subnet_cidr" {
  type        = string
  default     = null
  description = "The Web subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.tt_vcn2_web_subnet_cidr == null || can(cidrhost(var.tt_vcn2_web_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn2_web_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.1.0.0/24)."
  }
}
variable "tt_vcn2_web_subnet_is_private" {
  type        = bool
  default     = false
  description = "Whether the Web subnet private. It is public by default."
}
variable "tt_vcn2_external_allowed_cidrs_into_web_tier" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "The list of external CIDRs blocks allowed for ingress packets into tt_vcn2 VCN LBR Network Security Group. Use this to limit the range of IP addresses that can access the web tier."
  validation {
    condition     = length(var.tt_vcn2_external_allowed_cidrs_into_web_tier) == 0 ? true : alltrue([for v in var.tt_vcn2_external_allowed_cidrs_into_web_tier : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn2_external_allowed_cidrs_into_web_tier variable: all values must be in valid CIDR notation (e.g., 178.231.15.71/32)."
  }
}
variable "tt_vcn2_web_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:443"]
  description = "The list of protocols and destination ports allowed for ingress packets into LBR Network Security Group. Each list value is a colon-separated entry like 'TCP:443'."
  validation {
    condition     = length(var.tt_vcn2_web_ingress_destination_ports) == 0 ? true : alltrue([for v in var.tt_vcn2_web_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn2_web_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
variable "tt_vcn2_app_subnet_name" {
  type        = string
  default     = null
  description = "The Application subnet name."
}
variable "tt_vcn2_app_subnet_cidr" {
  type        = string
  default     = null
  description = "The Application subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.tt_vcn2_app_subnet_cidr == null || can(cidrhost(var.tt_vcn2_app_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn2_app_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.1.0.0/24)."
  }
}
variable "tt_vcn2_app_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:80"]
  description = "The list of protocols and destination ports allowed for ingress packets into App Network Security Group. Each list value is a colon-separated entry like 'TCP:80'."
  validation {
    condition     = length(var.tt_vcn2_app_ingress_destination_ports) == 0 ? true : alltrue([for v in var.tt_vcn2_app_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn2_app_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
variable "tt_vcn2_db_subnet_name" {
  type        = string
  default     = null
  description = "The Database subnet name."
}
variable "tt_vcn2_db_subnet_cidr" {
  type        = string
  default     = null
  description = "The Database subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.tt_vcn2_db_subnet_cidr == null || can(cidrhost(var.tt_vcn2_db_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn2_db_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.1.0.0/24)."
  }
}
variable "tt_vcn2_db_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:1521", "TCP:1522"]
  description = "The list of protocols and destination ports allowed for ingress packets into DB Network Security Group. Each list value is a colon-separated entry like 'TCP:1521'."
  validation {
    condition     = length(var.tt_vcn2_db_ingress_destination_ports) == 0 ? true : alltrue([for v in var.tt_vcn2_db_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn2_db_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
variable "deploy_tt_vcn2_bastion_subnet" {
  type        = bool
  default     = false
  description = "Whether to deploy a subnet where you can further deploy OCI Bastion service or a jump host."
}
variable "tt_vcn2_bastion_subnet_name" {
  type        = string
  default     = null
  description = "The Bastion subnet name."
}
variable "tt_vcn2_bastion_subnet_cidr" {
  type        = string
  default     = null
  description = "The Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.tt_vcn2_bastion_subnet_cidr == null || can(cidrhost(var.tt_vcn2_bastion_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn2_bastion_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.1.0.0/24)."
  }
}
variable "tt_vcn2_bastion_is_access_via_public_endpoint" {
  type        = bool
  default     = false
  description = "If true, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed."
}
variable "tt_vcn2_bastion_subnet_allowed_cidrs" {
  type        = list(string)
  default     = []
  description = "List of CIDRs blocks allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access."
  validation {
    condition     = length(var.tt_vcn2_bastion_subnet_allowed_cidrs) == 0 ? true : alltrue([for v in var.tt_vcn2_bastion_subnet_allowed_cidrs : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn2_bastion_subnet_allowed_cidrs variable: all values must be in valid CIDR notation (e.g., 10.0.0.0/20)."
  }
}
variable "tt_vcn2_onprem_route_enable" {
  type        = bool
  default     = false
  description = "This will drive the creation of the routes and security list rules."
}
variable "add_tt_vcn3" {
  type        = bool
  default     = false
  description = "Whether to add a third VCN configured for three-tier workload deployments, with up to four subnets: web (public by default), application (private), database (private). An optional subnet (private by default) for bastion deployment is also available. The added VCN is labelled 'TT-VCN-3'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Network topology."
}

# ------------------------------------------------------
# ----- Networking - Three-tier VCN 3
#-------------------------------------------------------
variable "tt_vcn3_name" {
  type        = string
  default     = null
  description = "The VCN name. If unassigned, a default name is provided. Label: TT-VCN-3."
}
variable "tt_vcn3_cidrs" {
  type        = list(string)
  default     = ["10.2.0.0/20"]
  description = "The list of CIDR blocks for the VCN."
  validation {
    condition     = alltrue([for v in var.tt_vcn3_cidrs : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn3_cidrs variable: all values must be in valid CIDR notation (e.g., 10.2.0.0/20)."
  }
}
variable "tt_vcn3_attach_to_drg" {
  type        = bool
  default     = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}
variable "tt_vcn3_routable_vcns" {
  type        = list(string)
  default     = []
  description = "The VCN labels that this VCN can send traffic to. Only applicable for Network topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3."
  validation {
    condition     = length(var.tt_vcn3_routable_vcns) == 0 ? true : (length(var.tt_vcn3_routable_vcns) == 0 || alltrue([for label in var.tt_vcn3_routable_vcns : contains(["TT-VCN-1", "TT-VCN-2", "EXA-VCN-1", "EXA-VCN-2", "EXA-VCN-3", "OKE-VCN-1", "OKE-VCN-2", "OKE-VCN-3"], label)]))
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn3_routable_vcns variable: it must be empty or contain only valid VCN labels: \"TT-VCN-1\",\"TT-VCN-3\",\"EXA-VCN-1\",\"EXA-VCN-2\",\"EXA-VCN-3\",\"OKE-VCN-1\",\"OKE-VCN-2\",\"OKE-VCN-3\"."
  }
}
variable "define_tt_vcn3_additional_nsgs" {
  type        = bool
  default     = false
  description = "When true, Landing Zone provisions additional TT-VCN-3 NSGs from tt_vcn3_additional_nsgs."
}
variable "tt_vcn3_additional_nsgs" {
  type        = any
  default     = {}
  nullable    = true
  description = "Additional NSGs for TT-VCN-3. Accepts either a native HCL map/object or a JSON object string. Only used when define_tt_vcn3_additional_nsgs is true."

  validation {
    condition = (
      var.tt_vcn3_additional_nsgs == null ||
      try(trimspace(tostring(var.tt_vcn3_additional_nsgs)) == "", false) ||
      can(keys(var.tt_vcn3_additional_nsgs)) ||
      can(keys(jsondecode(var.tt_vcn3_additional_nsgs)))
    )
    error_message = "VALIDATION FAILURE: tt_vcn3_additional_nsgs must be null, empty, a map/object, or a JSON object string."
  }
}
variable "customize_tt_vcn3_subnets" {
  type        = bool
  default     = false
  description = "If true, allows for the customization of default subnets settings. Applicable to RMS deployments only, used for UI displaying."
}
variable "tt_vcn3_web_subnet_name" {
  type        = string
  default     = null
  description = "The Web subnet name."
}
variable "tt_vcn3_web_subnet_cidr" {
  type        = string
  default     = null
  description = "The Web subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.tt_vcn3_web_subnet_cidr == null || can(cidrhost(var.tt_vcn3_web_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn3_web_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.2.0.0/24)."
  }
}
variable "tt_vcn3_web_subnet_is_private" {
  type        = bool
  default     = false
  description = "Whether the Web subnet private. It is public by default."
}
variable "tt_vcn3_external_allowed_cidrs_into_web_tier" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "The list of external CIDRs blocks allowed for ingress packets into tt_vcn3 VCN LBR Network Security Group. Use this to limit the range of IP addresses that can access the web tier."
  validation {
    condition     = length(var.tt_vcn3_external_allowed_cidrs_into_web_tier) == 0 ? true : alltrue([for v in var.tt_vcn3_external_allowed_cidrs_into_web_tier : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn3_external_allowed_cidrs_into_web_tier variable: all values must be in valid CIDR notation (e.g., 178.231.15.71/32)."
  }
}
variable "tt_vcn3_web_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:443"]
  description = "The list of protocols and destination ports allowed for ingress packets into LBR Network Security Group. Each list value is a colon-separated entry like 'TCP:443'."
  validation {
    condition     = length(var.tt_vcn3_web_ingress_destination_ports) == 0 ? true : alltrue([for v in var.tt_vcn3_web_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn3_web_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
variable "tt_vcn3_app_subnet_name" {
  type        = string
  default     = null
  description = "The Application subnet name."
}
variable "tt_vcn3_app_subnet_cidr" {
  type        = string
  default     = null
  description = "The Application subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.tt_vcn3_app_subnet_cidr == null || can(cidrhost(var.tt_vcn3_app_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn3_app_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.2.0.0/24)."
  }
}
variable "tt_vcn3_app_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:80"]
  description = "The list of protocols and destination ports allowed for ingress packets into App Network Security Group. Each list value is a colon-separated entry like 'TCP:80'."
  validation {
    condition     = length(var.tt_vcn3_app_ingress_destination_ports) == 0 ? true : alltrue([for v in var.tt_vcn3_app_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn3_app_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
variable "tt_vcn3_db_subnet_name" {
  type        = string
  default     = null
  description = "The Database subnet name."
}
variable "tt_vcn3_db_subnet_cidr" {
  type        = string
  default     = null
  description = "The Database subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.tt_vcn3_db_subnet_cidr == null || can(cidrhost(var.tt_vcn3_db_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn3_db_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.2.0.0/24)."
  }
}
variable "tt_vcn3_db_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:1521", "TCP:1522"]
  description = "The list of protocols and destination ports allowed for ingress packets into DB Network Security Group. Each list value is a colon-separated entry like 'TCP:1521'."
  validation {
    condition     = length(var.tt_vcn3_db_ingress_destination_ports) == 0 ? true : alltrue([for v in var.tt_vcn3_db_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn3_db_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
variable "deploy_tt_vcn3_bastion_subnet" {
  type        = bool
  default     = false
  description = "Whether to deploy a subnet where you can further deploy OCI Bastion service or a jump host."
}
variable "tt_vcn3_bastion_subnet_name" {
  type        = string
  default     = null
  description = "The Bastion subnet name."
}
variable "tt_vcn3_bastion_subnet_cidr" {
  type        = string
  default     = null
  description = "The Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.tt_vcn3_bastion_subnet_cidr == null || can(cidrhost(var.tt_vcn3_bastion_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn3_bastion_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.2.0.0/24)."
  }
}
variable "tt_vcn3_bastion_is_access_via_public_endpoint" {
  type        = bool
  default     = false
  description = "If true, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed."
}
variable "tt_vcn3_bastion_subnet_allowed_cidrs" {
  type        = list(string)
  default     = []
  description = "List of CIDRs allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access. 0.0.0.0/0 is not allowed."
  validation {
    condition     = length(var.tt_vcn3_bastion_subnet_allowed_cidrs) == 0 ? true : alltrue([for v in var.tt_vcn3_bastion_subnet_allowed_cidrs : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for tt_vcn3_bastion_subnet_allowed_cidrs variable: all values must be in valid CIDR notation (e.g., 10.0.0.0/20)."
  }
}
variable "tt_vcn3_onprem_route_enable" {
  type        = bool
  default     = false
  description = "This will drive the creation of the routes and security list rules."
}
