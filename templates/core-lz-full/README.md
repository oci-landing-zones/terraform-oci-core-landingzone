# Core Landing Zone Full

This template shows how to deploy an [OCI Core Landing Zone](../../) configuration with a full option showcase. It enables the main IAM, governance, security, observability, and networking options in one verbose template, with a practical default path enabled and alternate paths left commented in *main.tf.template*.

Please see [templates](../../templates/) for other CIS compliant Core Landing Zone templates.

## Configuration Variables

This template has the following variables pre-configured:

| Variable | Description | Value |
|---------|-------|-------|
| *service_label* | Resource name prefix used by Core Landing Zone. | *"full"* |
| *cis_level* | CIS profile level. Level 2 enables stricter controls such as Vault-backed encryption. | *"2"* |
| *is_free_tenancy* | Whether the target tenancy is free tier. | *false* |
| *extend_landing_zone_to_new_region* | Whether the deployment extends an existing landing zone into another region. | *false* |
| *display_output* | Whether concise resource outputs are displayed after apply. | *true* |
| *lz_provenant_prefix* | Provenance tag prefix. | *"core"* |
| *lz_provenant_version* | Provenance tag version. | *"1.6.0"* |
| *lz_provenant_label* | Provenance tag label. | *"Core Landing Zone Full Template"* |
| *enclosing_compartment_options* | Whether Core Landing Zone deploys a new enclosing compartment. | *"Yes, deploy new"* |
| *enclosing_compartment_parent_ocid* | Parent OCID for the enclosing compartment. Null uses the Root compartment. | *null* |
| *deploy_app_cmp* | Whether the application compartment is deployed. | *true* |
| *deploy_database_cmp* | Whether the database compartment is deployed. | *true* |
| *deploy_exainfra_cmp* | Whether the Exadata infrastructure compartment is deployed. | *true* |
| *custom_enclosing_compartment_name* | Enclosing compartment name. | *"corelz-full-enclosing-cmp"* |
| *custom_network_compartment_name* | Network compartment name. | *"corelz-full-network-cmp"* |
| *custom_security_compartment_name* | Security compartment name. | *"corelz-full-security-cmp"* |
| *custom_app_compartment_name* | Application compartment name. | *"corelz-full-application-cmp"* |
| *custom_database_compartment_name* | Database compartment name. | *"corelz-full-database-cmp"* |
| *custom_exainfra_compartment_name* | Exadata infrastructure compartment name. | *"corelz-full-exadata-infra-cmp"* |
| *identity_domain_option* | Identity domain deployment option. | *"New Identity Domain"* |
| *new_identity_domain_name* | Name of the identity domain to create. | *"corelz-identity-domain"* |
| *new_identity_domain_license_type* | License type for the new identity domain. | *"free"* |
| *policies_in_root_compartment* | Whether root policies are created or reused. | *"CREATE"* |
| *create_budget* | Whether a budget is deployed. | *true* |
| *budget_amount* | Budget amount. | *15000* |
| *budget_alert_threshold* | Budget alert threshold percentage. | *80* |
| *budget_alert_email_endpoints* | Budget alert email recipients. | *["finops@example.com"]* |
| *enable_cloud_guard_cloned_recipes* | Whether Cloud Guard cloned recipes are enabled. | *true* |
| *cloud_guard_reporting_region* | Cloud Guard reporting region. Null uses the default behavior. | *null* |
| *cloud_guard_risk_level_threshold* | Cloud Guard risk level threshold. | *"High"* |
| *cloud_guard_admin_email_endpoints* | Cloud Guard admin email recipients. | *["soc@example.com"]* |
| *enable_security_zones* | Whether Security Zones are enabled. | *true* |
| *vss_create* | Whether Vulnerability Scanning Service resources are created. | *true* |
| *vss_scan_schedule* | Vulnerability scan schedule. | *"DAILY"* |
| *vss_scan_day* | Vulnerability scan day. | *"SUNDAY"* |
| *vss_port_scan_level* | Port scan level. | *"STANDARD"* |
| *vss_agent_scan_level* | Agent scan level. | *"STANDARD"* |
| *vss_agent_cis_benchmark_settings_scan_level* | CIS benchmark scan level. | *"MEDIUM"* |
| *vss_enable_file_scan* | Whether file scanning is enabled. | *true* |
| *vss_folders_to_scan* | Folders included in file scanning. | *["/"]* |
| *enable_vault* | Whether Vault is enabled. | *true* |
| *vault_type* | Vault type. | *"VIRTUAL_PRIVATE"* |
| *network_admin_email_endpoints* | Network admin notification recipients. | *["network.admin@example.com"]* |
| *security_admin_email_endpoints* | Security admin notification recipients. | *["security.admin@example.com"]* |
| *storage_admin_email_endpoints* | Storage admin notification recipients. | *["storage.admin@example.com"]* |
| *compute_admin_email_endpoints* | Compute admin notification recipients. | *["compute.admin@example.com"]* |
| *budget_admin_email_endpoints* | Budget admin notification recipients. | *["budget.admin@example.com"]* |
| *database_admin_email_endpoints* | Database admin notification recipients. | *["database.admin@example.com"]* |
| *exainfra_admin_email_endpoints* | Exadata infrastructure admin notification recipients. | *["exadata.admin@example.com"]* |
| *notifications_advanced_options* | Whether advanced notification options are enabled. | *true* |
| *create_alarms_as_enabled* | Whether alarms are created enabled. | *true* |
| *create_events_as_enabled* | Whether events are created enabled. | *true* |
| *alarm_message_format* | Alarm message format. | *"PRETTY_JSON"* |
| *enable_service_connector* | Whether Service Connector Hub is enabled. | *true* |
| *activate_service_connector* | Whether the Service Connector is activated. | *true* |
| *service_connector_target_kind* | Service Connector target kind. | *"logginganalytics"* |
| *onboard_logging_analytics* | Whether Logging Analytics is onboarded. | *true* |
| *define_net* | Whether networking resources are deployed. | *true* |
| *hub_deployment_option* | Hub network deployment topology. | *"VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)"* |
| *enable_cross_vcn_open_nsg* | Whether open cross-VCN NSGs are enabled. | *true* |
| *enable_cross_vcn_constrained_nsgs* | Whether constrained cross-VCN NSGs are enabled. | *false* |
| *hub_vcn_name* | Hub VCN name. | *"corelz-full-hub"* |
| *hub_vcn_cidrs* | Hub VCN CIDR blocks. | *["10.80.0.0/23"]* |
| *hub_vcn_enable_internet_gateway* | Whether the Hub VCN internet gateway is enabled. | *true* |
| *customize_hub_vcn_subnets* | UI control for customizing Hub VCN subnets settings. | *true* |
| *hub_vcn_web_subnet_name* | Hub web subnet name. | *"hub-web"* |
| *hub_vcn_web_subnet_cidr* | Hub web subnet CIDR block. | *"10.80.0.0/25"* |
| *hub_vcn_web_subnet_is_private* | Whether the Hub web subnet is private. | *false* |
| *hub_vcn_mgmt_subnet_name* | Hub management subnet name. | *"hub-mgmt"* |
| *hub_vcn_mgmt_subnet_cidr* | Hub management subnet CIDR block. | *"10.80.0.128/26"* |
| *hub_vcn_indoor_subnet_name* | Hub indoor subnet name. | *"hub-indoor"* |
| *hub_vcn_indoor_subnet_cidr* | Hub indoor subnet CIDR block. | *"10.80.1.0/25"* |
| *hub_vcn_outdoor_subnet_name* | Hub outdoor subnet name. | *"hub-outdoor"* |
| *hub_vcn_outdoor_subnet_cidr* | Hub outdoor subnet CIDR block. | *"10.80.0.192/26"* |
| *hub_vcn_deploy_net_appliance_option* | Network appliance deployment option. | *"OCI Native Firewall"* |
| *enable_native_firewall_threat_log* | Whether OCI Network Firewall threat logs are enabled. | *true* |
| *enable_native_firewall_traffic_log* | Whether OCI Network Firewall traffic logs are enabled. | *true* |
| *oci_nfw_ip_ocid* | OCI Network Firewall private IP OCID. Null is used for the first apply. | *null* |
| *oci_nfw_policy_ocid* | OCI Network Firewall policy OCID. Null creates a default policy. | *null* |
| *onprem_cidrs* | On-premises CIDR blocks used for routing and security rules. | *["10.10.0.0/16"]* |
| *add_hub_vcn_jumphost_subnet* | Whether the Hub VCN jump host subnet is deployed. | *true* |
| *hub_vcn_jumphost_subnet_name* | Hub jump host subnet name. | *"hub-jumphost"* |
| *hub_vcn_jumphost_subnet_cidr* | Hub jump host subnet CIDR block. | *"10.80.1.128/26"* |
| *deploy_bastion_service* | Whether OCI Bastion service is deployed. | *true* |
| *bastion_service_name* | Bastion service name. | *"core-full-bastion"* |
| *bastion_service_allowed_cidrs* | CIDR blocks allowed into Bastion service. | *["198.51.100.0/24"]* |
| *deploy_bastion_jump_host* | Whether a Bastion jump host instance is deployed. | *true* |
| *bastion_jump_host_instance_name* | Bastion jump host instance name. | *"corelz-full-jump-host"* |
| *bastion_jump_host_ssh_public_key_path* | SSH public key path for the jump host. | *"~/.ssh/id_rsa.pub"* |
| *bastion_jump_host_instance_shape* | Jump host compute shape. | *"VM.Standard.E4.Flex"* |
| *bastion_jump_host_boot_volume_size* | Jump host boot volume size in GB. | *60* |
| *bastion_jump_host_flex_shape_memory* | Jump host flex memory in GB. | *16* |
| *bastion_jump_host_flex_shape_cpu* | Jump host flex OCPU count. | *2* |
| *bastion_jump_host_image_source* | Jump host image source. | *"Marketplace Image"* |
| *bastion_jump_host_marketplace_image_name* | Jump host marketplace image name. | *"Oracle Linux 8 STIG"* |
| *bastion_jump_host_marketplace_image_version* | Jump host marketplace image version. | *"Oracle-Linux-8.10-2025.06.24-STIG"* |
| *bastion_jump_host_marketplace_image_ocid* | Jump host marketplace image OCID. Null uses image name and version. | *null* |
| *add_tt_vcn1* | Whether three-tier VCN 1 is deployed. | *true* |
| *tt_vcn1_name* | Three-tier VCN 1 name. | *"corelz-tt-dev-vcn"* |
| *tt_vcn1_cidrs* | Three-tier VCN 1 CIDR blocks. | *["10.81.0.0/20"]* |
| *tt_vcn1_attach_to_drg* | Whether three-tier VCN 1 attaches to the DRG. | *true* |
| *tt_vcn1_routable_vcns* | VCNs routable from three-tier VCN 1. | *["TT-VCN-2", "OKE-VCN-1", "EXA-VCN-1"]* |
| *tt_vcn1_onprem_route_enable* | Whether three-tier VCN 1 routes to on-premises CIDRs. | *true* |
| *tt_vcn1_web_subnet_name* | Three-tier VCN 1 web subnet name. | *"web-subnet"* |
| *tt_vcn1_web_subnet_cidr* | Three-tier VCN 1 web subnet CIDR block. | *"10.81.0.0/24"* |
| *tt_vcn1_web_subnet_is_private* | Whether three-tier VCN 1 web subnet is private. | *false* |
| *tt_vcn1_external_allowed_cidrs_into_web_tier* | External CIDRs allowed into three-tier VCN 1 web tier. | *["198.51.100.0/24"]* |
| *tt_vcn1_web_ingress_destination_ports* | Destination ports allowed into three-tier VCN 1 web tier. | *["TCP:443"]* |
| *tt_vcn1_app_subnet_name* | Three-tier VCN 1 application subnet name. | *"app-subnet"* |
| *tt_vcn1_app_subnet_cidr* | Three-tier VCN 1 application subnet CIDR block. | *"10.81.1.0/24"* |
| *tt_vcn1_app_ingress_destination_ports* | Destination ports allowed into three-tier VCN 1 application tier. | *["TCP:80", "TCP:443"]* |
| *tt_vcn1_db_subnet_name* | Three-tier VCN 1 database subnet name. | *"db-subnet"* |
| *tt_vcn1_db_subnet_cidr* | Three-tier VCN 1 database subnet CIDR block. | *"10.81.2.0/24"* |
| *tt_vcn1_db_ingress_destination_ports* | Destination ports allowed into three-tier VCN 1 database tier. | *["TCP:1521", "TCP:1522"]* |
| *deploy_tt_vcn1_bastion_subnet* | Whether three-tier VCN 1 bastion subnet is deployed. | *true* |
| *tt_vcn1_bastion_subnet_name* | Three-tier VCN 1 bastion subnet name. | *"bastion-subnet"* |
| *tt_vcn1_bastion_subnet_cidr* | Three-tier VCN 1 bastion subnet CIDR block. | *"10.81.3.0/28"* |
| *tt_vcn1_bastion_is_access_via_public_endpoint* | Whether three-tier VCN 1 bastion uses a public endpoint. | *false* |
| *tt_vcn1_bastion_subnet_allowed_cidrs* | CIDR blocks allowed into three-tier VCN 1 bastion subnet. | *[]* |
| *add_tt_vcn2* | Whether three-tier VCN 2 is deployed. | *true* |
| *tt_vcn2_name* | Three-tier VCN 2 name. | *"corelz-tt-test-vcn"* |
| *tt_vcn2_cidrs* | Three-tier VCN 2 CIDR blocks. | *["10.82.0.0/20"]* |
| *tt_vcn2_attach_to_drg* | Whether three-tier VCN 2 attaches to the DRG. | *true* |
| *tt_vcn2_routable_vcns* | VCNs routable from three-tier VCN 2. | *["TT-VCN-1", "OKE-VCN-1", "OKE-VCN-2", "EXA-VCN-1"]* |
| *tt_vcn2_onprem_route_enable* | Whether three-tier VCN 2 routes to on-premises CIDRs. | *true* |
| *tt_vcn2_web_subnet_name* | Three-tier VCN 2 web subnet name. | *"web-subnet"* |
| *tt_vcn2_web_subnet_cidr* | Three-tier VCN 2 web subnet CIDR block. | *"10.82.0.0/24"* |
| *tt_vcn2_web_subnet_is_private* | Whether three-tier VCN 2 web subnet is private. | *true* |
| *tt_vcn2_external_allowed_cidrs_into_web_tier* | External CIDRs allowed into three-tier VCN 2 web tier. | *["10.10.0.0/16"]* |
| *tt_vcn2_web_ingress_destination_ports* | Destination ports allowed into three-tier VCN 2 web tier. | *["TCP:443"]* |
| *tt_vcn2_app_subnet_name* | Three-tier VCN 2 application subnet name. | *"app-subnet"* |
| *tt_vcn2_app_subnet_cidr* | Three-tier VCN 2 application subnet CIDR block. | *"10.82.1.0/24"* |
| *tt_vcn2_app_ingress_destination_ports* | Destination ports allowed into three-tier VCN 2 application tier. | *["TCP:80", "TCP:443"]* |
| *tt_vcn2_db_subnet_name* | Three-tier VCN 2 database subnet name. | *"db-subnet"* |
| *tt_vcn2_db_subnet_cidr* | Three-tier VCN 2 database subnet CIDR block. | *"10.82.2.0/24"* |
| *tt_vcn2_db_ingress_destination_ports* | Destination ports allowed into three-tier VCN 2 database tier. | *["TCP:1521", "TCP:1522"]* |
| *deploy_tt_vcn2_bastion_subnet* | Whether three-tier VCN 2 bastion subnet is deployed. | *false* |
| *add_tt_vcn3* | Whether three-tier VCN 3 is deployed. | *true* |
| *tt_vcn3_name* | Three-tier VCN 3 name. | *"corelz-tt-prod-vcn"* |
| *tt_vcn3_cidrs* | Three-tier VCN 3 CIDR blocks. | *["10.83.0.0/20"]* |
| *tt_vcn3_attach_to_drg* | Whether three-tier VCN 3 attaches to the DRG. | *true* |
| *tt_vcn3_routable_vcns* | VCNs routable from three-tier VCN 3. | *["TT-VCN-1", "TT-VCN-2", "EXA-VCN-2", "OKE-VCN-3"]* |
| *tt_vcn3_onprem_route_enable* | Whether three-tier VCN 3 routes to on-premises CIDRs. | *false* |
| *tt_vcn3_web_subnet_name* | Three-tier VCN 3 web subnet name. | *"web-subnet"* |
| *tt_vcn3_web_subnet_cidr* | Three-tier VCN 3 web subnet CIDR block. | *"10.83.0.0/24"* |
| *tt_vcn3_web_subnet_is_private* | Whether three-tier VCN 3 web subnet is private. | *true* |
| *tt_vcn3_external_allowed_cidrs_into_web_tier* | External CIDRs allowed into three-tier VCN 3 web tier. | *["10.10.0.0/16"]* |
| *tt_vcn3_web_ingress_destination_ports* | Destination ports allowed into three-tier VCN 3 web tier. | *["TCP:443"]* |
| *tt_vcn3_app_subnet_name* | Three-tier VCN 3 application subnet name. | *"app-subnet"* |
| *tt_vcn3_app_subnet_cidr* | Three-tier VCN 3 application subnet CIDR block. | *"10.83.1.0/24"* |
| *tt_vcn3_app_ingress_destination_ports* | Destination ports allowed into three-tier VCN 3 application tier. | *["TCP:80", "TCP:443"]* |
| *tt_vcn3_db_subnet_name* | Three-tier VCN 3 database subnet name. | *"db-subnet"* |
| *tt_vcn3_db_subnet_cidr* | Three-tier VCN 3 database subnet CIDR block. | *"10.83.2.0/24"* |
| *tt_vcn3_db_ingress_destination_ports* | Destination ports allowed into three-tier VCN 3 database tier. | *["TCP:1521", "TCP:1522"]* |
| *deploy_tt_vcn3_bastion_subnet* | Whether three-tier VCN 3 bastion subnet is deployed. | *false* |
| *add_oke_vcn1* | Whether OKE VCN 1 is deployed. | *true* |
| *oke_vcn1_name* | OKE VCN 1 name. | *"corelz-oke-dev-vcn"* |
| *oke_vcn1_cidrs* | OKE VCN 1 CIDR blocks. | *["10.84.0.0/16"]* |
| *oke_vcn1_cni_type* | OKE VCN 1 CNI type. | *"Native"* |
| *oke_vcn1_attach_to_drg* | Whether OKE VCN 1 attaches to the DRG. | *true* |
| *oke_vcn1_routable_vcns* | VCNs routable from OKE VCN 1. | *["TT-VCN-1", "TT-VCN-2", "EXA-VCN-1"]* |
| *oke_vcn1_onprem_route_enable* | Whether OKE VCN 1 routes to on-premises CIDRs. | *true* |
| *oke_vcn1_api_subnet_name* | OKE VCN 1 API subnet name. | *"api-subnet"* |
| *oke_vcn1_api_subnet_cidr* | OKE VCN 1 API subnet CIDR block. | *"10.84.0.0/28"* |
| *oke_vcn1_workers_subnet_name* | OKE VCN 1 workers subnet name. | *"workers-subnet"* |
| *oke_vcn1_workers_subnet_cidr* | OKE VCN 1 workers subnet CIDR block. | *"10.84.1.0/24"* |
| *oke_vcn1_services_subnet_name* | OKE VCN 1 services subnet name. | *"services-subnet"* |
| *oke_vcn1_services_subnet_cidr* | OKE VCN 1 services subnet CIDR block. | *"10.84.2.0/24"* |
| *oke_vcn1_services_subnet_is_private* | Whether OKE VCN 1 services subnet is private. | *false* |
| *oke_vcn1_external_allowed_cidrs_into_services_tier* | External CIDRs allowed into OKE VCN 1 services tier. | *["198.51.100.0/24"]* |
| *oke_vcn1_services_ingress_destination_ports* | Destination ports allowed into OKE VCN 1 services tier. | *["TCP:443"]* |
| *add_oke_vcn1_db_subnet* | Whether OKE VCN 1 database subnet is deployed. | *true* |
| *oke_vcn1_db_subnet_name* | OKE VCN 1 database subnet name. | *"db-subnet"* |
| *oke_vcn1_db_subnet_cidr* | OKE VCN 1 database subnet CIDR block. | *"10.84.3.0/24"* |
| *oke_vcn1_db_ingress_destination_ports* | Destination ports allowed into OKE VCN 1 database tier. | *["TCP:1521"]* |
| *add_oke_vcn1_mgmt_subnet* | Whether OKE VCN 1 management subnet is deployed. | *true* |
| *oke_vcn1_mgmt_subnet_name* | OKE VCN 1 management subnet name. | *"mgmt-subnet"* |
| *oke_vcn1_mgmt_subnet_cidr* | OKE VCN 1 management subnet CIDR block. | *"10.84.4.0/24"* |
| *oke_vcn1_pods_subnet_name* | OKE VCN 1 pods subnet name. | *"pods-subnet"* |
| *oke_vcn1_pods_subnet_cidr* | OKE VCN 1 pods subnet CIDR block. | *"10.84.128.0/17"* |
| *add_oke_vcn2* | Whether OKE VCN 2 is deployed. | *true* |
| *oke_vcn2_name* | OKE VCN 2 name. | *"corelz-oke-test-vcn"* |
| *oke_vcn2_cidrs* | OKE VCN 2 CIDR blocks. | *["10.85.0.0/16"]* |
| *oke_vcn2_cni_type* | OKE VCN 2 CNI type. | *"Flannel"* |
| *oke_vcn2_attach_to_drg* | Whether OKE VCN 2 attaches to the DRG. | *true* |
| *oke_vcn2_routable_vcns* | VCNs routable from OKE VCN 2. | *["TT-VCN-2", "OKE-VCN-1", "EXA-VCN-1"]* |
| *oke_vcn2_onprem_route_enable* | Whether OKE VCN 2 routes to on-premises CIDRs. | *false* |
| *oke_vcn2_api_subnet_name* | OKE VCN 2 API subnet name. | *"api-subnet"* |
| *oke_vcn2_api_subnet_cidr* | OKE VCN 2 API subnet CIDR block. | *"10.85.0.0/28"* |
| *oke_vcn2_workers_subnet_name* | OKE VCN 2 workers subnet name. | *"workers-subnet"* |
| *oke_vcn2_workers_subnet_cidr* | OKE VCN 2 workers subnet CIDR block. | *"10.85.1.0/24"* |
| *oke_vcn2_services_subnet_name* | OKE VCN 2 services subnet name. | *"services-subnet"* |
| *oke_vcn2_services_subnet_cidr* | OKE VCN 2 services subnet CIDR block. | *"10.85.2.0/24"* |
| *oke_vcn2_services_subnet_is_private* | Whether OKE VCN 2 services subnet is private. | *true* |
| *oke_vcn2_external_allowed_cidrs_into_services_tier* | External CIDRs allowed into OKE VCN 2 services tier. | *["10.10.0.0/16"]* |
| *oke_vcn2_services_ingress_destination_ports* | Destination ports allowed into OKE VCN 2 services tier. | *["TCP:443"]* |
| *add_oke_vcn2_db_subnet* | Whether OKE VCN 2 database subnet is deployed. | *true* |
| *oke_vcn2_db_subnet_name* | OKE VCN 2 database subnet name. | *"db-subnet"* |
| *oke_vcn2_db_subnet_cidr* | OKE VCN 2 database subnet CIDR block. | *"10.85.3.0/24"* |
| *oke_vcn2_db_ingress_destination_ports* | Destination ports allowed into OKE VCN 2 database tier. | *["TCP:1521"]* |
| *add_oke_vcn2_mgmt_subnet* | Whether OKE VCN 2 management subnet is deployed. | *true* |
| *oke_vcn2_mgmt_subnet_name* | OKE VCN 2 management subnet name. | *"mgmt-subnet"* |
| *oke_vcn2_mgmt_subnet_cidr* | OKE VCN 2 management subnet CIDR block. | *"10.85.4.0/24"* |
| *add_oke_vcn3* | Whether OKE VCN 3 is deployed. | *true* |
| *oke_vcn3_name* | OKE VCN 3 name. | *"corelz-oke-prod-vcn"* |
| *oke_vcn3_cidrs* | OKE VCN 3 CIDR blocks. | *["10.86.0.0/16"]* |
| *oke_vcn3_cni_type* | OKE VCN 3 CNI type. | *"Native"* |
| *oke_vcn3_attach_to_drg* | Whether OKE VCN 3 attaches to the DRG. | *true* |
| *oke_vcn3_routable_vcns* | VCNs routable from OKE VCN 3. | *["TT-VCN-3", "OKE-VCN-1", "EXA-VCN-2"]* |
| *oke_vcn3_onprem_route_enable* | Whether OKE VCN 3 routes to on-premises CIDRs. | *false* |
| *oke_vcn3_api_subnet_name* | OKE VCN 3 API subnet name. | *"api-subnet"* |
| *oke_vcn3_api_subnet_cidr* | OKE VCN 3 API subnet CIDR block. | *"10.86.0.0/28"* |
| *oke_vcn3_workers_subnet_name* | OKE VCN 3 workers subnet name. | *"workers-subnet"* |
| *oke_vcn3_workers_subnet_cidr* | OKE VCN 3 workers subnet CIDR block. | *"10.86.1.0/24"* |
| *oke_vcn3_services_subnet_name* | OKE VCN 3 services subnet name. | *"services-subnet"* |
| *oke_vcn3_services_subnet_cidr* | OKE VCN 3 services subnet CIDR block. | *"10.86.2.0/24"* |
| *oke_vcn3_services_subnet_is_private* | Whether OKE VCN 3 services subnet is private. | *true* |
| *oke_vcn3_external_allowed_cidrs_into_services_tier* | External CIDRs allowed into OKE VCN 3 services tier. | *["10.10.0.0/16"]* |
| *oke_vcn3_services_ingress_destination_ports* | Destination ports allowed into OKE VCN 3 services tier. | *["TCP:443"]* |
| *add_oke_vcn3_db_subnet* | Whether OKE VCN 3 database subnet is deployed. | *true* |
| *oke_vcn3_db_subnet_name* | OKE VCN 3 database subnet name. | *"db-subnet"* |
| *oke_vcn3_db_subnet_cidr* | OKE VCN 3 database subnet CIDR block. | *"10.86.3.0/24"* |
| *oke_vcn3_db_ingress_destination_ports* | Destination ports allowed into OKE VCN 3 database tier. | *["TCP:1521"]* |
| *add_oke_vcn3_mgmt_subnet* | Whether OKE VCN 3 management subnet is deployed. | *true* |
| *oke_vcn3_mgmt_subnet_name* | OKE VCN 3 management subnet name. | *"mgmt-subnet"* |
| *oke_vcn3_mgmt_subnet_cidr* | OKE VCN 3 management subnet CIDR block. | *"10.86.4.0/24"* |
| *oke_vcn3_pods_subnet_name* | OKE VCN 3 pods subnet name. | *"pods-subnet"* |
| *oke_vcn3_pods_subnet_cidr* | OKE VCN 3 pods subnet CIDR block. | *"10.86.128.0/17"* |
| *add_exa_vcn1* | Whether Exadata VCN 1 is deployed. | *true* |
| *exa_vcn1_name* | Exadata VCN 1 name. | *"corelz-exa-dev-vcn"* |
| *exa_vcn1_cidrs* | Exadata VCN 1 CIDR blocks. | *["172.40.0.0/20"]* |
| *exa_vcn1_attach_to_drg* | Whether Exadata VCN 1 attaches to the DRG. | *true* |
| *exa_vcn1_routable_vcns* | VCNs routable from Exadata VCN 1. | *["TT-VCN-1", "TT-VCN-2", "OKE-VCN-1"]* |
| *exa_vcn1_onprem_route_enable* | Whether Exadata VCN 1 routes to on-premises CIDRs. | *true* |
| *exa_vcn1_client_subnet_name* | Exadata VCN 1 client subnet name. | *"client-subnet"* |
| *exa_vcn1_client_subnet_cidr* | Exadata VCN 1 client subnet CIDR block. | *"172.40.0.0/24"* |
| *exa_vcn1_external_allowed_cidrs_into_client_tier* | External CIDRs allowed into Exadata VCN 1 client tier. | *["10.10.0.0/16"]* |
| *exa_vcn1_client_ingress_destination_ports* | Destination ports allowed into Exadata VCN 1 client tier. | *["TCP:1521", "TCP:1522"]* |
| *add_exa_vcn1_backup_subnet* | Whether Exadata VCN 1 backup subnet is deployed. | *true* |
| *exa_vcn1_backup_subnet_name* | Exadata VCN 1 backup subnet name. | *"backup-subnet"* |
| *exa_vcn1_backup_subnet_cidr* | Exadata VCN 1 backup subnet CIDR block. | *"172.40.1.0/24"* |
| *add_exa_vcn1_integration_subnet* | Whether Exadata VCN 1 integration subnet is deployed. | *true* |
| *exa_vcn1_integration_subnet_name* | Exadata VCN 1 integration subnet name. | *"integration-subnet"* |
| *exa_vcn1_integration_subnet_cidr* | Exadata VCN 1 integration subnet CIDR block. | *"172.40.2.0/24"* |
| *exa_vcn1_external_allowed_cidrs_into_integration_tier* | External CIDRs allowed into Exadata VCN 1 integration tier. | *["10.10.0.0/16"]* |
| *exa_vcn1_integration_ingress_destination_ports* | Destination ports allowed into Exadata VCN 1 integration tier. | *["TCP:443", "TCP:7809"]* |
| *add_exa_vcn2* | Whether Exadata VCN 2 is deployed. | *true* |
| *exa_vcn2_name* | Exadata VCN 2 name. | *"corelz-exa-test-vcn"* |
| *exa_vcn2_cidrs* | Exadata VCN 2 CIDR blocks. | *["172.41.0.0/20"]* |
| *exa_vcn2_attach_to_drg* | Whether Exadata VCN 2 attaches to the DRG. | *true* |
| *exa_vcn2_routable_vcns* | VCNs routable from Exadata VCN 2. | *["TT-VCN-3", "OKE-VCN-3", "EXA-VCN-1"]* |
| *exa_vcn2_onprem_route_enable* | Whether Exadata VCN 2 routes to on-premises CIDRs. | *false* |
| *exa_vcn2_client_subnet_name* | Exadata VCN 2 client subnet name. | *"client-subnet"* |
| *exa_vcn2_client_subnet_cidr* | Exadata VCN 2 client subnet CIDR block. | *"172.41.0.0/24"* |
| *exa_vcn2_external_allowed_cidrs_into_client_tier* | External CIDRs allowed into Exadata VCN 2 client tier. | *["10.10.0.0/16"]* |
| *exa_vcn2_client_ingress_destination_ports* | Destination ports allowed into Exadata VCN 2 client tier. | *["TCP:1521", "TCP:1522"]* |
| *add_exa_vcn2_backup_subnet* | Whether Exadata VCN 2 backup subnet is deployed. | *true* |
| *exa_vcn2_backup_subnet_name* | Exadata VCN 2 backup subnet name. | *"backup-subnet"* |
| *exa_vcn2_backup_subnet_cidr* | Exadata VCN 2 backup subnet CIDR block. | *"172.41.1.0/24"* |
| *add_exa_vcn2_integration_subnet* | Whether Exadata VCN 2 integration subnet is deployed. | *true* |
| *exa_vcn2_integration_subnet_name* | Exadata VCN 2 integration subnet name. | *"integration-subnet"* |
| *exa_vcn2_integration_subnet_cidr* | Exadata VCN 2 integration subnet CIDR block. | *"172.41.2.0/24"* |
| *exa_vcn2_external_allowed_cidrs_into_integration_tier* | External CIDRs allowed into Exadata VCN 2 integration tier. | *["10.10.0.0/16"]* |
| *exa_vcn2_integration_ingress_destination_ports* | Destination ports allowed into Exadata VCN 2 integration tier. | *["TCP:443", "TCP:7809"]* |
| *add_exa_vcn3* | Whether Exadata VCN 3 is deployed. | *true* |
| *exa_vcn3_name* | Exadata VCN 3 name. | *"corelz-exa-prod-vcn"* |
| *exa_vcn3_cidrs* | Exadata VCN 3 CIDR blocks. | *["172.42.0.0/20"]* |
| *exa_vcn3_attach_to_drg* | Whether Exadata VCN 3 attaches to the DRG. | *true* |
| *exa_vcn3_routable_vcns* | VCNs routable from Exadata VCN 3. | *["TT-VCN-1", "TT-VCN-2", "OKE-VCN-2"]* |
| *exa_vcn3_onprem_route_enable* | Whether Exadata VCN 3 routes to on-premises CIDRs. | *false* |
| *exa_vcn3_client_subnet_name* | Exadata VCN 3 client subnet name. | *"client-subnet"* |
| *exa_vcn3_client_subnet_cidr* | Exadata VCN 3 client subnet CIDR block. | *"172.42.0.0/24"* |
| *exa_vcn3_external_allowed_cidrs_into_client_tier* | External CIDRs allowed into Exadata VCN 3 client tier. | *["10.10.0.0/16"]* |
| *exa_vcn3_client_ingress_destination_ports* | Destination ports allowed into Exadata VCN 3 client tier. | *["TCP:1521", "TCP:1522"]* |
| *add_exa_vcn3_backup_subnet* | Whether Exadata VCN 3 backup subnet is deployed. | *true* |
| *exa_vcn3_backup_subnet_name* | Exadata VCN 3 backup subnet name. | *"backup-subnet"* |
| *exa_vcn3_backup_subnet_cidr* | Exadata VCN 3 backup subnet CIDR block. | *"172.42.1.0/24"* |
| *add_exa_vcn3_integration_subnet* | Whether Exadata VCN 3 integration subnet is deployed. | *true* |
| *exa_vcn3_integration_subnet_name* | Exadata VCN 3 integration subnet name. | *"integration-subnet"* |
| *exa_vcn3_integration_subnet_cidr* | Exadata VCN 3 integration subnet CIDR block. | *"172.42.2.0/24"* |
| *exa_vcn3_external_allowed_cidrs_into_integration_tier* | External CIDRs allowed into Exadata VCN 3 integration tier. | *["10.10.0.0/16"]* |
| *exa_vcn3_integration_ingress_destination_ports* | Destination ports allowed into Exadata VCN 3 integration tier. | *["TCP:443", "TCP:7809"]* |
| *enable_zpr* | Whether Zero Trust Packet Routing is enabled. | *false* |
| *zpr_namespace_name* | ZPR namespace name. | *"corelz-zpr"* |

For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with outer UI controls and required notification endpoints pre-assigned for deployment. Detailed subnet, port, route, image, shape, and defaulted network settings are documented in the configuration table above and in *main.tf.template*.

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/release-1.6.0.zip&zipUrlVariables={"customize_iam":true,"service_label":"full","cis_level":"2","enclosing_compartment_options":"Yes,%20deploy%20new","deploy_app_cmp":true,"deploy_database_cmp":true,"deploy_exainfra_cmp":true,"custom_enclosing_compartment_name":"corelz-full-enclosing-cmp","custom_network_compartment_name":"corelz-full-network-cmp","custom_security_compartment_name":"corelz-full-security-cmp","custom_app_compartment_name":"corelz-full-application-cmp","custom_database_compartment_name":"corelz-full-database-cmp","custom_exainfra_compartment_name":"corelz-full-exadata-infra-cmp","identity_domain_option":"New%20Identity%20Domain","new_identity_domain_name":"corelz-identity-domain","new_identity_domain_license_type":"free","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20through%20DMZ%20VCN%20with%20Network%20Virtual%20Appliance%20(DRG%20and%20DMZ%20VCN%20will%20be%20created)","customize_hub_vcn_subnets":true,"add_hub_vcn_jumphost_subnet":true,"deploy_bastion_jump_host":true,"deploy_bastion_service":true,"hub_vcn_deploy_net_appliance_option":"OCI%20Native%20Firewall","enable_native_firewall_threat_log":true,"enable_native_firewall_traffic_log":true,"add_tt_vcn1":true,"deploy_tt_vcn1_bastion_subnet":true,"add_tt_vcn2":true,"deploy_tt_vcn2_bastion_subnet":false,"add_tt_vcn3":true,"deploy_tt_vcn3_bastion_subnet":false,"add_oke_vcn1":true,"oke_vcn1_cni_type":"Native","add_oke_vcn1_db_subnet":true,"add_oke_vcn1_mgmt_subnet":true,"add_oke_vcn2":true,"oke_vcn2_cni_type":"Flannel","add_oke_vcn2_db_subnet":true,"add_oke_vcn2_mgmt_subnet":true,"add_oke_vcn3":true,"oke_vcn3_cni_type":"Native","add_oke_vcn3_db_subnet":true,"add_oke_vcn3_mgmt_subnet":true,"add_exa_vcn1":true,"add_exa_vcn1_backup_subnet":true,"add_exa_vcn1_integration_subnet":true,"add_exa_vcn2":true,"add_exa_vcn2_backup_subnet":true,"add_exa_vcn2_integration_subnet":true,"add_exa_vcn3":true,"add_exa_vcn3_backup_subnet":true,"add_exa_vcn3_integration_subnet":true,"network_admin_email_endpoints":["network.admin@example.com"],"security_admin_email_endpoints":["security.admin@example.com"],"display_security_logging_governance_settings":true,"tt_vcn1_attach_to_drg":true,"tt_vcn2_attach_to_drg":true,"tt_vcn3_attach_to_drg":true,"oke_vcn1_attach_to_drg":true,"oke_vcn2_attach_to_drg":true,"oke_vcn3_attach_to_drg":true,"exa_vcn1_attach_to_drg":true,"exa_vcn2_attach_to_drg":true,"exa_vcn3_attach_to_drg":true,"enable_security_zones":true,"enable_service_connector":true,"vss_create":true,"create_budget":true})

You are required to review/adjust the following variable settings:
 - Make sure to pick an OCI region for deployment.
 - Provide real email addresses for all admin email endpoint fields.
 - Replace placeholder provider values, OCIDs, CIDRs, regions, and key paths as needed.
 - Review cost-impacting options such as OCI Network Firewall, Vault, Service Connector, Vulnerability Scanning, and Bastion.
 - For OCI Network Firewall deployments, run Apply once, update *oci_nfw_ip_ocid* with the firewall private IP OCID output, and run Apply again to complete DRG routing.

With the stack created, perform a Plan, followed by an Apply using RMS UI.

## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*.
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply
