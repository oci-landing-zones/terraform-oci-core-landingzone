# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "test_network" {
  source = "../../"

  isolated_resources          = var.isolated_resources        # Set to true if the person deploying this network extension is in the Workload Admin group. Set to false if the person deploying this network extension is in the Network Admin group.
  workload_compartment_ocid   = var.workload_compartment_ocid # This value is required if isolated_resources = true
  deploy_network_architecture = var.deploy_network_architecture
  workload_vcn_cidr_block     = var.workload_vcn_cidr_block
  hub_vcn_cidrs               = var.hub_vcn_cidrs
  hub_drg_ocid                = var.hub_drg_ocid
  add_app_subnet              = var.add_app_subnet
  add_db_subnet               = var.add_db_subnet
  add_lb_subnet               = var.add_lb_subnet
  add_mgmt_subnet             = var.add_mgmt_subnet
  add_web_subnet              = var.add_web_subnet
  add_db_backup_subnet        = var.add_db_backup_subnet
}
