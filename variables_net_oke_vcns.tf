# ------------------------------------------------------
# ----- Networking - OKE VCN 1
#-------------------------------------------------------

variable "add_oke_vcn1" {
  type    = bool
  default = false
  description = "Click to add a VCN configured for OKE deployment, with at least three subnets: service (public by default), workers (private) and API endpoint (private). Additionally, a private subnet for pods deployment is created if the OKE CNI Type is 'Native'. You can also enable an extra private subnet for managing the OKE cluster."
}

variable "oke_vcn1_cni_type" {
  type    = string
  default = "Flannel"
  description = "CNI type of OKE clusters (ex: Flannel or Native)"
}

variable "oke_vcn1_name" {
  type    = string
  default = null
  description = "Enter the VCN name. Otherwise a default name is provided. The label above should be used in the 'Routable VCNs' field of other VCNs for constraining network traffic in a Hub/Spoke topology."
}

variable "oke_vcn1_cidrs" {
  type    = list(string)
  default = ["10.3.0.0/16"]
  description = "The list of CIDR blocks for the VCN."
}

variable "oke_vcn1_dns" {
  type    = string
  default = null
  description = "The VCN DNS name."
}

variable "oke_vcn1_attach_to_drg" {
  type    = bool
  default = false
  description = "Check to route private traffic to/from this VCN via a new or existing DRG."
}

variable "oke_vcn1_routable_vcns" {
  type    = list(string)
  default = []
  description = "Enter the VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub."
}

variable "oke_vcn1_api_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn1_api_subnet_name" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}

variable "oke_vcn1_api_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}

variable "oke_vcn1_workers_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn1_workers_subnet_name" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}

variable "oke_vcn1_workers_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}

variable "oke_vcn1_services_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn1_services_subnet_name" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}

variable "oke_vcn1_services_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}

variable "add_oke_vcn1_mgmt_subnet" {
  type    = bool
  default = false
  description = "Check to add a private subnet for cluster management."
}

variable "oke_vcn1_mgmt_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn1_mgmt_subnet_name" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}

variable "oke_vcn1_mgmt_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}

variable "oke_vcn1_pods_subnet_name" {
  type    = string
  default = null
  description = "The pods subnet name."
}
variable "oke_vcn1_pods_subnet_dns" {
  type    = string
  default = null
}

variable "oke_vcn1_pods_subnet_cidr" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}
# ------------------------------------------------------
# ----- Networking - OKE VCN 2
#-------------------------------------------------------

variable "add_oke_vcn2" {
  type    = bool
  default = false
  description = "Click to add a VCN configured for OKE deployment, with at least three subnets: service (public by default), workers (private) and API endpoint (private). Additionally, a private subnet for pods deployment is created if the OKE CNI Type is 'Native'. You can also enable an extra private subnet for managing the OKE cluster."
}

variable "oke_vcn2_cni_type" {
  type    = string
  default = "Flannel"
  description = "CNI type of OKE clusters (ex: Flannel or Native)"
}

variable "oke_vcn2_name" {
  type    = string
  default = null
  description = "Enter the VCN name. Otherwise a default name is provided. The label above should be used in the 'Routable VCNs' field of other VCNs for constraining network traffic in a Hub/Spoke topology."
}

variable "oke_vcn2_cidrs" {
  type    = list(string)
  default = ["10.4.0.0/16"]
  description = "The list of CIDR blocks for the VCN."
}

variable "oke_vcn2_dns" {
  type    = string
  default = null
  description = "The VCN DNS name."
}

variable "oke_vcn2_attach_to_drg" {
  type    = bool
  default = false
  description = "Check to route private traffic to/from this VCN via a new or existing DRG."
}

variable "oke_vcn2_routable_vcns" {
  type    = list(string)
  default = []
  description = "Enter the VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub."
}

variable "oke_vcn2_api_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn2_api_subnet_name" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}

variable "oke_vcn2_api_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}

variable "oke_vcn2_workers_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn2_workers_subnet_name" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}

variable "oke_vcn2_workers_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}

variable "oke_vcn2_services_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn2_services_subnet_name" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}

variable "oke_vcn2_services_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}

variable "add_oke_vcn2_mgmt_subnet" {
  type    = bool
  default = false
  description = "Check to add a private subnet for cluster management."
}

variable "oke_vcn2_mgmt_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn2_mgmt_subnet_name" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}

variable "oke_vcn2_mgmt_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}

variable "oke_vcn2_pods_subnet_name" {
  type    = string
  default = null
  description = "The pods subnet name."
}
variable "oke_vcn2_pods_subnet_dns" {
  type    = string
  default = null
}

variable "oke_vcn2_pods_subnet_cidr" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}


# ------------------------------------------------------
# ----- Networking - OKE VCN 3
#-------------------------------------------------------

variable "add_oke_vcn3" {
  type    = bool
  default = false
  description = "Click to add a VCN configured for OKE deployment, with at least three subnets: service (public by default), workers (private) and API endpoint (private). Additionally, a private subnet for pods deployment is created if the OKE CNI Type is 'Native'. You can also enable an extra private subnet for managing the OKE cluster."
}

variable "oke_vcn3_cni_type" {
  type    = string
  default = "Flannel"
  description = "CNI type of OKE clusters (ex: Flannel or Native)"
}

variable "oke_vcn3_name" {
  type    = string
  default = null
  description = "Enter the VCN name. Otherwise a default name is provided. The label above should be used in the 'Routable VCNs' field of other VCNs for constraining network traffic in a Hub/Spoke topology."
}

variable "oke_vcn3_cidrs" {
  type    = list(string)
  default = ["10.5.0.0/16"]
  description = "The list of CIDR blocks for the VCN."
}

variable "oke_vcn3_dns" {
  type    = string
  default = null
  description = "The VCN DNS name."
}

variable "oke_vcn3_attach_to_drg" {
  type    = bool
  default = false
  description = "Check to route private traffic to/from this VCN via a new or existing DRG."
}

variable "oke_vcn3_routable_vcns" {
  type    = list(string)
  default = []
  description = "Enter the VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub."
}

variable "oke_vcn3_api_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn3_api_subnet_name" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}

variable "oke_vcn3_api_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}

variable "oke_vcn3_workers_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn3_workers_subnet_name" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}

variable "oke_vcn3_workers_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}

variable "oke_vcn3_services_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn3_services_subnet_name" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}

variable "oke_vcn3_services_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}

variable "add_oke_vcn3_mgmt_subnet" {
  type    = bool
  default = false
  description = "Check to add a private subnet for cluster management."
}

variable "oke_vcn3_mgmt_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn3_mgmt_subnet_name" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}

variable "oke_vcn3_mgmt_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}

variable "oke_vcn3_pods_subnet_name" {
  type    = string
  default = null
  description = "The pods subnet name."
}
variable "oke_vcn3_pods_subnet_dns" {
  type    = string
  default = null
}

variable "oke_vcn3_pods_subnet_cidr" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}