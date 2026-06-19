# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# ------------------------------------------------------
# ----- Networking - OKE VCN 1
#-------------------------------------------------------

variable "add_oke_vcn1" {
  type        = bool
  default     = false
  description = "Whether to add a VCN configured for OKE workload deployments, with at least three subnets: service (public by default), workers (private) and API endpoint (private). Additionally, a private subnet for pods deployment is created if the OKE CNI Type is 'Native'. You can also enable an extra private subnet for managing the OKE cluster. The added VCN is labelled 'OKE-VCN-1'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Network topology."
}

variable "oke_vcn1_cni_type" {
  type        = string
  default     = "Flannel"
  description = "The CNI type for the OKE cluster. Valid values: 'Flannel' (default), 'Native'. If 'Native', a private subnet for pods deployment is created."
}

variable "oke_vcn1_name" {
  type        = string
  default     = null
  description = "The VCN name. If unassigned a default name is provided."
}

variable "oke_vcn1_cidrs" {
  type        = list(string)
  default     = ["10.3.0.0/16"]
  description = "The list of CIDR blocks for the VCN."
  validation {
    condition     = alltrue([for v in var.oke_vcn1_cidrs : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn1_cidrs variable: all values must be in valid CIDR notation (e.g., 10.3.0.0/16)."
  }
}

variable "oke_vcn1_attach_to_drg" {
  type        = bool
  default     = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}

variable "oke_vcn1_routable_vcns" {
  type        = list(string)
  default     = []
  description = "The VCN labels that this VCN can send traffic to. Only applicable for Network topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-2, OKE-VCN-3."
  validation {
    condition     = length(var.oke_vcn1_routable_vcns) == 0 ? true : (length(var.oke_vcn1_routable_vcns) == 0 || alltrue([for label in var.oke_vcn1_routable_vcns : contains(["TT-VCN-1", "TT-VCN-2", "TT-VCN-3", "EXA-VCN-1", "EXA-VCN-2", "EXA-VCN-3", "OKE-VCN-2", "OKE-VCN-3"], label)]))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn1_routable_vcns variable: it must be empty or contain only valid VCN labels: \"TT-VCN-1\",\"TT-VCN-2\",\"TT-VCN-3\",\"EXA-VCN-1\",\"EXA-VCN-2\",\"EXA-VCN-3\",\"OKE-VCN-2\",\"OKE-VCN-3\"."
  }
}

variable "define_oke_vcn1_additional_nsgs" {
  type        = bool
  default     = false
  description = "When true, Landing Zone provisions additional OKE-VCN-1 NSGs from oke_vcn1_additional_nsgs."
}

variable "oke_vcn1_additional_nsgs" {
  type        = any
  default     = {}
  nullable    = true
  description = "Additional NSGs for OKE-VCN-1. Accepts either a native HCL map/object or a JSON object string. Only used when define_oke_vcn1_additional_nsgs is true."

  validation {
    condition = (
      var.oke_vcn1_additional_nsgs == null ||
      try(trimspace(tostring(var.oke_vcn1_additional_nsgs)) == "", false) ||
      can(keys(var.oke_vcn1_additional_nsgs)) ||
      can(keys(jsondecode(var.oke_vcn1_additional_nsgs)))
    )
    error_message = "VALIDATION FAILURE: oke_vcn1_additional_nsgs must be null, empty, a map/object, or a JSON object string."
  }
}

variable "oke_vcn1_api_subnet_cidr" {
  type        = string
  default     = null
  description = "The API subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn1_api_subnet_cidr == null || can(cidrhost(var.oke_vcn1_api_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn1_api_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.3.0.0/16)."
  }
}

variable "oke_vcn1_api_subnet_name" {
  type        = string
  default     = null
  description = "The API subnet name."
}

variable "oke_vcn1_workers_subnet_cidr" {
  type        = string
  default     = null
  description = "The Workers subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn1_workers_subnet_cidr == null || can(cidrhost(var.oke_vcn1_workers_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn1_workers_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.3.0.0/16)."
  }
}

variable "oke_vcn1_workers_subnet_name" {
  type        = string
  default     = null
  description = "The Workers subnet name."
}

variable "oke_vcn1_services_subnet_cidr" {
  type        = string
  default     = null
  description = "The Services subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn1_services_subnet_cidr == null || can(cidrhost(var.oke_vcn1_services_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn1_services_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.3.0.0/16)."
  }
}

variable "oke_vcn1_services_subnet_is_private" {
  type        = bool
  default     = false
  description = "Whether the Services subnet private. It is public by default."
}

variable "oke_vcn1_services_subnet_name" {
  type        = string
  default     = null
  description = "The Services subnet name."
}

variable "oke_vcn1_external_allowed_cidrs_into_services_tier" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "The list of external CIDRs blocks allowed for ingress packets into oke_vcn1 VCN Services Network Security Group. Use this to limit the range of IP addresses that can access the services tier."
  validation {
    condition     = length(var.oke_vcn1_external_allowed_cidrs_into_services_tier) == 0 ? true : alltrue([for v in var.oke_vcn1_external_allowed_cidrs_into_services_tier : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn1_external_allowed_cidrs_into_services_tier variable: all values must be in valid CIDR notation (e.g., 178.231.15.71/32)."
  }
}

variable "oke_vcn1_services_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:443"]
  description = "The list of protocols and destination ports allowed for ingress packets into OKE Services Network Security Group."
  validation {
    condition     = length(var.oke_vcn1_services_ingress_destination_ports) == 0 ? true : alltrue([for v in var.oke_vcn1_services_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn1_services_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}


variable "add_oke_vcn1_db_subnet" {
  type        = bool
  default     = false
  description = "Whether to add an optional private database subnet for workloads running in OKE VCN 1."
}

variable "oke_vcn1_db_subnet_cidr" {
  type        = string
  default     = null
  description = "The Database subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn1_db_subnet_cidr == null || can(cidrhost(var.oke_vcn1_db_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn1_db_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.3.0.0/28)."
  }
}

variable "oke_vcn1_db_subnet_name" {
  type        = string
  default     = null
  description = "The Database subnet name."
}

variable "oke_vcn1_db_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:1521"]
  description = "Protocols and destination ports allowed for ingress packets into the OKE VCN1 database Network Security Group. Each value must be in the form protocol:port (e.g., 'TCP:1521')."
  validation {
    condition     = length(var.oke_vcn1_db_ingress_destination_ports) == 0 ? true : alltrue([for v in var.oke_vcn1_db_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn1_db_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}

variable "add_oke_vcn1_mgmt_subnet" {
  type        = bool
  default     = false
  description = "Whether to add a private subnet for cluster management."
}

variable "oke_vcn1_mgmt_subnet_cidr" {
  type        = string
  default     = null
  description = "The Management subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn1_mgmt_subnet_cidr == null || can(cidrhost(var.oke_vcn1_mgmt_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn1_mgmt_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.3.0.0/16)."
  }
}

variable "oke_vcn1_mgmt_subnet_name" {
  type        = string
  default     = null
  description = "The Management subnet name."
}

variable "oke_vcn1_pods_subnet_name" {
  type        = string
  default     = null
  description = "The Pods subnet name. A private subnet for pods deployment is automatically added if oke_vcn1_cni_type value is 'Native'."
}

variable "oke_vcn1_pods_subnet_cidr" {
  type        = string
  default     = null
  description = "The Pods subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn1_pods_subnet_cidr == null || can(cidrhost(var.oke_vcn1_pods_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn1_pods_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.3.0.0/16)."
  }
}

variable "oke_vcn1_onprem_route_enable" {
  type        = bool
  default     = false
  description = "This will drive the creation of the routes and security list rules."
}

variable "customize_oke_vcn1_subnets" {
  type        = bool
  default     = false
  description = "If true, allows for the customization of default subnets settings. Applicable to RMS deployments only, used for UI displaying."
}
# ------------------------------------------------------
# ----- Networking - OKE VCN 2
#-------------------------------------------------------

variable "add_oke_vcn2" {
  type        = bool
  default     = false
  description = "Whether to add a second VCN configured for OKE workload deployments, with at least three subnets: service (public by default), workers (private) and API endpoint (private). Additionally, a private subnet for pods deployment is created if the OKE CNI Type is 'Native'. You can also enable an extra private subnet for managing the OKE cluster. The added VCN is labelled 'OKE-VCN-2'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Network topology."
}

variable "oke_vcn2_cni_type" {
  type        = string
  default     = "Flannel"
  description = "The CNI type for the OKE cluster. Valid values: 'Flannel' (default), 'Native'. If 'Native', a private subnet for pods deployment is created."
}

variable "oke_vcn2_name" {
  type        = string
  default     = null
  description = "The VCN name. If unassigned, a default name is provided."
}

variable "oke_vcn2_cidrs" {
  type        = list(string)
  default     = ["10.4.0.0/16"]
  description = "The list of CIDR blocks for the VCN."
  validation {
    condition     = alltrue([for v in var.oke_vcn2_cidrs : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn2_cidrs variable: all values must be in valid CIDR notation (e.g., 10.4.0.0/16)."
  }
}

variable "oke_vcn2_attach_to_drg" {
  type        = bool
  default     = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}

variable "oke_vcn2_routable_vcns" {
  type        = list(string)
  default     = []
  description = "The VCN labels that this VCN can send traffic to. Only applicable for Network topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-3"
  validation {
    condition     = length(var.oke_vcn2_routable_vcns) == 0 ? true : (length(var.oke_vcn2_routable_vcns) == 0 || alltrue([for label in var.oke_vcn2_routable_vcns : contains(["TT-VCN-1", "TT-VCN-2", "TT-VCN-3", "EXA-VCN-1", "EXA-VCN-2", "EXA-VCN-3", "OKE-VCN-1", "OKE-VCN-3"], label)]))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn1_routable_vcns variable: it must be empty or contain only valid VCN labels: \"TT-VCN-1\",\"TT-VCN-2\",\"TT-VCN-3\",\"EXA-VCN-1\",\"EXA-VCN-2\",\"EXA-VCN-3\",\"OKE-VCN-1\",\"OKE-VCN-3\"."
  }
}

variable "define_oke_vcn2_additional_nsgs" {
  type        = bool
  default     = false
  description = "When true, Landing Zone provisions additional OKE-VCN-2 NSGs from oke_vcn2_additional_nsgs."
}

variable "oke_vcn2_additional_nsgs" {
  type        = any
  default     = {}
  nullable    = true
  description = "Additional NSGs for OKE-VCN-2. Accepts either a native HCL map/object or a JSON object string. Only used when define_oke_vcn2_additional_nsgs is true."

  validation {
    condition = (
      var.oke_vcn2_additional_nsgs == null ||
      try(trimspace(tostring(var.oke_vcn2_additional_nsgs)) == "", false) ||
      can(keys(var.oke_vcn2_additional_nsgs)) ||
      can(keys(jsondecode(var.oke_vcn2_additional_nsgs)))
    )
    error_message = "VALIDATION FAILURE: oke_vcn2_additional_nsgs must be null, empty, a map/object, or a JSON object string."
  }
}

variable "oke_vcn2_api_subnet_cidr" {
  type        = string
  default     = null
  description = "The API subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn2_api_subnet_cidr == null || can(cidrhost(var.oke_vcn2_api_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn2_api_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.4.0.0/16)."
  }
}

variable "oke_vcn2_api_subnet_name" {
  type        = string
  default     = null
  description = "The API subnet name."
}

variable "oke_vcn2_workers_subnet_cidr" {
  type        = string
  default     = null
  description = "The Workers subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn2_workers_subnet_cidr == null || can(cidrhost(var.oke_vcn2_workers_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn2_workers_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.4.0.0/16)."
  }
}

variable "oke_vcn2_workers_subnet_name" {
  type        = string
  default     = null
  description = "The Workers subnet name."
}

variable "oke_vcn2_services_subnet_cidr" {
  type        = string
  default     = null
  description = "The Services subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn2_services_subnet_cidr == null || can(cidrhost(var.oke_vcn2_services_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn2_services_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.4.0.0/16)."
  }
}

variable "oke_vcn2_services_subnet_is_private" {
  type        = bool
  default     = false
  description = "Whether the Services subnet private. It is public by default."
}

variable "oke_vcn2_services_subnet_name" {
  type        = string
  default     = null
  description = "The Services subnet name."
}

variable "oke_vcn2_external_allowed_cidrs_into_services_tier" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "The list of external CIDRs blocks allowed for ingress packets into oke_vcn2 VCN Services Network Security Group. Use this to limit the range of IP addresses that can access the services tier."
  validation {
    condition     = length(var.oke_vcn2_external_allowed_cidrs_into_services_tier) == 0 ? true : alltrue([for v in var.oke_vcn2_external_allowed_cidrs_into_services_tier : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn2_external_allowed_cidrs_into_services_tier variable: all values must be in valid CIDR notation (e.g., 178.231.15.71/32)."
  }
}

variable "oke_vcn2_services_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:443"]
  description = "The list of protocols and destination ports allowed for ingress packets into OKE Services Network Security Group."
  validation {
    condition     = length(var.oke_vcn2_services_ingress_destination_ports) == 0 ? true : alltrue([for v in var.oke_vcn2_services_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn2_services_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}

variable "add_oke_vcn2_db_subnet" {
  type        = bool
  default     = false
  description = "Whether to add an optional private database subnet for workloads running in OKE VCN 2."
}

variable "oke_vcn2_db_subnet_cidr" {
  type        = string
  default     = null
  description = "The Database subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn2_db_subnet_cidr == null || can(cidrhost(var.oke_vcn2_db_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn2_db_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.4.0.0/28)."
  }
}

variable "oke_vcn2_db_subnet_name" {
  type        = string
  default     = null
  description = "The Database subnet name."
}

variable "oke_vcn2_db_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:1521"]
  description = "Protocols and destination ports allowed for ingress packets into the OKE VCN2 database Network Security Group. Each value must be in the form protocol:port (e.g., 'TCP:1521')."
  validation {
    condition     = length(var.oke_vcn2_db_ingress_destination_ports) == 0 ? true : alltrue([for v in var.oke_vcn2_db_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn2_db_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}

variable "add_oke_vcn2_mgmt_subnet" {
  type        = bool
  default     = false
  description = "Whether to add a private subnet for cluster management."
}

variable "oke_vcn2_mgmt_subnet_cidr" {
  type        = string
  default     = null
  description = "The Management subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn2_mgmt_subnet_cidr == null || can(cidrhost(var.oke_vcn2_mgmt_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn2_mgmt_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.4.0.0/16)."
  }
}

variable "oke_vcn2_mgmt_subnet_name" {
  type        = string
  default     = null
  description = "The Management subnet name."
}

variable "oke_vcn2_pods_subnet_name" {
  type        = string
  default     = null
  description = "The pods subnet name. A private subnet for pods deployment is automatically added if oke_vcn2_cni_type value is 'Native'."
}

variable "oke_vcn2_pods_subnet_cidr" {
  type        = string
  default     = null
  description = "The Pods subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn2_pods_subnet_cidr == null || can(cidrhost(var.oke_vcn2_pods_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn2_pods_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.4.0.0/16)."
  }
}

variable "oke_vcn2_onprem_route_enable" {
  type        = bool
  default     = false
  description = "This will drive the creation of the routes and security list rules."
}

variable "customize_oke_vcn2_subnets" {
  type        = bool
  default     = false
  description = "If true, allows for the customization of default subnets settings. Applicable to RMS deployments only, used for UI displaying."
}
# ------------------------------------------------------
# ----- Networking - OKE VCN 3
#-------------------------------------------------------

variable "add_oke_vcn3" {
  type        = bool
  default     = false
  description = "Whether to add a third VCN configured for OKE workload deployments, with at least three subnets: service (public by default), workers (private) and API endpoint (private). Additionally, a private subnet for pods deployment is created if the OKE CNI Type is 'Native'. You can also enable an extra private subnet for managing the OKE cluster. The added VCN is labelled 'OKE-VCN-3'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Network topology."
}

variable "oke_vcn3_cni_type" {
  type        = string
  default     = "Flannel"
  description = "The CNI type for the OKE cluster. Valid values: 'Flannel' (default), 'Native'. If 'Native', a private subnet for pods deployment is created."
}

variable "oke_vcn3_name" {
  type        = string
  default     = null
  description = "The VCN name. If unassigned, a default name is provided."
}

variable "oke_vcn3_cidrs" {
  type        = list(string)
  default     = ["10.5.0.0/16"]
  description = "The list of CIDR blocks for the VCN."
  validation {
    condition     = alltrue([for v in var.oke_vcn3_cidrs : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn3_cidrs variable: all values must be in valid CIDR notation (e.g., 10.5.0.0/16)."
  }
}

variable "oke_vcn3_attach_to_drg" {
  type        = bool
  default     = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}

variable "oke_vcn3_routable_vcns" {
  type        = list(string)
  default     = []
  description = "The VCN labels that this VCN can send traffic to. Only applicable for Network topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2."
  validation {
    condition     = length(var.oke_vcn3_routable_vcns) == 0 ? true : (length(var.oke_vcn3_routable_vcns) == 0 || alltrue([for label in var.oke_vcn3_routable_vcns : contains(["TT-VCN-1", "TT-VCN-2", "TT-VCN-3", "EXA-VCN-1", "EXA-VCN-2", "EXA-VCN-3", "OKE-VCN-1", "OKE-VCN-2"], label)]))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn3_routable_vcns variable: it must be empty or contain only valid VCN labels: \"TT-VCN-1\",\"TT-VCN-2\",\"TT-VCN-3\",\"EXA-VCN-1\",\"EXA-VCN-2\",\"EXA-VCN-3\",\"OKE-VCN-1\",\"OKE-VCN-2\"."
  }
}

variable "define_oke_vcn3_additional_nsgs" {
  type        = bool
  default     = false
  description = "When true, Landing Zone provisions additional OKE-VCN-3 NSGs from oke_vcn3_additional_nsgs."
}

variable "oke_vcn3_additional_nsgs" {
  type        = any
  default     = {}
  nullable    = true
  description = "Additional NSGs for OKE-VCN-3. Accepts either a native HCL map/object or a JSON object string. Only used when define_oke_vcn3_additional_nsgs is true."

  validation {
    condition = (
      var.oke_vcn3_additional_nsgs == null ||
      try(trimspace(tostring(var.oke_vcn3_additional_nsgs)) == "", false) ||
      can(keys(var.oke_vcn3_additional_nsgs)) ||
      can(keys(jsondecode(var.oke_vcn3_additional_nsgs)))
    )
    error_message = "VALIDATION FAILURE: oke_vcn3_additional_nsgs must be null, empty, a map/object, or a JSON object string."
  }
}

variable "oke_vcn3_api_subnet_cidr" {
  type        = string
  default     = null
  description = "The API subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn3_api_subnet_cidr == null || can(cidrhost(var.oke_vcn3_api_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn3_api_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.5.0.0/16)."
  }
}

variable "oke_vcn3_api_subnet_name" {
  type        = string
  default     = null
  description = "The API subnet name."
}

variable "oke_vcn3_workers_subnet_cidr" {
  type        = string
  default     = null
  description = "The Workers subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn3_workers_subnet_cidr == null || can(cidrhost(var.oke_vcn3_workers_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn3_workers_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.5.0.0/16)."
  }
}

variable "oke_vcn3_workers_subnet_name" {
  type        = string
  default     = null
  description = "The Workers subnet name."
}

variable "oke_vcn3_services_subnet_cidr" {
  type        = string
  default     = null
  description = "The Services subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn3_services_subnet_cidr == null || can(cidrhost(var.oke_vcn3_services_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn3_services_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.5.0.0/16)."
  }
}

variable "oke_vcn3_services_subnet_is_private" {
  type        = bool
  default     = false
  description = "Whether the Services subnet private. It is public by default."
}

variable "oke_vcn3_services_subnet_name" {
  type        = string
  default     = null
  description = "The Services subnet name."
}

variable "oke_vcn3_external_allowed_cidrs_into_services_tier" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "The list of external CIDRs blocks allowed for ingress packets into oke_vcn3 VCN Services Network Security Group. Use this to limit the range of IP addresses that can access the services tier."
  validation {
    condition     = length(var.oke_vcn3_external_allowed_cidrs_into_services_tier) == 0 ? true : alltrue([for v in var.oke_vcn3_external_allowed_cidrs_into_services_tier : can(cidrhost(v, 0))])
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn3_external_allowed_cidrs_into_services_tier variable: all values must be in valid CIDR notation (e.g., 178.231.15.71/32)."
  }
}

variable "oke_vcn3_services_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:443"]
  description = "The list of protocols and destination ports allowed for ingress packets into OKE Services Network Security Group."
  validation {
    condition     = length(var.oke_vcn3_services_ingress_destination_ports) == 0 ? true : alltrue([for v in var.oke_vcn3_services_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn3_services_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}

variable "add_oke_vcn3_db_subnet" {
  type        = bool
  default     = false
  description = "Whether to add an optional private database subnet for workloads running in OKE VCN 3."
}

variable "oke_vcn3_db_subnet_cidr" {
  type        = string
  default     = null
  description = "The Database subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn3_db_subnet_cidr == null || can(cidrhost(var.oke_vcn3_db_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn3_db_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.5.0.0/28)."
  }
}

variable "oke_vcn3_db_subnet_name" {
  type        = string
  default     = null
  description = "The Database subnet name."
}

variable "oke_vcn3_db_ingress_destination_ports" {
  type        = list(string)
  default     = ["TCP:1521"]
  description = "Protocols and destination ports allowed for ingress packets into the OKE VCN3 database Network Security Group. Each value must be in the form protocol:port (e.g., 'TCP:1521')."
  validation {
    condition     = length(var.oke_vcn3_db_ingress_destination_ports) == 0 ? true : alltrue([for v in var.oke_vcn3_db_ingress_destination_ports : can(regex("^[^:]+:[^:]+$", v))])
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn3_db_ingress_destination_ports variable: all values must be in the form protocol:port, with exactly one ':' separating protocol and port values."
  }
}

variable "add_oke_vcn3_mgmt_subnet" {
  type        = bool
  default     = false
  description = "Whether to add a private subnet for cluster management."
}

variable "oke_vcn3_mgmt_subnet_cidr" {
  type        = string
  default     = null
  description = "The Management subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn3_mgmt_subnet_cidr == null || can(cidrhost(var.oke_vcn3_mgmt_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn3_mgmt_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.5.0.0/16)."
  }
}

variable "oke_vcn3_mgmt_subnet_name" {
  type        = string
  default     = null
  description = "The Management subnet name."
}

variable "oke_vcn3_pods_subnet_name" {
  type        = string
  default     = null
  description = "The Pods subnet name. A private subnet for pods deployment is automatically added if oke_vcn3_cni_type value is 'Native'."
}

variable "oke_vcn3_pods_subnet_cidr" {
  type        = string
  default     = null
  description = "The Pods subnet CIDR block. It must be within the VCN CIDR blocks."
  validation {
    condition     = var.oke_vcn3_pods_subnet_cidr == null || can(cidrhost(var.oke_vcn3_pods_subnet_cidr, 0))
    error_message = "VALIDATION FAILURE: Invalid value provided for oke_vcn3_pods_subnet_cidr variable: value must be in valid CIDR notation (e.g., 10.5.0.0/16)."
  }
}

variable "oke_vcn3_onprem_route_enable" {
  type        = bool
  default     = false
  description = "This will drive the creation of the routes and security list rules."
}

variable "customize_oke_vcn3_subnets" {
  type        = bool
  default     = false
  description = "If true, allows for the customization of default subnets settings. Applicable to RMS deployments only, used for UI displaying."
}
