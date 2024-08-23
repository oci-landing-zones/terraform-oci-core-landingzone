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
  description = "The region where resources are deployed."
  type = string
}
variable "service_label" {
  description = "A unique label that gets prepended to all resources deployed by the Landing Zone. Max length: 15 characters."
  validation {
    condition     = length(regexall("^[A-Za-z][A-Za-z0-9]{1,14}$", var.service_label)) > 0
    error_message = "Validation failed for service_label: value is required and must contain alphanumeric characters only, starting with a letter up to a maximum of 15 characters."
  }
}
variable "cis_level" {
  description = "Determines CIS OCI Benchmark Level to apply on Landing Zone managed resources. Level 1 is be practical and prudent. Level 2 is intended for environments where security is more critical than manageability and usability. Level 2 drives the creation of an OCI Vault, buckets encryption with a customer managed key, write logs for buckets and the usage of specific policies in Security Zones."
  type        = string
  default     = "1"
}
variable "extend_landing_zone_to_new_region" {
  description = "Whether Landing Zone is being extended to another region. When set to true, compartments, groups, policies and resources at the home region are not provisioned. Use this when you want to provision a Landing Zone in a new region, but reuse existing Landing Zone resources in the home region."
  default     = false
  type        = bool
}
variable "customize_iam" {
  description = "Whether Landing Zone IAM settings are to be customized. Customizable options are identity domains, groups, dynamic groups and policies."
  type        = bool
  default     = false
}
variable "customize_net" {
  description = "Whether networking is defined as part of this Landing Zone. By default, no networking resources are created."
  type        = bool
  default     = false
}
variable "display_output" {
  description = "Whether to display a concise set of select resource outputs with their OCIDs and names." 
  type        = bool
  default     = true
}
variable "lz_provenant_prefix" {
  description   = "The provenant landing zone prefix or code that identifies the client of this Landing Zone. This information goes into a freeform tag applied to all deployed resources."
  type          = string
  default       = "core"
  validation {
    condition     = length(regexall("^[A-Za-z][A-Za-z0-9]{1,4}$", var.lz_provenant_prefix)) > 0
    error_message = "Validation failed for lz_provenant_prefix: value must contain alphanumeric characters only, starting with a letter up to a maximum of 5 characters."
  }  
}
variable "lz_provenant_version" {
  description = "The provenant landing zone version. This information goes into a freeform tag applied to all deployed resources."
  type        = string
  default     = null
}