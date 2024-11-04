locals {

  zpr_label = var.service_label # pre-check if service label is valid

  zpr_configuration = {
    namespaces = {
      ZPR-CORE-LZ-NAMESPACE = {
        compartment_id = "TOP-CMP"
        description = "Core Landing Zone ZPR Security Attribute Namespace"
        name = var.zpr_security_attributes_namespace
      }
    }

    security_attributes = {
      APP = {
        description = "Security attribute for App in Three Tier VCN"
        name = "app"
        namespace_id = "ZPR-CORE-LZ-NAMESPACE"
        validator_type = "ENUM"
        validator_values = [local.zpr_label]
      }
      BASTION = {
        description = "Security attribute for Bastion in Three Tier VCN"
        name = "bastion"
        namespace_id = "ZPR-CORE-LZ-NAMESPACE"
        validator_type = "ENUM"
        validator_values = [local.zpr_label]
      }
      DB-SERVER = {
        description = "Security attribute for DB Server in Three Tier VCN"
        name = "db-server"
        namespace_id = "ZPR-CORE-LZ-NAMESPACE"
        validator_type = "ENUM"
        validator_values = [local.zpr_label]
      }
      DB-CLIENT-EXA = {
        description = "Security attribute for DB Client in Exadata VCN"
        name = "db-client"
        namespace_id = "ZPR-CORE-LZ-NAMESPACE"
        validator_type = "ENUM"
        validator_values = [local.zpr_label]
      }
      NET-TT = {
        description = "Security attribute for VCN in Three Tier VCN"
        name = "net"
        namespace_id = "ZPR-CORE-LZ-NAMESPACE"
        validator_type = "ENUM"
        validator_values = ["tt-vcn-1","tt-vcn-2","tt-vcn-3"]
      }
      NET-EXA = {
        description = "Security attribute for VCN in Exadata VCN"
        name = "net"
        namespace_id = "ZPR-CORE-LZ-NAMESPACE"
        validator_type = "ENUM"
        validator_values = ["exa-vcn-1","exa-vcn-2","exa-vcn-3"]
      }
    }

    zpr_policies = {
      ZPR-POLICY-TT-1 = var.add_tt_vcn1 == true ? {
        description = "ZPR policies for Three-tier VCN 1"
        name = "zpr-policy-three-tier-1"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.app:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.bastion:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/22'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to 'osn-services-ip-addresses' with protocol='tcp/443'"
        ]
      } : {}
      ZPR-POLICY-TT-2 = var.add_tt_vcn2 == true ? {
        description = "ZPR policies for VCN 2"
        name = "zpr-policy-three-tier-2"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.zpr_security_attributes_namespace}.app:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.zpr_security_attributes_namespace}.bastion:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/22'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to 'osn-services-ip-addresses' with protocol='tcp/443'",
        ]
      } : {}
      ZPR-POLICY-TT-3 = var.add_tt_vcn3 == true ? {
        description = "ZPR policies for VCN 2"
        name = "zpr-policy-three-tier-2"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-3 VCN allow ${var.zpr_security_attributes_namespace}.app:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-3 VCN allow ${var.zpr_security_attributes_namespace}.bastion:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/22'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-3 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to 'osn-services-ip-addresses' with protocol='tcp/443'",
          ""
        ]
      } : {}
      ZPR-POLICY-CROSS-TT1-TT2 = var.add_tt_vcn1 == true && var.add_tt_vcn2 == true ? {
        description = "ZPR policies for cross VCN communication bewteen TT VCN 1 and TT VCN 2"
        name = "zpr-policy-cross-tt1-tt2"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.tt_vcn2_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.tt_vcn2_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.tt_vcn1_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.tt_vcn1_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_app_subnet_cidr} with protocol='tcp/80'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_web_subnet_cidr} with protocol='tcp/443'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_db_subnet_cidr} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_app_subnet_cidr} with protocol='tcp/80'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_web_subnet_cidr} with protocol='tcp/443'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_db_subnet_cidr} with protocol='tcp/1521-1522'",
        ]
      } : {}
      ZPR-POLICY-CROSS-TT1-TT3 = var.add_tt_vcn1 == true && var.add_tt_vcn3 == true ? {
        description = "ZPR policies for cross VCN communication bewteen TT VCN 1 and TT VCN 3"
        name = "zpr-policy-cross-tt1-tt3"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.tt_vcn3_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.tt_vcn3_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-3 VCN allow ${var.tt_vcn1_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-3 VCN allow ${var.tt_vcn1_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn3_app_subnet_cidr} with protocol='tcp/80'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn3_web_subnet_cidr} with protocol='tcp/443'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn3_db_subnet_cidr} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-3 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_app_subnet_cidr} with protocol='tcp/80'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-3 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_web_subnet_cidr} with protocol='tcp/443'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-3 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_db_subnet_cidr} with protocol='tcp/1521-1522'",
        ]
      } : {}
      ZPR-POLICY-CROSS-TT1-TT3 = var.add_tt_vcn2 == true && var.add_tt_vcn3 == true ? {
        description = "ZPR policies for cross VCN communication bewteen TT VCN 1 and TT VCN 3"
        name = "zpr-policy-cross-tt2-tt3"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.tt_vcn3_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.tt_vcn3_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-3 VCN allow ${var.tt_vcn2_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-3 VCN allow ${var.tt_vcn2_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn3_app_subnet_cidr} with protocol='tcp/80'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn3_web_subnet_cidr} with protocol='tcp/443'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn3_db_subnet_cidr} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-3 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_app_subnet_cidr} with protocol='tcp/80'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-3 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_web_subnet_cidr} with protocol='tcp/443'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-3 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_db_subnet_cidr} with protocol='tcp/1521-1522'",
        ]
      } : {}
      ZPR-POLICY-CROSS-TT1-EXA1 = var.add_tt_vcn1 == true && var.add_exa_vcn1 == true ? {
        description = "ZPR policies for cross VCN communication bewteen TT VCN 1 and Exadata VCN 1"
        name = "zpr-policy-cross-tt1-exa1"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.app:${local.zpr_label} endpoints to connect to ${var.exa_vcn1_client_subnet_cidr} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.exa_vcn1_client_subnet_cidr} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.exa_vcn1_client_subnet_cidr} endpoints to connect to ${var.tt_vcn1_app_subnet_cidr} with protocol='tcp/80'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.exa_vcn1_client_subnet_cidr} endpoints to connect to ${var.tt_vcn1_web_subnet_cidr} with protocol='tcp/443'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1 VCN allow ${var.exa_vcn1_client_subnet_cidr} endpoints to connect to ${var.tt_vcn1_db_subnet_cidr} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_web_subnet_cidr} with protocol='tcp/443'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_app_subnet_cidr} with protocol='tcp/80'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_db_subnet_cidr} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_web_subnet_cidr} with protocol='tcp/443'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_app_subnet_cidr} with protocol='tcp/80'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_db_subnet_cidr} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn1_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${var.service_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn1_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${var.service_label} with protocol='tcp/1521-1522'"
        ]
      } : {}
      ZPR-POLICY-CROSS-TT1-EXA2 = var.add_tt_vcn1 == true && var.add_exa_vcn2 == true ? {
        description = "ZPR policies for cross VCN communication bewteen TT VCN 1 and Exadata VCN 2"
        name = "zpr-policy-cross-tt1-exa2"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.zpr_security_attributes_namespace}.app:${local.zpr_label} endpoints to connect to ${var.exa_vcn1_client_subnet_cidr} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.exa_vcn1_client_subnet_cidr} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.exa_vcn1_client_subnet_cidr} endpoints to connect to ${var.tt_vcn2_app_subnet_cidr} with protocol='tcp/80'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.exa_vcn1_client_subnet_cidr} endpoints to connect to ${var.tt_vcn2_web_subnet_cidr} with protocol='tcp/443'",
          "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-2 VCN allow ${var.exa_vcn1_client_subnet_cidr} endpoints to connect to ${var.tt_vcn2_db_subnet_cidr} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_web_subnet_cidr} with protocol='tcp/443'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_app_subnet_cidr} with protocol='tcp/80'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_db_subnet_cidr} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_web_subnet_cidr} with protocol='tcp/443'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_app_subnet_cidr} with protocol='tcp/80'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_db_subnet_cidr} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn2_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${var.service_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn2_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${var.service_label} with protocol='tcp/1521-1522'"
        ]
      } : {}
    }


  }

  // var.define_net == true && var.add_tt_vcn1 == true
}

module "zpr" {
  count = var.enable_zpr ? 1 : 0
  source = "../../"
  tenancy_ocid = var.tenancy_ocid
  zpr_configuration = var.zpr_configuration
}
