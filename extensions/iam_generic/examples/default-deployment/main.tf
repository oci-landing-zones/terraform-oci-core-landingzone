
# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
#--------------------------------------------------------------------------------------------------------------------------------------

module "test_iam" {
  source = "../../"

  workload_compartment_name = var.workload_compartment_name
  service_label             = var.service_label
  parent_compartment_ocid   = var.parent_compartment_ocid
  isolate_workload          = var.isolate_workload
  network_compartment_ocid  = var.network_compartment_ocid
  security_compartment_ocid = var.security_compartment_ocid
  tenancy_ocid              = var.tenancy_ocid
  user_ocid                 = var.user_ocid
  fingerprint               = var.fingerprint
  private_key_path          = var.private_key_path
  private_key_password      = var.private_key_password
  region                    = var.region
}