# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# ------------------------------------------------------
# ----- Networking - Exadata Cloud Service VCN 1
#-------------------------------------------------------
variable "add_exa_vcn1" {
  type        = bool
  default     = false
  description = "Whether to add a VCN configured for Exadata Cloud Service deployment, with two subnets: client (private) and backup (private). The added VCN is labelled 'EXA-VCN-1'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Network topology."
}
variable "exa_vcn1_name" {
  type        = string
  default     = null
  description = "The VCN name. If unassigned, a default name is provided. VCN label: EXA-VCN-1."
}
variable "exa_vcn1_cidrs" {
  type        = list(string)
  default     = ["172.16.0.0/20"]
  description = "The list of CIDR blocks for the VCN."
  validation {
    condition     = alltrue([for v in var.exa_vcn1_cidrs : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for exa_vcn1_cidrs variable: all values must be in valid CIDR notation (e.g., 172.16.0.0/20)."
  }
}
variable "exa_vcn1_attach_to_drg" {
  type        = bool
  default     = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}
variable "exa_vcn1_client_subnet_cidr" {
  type        = string
  default     = null
  description = "The Client subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn1_client_subnet_name" {
  type        = string
  default     = null
  description = "The Client subnet name."
}
variable "exa_vcn1_external_allowed_cidrs_into_client_tier" {
  type        = list(string)
  default     = []
  description = "The list of external CIDR blocks allowed for ingress packets into Exadata VCN1 Client Network Security Group. Use this to limit the range of IP addresses that can access the client tier."
  validation {
    condition     = length(var.exa_vcn1_external_allowed_cidrs_into_client_tier) == 0 ? true : alltrue([for v in var.exa_vcn1_external_allowed_cidrs_into_client_tier : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for exa_vcn1_external_allowed_cidrs_into_client_tier variable: all values must be in valid CIDR notation (e.g., 178.231.15.71/32)."
  }
}
variable "exa_vcn1_client_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:1521", "TCP:1522"]
  description = "The list of protocols and destination ports allowed for ingress packets into Exadata VCN1 Client Network Security Group."
  validation {
    condition     = length(var.exa_vcn1_client_ingress_destination_ports) == 0 ? true : alltrue([for v in var.exa_vcn1_client_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for exa_vcn1_client_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
variable "add_exa_vcn1_backup_subnet" {
  type        = bool
  default     = true
  description = "Whether to add an optional Backup subnet to Exadata VCN 1."
}
variable "exa_vcn1_backup_subnet_cidr" {
  type        = string
  default     = null
  description = "The Backup subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn1_backup_subnet_name" {
  type        = string
  default     = null
  description = "The Backup subnet name."
}
variable "add_exa_vcn1_integration_subnet" {
  type        = bool
  default     = false
  description = "Whether to add an optional Integration subnet to Exadata VCN 1."
}
variable "exa_vcn1_integration_subnet_cidr" {
  type        = string
  default     = null
  description = "The Integration subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn1_integration_subnet_name" {
  type        = string
  default     = null
  description = "The Integration subnet name."
}
variable "exa_vcn1_external_allowed_cidrs_into_integration_tier" {
  type        = list(string)
  default     = []
  description = "The list of external CIDR blocks allowed for ingress packets into Exadata VCN1 Integration Network Security Group. Use this to limit the range of IP addresses that can access the integration tier."
  validation {
    condition     = length(var.exa_vcn1_external_allowed_cidrs_into_integration_tier) == 0 ? true : alltrue([for v in var.exa_vcn1_external_allowed_cidrs_into_integration_tier : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for exa_vcn1_external_allowed_cidrs_into_integration_tier variable: all values must be in valid CIDR notation (e.g., 178.231.15.71/32)."
  }
}
variable "exa_vcn1_integration_ingress_destination_ports" {
  type        = list(string)
  default     = []
  description = "The list of protocols and destination ports allowed for ingress packets into Exadata VCN1 Integration Network Security Group."
  validation {
    condition     = length(var.exa_vcn1_integration_ingress_destination_ports) == 0 ? true : alltrue([for v in var.exa_vcn1_integration_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for exa_vcn1_integration_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
variable "exa_vcn1_routable_vcns" {
  type        = list(string)
  default     = []
  description = "The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Network topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3."
}
variable "define_exa_vcn1_additional_nsgs" {
  type        = bool
  default     = false
  description = "When true, Landing Zone provisions additional EXA-VCN-1 NSGs from exa_vcn1_additional_nsgs."
}
variable "exa_vcn1_additional_nsgs" {
  type        = any
  default     = {}
  nullable    = true
  description = "Additional NSGs for EXA-VCN-1. Accepts either a native HCL map/object or a JSON object string. Only used when define_exa_vcn1_additional_nsgs is true."

  validation {
    condition = (
      var.exa_vcn1_additional_nsgs == null ||
      try(trimspace(tostring(var.exa_vcn1_additional_nsgs)) == "", false) ||
      can(keys(var.exa_vcn1_additional_nsgs)) ||
      can(keys(jsondecode(var.exa_vcn1_additional_nsgs)))
    )
    error_message = "VALIDATION FAILURE: exa_vcn1_additional_nsgs must be null, empty, a map/object, or a JSON object string."
  }
}
variable "exa_vcn1_onprem_route_enable" {
  type        = bool
  default     = false
  description = "This will drive the creation of the routes and security list rules."
}
variable "customize_exa_vcn1_subnets" {
  type        = bool
  default     = false
  description = "If true, allows for the customization of default subnets settings. Applicable to RMS deployments only, used for UI displaying."
}
# ------------------------------------------------------
# ----- Networking - Exadata Cloud Service VCN 2
#-------------------------------------------------------

variable "add_exa_vcn2" {
  type        = bool
  default     = false
  description = "Whether to add a second VCN configured for Exadata Cloud Service deployment, with two subnets: client (private) and backup (private). The added VCN is labelled 'EXA-VCN-2'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Network topology."
}
variable "exa_vcn2_cidrs" {
  type        = list(string)
  default     = ["172.17.0.0/20"]
  description = "The list of CIDR blocks for the VCN."
  validation {
    condition     = alltrue([for v in var.exa_vcn2_cidrs : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for exa_vcn2_cidrs variable: all values must be in valid CIDR notation (e.g., 172.17.0.0/20)."
  }
}
variable "exa_vcn2_attach_to_drg" {
  type        = bool
  default     = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}
variable "exa_vcn2_name" {
  default     = null
  type        = string
  description = "The VCN name. If unassigned, a default name is provided. VCN label: EXA-VCN-2"
}
variable "exa_vcn2_client_subnet_cidr" {
  type        = string
  default     = null
  description = "The Client subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn2_client_subnet_name" {
  type        = string
  default     = null
  description = "The Client subnet name."
}
variable "exa_vcn2_external_allowed_cidrs_into_client_tier" {
  type        = list(string)
  default     = []
  description = "The list of external CIDR blocks allowed for ingress packets into Exadata VCN2 Client Network Security Group. Use this to limit the range of IP addresses that can access the client tier."
  validation {
    condition     = length(var.exa_vcn2_external_allowed_cidrs_into_client_tier) == 0 ? true : alltrue([for v in var.exa_vcn2_external_allowed_cidrs_into_client_tier : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for exa_vcn2_external_allowed_cidrs_into_client_tier variable: all values must be in valid CIDR notation (e.g., 178.231.15.71/32)."
  }
}
variable "exa_vcn2_client_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:1521", "TCP:1522"]
  description = "The list of protocols and destination ports allowed for ingress packets into Exadata VCN2 Client Network Security Group."
  validation {
    condition     = length(var.exa_vcn2_client_ingress_destination_ports) == 0 ? true : alltrue([for v in var.exa_vcn2_client_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for exa_vcn2_client_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
variable "add_exa_vcn2_backup_subnet" {
  type        = bool
  default     = true
  description = "Whether to add an optional Backup subnet to Exadata VCN 2."
}
variable "exa_vcn2_backup_subnet_cidr" {
  type        = string
  default     = null
  description = "The Backup subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn2_backup_subnet_name" {
  type        = string
  default     = null
  description = "The Backup subnet name."
}
variable "add_exa_vcn2_integration_subnet" {
  type        = bool
  default     = false
  description = "Whether to add an optional Integration subnet to Exadata VCN 2."
}
variable "exa_vcn2_integration_subnet_cidr" {
  type        = string
  default     = null
  description = "The Integration subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn2_integration_subnet_name" {
  type        = string
  default     = null
  description = "The Integration subnet name."
}
variable "exa_vcn2_external_allowed_cidrs_into_integration_tier" {
  type        = list(string)
  default     = []
  description = "The list of external CIDR blocks allowed for ingress packets into Exadata VCN2 Integration Network Security Group. Use this to limit the range of IP addresses that can access the integration tier."
  validation {
    condition     = length(var.exa_vcn2_external_allowed_cidrs_into_integration_tier) == 0 ? true : alltrue([for v in var.exa_vcn2_external_allowed_cidrs_into_integration_tier : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for exa_vcn2_external_allowed_cidrs_into_integration_tier variable: all values must be in valid CIDR notation (e.g., 178.231.15.71/32)."
  }
}
variable "exa_vcn2_integration_ingress_destination_ports" {
  type        = list(string)
  default     = []
  description = "The list of protocols and destination ports allowed for ingress packets into Exadata VCN2 Integration Network Security Group."
  validation {
    condition     = length(var.exa_vcn2_integration_ingress_destination_ports) == 0 ? true : alltrue([for v in var.exa_vcn2_integration_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for exa_vcn2_integration_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
variable "exa_vcn2_routable_vcns" {
  type        = list(string)
  default     = []
  description = "The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Network topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3."
}
variable "define_exa_vcn2_additional_nsgs" {
  type        = bool
  default     = false
  description = "When true, Landing Zone provisions additional EXA-VCN-2 NSGs from exa_vcn2_additional_nsgs."
}
variable "exa_vcn2_additional_nsgs" {
  type        = any
  default     = {}
  nullable    = true
  description = "Additional NSGs for EXA-VCN-2. Accepts either a native HCL map/object or a JSON object string. Only used when define_exa_vcn2_additional_nsgs is true."

  validation {
    condition = (
      var.exa_vcn2_additional_nsgs == null ||
      try(trimspace(tostring(var.exa_vcn2_additional_nsgs)) == "", false) ||
      can(keys(var.exa_vcn2_additional_nsgs)) ||
      can(keys(jsondecode(var.exa_vcn2_additional_nsgs)))
    )
    error_message = "VALIDATION FAILURE: exa_vcn2_additional_nsgs must be null, empty, a map/object, or a JSON object string."
  }
}
variable "exa_vcn2_onprem_route_enable" {
  type        = bool
  default     = false
  description = "This will drive the creation of the routes and security list rules."
}
variable "customize_exa_vcn2_subnets" {
  type        = bool
  default     = false
  description = "If true, allows for the customization of default subnets settings. Applicable to RMS deployments only, used for UI displaying."
}
# ------------------------------------------------------
# ----- Networking - Exadata Cloud Service VCN 3
#-------------------------------------------------------
variable "add_exa_vcn3" {
  type        = bool
  default     = false
  description = "Whether to add a third VCN configured for Exadata Cloud Service deployment, with two subnets: client (private) and backup (private). The added VCN is labelled 'EXA-VCN-3'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Network topology."
}
variable "exa_vcn3_cidrs" {
  type        = list(string)
  default     = ["172.18.0.0/20"]
  description = "The list of CIDR blocks for the VCN."
  validation {
    condition     = alltrue([for v in var.exa_vcn3_cidrs : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for exa_vcn3_cidrs variable: all values must be in valid CIDR notation (e.g., 172.18.0.0/20)."
  }
}
variable "exa_vcn3_attach_to_drg" {
  type        = bool
  default     = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}

variable "exa_vcn3_name" {
  type        = string
  default     = null
  description = "The VCN name. If unassigned, a default name is provided. Label: EXA-VCN-3."
}
variable "exa_vcn3_client_subnet_cidr" {
  type        = string
  default     = null
  description = "The Client subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn3_client_subnet_name" {
  type        = string
  default     = null
  description = "The Client subnet name."
}
variable "exa_vcn3_external_allowed_cidrs_into_client_tier" {
  type        = list(string)
  default     = []
  description = "The list of external CIDR blocks allowed for ingress packets into Exadata VCN3 Client Network Security Group. Use this to limit the range of IP addresses that can access the client tier."
  validation {
    condition     = length(var.exa_vcn3_external_allowed_cidrs_into_client_tier) == 0 ? true : alltrue([for v in var.exa_vcn3_external_allowed_cidrs_into_client_tier : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for exa_vcn3_external_allowed_cidrs_into_client_tier variable: all values must be in valid CIDR notation (e.g., 178.231.15.71/32)."
  }
}
variable "exa_vcn3_client_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:1521", "TCP:1522"]
  description = "The list of protocols and destination ports allowed for ingress packets into Exadata VCN3 Client Network Security Group."
  validation {
    condition     = length(var.exa_vcn3_client_ingress_destination_ports) == 0 ? true : alltrue([for v in var.exa_vcn3_client_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for exa_vcn3_client_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
variable "add_exa_vcn3_backup_subnet" {
  type        = bool
  default     = true
  description = "Whether to add an optional Backup subnet to Exadata VCN 3."
}
variable "exa_vcn3_backup_subnet_cidr" {
  type        = string
  default     = null
  description = "The Backup subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn3_backup_subnet_name" {
  type        = string
  default     = null
  description = "The Backup subnet name."
}
variable "add_exa_vcn3_integration_subnet" {
  type        = bool
  default     = false
  description = "Whether to add an optional Integration subnet to Exadata VCN 3."
}
variable "exa_vcn3_integration_subnet_cidr" {
  type        = string
  default     = null
  description = "The Integration subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn3_integration_subnet_name" {
  type        = string
  default     = null
  description = "The Integration subnet name."
}
variable "exa_vcn3_external_allowed_cidrs_into_integration_tier" {
  type        = list(string)
  default     = []
  description = "The list of external CIDR blocks allowed for ingress packets into Exadata VCN3 Integration Network Security Group. Use this to limit the range of IP addresses that can access the integration tier."
  validation {
    condition     = length(var.exa_vcn3_external_allowed_cidrs_into_integration_tier) == 0 ? true : alltrue([for v in var.exa_vcn3_external_allowed_cidrs_into_integration_tier : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for exa_vcn3_external_allowed_cidrs_into_integration_tier variable: all values must be in valid CIDR notation (e.g., 178.231.15.71/32)."
  }
}
variable "exa_vcn3_integration_ingress_destination_ports" {
  type        = list(string)
  default     = []
  description = "The list of protocols and destination ports allowed for ingress packets into Exadata VCN3 Integration Network Security Group."
  validation {
    condition     = length(var.exa_vcn3_integration_ingress_destination_ports) == 0 ? true : alltrue([for v in var.exa_vcn3_integration_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for exa_vcn3_integration_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}
variable "exa_vcn3_routable_vcns" {
  type        = list(string)
  default     = []
  description = "The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Network topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN2, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3."
}
variable "define_exa_vcn3_additional_nsgs" {
  type        = bool
  default     = false
  description = "When true, Landing Zone provisions additional EXA-VCN-3 NSGs from exa_vcn3_additional_nsgs."
}
variable "exa_vcn3_additional_nsgs" {
  type        = any
  default     = {}
  nullable    = true
  description = "Additional NSGs for EXA-VCN-3. Accepts either a native HCL map/object or a JSON object string. Only used when define_exa_vcn3_additional_nsgs is true."

  validation {
    condition = (
      var.exa_vcn3_additional_nsgs == null ||
      try(trimspace(tostring(var.exa_vcn3_additional_nsgs)) == "", false) ||
      can(keys(var.exa_vcn3_additional_nsgs)) ||
      can(keys(jsondecode(var.exa_vcn3_additional_nsgs)))
    )
    error_message = "VALIDATION FAILURE: exa_vcn3_additional_nsgs must be null, empty, a map/object, or a JSON object string."
  }
}
variable "exa_vcn3_onprem_route_enable" {
  type        = bool
  default     = false
  description = "This will drive the creation of the routes and security list rules."
}
variable "customize_exa_vcn3_subnets" {
  type        = bool
  default     = false
  description = "If true, allows for the customization of default subnets settings. Applicable to RMS deployments only, used for UI displaying."
}
