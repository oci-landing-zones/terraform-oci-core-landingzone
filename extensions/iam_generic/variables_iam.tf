# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# ------------------------------------------------------
# ----- General
#-------------------------------------------------------
variable "tenancy_ocid" {
  default = ""
}
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
variable "region" {
  description = "The region where resources are deployed."
  type        = string
}
variable "parent_compartment_ocid" {
  default     = ""
  type        = string
  description = "the OCID of the root compartment in the parent landing zone"
}
variable "service_label" {
  default     = ""
  type        = string
  description = "A unique label that gets prepended to all resources deployed by the Landing Zone. Max length: 15 characters."
}
variable "workload_compartment_name" {
  default     = "workload-cmp"
  type        = string
  description = "the name of the workload compartment"
}
variable "isolate_workload" {
  default     = false
  type        = bool
  description = "the option to isolate the workload"
}
variable "network_compartment_ocid"{
  default     = ""
  type        = string
  description = "The network compartment OCID. Applicable when isolate_workload is false."
}
variable "security_compartment_ocid"{
  default     = ""
  type        = string
  description = "The security compartment OCID. Applicable when isolate_workload is false."
}

variable "workload_compartment_description" {
  default = "Workload compartment"
  type = string
  description = "Workload compartment description"
}
variable "network_compartment_description" {
  default = "Workload sub-compartment for all network related resources: VCNs, subnets, network gateways, security lists, NSGs, load balancers, VNICs, and others."
  type = string
  description = "Network compartment description"
}
variable "app_compartment_description" {
  default = "Workload sub-compartment for all resources related to application development: compute instances, storage, functions, OKE, API Gateway, streaming, and others."
  type = string
  description = "App compartment description"
}
variable "database_compartment_description" {
  default = "Workload sub-compartment for all network related resources: VCNs, subnets, network gateways, security lists, NSGs, load balancers, VNICs, and others."
  type = string
  description = "Database compartment description"
}

# ------------------------------------------------------
# ----- Compartments
#-------------------------------------------------------
variable "create_workload_network_subcompartment" {
  default     = false
  type        = bool
  description = "the option to enable workload network compartment"
}

variable "create_workload_app_subcompartment" {
  default     = false
  type        = bool
  description = "the option to enable workload app compartment"
}
variable "create_workload_database_subcompartment" {
  default     = false
  type        = bool
  description = "the option to enable workload database compartment"
}
# ------------------------------------------------------
# ----- Groups
#-------------------------------------------------------
variable "use_custom_identity_domain" {
  default     = false
  type        = bool
  description = "the flag to use custom identity domain in the parent landing zone"
}
variable "custom_identity_domain_ocid" {
  default     = ""
  type        = string
  description = "the OCID of custom identity domain"
}
variable "custom_identity_domain_name" {
  default     = ""
  type        = string
  description = "the name of custom identity domain"
}
variable "enable_db_admin_group" {
  default     = false
  type        = bool
  description = "the option to enable workload database admin group"
}
variable "customize_group_policy_name" {
  default     = false
  type        = bool
  description = "the option to customize group and policy names"
}
variable "workload_admin_group_name" {
  default     = "workload-admin-group"
  type        = string
  description = "the name of workload admin group"
}
variable "workload_app_admin_group_name" {
  default     = "workload-app-admin-group"
  type        = string
  description = "the name of the workload app admin group"
}
variable "workload_db_admin_group_name" {
  default     = "workload-db-admin-group"
  type        = string
  description = "the name of the workload database admin group"
}
variable "additional_root_policy_statements" {
  default     = []
  type        = list(string)
  description = "Additional statements to add to the root policy. Note that this this policy is created at the root compartment."
}
variable "additional_wkld_admin_policy_statements" {
  default     = []
  type        = list(string)
  description = "Additional statements to add to the workload admin policy. Note that this this policy is created at the parent compartment of the workload."
}
variable "additional_app_admin_policy_statements" {
  default     = []
  type        = list(string)
  description = "Additional statements to add to the root policy. Note that this this policy is created at the parent compartment of the workload."
}
variable "additional_db_admin_policy_statements" {
  default     = []
  type        = list(string)
  description = "Additional statements to add to the root policy. Note that this this policy is created at the parent compartment of the workload."
}

# ------------------------------------------------------
# ----- Deployment Flags
#-------------------------------------------------------

variable "deploy_workload_compartment" {
  default = true
  type = bool
  description = "Whether or not to deploy workload compartment"
}

variable "deploy_default_groups" {
  default = true
  type = bool
  description = "Whether or not to deploy groups"
}
variable "deploy_root_policies" {
  default = true
  type = bool
  description = "Whether or not to deploy root policies"
}
variable "deploy_wkld_policies" {
  default = true
  type = bool
  description = "Whether or not to deploy wkld policies"
}
variable "root_policy_name"{
  default = "root-policy"
  type = string
  description = "Root policy name."
}
variable "wkld_admin_policy_name"{
  default = "wkld-admin-policy"
  type = string
  description = "Workload Admin policy name."
}
variable "db_admin_policy_name"{
  default = "wkld-db-admin-policy"
  type = string
  description = "DB Admin policy name."
}
variable "app_admin_policy_name"{
  default = "wkld-app-admin-policy"
  type = string
  description = "App Admin policy name."
}