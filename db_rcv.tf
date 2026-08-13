locals {
  tt_vcn1_rcv_subnet = var.enable_tt_vcn1_rcv_infra && local.add_tt_vcn1 ? {
    "TT-VCN-1-RCV-SUBNET" = {
      display_name       = "${var.service_label}-tt-vcn1-rcv-subnet"
      vcn_id             = module.lz_network.provisioned_networking_resources.vcns["TT-VCN-1"].id
      subnet_ids         = [module.lz_network.provisioned_networking_resources.subnets["TT-VCN-1-DB-SUBNET"].id]
      nsg_ids            = [module.lz_network.provisioned_networking_resources.network_security_groups["TT-VCN-1-RCV-NSG"].id]
      enable_default_nsg = false
      enable_iam_policies= false
    }
  } : {}
  tt_vcn2_rcv_subnet = var.enable_tt_vcn2_rcv_infra && local.add_tt_vcn2 ? {
    "TT-VCN-2-RCV-SUBNET" = {
      display_name       = "${var.service_label}-tt-vcn2-rcv-subnet"
      vcn_id             = module.lz_network.provisioned_networking_resources.vcns["TT-VCN-2"].id
      subnet_ids         = [module.lz_network.provisioned_networking_resources.subnets["TT-VCN-2-DB-SUBNET"].id]
      nsg_ids            = [module.lz_network.provisioned_networking_resources.network_security_groups["TT-VCN-2-RCV-NSG"].id]
      enable_default_nsg = false
      enable_iam_policies= false
    }
  } : {}
  tt_vcn3_rcv_subnet = var.enable_tt_vcn3_rcv_infra && local.add_tt_vcn3 ? {
    "TT-VCN-3-RCV-SUBNET" = {
      display_name       = "${var.service_label}-tt-vcn3-rcv-subnet"
      vcn_id             = module.lz_network.provisioned_networking_resources.vcns["TT-VCN-3"].id
      subnet_ids         = [module.lz_network.provisioned_networking_resources.subnets["TT-VCN-3-DB-SUBNET"].id]
      nsg_ids            = [module.lz_network.provisioned_networking_resources.network_security_groups["TT-VCN-3-RCV-NSG"].id]
      enable_default_nsg = false
      enable_iam_policies= false
    }
  } : {}
  oke_vcn1_rcv_subnet = var.enable_oke_vcn1_rcv_infra && local.add_oke_vcn1 && var.add_oke_vcn1_db_subnet ? {
    "OKE-VCN-1-RCV-SUBNET" = {
      display_name       = "${var.service_label}-oke-vcn1-rcv-subnet"
      vcn_id             = module.lz_network.provisioned_networking_resources.vcns["OKE-VCN-1"].id
      subnet_ids         = [module.lz_network.provisioned_networking_resources.subnets["OKE-VCN-1-DB-SUBNET"].id]
      nsg_ids            = [module.lz_network.provisioned_networking_resources.network_security_groups["OKE-VCN-1-RCV-NSG"].id]
      enable_default_nsg = false
      enable_iam_policies= false
    }
  } : {}
  oke_vcn2_rcv_subnet = var.enable_oke_vcn2_rcv_infra && local.add_oke_vcn2 && var.add_oke_vcn2_db_subnet ? {
    "OKE-VCN-2-RCV-SUBNET" = {
      display_name       = "${var.service_label}-oke-vcn2-rcv-subnet"
      vcn_id             = module.lz_network.provisioned_networking_resources.vcns["OKE-VCN-2"].id
      subnet_ids         = [module.lz_network.provisioned_networking_resources.subnets["OKE-VCN-2-DB-SUBNET"].id]
      nsg_ids            = [module.lz_network.provisioned_networking_resources.network_security_groups["OKE-VCN-2-RCV-NSG"].id]
      enable_default_nsg = false
      enable_iam_policies= false
    }
  } : {}
  oke_vcn3_rcv_subnet = var.enable_oke_vcn3_rcv_infra && local.add_oke_vcn3 && var.add_oke_vcn3_db_subnet ? {
    "OKE-VCN-3-RCV-SUBNET" = {
      display_name       = "${var.service_label}-oke-vcn3-rcv-subnet"
      vcn_id             = module.lz_network.provisioned_networking_resources.vcns["OKE-VCN-3"].id
      subnet_ids         = [module.lz_network.provisioned_networking_resources.subnets["OKE-VCN-3-DB-SUBNET"].id]
      nsg_ids            = [module.lz_network.provisioned_networking_resources.network_security_groups["OKE-VCN-3-RCV-NSG"].id]
      enable_default_nsg = false
      enable_iam_policies= false
    }
  } : {}
  exa_vcn1_rcv_subnet = var.enable_exa_vcn1_rcv_infra && local.add_exa_vcn1 ? {
    "EXA-VCN-1-SUBNET-RCV" = {
      display_name       = "${var.service_label}-exa-vcn1-rcv-subnet"
      vcn_id             = module.lz_network.provisioned_networking_resources.vcns["EXA-VCN-1"].id
      subnet_ids         = [var.add_exa_vcn1_backup_subnet ? module.lz_network.provisioned_networking_resources.subnets["EXA-VCN-1-BACKUP-SUBNET"].id : module.lz_network.provisioned_networking_resources.subnets["EXA-VCN-1-CLIENT-SUBNET"].id]
      nsg_ids            = [module.lz_network.provisioned_networking_resources.network_security_groups["EXA-VCN-1-RCV-NSG"].id]
      enable_default_nsg = false
      enable_iam_policies= false
    }
  } : {}
  exa_vcn2_rcv_subnet = var.enable_exa_vcn2_rcv_infra && local.add_exa_vcn2 ? {
    "EXA-VCN-2-SUBNET-RCV" = {
      display_name       = "${var.service_label}-exa-vcn2-rcv-subnet"
      vcn_id             = module.lz_network.provisioned_networking_resources.vcns["EXA-VCN-2"].id
      subnet_ids         = [var.add_exa_vcn2_backup_subnet ? module.lz_network.provisioned_networking_resources.subnets["EXA-VCN-2-BACKUP-SUBNET"].id : module.lz_network.provisioned_networking_resources.subnets["EXA-VCN-2-CLIENT-SUBNET"].id]
      nsg_ids            = [module.lz_network.provisioned_networking_resources.network_security_groups["EXA-VCN-2-RCV-NSG"].id]
      enable_default_nsg = false
      enable_iam_policies= false
    }
  } : {}
  exa_vcn3_rcv_subnet = var.enable_exa_vcn3_rcv_infra && local.add_exa_vcn3 ? {
    "EXA-VCN-3-SUBNET-RCV" = {
      display_name       = "${var.service_label}-exa-vcn3-rcv-subnet"
      vcn_id             = module.lz_network.provisioned_networking_resources.vcns["EXA-VCN-3"].id
      subnet_ids         = [var.add_exa_vcn3_backup_subnet ? module.lz_network.provisioned_networking_resources.subnets["EXA-VCN-3-BACKUP-SUBNET"].id : module.lz_network.provisioned_networking_resources.subnets["EXA-VCN-3-CLIENT-SUBNET"].id]
      nsg_ids            = [module.lz_network.provisioned_networking_resources.network_security_groups["EXA-VCN-3-RCV-NSG"].id]
      enable_default_nsg = false
      enable_iam_policies= false
    }
  } : {}

  tt_vcn1_rcv_protection_policy = var.enable_tt_vcn1_rcv_infra && local.add_tt_vcn1 ? {
    "TT-VCN-1-RCV-PROTECTION-POLICY" = {
      display_name                    = "${var.service_label}-tt-vcn1-rcv-protection-policy"
      backup_retention_period_in_days = var.tt_vcn1_rcv_backup_retention_period_in_days
    }
  } : {}
  tt_vcn2_rcv_protection_policy = var.enable_tt_vcn2_rcv_infra && local.add_tt_vcn2 ? {
    "TT-VCN-2-RCV-PROTECTION-POLICY" = {
      display_name                    = "${var.service_label}-tt-vcn2-rcv-protection-policy"
      backup_retention_period_in_days = var.tt_vcn2_rcv_backup_retention_period_in_days
    }
  } : {}
  tt_vcn3_rcv_protection_policy = var.enable_tt_vcn3_rcv_infra && local.add_tt_vcn3 ? {
    "TT-VCN-3-RCV-PROTECTION-POLICY" = {
      display_name                    = "${var.service_label}-tt-vcn3-rcv-protection-policy"
      backup_retention_period_in_days = var.tt_vcn3_rcv_backup_retention_period_in_days
    }
  } : {}
  oke_vcn1_rcv_protection_policy = var.enable_oke_vcn1_rcv_infra && local.add_oke_vcn1 && var.add_oke_vcn1_db_subnet ? {
    "OKE-VCN-1-RCV-PROTECTION-POLICY" = {
      display_name                    = "${var.service_label}-oke-vcn1-rcv-protection-policy"
      backup_retention_period_in_days = var.oke_vcn1_rcv_backup_retention_period_in_days
    }
  } : {}
  oke_vcn2_rcv_protection_policy = var.enable_oke_vcn2_rcv_infra && local.add_oke_vcn2 && var.add_oke_vcn2_db_subnet ? {
    "OKE-VCN-2-RCV-PROTECTION-POLICY" = {
      display_name                    = "${var.service_label}-oke-vcn2-rcv-protection-policy"
      backup_retention_period_in_days = var.oke_vcn2_rcv_backup_retention_period_in_days
    }
  } : {}
  oke_vcn3_rcv_protection_policy = var.enable_oke_vcn3_rcv_infra && local.add_oke_vcn3 && var.add_oke_vcn3_db_subnet ? {
    "OKE-VCN-3-RCV-PROTECTION-POLICY" = {
      display_name                    = "${var.service_label}-oke-vcn3-rcv-protection-policy"
      backup_retention_period_in_days = var.oke_vcn3_rcv_backup_retention_period_in_days
    }
  } : {}
  exa_vcn1_rcv_protection_policy = var.enable_exa_vcn1_rcv_infra && local.add_exa_vcn1 ? {
    "EXA-VCN-1-RCV-PROTECTION-POLICY" = {
      display_name                    = "${var.service_label}-exa-vcn1-rcv-protection-policy"
      backup_retention_period_in_days = var.exa_vcn1_rcv_backup_retention_period_in_days
    }
  } : {}
  exa_vcn2_rcv_protection_policy = var.enable_exa_vcn2_rcv_infra && local.add_exa_vcn2 ? {
    "EXA-VCN-2-RCV-PROTECTION-POLICY" = {
      display_name                    = "${var.service_label}-exa-vcn2-rcv-protection-policy"
      backup_retention_period_in_days = var.exa_vcn2_rcv_backup_retention_period_in_days
    }
  } : {}
  exa_vcn3_rcv_protection_policy = var.enable_exa_vcn3_rcv_infra && local.add_exa_vcn3 ? {
    "EXA-VCN-3-RCV-PROTECTION-POLICY" = {
      display_name                    = "${var.service_label}-exa-vcn3-rcv-protection-policy"
      backup_retention_period_in_days = var.exa_vcn3_rcv_backup_retention_period_in_days
    }
  } : {}

  recovery_subnets    = merge(local.tt_vcn1_rcv_subnet, local.tt_vcn2_rcv_subnet, local.tt_vcn3_rcv_subnet, local.oke_vcn1_rcv_subnet, local.oke_vcn2_rcv_subnet, local.oke_vcn3_rcv_subnet, local.exa_vcn1_rcv_subnet, local.exa_vcn2_rcv_subnet, local.exa_vcn3_rcv_subnet)
  protection_policies = merge(local.tt_vcn1_rcv_protection_policy, local.tt_vcn2_rcv_protection_policy, local.tt_vcn3_rcv_protection_policy, local.oke_vcn1_rcv_protection_policy, local.oke_vcn2_rcv_protection_policy, local.oke_vcn3_rcv_protection_policy, local.exa_vcn1_rcv_protection_policy, local.exa_vcn2_rcv_protection_policy, local.exa_vcn3_rcv_protection_policy)

  autonomous_recovery_service_configuration = local.enable_database_compartment && length(local.recovery_subnets) > 0 ? {
    default_compartment_id = local.database_compartment_id
    recovery_subnets       = local.recovery_subnets
    protection_policies    = local.protection_policies
  } : {
    default_compartment_id = null
    recovery_subnets       = null
    protection_policies    = null
  }
}

module "lz_rcv" {
  source = "github.com/oci-landing-zones/terraform-oci-modules-oracle-database//autonomous-recovery-service?ref=rcv"
  count = local.enable_database_compartment && length(local.recovery_subnets) > 0 ? 1 : 0
  providers = {
    oci                  = oci
    oci.home             = oci.home
  }  
  autonomous_recovery_service_configuration = local.autonomous_recovery_service_configuration
  tenancy_ocid = var.tenancy_ocid  
}

