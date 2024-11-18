locals {

  enable_zpr = var.define_net && var.enable_zpr
  zpr_label  = var.service_label
  zpr_namespace_name = coalesce(var.zpr_namespace_name,"${local.zpr_label}-zpr")
  
  // for each exa vcn that is added, add its name to the list of validator values
  exa_vcn_validator_values = [for index, exa_vcn_added in tolist([local.add_exa_vcn1, local.add_exa_vcn2, local.add_exa_vcn3]) : "exa-vcn-${index + 1}" if exa_vcn_added == true]

  // for each tt vcn that is added, add its name to the list of validator values
  tt_vcn_validator_values = [for index, tt_vcn_added in tolist([local.add_tt_vcn1, local.add_tt_vcn2, local.add_tt_vcn3]) : "tt-vcn-${index + 1}" if tt_vcn_added == true]

  lz_zpr_configuration = local.enable_zpr ? {
    default_defined_tags  = null
    default_freeform_tags = null

    namespaces = {
      ZPR-LZ-NAMESPACE = {
        compartment_id = local.enclosing_compartment_id
        description    = "Core Landing Zone ZPR Namespace."
        name           = local.zpr_namespace_name
      }
    }

    security_attributes = {
      APP = {
        description      = "Security attribute for App Server instances."
        name             = "app"
        namespace_id     = "ZPR-LZ-NAMESPACE"
        validator_type   = "ENUM"
        validator_values = [local.zpr_label]
      },
      BASTION = {
        description      = "Security attribute for Bastion Compute instances."
        name             = "bastion"
        namespace_id     = "ZPR-LZ-NAMESPACE"
        validator_type   = "ENUM"
        validator_values = [local.zpr_label]
      },
      DATABASE = {
        description      = "Security attribute for Databases."
        name             = "database"
        namespace_id     = "ZPR-LZ-NAMESPACE"
        validator_type   = "ENUM"
        validator_values = [local.zpr_label]
      },
      NET = {
        description      = "Security attribute for VCNs."
        name             = "net"
        namespace_id     = "ZPR-LZ-NAMESPACE"
        validator_type   = "ENUM"
        validator_values = concat(local.exa_vcn_validator_values, local.tt_vcn_validator_values)
      }
    }
    zpr_policies = merge(local.exa_1_zpr_policy, local.exa_2_zpr_policy, local.exa_3_zpr_policy, local.tt_1_zpr_policy, local.tt_2_zpr_policy, local.tt_3_zpr_policy)
  } : null
}

module "lz_zpr" {
  count             = local.enable_zpr ? 1 : 0
  source            = "github.com/oci-landing-zones/terraform-oci-modules-security//zpr?ref=v0.1.9"
  providers         = { oci = oci.home }
  tenancy_ocid      = var.tenancy_ocid
  zpr_configuration = local.lz_zpr_configuration
}
