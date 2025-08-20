# # Copyright (c) 2025 Oracle and/or its affiliates.
# # Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# Provider variables
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "private_key_password" {}
variable "region" {}

# Deployment details
variable "workload_compartment_name" {}
variable "service_label" {}
variable "parent_compartment_ocid" {}
variable "isolate_workload" {}
variable "network_compartment_ocid" {}
variable "security_compartment_ocid" {}