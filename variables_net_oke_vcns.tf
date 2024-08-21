# ------------------------------------------------------
# ----- Networking - OKE VCN 1
#-------------------------------------------------------

variable "add_oke_vcn1" {
  type    = bool
  default = false
}

variable "oke_vcn1_cni_type" {
  type    = string
  default = "Flannel"
}

variable "oke_vcn1_name" {
  type    = string
  default = null
}

variable "oke_vcn1_cidrs" {
  type    = list(string)
  default = ["10.3.0.0/16"]
}

variable "oke_vcn1_dns" {
  type    = string
  default = null
}

variable "oke_vcn1_attach_to_drg" {
  type    = bool
  default = false
}

variable "oke_vcn1_routable_vcns" {
  type    = list(string)
  default = []
}

variable "oke_vcn1_api_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn1_api_subnet_name" {
  type    = string
  default = null
}

variable "oke_vcn1_api_subnet_dns" {
  type    = string
  default = null
}

variable "oke_vcn1_workers_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn1_workers_subnet_name" {
  type    = string
  default = null
}

variable "oke_vcn1_workers_subnet_dns" {
  type    = string
  default = null
}

variable "oke_vcn1_services_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn1_services_subnet_name" {
  type    = string
  default = null
}

variable "oke_vcn1_services_subnet_dns" {
  type    = string
  default = null
}

variable "add_oke_vcn1_mgmt_subnet" {
  type    = bool
  default = false
}

variable "oke_vcn1_mgmt_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn1_mgmt_subnet_name" {
  type    = string
  default = null
}

variable "oke_vcn1_mgmt_subnet_dns" {
  type    = string
  default = null
}

variable "oke_vcn1_pods_subnet_name" {
  type    = string
  default = null
}
variable "oke_vcn1_pods_subnet_dns" {
  type    = string
  default = null
}

variable "oke_vcn1_pods_subnet_cidr" {
  type    = string
  default = null
}
# ------------------------------------------------------
# ----- Networking - OKE VCN 2
#-------------------------------------------------------

variable "add_oke_vcn2" {
  type    = bool
  default = false
}

variable "oke_vcn2_cni_type" {
  type    = string
  default = "Flannel"
}

variable "oke_vcn2_name" {
  type    = string
  default = null
}

variable "oke_vcn2_cidrs" {
  type    = list(string)
  default = ["10.4.0.0/16"]
}

variable "oke_vcn2_dns" {
  type    = string
  default = null
}

variable "oke_vcn2_attach_to_drg" {
  type    = bool
  default = false
}

variable "oke_vcn2_routable_vcns" {
  type    = list(string)
  default = []
}

variable "oke_vcn2_api_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn2_api_subnet_name" {
  type    = string
  default = null
}

variable "oke_vcn2_api_subnet_dns" {
  type    = string
  default = null
}

variable "oke_vcn2_workers_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn2_workers_subnet_name" {
  type    = string
  default = null
}

variable "oke_vcn2_workers_subnet_dns" {
  type    = string
  default = null
}

variable "oke_vcn2_services_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn2_services_subnet_name" {
  type    = string
  default = null
}

variable "oke_vcn2_services_subnet_dns" {
  type    = string
  default = null
}

variable "add_oke_vcn2_mgmt_subnet" {
  type    = bool
  default = false
}

variable "oke_vcn2_mgmt_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn2_mgmt_subnet_name" {
  type    = string
  default = null
}

variable "oke_vcn2_mgmt_subnet_dns" {
  type    = string
  default = null
}

variable "oke_vcn2_pods_subnet_name" {
  type    = string
  default = null
}
variable "oke_vcn2_pods_subnet_dns" {
  type    = string
  default = null
}

variable "oke_vcn2_pods_subnet_cidr" {
  type    = string
  default = null
}


# ------------------------------------------------------
# ----- Networking - OKE VCN 3
#-------------------------------------------------------

variable "add_oke_vcn3" {
  type    = bool
  default = false
}

variable "oke_vcn3_cni_type" {
  type    = string
  default = "Flannel"
}

variable "oke_vcn3_name" {
  type    = string
  default = null
}

variable "oke_vcn3_cidrs" {
  type    = list(string)
  default = ["10.5.0.0/16"]
}

variable "oke_vcn3_dns" {
  type    = string
  default = null
}

variable "oke_vcn3_attach_to_drg" {
  type    = bool
  default = false
}

variable "oke_vcn3_routable_vcns" {
  type    = list(string)
  default = []
}

variable "oke_vcn3_api_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn3_api_subnet_name" {
  type    = string
  default = null
}

variable "oke_vcn3_api_subnet_dns" {
  type    = string
  default = null
}

variable "oke_vcn3_workers_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn3_workers_subnet_name" {
  type    = string
  default = null
}

variable "oke_vcn3_workers_subnet_dns" {
  type    = string
  default = null
}

variable "oke_vcn3_services_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn3_services_subnet_name" {
  type    = string
  default = null
}

variable "oke_vcn3_services_subnet_dns" {
  type    = string
  default = null
}

variable "add_oke_vcn3_mgmt_subnet" {
  type    = bool
  default = false
}

variable "oke_vcn3_mgmt_subnet_cidr" {
  type    = string
  default = null
}

variable "oke_vcn3_mgmt_subnet_name" {
  type    = string
  default = null
}

variable "oke_vcn3_mgmt_subnet_dns" {
  type    = string
  default = null
}

variable "oke_vcn3_pods_subnet_name" {
  type    = string
  default = null
}
variable "oke_vcn3_pods_subnet_dns" {
  type    = string
  default = null
}

variable "oke_vcn3_pods_subnet_cidr" {
  type    = string
  default = null
}

