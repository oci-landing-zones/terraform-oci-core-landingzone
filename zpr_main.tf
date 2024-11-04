locals {

  zpr_label = var.service_label # pre-check if service label is valid

  zpr_configuration = {
    namespaces = {
      ZPR-CORE-LZ-NAMESPACE = {
        compartment_id = "TOP-CMP"
        description    = "Core Landing Zone ZPR Security Attribute Namespace"
        name           = var.zpr_security_attributes_namespace
      }
    }

    security_attributes = {
      APP = {
        description      = "Security attribute for App in Three Tier VCN"
        name             = "app"
        namespace_id     = "ZPR-CORE-LZ-NAMESPACE"
        validator_type   = "ENUM"
        validator_values = [local.zpr_label]
      }
      BASTION = {
        description      = "Security attribute for Bastion in Three Tier VCN"
        name             = "bastion"
        namespace_id     = "ZPR-CORE-LZ-NAMESPACE"
        validator_type   = "ENUM"
        validator_values = [local.zpr_label]
      }
      DB-SERVER = {
        description      = "Security attribute for DB Server in Three Tier VCN"
        name             = "db-server"
        namespace_id     = "ZPR-CORE-LZ-NAMESPACE"
        validator_type   = "ENUM"
        validator_values = [local.zpr_label]
      }
      DB-CLIENT-EXA = {
        description      = "Security attribute for DB Client in Exadata VCN"
        name             = "db-client"
        namespace_id     = "ZPR-CORE-LZ-NAMESPACE"
        validator_type   = "ENUM"
        validator_values = [local.zpr_label]
      }
      NET-TT = {
        description      = "Security attribute for VCN in Three Tier VCN"
        name             = "net"
        namespace_id     = "ZPR-CORE-LZ-NAMESPACE"
        validator_type   = "ENUM"
        validator_values = ["tt-vcn-1", "tt-vcn-2", "tt-vcn-3"]
      }
      NET-EXA = {
        description      = "Security attribute for VCN in Exadata VCN"
        name             = "net"
        namespace_id     = "ZPR-CORE-LZ-NAMESPACE"
        validator_type   = "ENUM"
        validator_values = ["exa-vcn-1", "exa-vcn-2", "exa-vcn-3"]
      }
    }
    zpr_policies = merge(local.exa_zpr_policies)
  }
}


module "zpr" {
  count = var.enable_zpr ? 1 : 0
  source = "github.com/oci-landing-zones/terraform-oci-modules-security//zpr?ref=release-0.1.9" // need to update this when release branch gets merged into main branch
  tenancy_ocid = var.tenancy_ocid
  zpr_configuration = local.zpr_configuration
}
