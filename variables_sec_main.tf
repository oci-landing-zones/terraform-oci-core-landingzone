# Copyright (c) 2022 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# ------------------------------------------------------
# ----- Security Zones
# ------------------------------------------------------
# variable "enable_security_zones" {
#     type        = bool
#     default     = false
#     description = "Determines if Security Zones are enabled in Landing Zone. When set to true, the Security Zone is enabled for the enclosing compartment. If no enclosing compartment is used, then the Security Zone is not enabled."
#   }
  
#   variable "sz_security_policies" {
#     type = list
#     default = []
#     description =  "List of Security Zones Policy OCIDs to add to security zone recipe. To get a Security Zone policy OCID use the oci cli:  oci cloud-guard security-policy-collection list-security-policies --compartment-id <tenancy-ocid>."
#     validation {
#       condition = length([for e in var.sz_security_policies : e if length(regexall("ocid1.securityzonessecuritypolicy.*", e)) > 0]) == length(var.sz_security_policies)
#       error_message = "Validation failed for sz_security_policies must be a valid Security Zone Policy OCID.  To get a Security Zone policy OCID use the oci cli:  oci cloud-guard security-policy-collection list-security-policies --compartment-id <tenancy-ocid>."
#     }
#   }