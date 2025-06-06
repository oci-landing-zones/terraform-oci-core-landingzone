# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

locals {

  add_oke_vcn1 = var.define_net == true && var.add_oke_vcn1 == true


  oke_vcn_1 = local.add_oke_vcn1 == true ? {
    "OKE-VCN-1" = {
      display_name                     = coalesce(var.oke_vcn1_name, "${var.service_label}-oke-vcn-1")
      is_ipv6enabled                   = false
      is_oracle_gua_allocation_enabled = false
      cidr_blocks                      = var.oke_vcn1_cidrs,
      dns_label                        = substr(replace(coalesce(var.oke_vcn1_name, "oke-vcn-1"), "/[^\\w]/", ""), 0, 14)
      block_nat_traffic                = false

      subnets = merge(
        {
          "OKE-VCN-1-API-SUBNET" = {
            cidr_block                = coalesce(var.oke_vcn1_api_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 0))
            dhcp_options_key          = "default_dhcp_options"
            display_name              = coalesce(var.oke_vcn1_api_subnet_name, "${var.service_label}-oke-vcn-1-api-subnet")
            dns_label                 = substr(replace(coalesce(var.oke_vcn1_api_subnet_name, "api-subnet"), "/[^\\w]/", ""), 0, 14)
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "OKE-VCN-1-API-SUBNET-ROUTE-TABLE"
            # security_list_keys        = ["OKE-VCN-1-API-SUBNET-SL"]
          }
        },
        {
          "OKE-VCN-1-WORKERS-SUBNET" = {
            cidr_block                = coalesce(var.oke_vcn1_workers_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 1))
            dhcp_options_key          = "default_dhcp_options"
            display_name              = coalesce(var.oke_vcn1_workers_subnet_name, "${var.service_label}-oke-vcn-1-workers-subnet")
            dns_label                 = substr(replace(coalesce(var.oke_vcn1_workers_subnet_name, "workers-subnet"), "/[^\\w]/", ""), 0, 14)
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "OKE-VCN-1-WORKERS-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["OKE-VCN-1-WORKERS-SUBNET-SL"]
          }
        },
        {
          "OKE-VCN-1-SERVICES-SUBNET" = {
            cidr_block                = coalesce(var.oke_vcn1_services_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 2))
            dhcp_options_key          = "default_dhcp_options"
            display_name              = coalesce(var.oke_vcn1_services_subnet_name, "${var.service_label}-oke-vcn-1-services-subnet")
            dns_label                 = substr(replace(coalesce(var.oke_vcn1_services_subnet_name, "services-subnet"), "/[^\\w]/", ""), 0, 14)
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = (local.hub_with_vcn == true && var.oke_vcn1_attach_to_drg == true) ? true : false
            route_table_key           = "OKE-VCN-1-SERVICES-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["OKE-VCN-1-SERVICES-SUBNET-SL"]
          }
        },
        var.add_oke_vcn1_mgmt_subnet ? {
          "OKE-VCN-1-MGMT-SUBNET" = {
            cidr_block                = coalesce(var.oke_vcn1_mgmt_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 12, 48))
            dhcp_options_key          = "default_dhcp_options"
            display_name              = coalesce(var.oke_vcn1_mgmt_subnet_name, "${var.service_label}-oke-vcn-1-mgmt-subnet")
            dns_label                 = substr(replace(coalesce(var.oke_vcn1_mgmt_subnet_name, "mgmt-subnet"), "/[^\\w]/", ""), 0, 14)
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "OKE-VCN-1-MGMT-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["OKE-VCN-1-MGMT-SUBNET-SL"]
          }
        } : {},
        upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
          "OKE-VCN-1-PODS-SUBNET" = {
            cidr_block                = coalesce(var.oke_vcn1_pods_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 3, 1))
            dhcp_options_key          = "default_dhcp_options"
            display_name              = coalesce(var.oke_vcn1_pods_subnet_name, "${var.service_label}-oke-vcn-1-pods-subnet")
            dns_label                 = substr(replace(coalesce(var.oke_vcn1_pods_subnet_name, "pods-subnet"), "/[^\\w]/", ""), 0, 14)
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "OKE-VCN-1-PODS-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["OKE-VCN-1-PODS-SUBNET-SL"]
          }
        } : {}
      )


      security_lists = merge(
        {
          "OKE-VCN-1-WORKERS-SUBNET-SL" = {
            display_name = "${coalesce(var.oke_vcn1_workers_subnet_name, "${var.service_label}-oke-vcn-1-workers-subnet")}-security-list"
            egress_rules = []
            ingress_rules = [
              {
                description = "Allows inbound ICMP traffic for path discovery"
                stateless   = false
                protocol    = "ICMP"
                src         = "0.0.0.0/0"
                src_type    = "CIDR_BLOCK"
                icmp_type   = 3
                icmp_code   = 4
              }
            ]
          }
        },
        {
          "OKE-VCN-1-SERVICES-SUBNET-SL" = {
            display_name = "${coalesce(var.oke_vcn1_services_subnet_name, "${var.service_label}-oke-vcn-1-services-subnet")}-security-list"
            egress_rules = []
            ingress_rules = [
              {
                description = "Ingress ICMP for path discovery"
                stateless   = false
                protocol    = "ICMP"
                src         = "0.0.0.0/0"
                src_type    = "CIDR_BLOCK"
                icmp_type   = 3
                icmp_code   = 4
              }
            ]
          }
        },
        var.add_oke_vcn1_mgmt_subnet ? {
          "OKE-VCN-1-MGMT-SUBNET-SL" = {
            display_name = "${coalesce(var.oke_vcn1_mgmt_subnet_name, "${var.service_label}-oke-vcn-1-mgmt-subnet")}-security-list"
            ingress_rules = [
              {
                description = "Allows inbound ICMP traffic for path discovery."
                stateless   = false
                protocol    = "ICMP"
                src         = "0.0.0.0/0"
                src_type    = "CIDR_BLOCK"
                icmp_type   = 3
                icmp_code   = 4
              },
              {
                description  = "Allows inbound SSH access from hosts in the mgmt subnet. Required for OCI Bastion service endpoints in the mgmt subnet to reach Operator host in the mgmt subnet."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.oke_vcn1_mgmt_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 12, 48))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            ]
            egress_rules = [
              {
                description  = "Allows outbound SSH traffic from MGMT subnet to hosts in the MGMT subnet, for Bastion service."
                stateless    = false
                protocol     = "TCP"
                dst          = coalesce(var.oke_vcn1_mgmt_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 12, 48))
                dst_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              },
              {
                description  = "Egress for bastion service to API endpoint"
                stateless    = false
                protocol     = "TCP"
                dst          = coalesce(var.oke_vcn1_api_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 0))
                dst_type     = "CIDR_BLOCK"
                dst_port_min = 6443
                dst_port_max = 6443
              },
              {
                description  = "Egress for bastion service to worker nodes"
                stateless    = false
                protocol     = "TCP"
                dst          = coalesce(var.oke_vcn1_workers_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 1))
                dst_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            ]
          }
        } : {},
        upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
          "OKE-VCN-1-PODS-SUBNET-SL" = {
            display_name = "${coalesce(var.oke_vcn1_pods_subnet_name, "${var.service_label}-oke-vcn-1-pods-subnet")}-security-list"
            egress_rules = []
            ingress_rules = [
              {
                description = "Ingress ICMP for path discovery"
                stateless   = false
                protocol    = "ICMP"
                src         = "0.0.0.0/0"
                src_type    = "CIDR_BLOCK"
                icmp_type   = 3
                icmp_code   = 4
              }
            ]
          }
        } : {}
      )

      route_tables = merge(
        {
          "OKE-VCN-1-API-SUBNET-ROUTE-TABLE" = {
            display_name = "api-subnet-route-table"
            route_rules = merge(
              (local.chosen_hub_option != 3 && local.chosen_hub_option != 4) ? {
                "SGW-RULE" = {
                  network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                  description        = "Route for sgw"
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
                } : {
                "HUB-DRG-RULE" = {
                  network_entity_key = "HUB-DRG"
                  description        = "Route to HUB DRG"
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              },
              (local.chosen_hub_option != 3 && local.chosen_hub_option != 4) && upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                "NATGW-RULE" = {
                  network_entity_key = "OKE-VCN-1-NAT-GATEWAY"
                  description        = "Route for internet access via NAT GW"
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              } : {}
            )
          }
        },
        {
          "OKE-VCN-1-WORKERS-SUBNET-ROUTE-TABLE" = {
            display_name = "workers-subnet-route-table"
            route_rules = merge(
              (local.chosen_hub_option != 3 && local.chosen_hub_option != 4) ? {
                "SGW-RULE" = {
                  network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                  description        = "Route for sgw"
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                },
                "NATGW-RULE" = {
                  network_entity_key = "OKE-VCN-1-NAT-GATEWAY"
                  description        = "Route for internet access via NAT GW"
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
                } : {
                "HUB-DRG-RULE" = {
                  network_entity_key = "HUB-DRG"
                  description        = "Route to HUB DRG"
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              },
              local.oke_vcn_1_drg_routing
            )
          }
        },
        {
          "OKE-VCN-1-SERVICES-SUBNET-ROUTE-TABLE" = {
            display_name = "services-subnet-route-table"
            route_rules = (local.chosen_hub_option != 3 && local.chosen_hub_option != 4) ? {
              "IGW-RULE" = {
                network_entity_key = "OKE-VCN-1-INTERNET-GATEWAY"
                description        = "Route for igw"
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
              } : {
              "HUB-DRG-RULE" = {
                network_entity_key = "HUB-DRG"
                description        = "Route to HUB DRG"
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
            }
          }
        },
        var.add_oke_vcn1_mgmt_subnet ? {
          "OKE-VCN-1-MGMT-SUBNET-ROUTE-TABLE" = {
            display_name = "mgmt-subnet-route-table"
            route_rules = (local.chosen_hub_option != 3 && local.chosen_hub_option != 4) ? {
              "SGW-RULE" = {
                network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                description        = "Route for sgw"
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              }
              "NATGW-RULE" = {
                network_entity_key = "OKE-VCN-1-NAT-GATEWAY"
                description        = "Route for NAT Gateway"
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
              } : {
              "HUB-DRG-RULE" = {
                network_entity_key = "HUB-DRG"
                description        = "Route to HUB DRG"
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
            }
          }
        } : {},
        upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
          "OKE-VCN-1-PODS-SUBNET-ROUTE-TABLE" = {
            display_name = "pods-subnet-route-table"
            route_rules = merge((local.chosen_hub_option != 3 && local.chosen_hub_option != 4) ? {
              "SGW-RULE" = {
                network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                description        = "Route for sgw"
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              },
              "NATGW-RULE" = {
                network_entity_key = "OKE-VCN-1-NAT-GATEWAY"
                description        = "Route for internet access via NAT GW"
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
              } : {
              "HUB-DRG-RULE" = {
                network_entity_key = "HUB-DRG"
                description        = "Route to HUB DRG"
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
              }
            )
          }
        } : {}
      )

      network_security_groups = merge(
        {
          "OKE-VCN-1-API-NSG" = {
            display_name = "api-nsg"
            egress_rules = merge(
              {
                "EGRESS-TO-SERVICES-API-RULE" = {
                  description = "Allow TCP egress from OKE control plane to OCI services"
                  stateless   = false
                  protocol    = "TCP"
                  dst         = "all-services"
                  dst_type    = "SERVICE_CIDR_BLOCK"
                }
              },
              {
                "EGRESS-TO-KUBELET-API-RULE" = {
                  description  = "Allow TCP egress from OKE control plane to Kubelet on worker nodes."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-1-WORKERS-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 10250
                  dst_port_max = 10250
                }
              },
              {
                "EGRESS-TO-WORKERS-API-RULE" = {
                  description  = "Allow TCP egress from OKE control plane to worker node"
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-1-WORKERS-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 12250
                  dst_port_max = 12250
                }
              },
              {
                "EGRESS-TO-WORKERS-ICMP-API-RULE" = {
                  description = "Allows outbound ICMP to worker nodes path discovery."
                  stateless   = false
                  protocol    = "ICMP"
                  dst         = "OKE-VCN-1-WORKERS-NSG"
                  dst_type    = "NETWORK_SECURITY_GROUP"
                  icmp_type   = 3
                  icmp_code   = 4
                }
              },
              upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                "EGRESS-TO-API-API-RULE" = {
                  description  = "Allow TCP egress for Kubernetes control plane inter-communication"
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-1-API-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                "EGRESS-TO-PODS-API-RULE" = {
                  description = "Allow Kubernetes API endpoint to communicate with pods."
                  stateless   = false
                  protocol    = "ALL"
                  dst         = "OKE-VCN-1-PODS-NSG"
                  dst_type    = "NETWORK_SECURITY_GROUP"
                }
              } : {}
            )
            ingress_rules = merge(
              {
                "INGRESS-FROM-WORKERS-6443-API-RULE" = {
                  description  = "Allows inbound TCP from worker nodes."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-1-WORKERS-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
              },
              {
                "INGRESS-FROM-WORKERS-10250-API-RULE" = {
                  description  = "Allows inbound TCP from worker nodes."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-1-WORKERS-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 10250
                  dst_port_max = 10250
                }
              },
              {
                "INGRESS-FROM-WORKERS-12250-API-RULE" = {
                  description  = "Allows inbound TCP from worker nodes."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-1-WORKERS-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 12250
                  dst_port_max = 12250
                }
              },
              upper(var.oke_vcn1_cni_type) == "FLANNEL" ? {
                "INGRESS-FROM-MGMT-API-RULE" = {
                  description  = "Allows inbound TCP from mgmt subnet."
                  stateless    = false
                  protocol     = "TCP"
                  src          = coalesce(var.oke_vcn1_mgmt_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 4, 3))
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                } : upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                "INGRESS-FROM-API-API-RULE" = {
                  description  = "Allow TCP ingress for Kubernetes control plane inter-communication."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-1-API-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                "INGRESS-FROM-BASTION-API-RULE" = {
                  description  = "Bastion service access to Kubernetes API endpoint"
                  stateless    = false
                  protocol     = "TCP"
                  src          = coalesce(var.oke_vcn1_mgmt_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 4, 3))
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                "INGRESS-FROM-WORKERS-ICMP-API-RULE" = {
                  description = "Allow ICMP ingress for path discovery from worker nodes."
                  stateless   = false
                  protocol    = "ICMP"
                  src         = "OKE-VCN-1-WORKERS-NSG"
                  src_type    = "NETWORK_SECURITY_GROUP"
                  icmp_type   = 3
                  icmp_code   = 4
                }
                "INGRESS-FROM-PODS-6443-API-RULE" = {
                  description  = "Pod to Kubernetes API endpoint communication (when using VCN-native pod networking)"
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-1-PODS-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                "INGRESS-FROM-PODS-12250-API-RULE" = {
                  description  = "Pod to Kubernetes API endpoint communication (when using VCN-native pod networking)"
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-1-PODS-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 12250
                  dst_port_max = 12250
                }
              } : {},
              upper(var.oke_vcn1_cni_type) == "NATIVE" && var.add_oke_vcn1_mgmt_subnet ? {
                "INGRESS-FROM-OPERATOR-API-RULE" = {
                  description  = "Operator access to Kubernetes API endpoint"
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-1-MGMT-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
              } : {}
            )
          }
          "OKE-VCN-1-WORKERS-NSG" = {
            display_name = "workers-nsg"
            egress_rules = merge(
              {
                "EGRESS-TO-WORKERS-WORKERS-RULE" = {
                  description = "Allows outbound access to worker nodes."
                  stateless   = false
                  protocol    = "ALL"
                  dst         = "OKE-VCN-1-WORKERS-NSG"
                  dst_type    = "NETWORK_SECURITY_GROUP"
                }
                "EGRESS-TO-SERVICES-WORKERS-RULE" = {
                  description = "Allows outbound TCP egress to OCI Services."
                  stateless   = false
                  protocol    = "TCP"
                  dst         = "all-services"
                  dst_type    = "SERVICE_CIDR_BLOCK"
                }
                "EGRESS-TO-API-WORKERS-RULE" = {
                  description  = "Allows outbound TCP to OKE API endpoint."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-1-API-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                "EGRESS-TO-CONTROL-PLANE-10250-WORKERS-RULE" = {
                  description  = "Allows outbound TCP to OKE control plane health check."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-1-API-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 10250
                  dst_port_max = 10250
                }
                "EGRESS-TO-CONTROL-PLANE-12250-WORKERS-RULE" = {
                  description  = "Allows outbound TCP egress to OKE control plane."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-1-API-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 12250
                  dst_port_max = 12250
                }
                "EGRESS-TO-ANYWHERE-ICMP-WORKERS-RULE" = {
                  description = "Allows outbound ICMP for path discovery."
                  stateless   = false
                  protocol    = "ICMP"
                  dst         = "0.0.0.0/0"
                  dst_type    = "CIDR_BLOCK"
                  icmp_type   = 3
                  icmp_code   = 4
                }
                "EGRESS-TO-ANYWHERE-TCP-WORKERS-RULE" = {
                  description = "(optional) Allows worker nodes to communicate with the Internet."
                  stateless   = false
                  protocol    = "TCP"
                  dst         = "0.0.0.0/0"
                  dst_type    = "CIDR_BLOCK"
                }
              },
              upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                "EGRESS-TO-PODS-WORKERS-RULE" = {
                  description = "Allow worker nodes to access pods."
                  stateless   = false
                  protocol    = "ALL"
                  dst         = "OKE-VCN-1-PODS-NSG"
                  dst_type    = "NETWORK_SECURITY_GROUP"
                }
              } : {},
              local.oke_vcn_1_to_workers_subnet_cross_vcn_egress,
              local.oke_vcn_1_to_services_subnet_cross_vcn_egress,
              local.oke_vcn_1_to_client_subnet_cross_vcn_egress,
              local.oke_vcn_1_to_web_subnet_cross_vcn_egress,
              local.oke_vcn_1_to_db_subnet_cross_vcn_egress
            )
            ingress_rules = merge({
              "INGRESS-FROM-WORKERS-ALL-WORKERS-RULE" = {
                description = "Allows all inbound traffic from worker nodes."
                stateless   = false
                protocol    = "ALL"
                src         = "OKE-VCN-1-WORKERS-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
              "INGRESS-FROM-API-WORKERS-RULE" = {
                description = "Allows all inbound traffic from OKE control plane for webhooks served by workers."
                stateless   = false
                protocol    = "ALL"
                src         = "OKE-VCN-1-API-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
              "INGRESS-FROM-LB-10256-WORKERS-RULE" = {
                description  = "Allows inbound TCP for health check from public load balancers."
                stateless    = false
                protocol     = "TCP"
                src          = "OKE-VCN-1-SERVICES-NSG"
                src_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 10256
                dst_port_max = 10256
              }
              "INGRESS-FROM-LB-TCP-WORKERS-RULE" = {
                description  = "Allows inbound TCP from public load balancers."
                stateless    = false
                protocol     = "TCP"
                src          = "OKE-VCN-1-SERVICES-NSG"
                src_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 30000
                dst_port_max = 32767
              }
              },
              upper(var.oke_vcn1_cni_type) == "FLANNEL" ? {
                "INGRESS-FROM-MGMT-WORKERS-RULE" = {
                  description  = "Allows inbound SSH access from mgmt subnet."
                  stateless    = false
                  protocol     = "TCP"
                  src          = coalesce(var.oke_vcn1_mgmt_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 12, 48))
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
                } : upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                "INGRESS-FROM-ANYWHERE-ICMP-WORKERS-RULE" = {
                  description = "Allow ICMP ingress to workers for path discovery."
                  stateless   = false
                  protocol    = "ICMP"
                  src         = "0.0.0.0/0"
                  src_type    = "CIDR_BLOCK"
                  icmp_type   = 3
                  icmp_code   = 4
                }
                "INGRESS-FROM-BASTION-WORKERS-RULE" = {
                  description  = "Bastion service ssh access to workers"
                  stateless    = false
                  protocol     = "TCP"
                  src          = coalesce(var.oke_vcn1_mgmt_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 12, 48))
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              upper(var.oke_vcn1_cni_type) == "NATIVE" && var.add_oke_vcn1_mgmt_subnet ? {
                "INGRESS-FROM-OPERATOR-WORKERS-RULE" = {
                  description  = "Operator ssh access to workers"
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-1-MGMT-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              (local.hub_with_vcn == true && var.deploy_bastion_jump_host == true) ? {
                "INGRESS-FROM-HUB-JUMPHOST-SUBNET-RULE" = {
                  description  = "Ingress from Hub VCN Jumphost Subnet. Required for deploying jump host instance access."
                  stateless    = false
                  protocol     = "TCP"
                  src          = coalesce(var.hub_vcn_jumphost_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 3, 4))
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              local.oke_vcn_1_to_workers_subnet_cross_vcn_ingress
            )
          }
          "OKE-VCN-1-SERVICES-NSG" = {
            display_name = "services-nsg"
            egress_rules = merge({
              "EGRESS-TO-WORKERS-NSG-RULE" = {
                description  = "Allows outbound TCP to workers nodes for NodePort traffic."
                stateless    = false
                protocol     = "TCP"
                dst          = "OKE-VCN-1-WORKERS-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 30000
                dst_port_max = 32767
              }
              "EGRESS-TO-WORKERS-TCP-RULE" = {
                description  = "Allows outbound TCP egress to worker nodes for health checks."
                stateless    = false
                protocol     = "TCP"
                dst          = "OKE-VCN-1-WORKERS-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 10256
                dst_port_max = 10256
              }
              "EGRESS-TO-WORKERS-ICMP-RULE" = {
                description = "Allow outbound ICMP to worker nodes for path discovery."
                stateless   = false
                protocol    = "ICMP"
                dst         = "OKE-VCN-1-WORKERS-NSG"
                dst_type    = "NETWORK_SECURITY_GROUP"
                icmp_type   = 3
                icmp_code   = 4
              }
              },
              local.oke_vcn_1_to_workers_subnet_cross_vcn_egress,
              local.oke_vcn_1_to_pods_subnet_cross_vcn_egress
            ),
            ingress_rules = merge({
              "INGRESS-FROM-ANYWHERE-TCP-RULE" = {
                description  = "Allows inbound TCP."
                stateless    = false
                protocol     = "TCP"
                src          = "0.0.0.0/0"
                src_type     = "CIDR_BLOCK"
                dst_port_min = 443
                dst_port_max = 443
              }
              }
            )
          }
        },
        var.add_oke_vcn1_mgmt_subnet ? {
          "OKE-VCN-1-MGMT-NSG" = {
            display_name = "mgmt-nsg"
            egress_rules = merge({
              "EGRESS-TO-SERVICE-GATEWAY-RULE" = {
                description = "Allows outbound TCP to OCI services."
                stateless   = false
                protocol    = "TCP"
                dst         = "all-services"
                dst_type    = "SERVICE_CIDR_BLOCK"
              }
              "EGRESS-TO-ANYWHERE-RULE" = {
                description = "Allows outbound connections to anywhere."
                stateless   = false
                protocol    = "TCP"
                dst         = "0.0.0.0/0"
                dst_type    = "CIDR_BLOCK"
              }
              },
              upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                "EGRESS-TO-API-RULE" = {
                  description  = "Allows TCP outbound traffic from mgmt subnet to Kubernetes API server, for OKE management."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-1-API-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                "EGRESS-TO-WORKERS-RULE" = {
                  description  = "Allows outbound SSH to worker nodes."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-1-WORKERS-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {}
            )
            ingress_rules = upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
              "INGRESS-FROM-SSH-RULE" = {
                description  = "Allows inbound SSH access."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.oke_vcn1_mgmt_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 12, 48))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            } : {}
          }
        } : {},
        upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
          "OKE-VCN-1-PODS-NSG" = {
            display_name = "pods-nsg"
            egress_rules = merge({
              "EGRESS-TO-PODS-RULE" = {
                description = "Allow pods to communicate with other pods."
                stateless   = false
                protocol    = "ALL"
                dst         = "OKE-VCN-1-PODS-NSG"
                dst_type    = "NETWORK_SECURITY_GROUP"
              }
              "EGRESS-TO-ICMP-RULE" = {
                description = "Path Discovery."
                stateless   = false
                protocol    = "ICMP"
                dst         = "all-services"
                dst_type    = "SERVICE_CIDR_BLOCK"
                icmp_type   = 3
                icmp_code   = 4
              }
              "EGRESS-TO-SERVICES-TCP-RULE" = {
                description = "Allow TCP egress from pods to OCI Services."
                stateless   = false
                protocol    = "TCP"
                dst         = "all-services"
                dst_type    = "SERVICE_CIDR_BLOCK"
              }
              "EGRESS-TO-INTERNET-RULE" = {
                description = "(optional) Allow pods nodes to communicate with internet."
                stateless   = false
                protocol    = "TCP"
                dst         = "0.0.0.0/0"
                dst_type    = "CIDR_BLOCK"
              }
              "EGRESS-TO-API-RULE" = {
                description  = "Allow TCP egress from pods to Kubernetes API server."
                stateless    = false
                protocol     = "TCP"
                dst          = "OKE-VCN-1-API-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 6443
                dst_port_max = 6443
              }
              "EGRESS-TO-API-12250-RULE" = {
                description  = "Allow TCP egress from pods to OKE control plane."
                stateless    = false
                protocol     = "TCP"
                dst          = "OKE-VCN-1-API-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 12250
                dst_port_max = 12250
              }
              },
              local.oke_vcn_1_to_services_subnet_cross_vcn_egress,
              local.oke_vcn_1_to_pods_subnet_cross_vcn_egress,
              local.oke_vcn_1_to_client_subnet_cross_vcn_egress,
              local.oke_vcn_1_to_web_subnet_cross_vcn_egress,
              local.oke_vcn_1_to_db_subnet_cross_vcn_egress
            )
            ingress_rules = merge({
              "INGRESS-FROM-WORKERS-RULE" = {
                description = "Allow worker nodes to access pods."
                stateless   = false
                protocol    = "ALL"
                src         = "OKE-VCN-1-WORKERS-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
              "INGRESS-FROM-API-RULE" = {
                description = "Allow Kubernetes API endpoint to communicate with pods."
                stateless   = false
                protocol    = "ALL"
                src         = "OKE-VCN-1-API-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
              "INGRESS-TO-PODS-RULE" = {
                description = "Allow pods to communicate with other pods."
                stateless   = false
                protocol    = "ALL"
                src         = "OKE-VCN-1-PODS-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
              },
              local.oke_vcn_1_to_pods_subnet_cross_vcn_ingress
            )
          }
        } : {}
      )

      vcn_specific_gateways = (local.chosen_hub_option != 3 && local.chosen_hub_option != 4) ? {
        internet_gateways = {
          // don't deploy when deploying Hub VCN
          "OKE-VCN-1-INTERNET-GATEWAY" = {
            enabled      = true
            display_name = "oke-vcn-internet-gateway"
          }
        }
        nat_gateways = {
          // don't deploy when deploying Hub VCN
          "OKE-VCN-1-NAT-GATEWAY" = {
            block_traffic = false
            display_name  = "oke-vcn-nat-gateway"
          }
        }
        service_gateways = {
          // don't deploy when deploying Hub VCN
          "OKE-VCN-1-SERVICE-GATEWAY" = {
            display_name = "oke-vcn-service-gateway"
            services     = "all-services"
          }
        }
      } : {}
    }
  } : {}

  ## OKE-VCN-1
  ## Egress rules
  oke_vcn_1_to_workers_subnet_cross_vcn_egress = merge(
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-2")))) ? {
      "EGRESS-TO-OKE-VCN-2-WORKERS-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.oke_vcn2_workers_subnet_name, "${var.service_label}-oke-vcn-2-workers-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.oke_vcn2_workers_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 1))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 30000
        dst_port_max = 32767
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-3")))) ? {
      "EGRESS-TO-OKE-VCN-3-WORKERS-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.oke_vcn3_workers_subnet_name, "${var.service_label}-oke-vcn-3-workers-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.oke_vcn3_workers_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 1))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 30000
        dst_port_max = 32767
      }
    } : {}
  )
  oke_vcn_1_to_services_subnet_cross_vcn_egress = merge(
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-2")))) ? {
      "EGRESS-TO-OKE-VCN-2-SERVICES-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.oke_vcn2_services_subnet_name, "${var.service_label}-oke-vcn-2-services-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.oke_vcn2_services_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 2))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-3")))) ? {
      "EGRESS-TO-OKE-VCN-3-SERVICES-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.oke_vcn3_services_subnet_name, "${var.service_label}-oke-vcn-3-services-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.oke_vcn3_services_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 2))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {}
  )
  oke_vcn_1_to_pods_subnet_cross_vcn_egress = merge(
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (upper(var.oke_vcn2_cni_type) == "NATIVE") &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-2")))) ? {
      "EGRESS-TO-OKE-VCN-2-PODS-SUBNET-RULE" = {
        description = "Egress to ${coalesce(var.oke_vcn2_pods_subnet_name, "${var.service_label}-oke-vcn-2-pods-subnet")}."
        stateless   = false
        protocol    = "TCP"
        dst         = coalesce(var.oke_vcn2_pods_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 3, 1))
        dst_type    = "CIDR_BLOCK"
        #dst_port_min = 443
        #dst_port_max = 443
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (upper(var.oke_vcn3_cni_type) == "NATIVE") &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-3")))) ? {
      "EGRESS-TO-OKE-VCN-3-PODS-SUBNET-RULE" = {
        description = "Egress to ${coalesce(var.oke_vcn3_pods_subnet_name, "${var.service_label}-oke-vcn-3-pods-subnet")}."
        stateless   = false
        protocol    = "TCP"
        dst         = coalesce(var.oke_vcn3_pods_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 3, 1))
        dst_type    = "CIDR_BLOCK"
        #dst_port_min = 443
        #dst_port_max = 443
      }
    } : {}
  )
  oke_vcn_1_to_client_subnet_cross_vcn_egress = merge(
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-1")))) ? {
      "EGRESS-TO-EXA-VCN-1-CLIENT-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.exa_vcn1_client_subnet_name, "${var.service_label}-exa-vcn-1-client-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-2")))) ? {
      "EGRESS-TO-EXA-VCN-2-CLIENT-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.exa_vcn2_client_subnet_name, "${var.service_label}-exa-vcn-2-client-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-3")))) ? {
      "EGRESS-TO-EXA-VCN-3-CLIENT-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.exa_vcn3_client_subnet_name, "${var.service_label}-exa-vcn-3-client-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      }
    } : {}
  )
  oke_vcn_1_to_web_subnet_cross_vcn_egress = merge(
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-1")))) ? {
      "EGRESS-TO-TT-VCN-1-WEB-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn1_web_subnet_name, "${var.service_label}-tt-vcn-1-web-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn1_web_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 0))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-2")))) ? {
      "EGRESS-TO-TT-VCN-2-WEB-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn2_web_subnet_name, "${var.service_label}-tt-vcn-2-web-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn2_web_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 0))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-3")))) ? {
      "EGRESS-TO-TT-VCN-3-WEB-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn3_web_subnet_name, "${var.service_label}-tt-vcn-3-web-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn3_web_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 0))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {}
  )
  oke_vcn_1_to_app_subnet_cross_vcn_egress = merge(
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-1")))) ? {
      "EGRESS-TO-TT-VCN-1-APP-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn1_app_subnet_name, "${var.service_label}-tt-vcn-1-app-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 1))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 80
        dst_port_max = 80
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-2")))) ? {
      "EGRESS-TO-TT-VCN-2-APP-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn2_app_subnet_name, "${var.service_label}-tt-vcn-2-app-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 1))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 80
        dst_port_max = 80
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-3")))) ? {
      "EGRESS-TO-TT-VCN-3-APP-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn3_app_subnet_name, "${var.service_label}-tt-vcn-3-app-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn3_app_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 1))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 80
        dst_port_max = 80
      }
    } : {}
  )
  oke_vcn_1_to_db_subnet_cross_vcn_egress = merge(
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-1")))) ? {
      "EGRESS-TO-TT-VCN-1-DB-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn1_db_subnet_name, "${var.service_label}-tt-vcn-1-db-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-2")))) ? {
      "EGRESS-TO-TT-VCN-2-DB-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn2_db_subnet_name, "${var.service_label}-tt-vcn-2-db-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-3")))) ? {
      "EGRESS-TO-TT-VCN-3-DB-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn3_db_subnet_name, "${var.service_label}-tt-vcn-3-db-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      }
    } : {}
  )

  ## Ingress rules
  oke_vcn_1_to_services_subnet_cross_vcn_ingress = merge(
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-2")))) ? {
      "INGRESS-FROM-OKE-VCN-2-WORKERS-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.oke_vcn2_workers_subnet_name, "${var.service_label}-oke-vcn-2-workers-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.oke_vcn2_workers_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      },
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-3")))) ? {
      "INGRESS-FROM-OKE-VCN-3-WORKERS-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.oke_vcn3_workers_subnet_name, "${var.service_label}-oke-vcn-3-workers-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.oke_vcn3_workers_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      },
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-1")))) ? {
      "INGRESS-FROM-TT-VCN-1-APP-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.tt_vcn1_app_subnet_name, "${var.service_label}-tt-vcn-1-app-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      },
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-2")))) ? {
      "INGRESS-FROM-TT-VCN-2-APP-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.tt_vcn2_app_subnet_name, "${var.service_label}-tt-vcn-2-app-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      },
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-3")))) ? {
      "INGRESS-FROM-TT-VCN-3-APP-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.tt_vcn3_app_subnet_name, "${var.service_label}-tt-vcn-3-app-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.tt_vcn3_app_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      },
    } : {},
    ## Ingress from on-premises CIDRs
    (local.add_oke_vcn1 == true && (var.oke_vcn1_attach_to_drg == true && var.oke_vcn1_onprem_route_enable)) &&
    (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? {
      for cidr in var.onprem_cidrs : "INGRESS-FROM-ONPREM--${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        description  = "Ingress from onprem ${cidr}"
        stateless    = false
        protocol     = "TCP"
        src          = cidr
        src_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {}
  )
  oke_vcn_1_to_workers_subnet_cross_vcn_ingress = merge(
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-2")))) ? {
      "INGRESS-FROM-OKE-VCN-2-WORKERS-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.oke_vcn2_workers_subnet_name, "${var.service_label}-oke-vcn-2-workers-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.oke_vcn2_workers_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 30000
        dst_port_max = 32767
      },
      "INGRESS-FROM-OKE-VCN-2-SERVICES-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.oke_vcn2_services_subnet_name, "${var.service_label}-oke-vcn-2-services-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.oke_vcn2_services_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 2))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 30000
        dst_port_max = 32767
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-3")))) ? {
      "INGRESS-FROM-OKE-VCN-3-WORKERS-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.oke_vcn3_workers_subnet_name, "${var.service_label}-oke-vcn-3-workers-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.oke_vcn3_workers_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 30000
        dst_port_max = 32767
      },
      "INGRESS-FROM-OKE-VCN-3-SERVICES-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.oke_vcn3_services_subnet_name, "${var.service_label}-oke-vcn-3-services-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.oke_vcn3_services_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 2))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 30000
        dst_port_max = 32767
      },
    } : {},
    ## Ingress from on-premises CIDRs
    (local.add_oke_vcn1 == true && (var.oke_vcn1_attach_to_drg == true && var.oke_vcn1_onprem_route_enable)) &&
    (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? {
      for cidr in var.onprem_cidrs : "INGRESS-FROM-ONPREM--${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        description  = "Ingress from onprem ${cidr}"
        stateless    = false
        protocol     = "TCP"
        src          = cidr
        src_type     = "CIDR_BLOCK"
        dst_port_min = 30000
        dst_port_max = 32767
      }
    } : {}
  )
  oke_vcn_1_to_pods_subnet_cross_vcn_ingress = merge(
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-2")))) ? {
      "INGRESS-FROM-OKE-VCN-2-WORKERS-SUBNET-RULE" = {
        description = "Ingress from ${coalesce(var.oke_vcn2_workers_subnet_name, "${var.service_label}-oke-vcn-2-workers-subnet")}."
        stateless   = false
        protocol    = "TCP"
        src         = coalesce(var.oke_vcn2_workers_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 1))
        src_type    = "CIDR_BLOCK"
      },
      "INGRESS-FROM-OKE-VCN-2-SERVICES-SUBNET-RULE" = {
        description = "Ingress from ${coalesce(var.oke_vcn2_services_subnet_name, "${var.service_label}-oke-vcn-2-services-subnet")}."
        stateless   = false
        protocol    = "TCP"
        src         = coalesce(var.oke_vcn2_services_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 2))
        src_type    = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (upper(var.oke_vcn2_cni_type) == "NATIVE") &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-2")))) ? {
      "INGRESS-FROM-OKE-VCN-2-PODS-SUBNET-RULE" = {
        description = "Ingress from ${coalesce(var.oke_vcn2_pods_subnet_name, "${var.service_label}-oke-vcn-2-pods-subnet")}."
        stateless   = false
        protocol    = "TCP"
        src         = coalesce(var.oke_vcn2_pods_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 3, 1))
        src_type    = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-3")))) ? {
      "INGRESS-FROM-OKE-VCN-3-WORKERS-SUBNET-RULE" = {
        description = "Ingress from ${coalesce(var.oke_vcn3_workers_subnet_name, "${var.service_label}-oke-vcn-3-workers-subnet")}."
        stateless   = false
        protocol    = "TCP"
        src         = coalesce(var.oke_vcn3_workers_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 1))
        src_type    = "CIDR_BLOCK"
      },
      "INGRESS-FROM-OKE-VCN-3-SERVICES-SUBNET-RULE" = {
        description = "Ingress from ${coalesce(var.oke_vcn3_services_subnet_name, "${var.service_label}-oke-vcn-3-services-subnet")}."
        stateless   = false
        protocol    = "TCP"
        src         = coalesce(var.oke_vcn3_services_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 2))
        src_type    = "CIDR_BLOCK"
      },
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (upper(var.oke_vcn3_cni_type) == "NATIVE") &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-3")))) ? {
      "INGRESS-FROM-OKE-VCN-3-PODS-SUBNET-RULE" = {
        description = "Ingress from ${coalesce(var.oke_vcn3_pods_subnet_name, "${var.service_label}-oke-vcn-3-pods-subnet")}."
        stateless   = false
        protocol    = "TCP"
        src         = coalesce(var.oke_vcn3_pods_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 3, 1))
        src_type    = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true ||
      (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-1")))) ? {
      "INGRESS-FROM-TT-VCN-1-APP-SUBNET-RULE" = {
        description = "Ingress from ${coalesce(var.tt_vcn1_app_subnet_name, "${var.service_label}-tt-vcn-1-app-subnet")}."
        stateless   = false
        protocol    = "TCP"
        src         = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 1))
        src_type    = "CIDR_BLOCK"
      },
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-1")))) ? {
      "INGRESS-FROM-TT-VCN-1-DB-SUBNET-RULE" = {
        description = "Ingress from ${coalesce(var.tt_vcn1_db_subnet_name, "${var.service_label}-tt-vcn-1-db-subnet")}."
        stateless   = false
        protocol    = "TCP"
        src         = coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))
        src_type    = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-2")))) ? {
      "INGRESS-FROM-TT-VCN-2-APP-SUBNET-RULE" = {
        description = "Ingress from ${coalesce(var.tt_vcn2_app_subnet_name, "${var.service_label}-tt-vcn-2-app-subnet")}."
        stateless   = false
        protocol    = "TCP"
        src         = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 1))
        src_type    = "CIDR_BLOCK"
      },
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-2")))) ? {
      "INGRESS-FROM-TT-VCN-2-DB-SUBNET-RULE" = {
        description = "Ingress from ${coalesce(var.tt_vcn2_db_subnet_name, "${var.service_label}-tt-vcn-2-db-subnet")}."
        stateless   = false
        protocol    = "TCP"
        src         = coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))
        src_type    = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-3")))) ? {
      "INGRESS-FROM-TT-VCN-3-APP-SUBNET-RULE" = {
        description = "Ingress from ${coalesce(var.tt_vcn3_app_subnet_name, "${var.service_label}-tt-vcn-3-app-subnet")}."
        stateless   = false
        protocol    = "TCP"
        src         = coalesce(var.tt_vcn3_app_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 1))
        src_type    = "CIDR_BLOCK"
      },
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-3")))) ? {
      "INGRESS-FROM-TT-VCN-3-DB-SUBNET-RULE" = {
        description = "Ingress from ${coalesce(var.tt_vcn3_db_subnet_name, "${var.service_label}-tt-vcn-3-db-subnet")}."
        stateless   = false
        protocol    = "TCP"
        src         = coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))
        src_type    = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-1")))) ? {
      "INGRESS-FROM-EXA-VCN-1-CLIENT-SUBNET-RULE" = {
        description = "Ingress from ${coalesce(var.exa_vcn1_client_subnet_name, "${var.service_label}-exa-vcn-1-client-subnet")}."
        stateless   = false
        protocol    = "TCP"
        src         = coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))
        src_type    = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-2")))) ? {
      "INGRESS-FROM-EXA-VCN-2-CLIENT-SUBNET-RULE" = {
        description = "Ingress from ${coalesce(var.exa_vcn2_client_subnet_name, "${var.service_label}-exa-vcn-2-client-subnet")}."
        stateless   = false
        protocol    = "TCP"
        src         = coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))
        src_type    = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-3")))) ? {
      "INGRESS-FROM-EXA-VCN-3-CLIENT-SUBNET-RULE" = {
        description = "Ingress from ${coalesce(var.exa_vcn3_client_subnet_name, "${var.service_label}-exa-vcn-3-client-subnet")}."
        stateless   = false
        protocol    = "TCP"
        src         = coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))
        src_type    = "CIDR_BLOCK"
      }
    } : {}
  )
  


  oke_vcn_1_drg_routing = merge(
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-2"))) ? {
      for cidr in var.oke_vcn2_cidrs : "OKE-VCN-2-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-3"))) ? {
      for cidr in var.oke_vcn3_cidrs : "OKE-VCN-3-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-1"))) ? {
      for cidr in var.tt_vcn1_cidrs : "TT-VCN-1-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-2"))) ? {
      for cidr in var.tt_vcn2_cidrs : "TT-VCN-2-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-3"))) ? {
      for cidr in var.tt_vcn3_cidrs : "TT-VCN-3-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) &&
    (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-1"))) ? {
      for cidr in var.exa_vcn1_cidrs : "EXA-VCN-1-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) &&
    (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-2"))) ? {
      for cidr in var.exa_vcn2_cidrs : "EXA-VCN-2-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) &&
    (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-3"))) ? {
      for cidr in var.exa_vcn3_cidrs : "EXA-VCN-3-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},
    ## Route to on-premises CIDRs
    (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && length(var.onprem_cidrs) > 0) &&
    (local.hub_with_drg_only == true) ? {
      for cidr in var.onprem_cidrs : "ONPREM-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "Traffic destined to on-premises ${cidr} CIDR range goes to DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {}
  )

}