variable "tenancy_ocid" {}
variable "user_ocid" {
  default = ""
}
variable "fingerprint" {
  default = ""
}
variable "private_key_path" {
  default = ""
}
variable "private_key_password" {
  default = ""
}
# ------------------------------------------------------
# ----- General
#-------------------------------------------------------
variable "region" {
  type = string
}
variable "service_label" {
  validation {
    condition     = length(regexall("^[A-Za-z][A-Za-z0-9]{1,14}$", var.service_label)) > 0
    error_message = "Validation failed for service_label: value is required and must contain alphanumeric characters only, starting with a letter up to a maximum of 15 characters."
  }
}
variable "cis_level" {
  type        = string
  default     = "1"
  description = "Determines CIS OCI Benchmark Level to apply on Landing Zone managed resources. Level 1 is be practical and prudent. Level 2 is intended for environments where security is more critical than manageability and usability. Level 2 drives the creation of an OCI Vault, buckets encryption with a customer managed key, write logs for buckets and the usage of specific policies in Security Zones."
}
variable "extend_landing_zone_to_new_region" {
  default     = false
  type        = bool
  description = "Whether Landing Zone is being extended to another region. When set to true, compartments, groups, policies and resources at the home region are not provisioned. Use this when you want to provision a Landing Zone in a new region, but reuse existing Landing Zone resources in the home region."
}
variable "customize_iam" {
  type    = bool
  default = false
}
variable "customize_net" {
  type    = bool
  default = false
}
variable "lz_provenant_prefix" {
  description   = "The provenant landing zone prefix or code that identifies the client of this landing zone."
  type          = string
  default       = "core"
  validation {
    condition     = length(regexall("^[A-Za-z][A-Za-z0-9]{1,4}$", var.lz_provenant_prefix)) > 0
    error_message = "Validation failed for lz_provenant_prefix: value must contain alphanumeric characters only, starting with a letter up to a maximum of 5 characters."
  }  
}
variable "lz_provenant_version" {
  description = "The provenant landing zone version."
  type        = string
  default     = null
}