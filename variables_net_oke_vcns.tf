# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# ------------------------------------------------------
# ----- Networking - OKE VCN 1
#-------------------------------------------------------

variable "add_oke_vcn1" {
  type    = bool
  default = false
  description = "Whether to add a VCN configured for OKE workload deployments, with at least three subnets: service (public by default), workers (private) and API endpoint (private). Additionally, a private subnet for pods deployment is created if the OKE CNI Type is 'Native'. You can also enable an extra private subnet for managing the OKE cluster. The added VCN is labelled 'OKE-VCN-1'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Network topology."
}

variable "oke_vcn1_cni_type" {
  type    = string
  default = "Flannel"
  description = "The CNI type for the OKE cluster. Valid values: 'Flannel' (default), 'Native'. If 'Native', a private subnet for pods deployment is created."
}

variable "oke_vcn1_name" {
  type    = string
  default = null
  description = "The VCN name. If unassigned a default name is provided."
}

variable "oke_vcn1_cidrs" {
  type    = list(string)
  default = ["10.3.0.0/16"]
  description = "The list of CIDR blocks for the VCN."
}

variable "oke_vcn1_attach_to_drg" {
  type    = bool
  default = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}

variable "oke_vcn1_routable_vcns" {
  type    = list(string)
  default = []
  description = "The VCN labels that this VCN can send traffic to. Only applicable for Network topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-2, OKE-VCN-3."
}

variable "oke_vcn1_api_subnet_cidr" {
  type    = string
  default = null
  description = "The API subnet CIDR block. It must be within the VCN CIDR blocks."
}

variable "oke_vcn1_api_subnet_name" {
  type    = string
  default = null
  description = "The API subnet name."
}

variable "oke_vcn1_workers_subnet_cidr" {
  type    = string
  default = null
  description = "The Workers subnet CIDR block. It must be within the VCN CIDR blocks."
}

variable "oke_vcn1_workers_subnet_name" {
  type    = string
  default = null
  description = "The Workers subnet name."
}

variable "oke_vcn1_services_subnet_cidr" {
  type    = string
  default = null
  description = "The Services subnet CIDR block. It must be within the VCN CIDR blocks."
}

variable "oke_vcn1_services_subnet_name" {
  type    = string
  default = null
  description = "The Services subnet name."
}

variable "add_oke_vcn1_mgmt_subnet" {
  type    = bool
  default = false
  description = "Whether to add a private subnet for cluster management."
}

variable "oke_vcn1_mgmt_subnet_cidr" {
  type    = string
  default = null
  description = "The Management subnet CIDR block. It must be within the VCN CIDR blocks."
}

variable "oke_vcn1_mgmt_subnet_name" {
  type    = string
  default = null
  description = "The Management subnet name."
}

variable "oke_vcn1_pods_subnet_name" {
  type    = string
  default = null
  description = "The Pods subnet name. A private subnet for pods deployment is automatically added if oke_vcn1_cni_type value is 'Native'."
}

variable "oke_vcn1_pods_subnet_cidr" {
  type    = string
  default = null
  description = "The Pods subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "oke_vcn1_onprem_route_enable" {
  type        = bool
  default     = false
  description = "This will drive the creation of the routes and security list rules."
}

# ------------------------------------------------------
# ----- Networking - OKE VCN 2
#-------------------------------------------------------

variable "add_oke_vcn2" {
  type    = bool
  default = false
  description = "Whether to add a second VCN configured for OKE workload deployments, with at least three subnets: service (public by default), workers (private) and API endpoint (private). Additionally, a private subnet for pods deployment is created if the OKE CNI Type is 'Native'. You can also enable an extra private subnet for managing the OKE cluster. The added VCN is labelled 'OKE-VCN-2'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Network topology."
}

variable "oke_vcn2_cni_type" {
  type    = string
  default = "Flannel"
  description = "The CNI type for the OKE cluster. Valid values: 'Flannel' (default), 'Native'. If 'Native', a private subnet for pods deployment is created."
}

variable "oke_vcn2_name" {
  type    = string
  default = null
  description = "The VCN name. If unassigned, a default name is provided."
}

variable "oke_vcn2_cidrs" {
  type    = list(string)
  default = ["10.4.0.0/16"]
  description = "The list of CIDR blocks for the VCN."
}

variable "oke_vcn2_attach_to_drg" {
  type    = bool
  default = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}

variable "oke_vcn2_routable_vcns" {
  type    = list(string)
  default = []
  description = "The VCN labels that this VCN can send traffic to. Only applicable for Network topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-3"
}

variable "oke_vcn2_api_subnet_cidr" {
  type    = string
  default = null
  description = "The API subnet CIDR block. It must be within the VCN CIDR blocks."
}

variable "oke_vcn2_api_subnet_name" {
  type    = string
  default = null
  description = "The API subnet name."
}

variable "oke_vcn2_workers_subnet_cidr" {
  type    = string
  default = null
  description = "The Workers subnet CIDR block. It must be within the VCN CIDR blocks."
}

variable "oke_vcn2_workers_subnet_name" {
  type    = string
  default = null
  description = "The Workers subnet name."
}

variable "oke_vcn2_services_subnet_cidr" {
  type    = string
  default = null
  description = "The Services subnet CIDR block. It must be within the VCN CIDR blocks."
}

variable "oke_vcn2_services_subnet_name" {
  type    = string
  default = null
  description = "The Services subnet name."
}

variable "add_oke_vcn2_mgmt_subnet" {
  type    = bool
  default = false
  description = "Whether to add a private subnet for cluster management."
}

variable "oke_vcn2_mgmt_subnet_cidr" {
  type    = string
  default = null
  description = "The Management subnet CIDR block. It must be within the VCN CIDR blocks."
}

variable "oke_vcn2_mgmt_subnet_name" {
  type    = string
  default = null
  description = "The Management subnet name."
}

variable "oke_vcn2_pods_subnet_name" {
  type    = string
  default = null
  description = "The pods subnet name. A private subnet for pods deployment is automatically added if oke_vcn2_cni_type value is 'Native'."
}

variable "oke_vcn2_pods_subnet_cidr" {
  type    = string
  default = null
  description = "The Pods subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "oke_vcn2_onprem_route_enable" {
  type        = bool
  default     = false
  description = "This will drive the creation of the routes and security list rules."
}

# ------------------------------------------------------
# ----- Networking - OKE VCN 3
#-------------------------------------------------------

variable "add_oke_vcn3" {
  type    = bool
  default = false
  description = "Whether to add a third VCN configured for OKE workload deployments, with at least three subnets: service (public by default), workers (private) and API endpoint (private). Additionally, a private subnet for pods deployment is created if the OKE CNI Type is 'Native'. You can also enable an extra private subnet for managing the OKE cluster. The added VCN is labelled 'OKE-VCN-3'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Network topology."
}

variable "oke_vcn3_cni_type" {
  type    = string
  default = "Flannel"
  description = "The CNI type for the OKE cluster. Valid values: 'Flannel' (default), 'Native'. If 'Native', a private subnet for pods deployment is created."
}

variable "oke_vcn3_name" {
  type    = string
  default = null
  description = "The VCN name. If unassigned, a default name is provided."
}

variable "oke_vcn3_cidrs" {
  type    = list(string)
  default = ["10.5.0.0/16"]
  description = "The list of CIDR blocks for the VCN."
}

variable "oke_vcn3_attach_to_drg" {
  type    = bool
  default = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}

variable "oke_vcn3_routable_vcns" {
  type    = list(string)
  default = []
  description = "The VCN labels that this VCN can send traffic to. Only applicable for Network topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2."
}

variable "oke_vcn3_api_subnet_cidr" {
  type    = string
  default = null
  description = "The API subnet CIDR block. It must be within the VCN CIDR blocks."
}

variable "oke_vcn3_api_subnet_name" {
  type    = string
  default = null
  description = "The API subnet name."
}

variable "oke_vcn3_workers_subnet_cidr" {
  type    = string
  default = null
  description = "The Workers subnet CIDR block. It must be within the VCN CIDR blocks."
}

variable "oke_vcn3_workers_subnet_name" {
  type    = string
  default = null
  description = "The Workers subnet name."
}

variable "oke_vcn3_services_subnet_cidr" {
  type    = string
  default = null
  description = "The Services subnet CIDR block. It must be within the VCN CIDR blocks."
}

variable "oke_vcn3_services_subnet_name" {
  type    = string
  default = null
  description = "The Services subnet name."
}

variable "add_oke_vcn3_mgmt_subnet" {
  type    = bool
  default = false
  description = "Whether to add a private subnet for cluster management."
}

variable "oke_vcn3_mgmt_subnet_cidr" {
  type    = string
  default = null
  description = "The Management subnet CIDR block. It must be within the VCN CIDR blocks."
}

variable "oke_vcn3_mgmt_subnet_name" {
  type    = string
  default = null
  description = "The Management subnet name."
}

variable "oke_vcn3_pods_subnet_name" {
  type    = string
  default = null
  description = "The Pods subnet name. A private subnet for pods deployment is automatically added if oke_vcn3_cni_type value is 'Native'."
}

variable "oke_vcn3_pods_subnet_cidr" {
  type    = string
  default = null
  description = "The Pods subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "oke_vcn3_onprem_route_enable" {
  type        = bool
  default     = false
  description = "This will drive the creation of the routes and security list rules."
}