# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #------------------------------------------------------------------------------------------------------
  #-- Any of these local variables can be overriden in a _override.tf file
  #------------------------------------------------------------------------------------------------------
  custom_cmps_defined_tags  = null
  custom_cmps_freeform_tags = null
}

module "lz_top_compartment" {
  count                      = var.extend_landing_zone_to_new_region == false && local.deploy_enclosing_compartment ? 1 : 0
  source                     = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam//compartments?ref=release-0.2.3"
  providers                  = { oci = oci.home }
  tenancy_ocid               = var.tenancy_ocid
  compartments_configuration = local.enclosing_compartment_configuration
}

module "lz_compartments" {
  count                      = var.extend_landing_zone_to_new_region == false ? 1 : 0
  source                     = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam//compartments?ref=release-0.2.3"
  providers                  = { oci = oci.home }
  tenancy_ocid               = var.tenancy_ocid
  compartments_configuration = local.enclosed_compartments_configuration
}

locals {
  #------------------------------------------------------------------------------------------------------
  #-- These variables are not meant to be overridden
  #------------------------------------------------------------------------------------------------------

  deploy_enclosing_compartment = (var.enclosing_compartment_options == "Yes, deploy new")
  use_enclosing_compartment    = (var.enclosing_compartment_options == "Yes, use existing")

  enable_network_compartment  = true
  enable_security_compartment = true
  enable_app_compartment      = true
  enable_database_compartment = true
  enable_exainfra_compartment = var.deploy_exainfra_cmp

  #-----------------------------------------------------------
  #----- Tags to apply to compartments
  #-----------------------------------------------------------
  default_cmps_defined_tags  = null
  default_cmps_freeform_tags = local.landing_zone_tags

  cmps_defined_tags  = local.custom_cmps_defined_tags != null ? merge(local.custom_cmps_defined_tags, local.default_cmps_defined_tags) : local.default_cmps_defined_tags
  cmps_freeform_tags = local.custom_cmps_freeform_tags != null ? merge(local.custom_cmps_freeform_tags, local.default_cmps_freeform_tags) : local.default_cmps_freeform_tags

  #-----------------------------------------------------------
  #----- Keys for the compartment maps
  #-----------------------------------------------------------
  enclosing_compartment_key = "TOP-CMP"
  network_compartment_key   = "NETWORK-CMP"
  security_compartment_key  = "SECURITY-CMP"
  app_compartment_key       = "APP-CMP"
  database_compartment_key  = "DATABASE-CMP"
  exainfra_compartment_key  = "EXAINFRA-CMP"

  #----------------------------------------------------------------------------------------------------------
  #----- Provided compartment names
  #----------------------------------------------------------------------------------------------------------
  provided_enclosing_compartment_name = "${var.service_label}-top-cmp"
  provided_network_compartment_name   = "${var.service_label}-network-cmp"
  provided_security_compartment_name  = "${var.service_label}-security-cmp"
  provided_app_compartment_name       = "${var.service_label}-app-cmp"
  provided_database_compartment_name  = "${var.service_label}-database-cmp"
  provided_exainfra_compartment_name  = "${var.service_label}-exainfra-cmp"

  #----------------------------------------------------------------------
  #----- Auxiliary object for Terraform ternary operator satisfaction
  #----------------------------------------------------------------------
  empty_compartments_configuration = {
    default_parent_id : null
    compartments : {}
  }

  #------------------------------------------------------------------------
  #----- Enclosing compartment configuration definition. Input to module.
  #------------------------------------------------------------------------  
  enclosing_compartment_configuration = local.deploy_enclosing_compartment ? {
    default_parent_id : coalesce(var.enclosing_compartment_parent_ocid, var.tenancy_ocid)
    compartments : {
      (local.enclosing_compartment_key) : {
        name : local.provided_enclosing_compartment_name,
        description : "CIS Landing Zone enclosing compartment",
        defined_tags : local.cmps_defined_tags,
        freeform_tags : local.cmps_freeform_tags,
        children = {}
      }
    }
  } : local.empty_compartments_configuration

  #-----------------------------------------------------------
  #----- Enclosed compartments definition
  #-----------------------------------------------------------
  network_cmp = local.enable_network_compartment ? {
    (local.network_compartment_key) : {
      name : local.provided_network_compartment_name,
      description : "CIS Landing Zone compartment for all network related resources: VCNs, subnets, network gateways, security lists, NSGs, load balancers, VNICs, and others.",
      defined_tags : local.cmps_defined_tags,
      freeform_tags : local.cmps_freeform_tags,
      children : {}
    }
  } : {}

  security_cmp = local.enable_security_compartment ? {
    (local.security_compartment_key) : {
      name : local.provided_security_compartment_name,
      description : "CIS Landing Zone compartment for all security related resources: vaults, topics, notifications, logging, scanning, and others.",
      defined_tags : local.cmps_defined_tags,
      freeform_tags : local.cmps_freeform_tags,
      children : {}
    }
  } : {}

  app_cmp = local.enable_app_compartment ? {
    (local.app_compartment_key) : {
      name : local.provided_app_compartment_name,
      description : "CIS Landing Zone compartment for all resources related to application development: compute instances, storage, functions, OKE, API Gateway, streaming, and others.",
      defined_tags : local.cmps_defined_tags,
      freeform_tags : local.cmps_freeform_tags,
      children : {}
    }
  } : {}

  database_cmp = local.enable_database_compartment ? {
    (local.database_compartment_key) : {
      name : local.provided_database_compartment_name,
      description : "CIS Landing Zone compartment for all database related resources.",
      defined_tags : local.cmps_defined_tags,
      freeform_tags : local.cmps_freeform_tags,
      children : {}
    }
  } : {}

  exainfra_cmp = local.enable_exainfra_compartment ? {
    (local.exainfra_compartment_key) : {
      name : local.provided_exainfra_compartment_name,
      description : "CIS Landing Zone compartment for Exadata Cloud Service infrastructure.",
      defined_tags : local.cmps_defined_tags,
      freeform_tags : local.cmps_freeform_tags,
      children : {}
    }
  } : {}

  all_enclosed_compartments = merge(local.network_cmp, local.security_cmp, local.app_cmp, local.database_cmp, local.exainfra_cmp)
  #------------------------------------------------------------------------
  #----- Enclosing compartment configuration definition. Input to module.
  #------------------------------------------------------------------------
  enclosed_compartments_configuration = length(local.all_enclosed_compartments) > 0 ? {
    default_parent_id : local.enclosing_compartment_id
    compartments : local.all_enclosed_compartments
  } : local.empty_compartments_configuration

  #---------------------------------------------------------------------------------------
  #----- Variables with compartment names and OCIDs per compartments module output
  #---------------------------------------------------------------------------------------
  #enclosing_compartment_name = local.use_enclosing_compartment == true ? (var.existing_enclosing_compartment_ocid != null ? data.oci_identity_compartment.existing_enclosing_compartment.name : local.provided_enclosing_compartment_name) : "tenancy"
  enclosing_compartment_name = local.deploy_enclosing_compartment ? module.lz_top_compartment[0].compartments[local.enclosing_compartment_key].name : local.use_enclosing_compartment ? data.oci_identity_compartment.existing_enclosing_compartment.name : "tenancy"
  enclosing_compartment_id   = local.deploy_enclosing_compartment ? module.lz_top_compartment[0].compartments[local.enclosing_compartment_key].id : local.use_enclosing_compartment ? var.existing_enclosing_compartment_ocid : var.tenancy_ocid

  network_compartment_name = var.extend_landing_zone_to_new_region == false && local.enable_network_compartment == true ? module.lz_compartments[0].compartments[local.network_compartment_key].name : local.provided_network_compartment_name
  network_compartment_id   = var.extend_landing_zone_to_new_region == false && local.enable_network_compartment == true ? module.lz_compartments[0].compartments[local.network_compartment_key].id : length(data.oci_identity_compartments.network.compartments) > 0 ? data.oci_identity_compartments.network.compartments[0].id : null

  security_compartment_name = var.extend_landing_zone_to_new_region == false && local.enable_security_compartment == true ? module.lz_compartments[0].compartments[local.security_compartment_key].name : local.provided_security_compartment_name
  security_compartment_id   = var.extend_landing_zone_to_new_region == false && local.enable_security_compartment == true ? module.lz_compartments[0].compartments[local.security_compartment_key].id : length(data.oci_identity_compartments.security.compartments) > 0 ? data.oci_identity_compartments.security.compartments[0].id : null

  app_compartment_name = var.extend_landing_zone_to_new_region == false && local.enable_app_compartment == true ? module.lz_compartments[0].compartments[local.app_compartment_key].name : local.provided_app_compartment_name
  app_compartment_id   = var.extend_landing_zone_to_new_region == false && local.enable_security_compartment == true ? module.lz_compartments[0].compartments[local.app_compartment_key].id : length(data.oci_identity_compartments.app.compartments) > 0 ? data.oci_identity_compartments.app.compartments[0].id : null

  database_compartment_name = var.extend_landing_zone_to_new_region == false && local.enable_database_compartment == true ? module.lz_compartments[0].compartments[local.database_compartment_key].name : local.provided_database_compartment_name
  database_compartment_id   = var.extend_landing_zone_to_new_region == false && local.enable_security_compartment == true ? module.lz_compartments[0].compartments[local.database_compartment_key].id : length(data.oci_identity_compartments.database.compartments) > 0 ? data.oci_identity_compartments.database.compartments[0].id : null

  exainfra_compartment_name = var.extend_landing_zone_to_new_region == false && local.enable_exainfra_compartment == true ? module.lz_compartments[0].compartments[local.exainfra_compartment_key].name : local.provided_exainfra_compartment_name
  exainfra_compartment_id   = var.extend_landing_zone_to_new_region == false && local.enable_exainfra_compartment == true ? module.lz_compartments[0].compartments[local.exainfra_compartment_key].id : length(data.oci_identity_compartments.exainfra.compartments) > 0 ? data.oci_identity_compartments.exainfra.compartments[0].id : null
}