locals {

  zpr_label = var.service_label # pre-check if service label is valid

  // for each exa vcn that is added, add its name to the list of validator values
  exa_vcn_validator_values = [for index, exa_vcn_added in tolist([var.add_exa_vcn1, var.add_exa_vcn2, var.add_exa_vcn3]) : "exa-vcn-${index + 1}" if exa_vcn_added == true]

  // for each tt vcn that is added, add its name to the list of validator values
  tt_vcn_validator_values = [for index, tt_vcn_added in tolist([var.add_tt_vcn1, var.add_tt_vcn2, var.add_tt_vcn3]) : "tt-vcn-${index + 1}" if tt_vcn_added == true]

  lz_zpr_configuration = {
    default_defined_tags  = null
    default_freeform_tags = null

    namespaces = {
      ZPR-CORE-LZ-NAMESPACE = {
        compartment_id = local.enclosing_compartment_id
        description    = "Core Landing Zone ZPR Security Attribute Namespace"
        name           = var.zpr_security_attributes_namespace
      }
    }

    security_attributes = {
      APP = {
        description      = "Security attribute for App Server Instance"
        name             = "app"
        namespace_id     = "ZPR-CORE-LZ-NAMESPACE"
        validator_type   = "ENUM"
        validator_values = [local.zpr_label]
      },
      BASTION = {
        description      = "Security attribute for Bastion Compute Instance"
        name             = "bastion"
        namespace_id     = "ZPR-CORE-LZ-NAMESPACE"
        validator_type   = "ENUM"
        validator_values = [local.zpr_label]
      },
      DATABASE = {
        description      = "Security attribute for Database"
        name             = "database"
        namespace_id     = "ZPR-CORE-LZ-NAMESPACE"
        validator_type   = "ENUM"
        validator_values = [local.zpr_label]
      },
      NET = {
        description      = "Security attribute for VCNs"
        name             = "net"
        namespace_id     = "ZPR-CORE-LZ-NAMESPACE"
        validator_type   = "ENUM"
        validator_values = concat(local.exa_vcn_validator_values, local.tt_vcn_validator_values)
      }
    }
    zpr_policies = merge(
      local.exa_zpr_policies, 
      local.tt_1_zpr_policies, 
      local.tt_2_zpr_policies, 
      local.tt_3_zpr_policies
    )
  }
}

module "lz_zpr" {
  count             = var.enable_zpr ? 1 : 0
  source            = "github.com/oci-landing-zones/terraform-oci-modules-security//zpr?ref=v0.1.9"
  tenancy_ocid      = var.tenancy_ocid
  zpr_configuration = local.lz_zpr_configuration
}
