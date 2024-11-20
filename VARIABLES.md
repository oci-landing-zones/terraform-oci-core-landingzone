## Table of Contents

- [General](#general)
- [Identity](#identity)
- [Security](#security)
- [Three Tier Networking](#three-tier-networking)
- [EXA Network](#exa-network)
- [OKE Networking](#oke-networking)
- [Hub and Spoke Networking](#hub-and-spoke-networking)
- [Monitoring](#monitoring)
- [Governance](#governance)

### General

| Variable Name | Description | Type | Default | Required |
|---------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|----|----------|
| service_label | A unique label that gets prepended to all resources deployed by the Landing Zone. Max length: 15 characters. | `any` | | yes |
| cis_level | Determines CIS OCI Benchmark Level to apply on Landing Zone managed resources. Level 1 is be practical and prudent. Level 2 is intended for environments where security is more critical than manageability and usability. Level 2 drives the creation of an OCI Vault, buckets encryption with a customer managed key, write logs for buckets and the usage of specific policies in Security Zones. | `string` | 1 | no |
| customize_iam | Whether Landing Zone IAM settings are to be customized. Customizable options are identity domains, groups, dynamic groups and policies. | `bool` | `false` | no |
| define_net | Whether networking is defined as part of this Landing Zone. By default, no networking resources are created. | `bool` | `false` | no |
| display_output | Whether to display a concise set of select resource outputs with their OCIDs and names. | `bool` | `true` | no |
| extend_landing_zone_to_new_region | Whether Landing Zone is being extended to another region. When set to true, compartments, groups, policies and resources at the home region are not provisioned. Use this when you want to provision a Landing Zone in a new region, but reuse existing Landing Zone resources in the home region. | `bool` | `false` | no |
| lz_provenant_prefix | The provenant landing zone prefix or code that identifies the client of this Landing Zone. This information goes into a freeform tag applied to all deployed resources. | `string` | `core` | no |
| lz_provenant_version | The provenant landing zone version. This information goes into a freeform tag applied to all deployed resources. | `string` | `null` | no |
| enable_zpr | Whether ZPR is enabled as part of this Landing Zone. By default, no ZPR resources are created. | `bool` | `false` | no |
| zpr_namespace_name | The name of ZPR security attribute namespace. | `string` | `<service_label>-zpr` | no |

### Identity

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| custom_id_domain_ocid | The existing identity domain OCID. | `string` | `null` | no |
| deploy_exainfra_cmp | Whether a separate compartment for Exadata Cloud Service Infrastructure is deployed. | `bool` | `false` | no |
| dyn_groups_options | IAM - Dynamic Groups | `string` | `Yes` | no |
| enclosing_compartment_parent_ocid | The existing compartment where Landing Zone enclosing compartment is created. | `string` | `null` | no |
| existing_ag_admin_group_name | The existing group to which Access Governance management policies will be granted to. | `list(string)` | `[]` | no |
| existing_announcement_reader_group_name | The existing group to which announcement reading policies will be granted to. | `list(string)` | `[]` | no |
| existing_appdev_admin_group_name | The existing group to which application management policies will be granted to. | `list(string)` | `[]` | no |
| existing_appdev_fun_dyn_group_name | Existing appdev dynamic group. | `string` | `"` | no |
| existing_auditor_group_name | The existing group to which auditing policies will be granted to. | `list(string)` | `[]` | no |
| existing_compute_agent_dyn_group_name | Existing compute agent dynamic group for management agent access. | `string` | `"` | no |
| existing_cost_admin_group_name | The existing group to which Cost management policies will be granted to. | `list(string)` | `[]` | no |
| existing_cred_admin_group_name | The existing group to which credentials management policies will be granted to. | `list(string)` | `[]` | no |
| existing_database_admin_group_name | The existing group to which database management policies will be granted to. | `list(string)` | `[]` | no |
| existing_database_kms_dyn_group_name | Existing database dynamic group for database to access keys. | `string` | `"` | no |
| existing_enclosing_compartment_ocid | The existing compartment where Landing Zone compartments (Network, Security, App, Database) are created. | `string` | `null` | no |
| existing_exainfra_admin_group_name | The existing group to which Exadata Cloud Service infrastructure management policies will be granted to. | `list(string)` | `[]` | no |
| existing_iam_admin_group_name | The existing group to which IAM management policies will be granted to. | `list(string)` | `[]` | no |
| existing_id_domain_appdev_fun_dyn_group_name | The existing dynamic group name in the existing identity domain for executing applications functions. | `string` | `"` | no |
| existing_id_domain_compute_agent_dyn_group_name | The existing dynamic group name in the existing identity domain for Compute agents. | `string` | `"` | no |
| existing_id_domain_database_kms_dyn_group_name | The existing dynamic group name in the existing identity domain for accessing database encryption keys. | `string` | `"` | no |
| existing_id_domain_net_fw_app_dyn_group_name | The existing dynamic group name in the existing identity domain for running network firewall appliances. | `string` | `"` | no |
| existing_id_domain_security_fun_dyn_group_name | The existing dynamic group name in the existing identity domain for executing security functions. | `string` | `"` | no |
| existing_net_fw_app_dyn_group_name | Existing network firewall appliance dynamic group for reading firewall instances. | `string` | `"` | no |
| existing_network_admin_group_name | The existing group to which network management policies will be granted to. | `list(string)` | `[]` | no |
| existing_security_admin_group_name | The existing group to which security management policies will be granted to. | `list(string)` | `[]` | no |
| existing_security_fun_dyn_group_name | Existing security dynamic group to run functions. | `string` | `"` | no |
| existing_storage_admin_group_name | The existing group to which Storage management policies will be granted to. | `list(string)` | `[]` | no |
| groups_options | Whether to deploy new groups or use existing groups. | `string` | `Yes` | no |
| policies_in_root_compartment | Whether policies in the Root compartment should be created or simply used. If 'CREATE', you must be sure the user executing this stack has permissions to create policies in the Root compartment. If 'USE', policies must have been created previously. | `string` | `CREATE` | no |
| rm_existing_ag_admin_group_name | Only applicable to RMS deployments. The existing group to which access governance policies will be granted to. | `string` | `"` | no |
| rm_existing_announcement_reader_group_name | Only applicable to RMS deployments. The existing group to which announcement reader policies will be granted to. | `string` | `"` | no |
| rm_existing_appdev_admin_group_name | Only applicable to RMS deployments. The existing group to which application management policies will be granted to. | `string` | `"` | no |
| rm_existing_auditor_group_name | Only applicable to RMS deployments. The existing group to which auditor policies will be granted to. | `string` | `"` | no |
| rm_existing_cost_admin_group_name | Only applicable to RMS deployments. The existing group to which cost management policies will be granted to. | `string` | `"` | no |
| rm_existing_cred_admin_group_name | Only applicable to RMS deployments. The existing group to which credentials management policies will be granted to. | `string` | `"` | no |
| rm_existing_database_admin_group_name | Only applicable to RMS deployments. The existing group to which database management policies will be granted to. | `string` | `"` | no |
| rm_existing_exainfra_admin_group_name | Only applicable to RMS deployments. The existing group to which Exadata Cloud Service infrastructure management policies will be granted to. | `string` | `"` | no |
| rm_existing_iam_admin_group_name | Only applicable to RMS deployments. The existing group to which IAM management policies will be granted to. | `string` | `"` | no |
| rm_existing_id_domain_ag_admin_group_name | The existing access governance admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm_existing_id_domain_announcement_reader_group_name | The existing announcement readers group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm_existing_id_domain_appdev_admin_group_name | The existing applications admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm_existing_id_domain_auditor_group_name | The existing auditor group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm_existing_id_domain_cost_admin_group_name | The existing cost admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm_existing_id_domain_cred_admin_group_name | The existing credentials admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm_existing_id_domain_database_admin_group_name | The existing database admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm_existing_id_domain_exainfra_admin_group_name | The existing Exadata CS infrastructure admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm_existing_id_domain_iam_admin_group_name | The existing IAM admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm_existing_id_domain_network_admin_group_name | The existing network admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm_existing_id_domain_security_admin_group_name | The existing security admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm_existing_id_domain_storage_admin_group_name | The existing storage admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm_existing_network_admin_group_name | Only applicable to RMS deployments. The existing group to which network management policies will be granted to. | `string` | `"` | no |
| rm_existing_security_admin_group_name | Only applicable to RMS deployments. The existing group to which security policies will be granted to. | `string` | `"` | no |
| rm_existing_storage_admin_group_name | Only applicable to RMS deployments. The existing group to which storage management policies will be granted to. | `string` | `"` | no |
| use_custom_id_domain | Whether to use an existing identity domain with groups and dynamic groups to grant landing zone IAM policies. If false, groups and dynamic groups from the Default identity domain are utilized. | `bool` | `false` | no |

### Security

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| cloud_guard_admin_email_endpoints | List of email addresses for Cloud Guard related notifications. | `list(string)` | `[]` | no |
| cloud_guard_reporting_region | Cloud Guard reporting region, where Cloud Guard reporting resources are kept. If not set, it defaults to home region. | `string` | `null` | no |
| cloud_guard_risk_level_threshold | Determines the minimum Risk level that triggers sending Cloud Guard problems to the defined Cloud Guard Email Endpoint. E.g. a setting of High will send notifications for Critical and High problems. | `string` | `High` | no |
| enable_cloud_guard | Determines whether the Cloud Guard service should be enabled. If true, Cloud Guard is enabled and the Root compartment is configured with a Cloud Guard target, as long as there is no pre-existing Cloud Guard target for the Root compartment (or target creation will fail). Keep in mind that once you set this to true, Cloud Guard target is managed by Landing Zone. If later on you switch this to false, the managed target is deleted and all (open, resolved and dismissed) problems associated with the deleted target are being moved to 'deleted' state. This operation happens in the background and would take some time to complete. Deleted problems can be viewed from the problems page using the 'deleted' status filter. For more details on Cloud Guard problems lifecycle, see https://docs.oracle.com/en-us/iaas/cloud-guard/using/problems-page.htm#problems-page__sect_prob_lifecycle. If Cloud Guard is already enabled and a target exists for the Root compartment, set this variable to false. | `bool` | `true` | no |
| enable_cloud_guard_cloned_recipes | Whether cloned recipes are attached to the managed Cloud Guard target. If false, Oracle managed recipes are attached. | `bool` | `true` | no |
| enable_security_zones | Determines if Security Zones are enabled in Landing Zone. When set to true, the Security Zone is enabled for the enclosing compartment. If no enclosing compartment is used, then the Security Zone is not enabled. | `bool` | `false` | no |
| security_zones_reporting_region | The reporting region of security zones. It defaults to tenancy home region if undefined. | `string` | `` | no |
| sz_security_policies | Additional Security Zones Policy OCIDs to add to security zone recipe (The default policies are added based on CIS level). To get a Security Zone policy OCID use the oci cli: oci cloud-guard security-policy-collection list-security-policies --compartment-id <tenancy-ocid>. | `list(string)` | `[]` | no |
| vss_agent_cis_benchmark_settings_scan_level | Valid values: STRICT, MEDIUM, LIGHTWEIGHT, NONE. STRICT: If more than 20% of the CIS benchmarks fail, then the target is assigned a risk level of Critical. MEDIUM: If more than 40% of the CIS benchmarks fail, then the target is assigned a risk level of High. LIGHTWEIGHT: If more than 80% of the CIS benchmarks fail, then the target is assigned a risk level of High. NONE: disables cis benchmark scanning. | `string` | `MEDIUM` | no |
| vss_agent_scan_level | Valid values: STANDARD, NONE. STANDARD enables agent-based scanning. NONE disables agent-based scanning and moots any agent related attributes. | `string` | `STANDARD` | no |
| vss_create | Whether Vulnerability Scanning Service recipes and targets are enabled in the Landing Zone. | `bool` | `false` | no |
| vss_enable_file_scan | Whether file scanning is enabled. | `bool` | `false` | no |
| vss_folders_to_scan | A list of folders to scan. Only applies if vss\_enable\_file\_scan is true. Currently, the Scanning service checks for vulnerabilities only in log4j and spring4shell. | `list(string)` | `[/]` | no |
| vss_port_scan_level | Valid values: STANDARD, LIGHT, NONE. STANDARD checks the 1000 most common port numbers, LIGHT checks the 100 most common port numbers, NONE does not check for open ports. | `string` | `STANDARD` | no |
| vss_scan_day | The week day for the Vulnerability Scanning Service recipe, if enabled. Only applies if vss\_scan\_schedule is WEEKLY (case insensitive). | `string` | `SUNDAY` | no |
| vss_scan_schedule | The scan schedule for the Vulnerability Scanning Service recipe, if enabled. Valid values are WEEKLY or DAILY (case insensitive). | `string` | `WEEKLY` | no |

### Three Tier Networking

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| add_tt_vcn1 | Whether to add a VCN configured for three-tier workload deployments, with up to four subnets: web (public by default), application (private), database (private). An optional subnet (private by default) for bastion deployment is also available. The added VCN is labelled 'TT-VCN-1'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| add_tt_vcn2 | Whether to add a second VCN configured for three-tier workload deployments, with up to four subnets: web (public by default), application (private), database (private). An optional subnet (private by default) for bastion deployment is also available. The added VCN is labelled 'TT-VCN-2'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| add_tt_vcn3 | Whether to add a third VCN configured for three-tier workload deployments, with up to four subnets: web (public by default), application (private), database (private). An optional subnet (private by default) for bastion deployment is also available. The added VCN is labelled 'TT-VCN-3'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| customize_tt_vcn1_subnets | If true, allows for the customization of default subnets settings. Only applicable to RMS deployments. | `bool` | `false` | no |
| customize_tt_vcn2_subnets | If true, allows for the customization of default subnets settings. Only applicable to RMS deployments. | `bool` | `false` | no |
| customize_tt_vcn3_subnets | If true, allows for the customization of default subnets settings. Only applicable to RMS deployments. | `bool` | `false` | no |
| deploy_tt_vcn1_bastion_subnet | Whether to deploy a subnet where you can further deploy OCI Bastion service or a jump host. | `bool` | `false` | no |
| deploy_tt_vcn2_bastion_subnet | Whether to deploy a subnet where you can further deploy OCI Bastion service or a jump host. | `bool` | `false` | no |
| deploy_tt_vcn3_bastion_subnet | Whether to deploy a subnet where you can further deploy OCI Bastion service or a jump host. | `bool` | `false` | no |
| tt_vcn1_app_subnet_cidr | The Application subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt_vcn1_app_subnet_dns | The Application subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt_vcn1_app_subnet_name | The Application subnet name. | `string` | `null` | no |
| tt_vcn1_attach_to_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| tt_vcn1_bastion_is_access_via_public_endpoint | If true, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed. | `bool` | `false` | no |
| tt_vcn1_bastion_subnet_allowed_cidrs | List of CIDR blocks allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access. | `list(string)` | `[]` | no |
| tt_vcn1_bastion_subnet_cidr | The Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt_vcn1_bastion_subnet_dns | The Bastion subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt_vcn1_bastion_subnet_name | The Bastion subnet name. | `string` | `null` | no |
| tt_vcn1_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[10.0.0.0/20]` | no |
| tt_vcn1_db_subnet_cidr | The Database subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt_vcn1_db_subnet_dns | The Database subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt_vcn1_db_subnet_name | The Database subnet name. | `string` | `null` | no |
| tt_vcn1_dns | The VCN DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt_vcn1_name | The VCN name. If unassigned, a default name is provided. VCN label: TT-VCN-1. | `string` | `null` | no |
| tt_vcn1_routable_vcns | The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3. | `list(string)` | `[]` | no |
| tt_vcn1_web_subnet_cidr | The Web subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt_vcn1_web_subnet_dns | The Web subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt_vcn1_web_subnet_is_private | Whether the Web subnet private. It is public by default. | `bool` | `false` | no |
| tt_vcn1_web_subnet_name | The Web subnet name. | `string` | `null` | no |
| tt_vcn2_app_subnet_cidr | The Application subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt_vcn2_app_subnet_dns | The Application subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt_vcn2_app_subnet_name | The Application subnet name. | `string` | `null` | no |
| tt_vcn2_attach_to_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| tt_vcn2_bastion_is_access_via_public_endpoint | If true, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed. | `bool` | `false` | no |
| tt_vcn2_bastion_subnet_allowed_cidrs | List of CIDRs blocks allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access. | `list(string)` | `[]` | no |
| tt_vcn2_bastion_subnet_cidr | The Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt_vcn2_bastion_subnet_dns | The Bastion subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt_vcn2_bastion_subnet_name | The Bastion subnet name. | `string` | `null` | no |
| tt_vcn2_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[10.1.0.0/20]` | no |
| tt_vcn2_db_subnet_cidr | The Database subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt_vcn2_db_subnet_dns | The Database subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt_vcn2_db_subnet_name | The Database subnet name. | `string` | `null` | no |
| tt_vcn2_dns | The VCN DNS Name. | `string` | `null` | no |
| tt_vcn2_name | The VCN name. If unassigned, a default name is provided. Label: TT-VCN-2. | `string` | `null` | no |
| tt_vcn2_routable_vcns | The VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3. | `list(string)` | `[]` | no |
| tt_vcn2_web_subnet_cidr | The Web subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt_vcn2_web_subnet_dns | The Web subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt_vcn2_web_subnet_is_private | Whether the Web subnet private. It is public by default. | `bool` | `false` | no |
| tt_vcn2_web_subnet_name | The Web subnet name. | `string` | `null` | no |
| tt_vcn3_app_subnet_cidr | The Application subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt_vcn3_app_subnet_dns | The Application subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt_vcn3_app_subnet_name | The Application subnet name. | `string` | `null` | no |
| tt_vcn3_attach_to_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| tt_vcn3_bastion_is_access_via_public_endpoint | If true, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed. | `bool` | `false` | no |
| tt_vcn3_bastion_subnet_allowed_cidrs | List of CIDRs allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access. 0.0.0.0/0 is not allowed. | `list(string)` | `[]` | no |
| tt_vcn3_bastion_subnet_cidr | The Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt_vcn3_bastion_subnet_dns | The Bastion subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt_vcn3_bastion_subnet_name | The Bastion subnet name. | `string` | `null` | no |
| tt_vcn3_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[10.2.0.0/20]` | no |
| tt_vcn3_db_subnet_cidr | The Database subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt_vcn3_db_subnet_dns | The Database subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt_vcn3_db_subnet_name | The Database subnet name. | `string` | `null` | no |
| tt_vcn3_dns | The VCN DNS Name. | `string` | `null` | no |
| tt_vcn3_name | The VCN name. If unassigned, a default name is provided. Label: TT-VCN-3. | `string` | `null` | no |
| tt_vcn3_routable_vcns | The VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3. | `list(string)` | `[]` | no |
| tt_vcn3_web_subnet_cidr | The Web subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt_vcn3_web_subnet_dns | The Web subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt_vcn3_web_subnet_is_private | Whether the Web subnet private. It is public by default. | `bool` | `false` | no |
| tt_vcn3_web_subnet_name | The Web subnet name. | `string` | `null` | no |

### EXA Network

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| add_exa_vcn1 | Whether to add a VCN configured for Exadata Cloud Service deployment, with two subnets: client (private) and backup (private). The added VCN is labelled 'EXA-VCN-1'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| add_exa_vcn2 | Whether to add a second VCN configured for Exadata Cloud Service deployment, with two subnets: client (private) and backup (private). The added VCN is labelled 'EXA-VCN-2'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| add_exa_vcn3 | Whether to add a third VCN configured for Exadata Cloud Service deployment, with two subnets: client (private) and backup (private). The added VCN is labelled 'EXA-VCN-3'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| exa_vcn1_attach_to_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| exa_vcn1_backup_subnet_cidr | The Backup subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| exa_vcn1_backup_subnet_dns | The Backup subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| exa_vcn1_backup_subnet_name | The Backup subnet name. | `string` | `null` | no |
| exa_vcn1_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[172.16.0.0/20] ` | no |
| exa_vcn1_client_subnet_cidr | The Client subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| exa_vcn1_client_subnet_dns | The Client subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| exa_vcn1_client_subnet_name | The Client subnet name. | `string` | `null` | no |
| exa_vcn1_dns | The VCN DNS name. | `string` | `null` | no |
| exa_vcn1_name | The VCN name. If unassigned, a default name is provided. VCN label: EXA-VCN-1. | `string` | `null` | no |
| exa_vcn1_routable_vcns | The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3. | `list(string)` | `[]` | no |
| exa_vcn2_attach_to_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| exa_vcn2_backup_subnet_cidr | The Backup subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| exa_vcn2_backup_subnet_dns | The Backup subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| exa_vcn2_backup_subnet_name | The Backup subnet name. | `string` | `null` | no |
| exa_vcn2_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[172.17.0.0/20]` | no |
| exa_vcn2_client_subnet_cidr | The Client subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| exa_vcn2_client_subnet_dns | The Client subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| exa_vcn2_client_subnet_name | The Client subnet name. | `string` | `null` | no |
| exa_vcn2_dns | The VCN DNS name. | `string` | `` | no |
| exa_vcn2_name | The VCN name. If unassigned, a default name is provided. VCN label: EXA-VCN-2 | `string` | `` | no |
| exa_vcn2_routable_vcns | The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3. | `list(string)` | `[]` | no |
| exa_vcn3_attach_to_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| exa_vcn3_backup_subnet_cidr | The Backup subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| exa_vcn3_backup_subnet_dns | The Backup subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| exa_vcn3_backup_subnet_name | The Backup subnet name. | `string` | `null` | no |
| exa_vcn3_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[172.18.0.0/20]` | no |
| exa_vcn3_client_subnet_cidr | The Client subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| exa_vcn3_client_subnet_dns | The Client subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| exa_vcn3_client_subnet_name | The Client subnet name. | `string` | `null` | no |
| exa_vcn3_dns | The VCN DNS name. | `string` | `` | no |
| exa_vcn3_name | The VCN name. If unassigned, a default name is provided. Label: EXA-VCN-3. | `string` | `` | no |
| exa_vcn3_routable_vcns | The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN2, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3. | `list(string)` | `[]` | no |

### OKE Networking

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| add_oke_vcn1 | Whether to add a VCN configured for OKE workload deployments, with at least three subnets: service (public by default), workers (private) and API endpoint (private). Additionally, a private subnet for pods deployment is created if the OKE CNI Type is 'Native'. You can also enable an extra private subnet for managing the OKE cluster. The added VCN is labelled 'OKE-VCN-1'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| add_oke_vcn1_mgmt_subnet | Whether to add a private subnet for cluster management. | `bool` | `false` | no |
| add_oke_vcn2 | Whether to add a second VCN configured for OKE workload deployments, with at least three subnets: service (public by default), workers (private) and API endpoint (private). Additionally, a private subnet for pods deployment is created if the OKE CNI Type is 'Native'. You can also enable an extra private subnet for managing the OKE cluster. The added VCN is labelled 'OKE-VCN-2'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| add_oke_vcn2_mgmt_subnet | Whether to add a private subnet for cluster management. | `bool` | `false` | no |
| add_oke_vcn3 | Whether to add a third VCN configured for OKE workload deployments, with at least three subnets: service (public by default), workers (private) and API endpoint (private). Additionally, a private subnet for pods deployment is created if the OKE CNI Type is 'Native'. You can also enable an extra private subnet for managing the OKE cluster. The added VCN is labelled 'OKE-VCN-3'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| add_oke_vcn3_mgmt_subnet | Whether to add a private subnet for cluster management. | `bool` | `false` | no |
| oke_vcn1_api_subnet_cidr | The API subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke_vcn1_api_subnet_dns | The API subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn1_api_subnet_name | The API subnet name. | `string` | `null` | no |
| oke_vcn1_attach_to_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| oke_vcn1_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[10.3.0.0/16]` | no |
| oke_vcn1_cni_type | The CNI type for the OKE cluster. Valid values: 'Flannel' (default), 'Native'. If 'Native', a private subnet for pods deployment is created. | `string` | `Flannel` | no |
| oke_vcn1_dns | The VCN DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn1_mgmt_subnet_cidr | The Management subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke_vcn1_mgmt_subnet_dns | The Management subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn1_mgmt_subnet_name | The Management subnet name. | `string` | `null` | no |
| oke_vcn1_name | The VCN name. If unassigned a default name is provided. | `string` | `null` | no |
| oke_vcn1_pods_subnet_cidr | The Pods subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke_vcn1_pods_subnet_dns | The Pods subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn1_pods_subnet_name | The Pods subnet name. A private subnet for pods deployment is automatically added if oke\_vcn1\_cni\_type value is 'Native'. | `string` | `null` | no |
| oke_vcn1_routable_vcns | The VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-2, OKE-VCN-3. | `list(string)` | `[]` | no |
| oke_vcn1_services_subnet_cidr | The Services subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke_vcn1_services_subnet_dns | The Services subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn1_services_subnet_name | The Services subnet name. | `string` | `null` | no |
| oke_vcn1_workers_subnet_cidr | The Workers subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke_vcn1_workers_subnet_dns | The Workers subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn1_workers_subnet_name | The Workers subnet name. | `string` | `null` | no |
| oke_vcn2_api_subnet_cidr | The API subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke_vcn2_api_subnet_dns | The API subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn2_api_subnet_name | The API subnet name. | `string` | `null` | no |
| oke_vcn2_attach_to_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| oke_vcn2_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[10.4.0.0/16]` | no |
| oke_vcn2_cni_type | The CNI type for the OKE cluster. Valid values: 'Flannel' (default), 'Native'. If 'Native', a private subnet for pods deployment is created. | `string` | `Flannel` | no |
| oke_vcn2_dns | The VCN DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn2_mgmt_subnet_cidr | The Management subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke_vcn2_mgmt_subnet_dns | The Management subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn2_mgmt_subnet_name | The Management subnet name. | `string` | `null` | no |
| oke_vcn2_name | The VCN name. If unassigned, a default name is provided. | `string` | `null` | no |
| oke_vcn2_pods_subnet_cidr | The Pods subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke_vcn2_pods_subnet_dns | nan | `string` | `null` | no |
| oke_vcn2_pods_subnet_name | The pods subnet name. A private subnet for pods deployment is automatically added if oke\_vcn2\_cni\_type value is 'Native'. | `string` | `null` | no |
| oke_vcn2_routable_vcns | The VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-3. | `list(string)` | `[]` | no |
| oke_vcn2_services_subnet_cidr | The Services subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke_vcn2_services_subnet_dns | The Services subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn2_services_subnet_name | The Services subnet name. | `string` | `null` | no |
| oke_vcn2_workers_subnet_cidr | The Workers subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke_vcn2_workers_subnet_dns | The Workers subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn2_workers_subnet_name | The Workers subnet name. | `string` | `null` | no |
| oke_vcn3_api_subnet_cidr | The API subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke_vcn3_api_subnet_dns | The API subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn3_api_subnet_name | The API subnet name. | `string` | `null` | no |
| oke_vcn3_attach_to_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| oke_vcn3_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[10.5.0.0/16]` | no |
| oke_vcn3_cni_type | The CNI type for the OKE cluster. Valid values: 'Flannel' (default), 'Native'. If 'Native', a private subnet for pods deployment is created. | `string` | `Flannel` | no |
| oke_vcn3_dns | The VCN DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn3_mgmt_subnet_cidr | The Management subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke_vcn3_mgmt_subnet_dns | The Management subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn3_mgmt_subnet_name | The Management subnet name. | `string` | `null` | no |
| oke_vcn3_name | The VCN name. If unassigned, a default name is provided. | `string` | `null` | no |
| oke_vcn3_pods_subnet_cidr | The Pods subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke_vcn3_pods_subnet_dns | The Pods subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn3_pods_subnet_name | The Pods subnet name. A private subnet for pods deployment is automatically added if oke\_vcn3\_cni\_type value is 'Native'. | `string` | `null` | no |
| oke_vcn3_routable_vcns | The VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2. | `list(string)` | `[]` | no |
| oke_vcn3_services_subnet_cidr | The Services subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke_vcn3_services_subnet_dns | The Services subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn3_services_subnet_name | The Services subnet name. | `string` | `null` | no |
| oke_vcn3_workers_subnet_cidr | The Workers subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke_vcn3_workers_subnet_dns | The Workers subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke_vcn3_workers_subnet_name | The Workers subnet name. | `string` | `null` | no |

### Hub and Spoke Networking

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| customize_hub_vcn_subnets | Whether to customize default subnets settings of the Hub VCN. Only applicable to RMS deployments. | `bool` | `false` | no |
| existing_drg_ocid | The OCID of an existing DRG that you want to reuse for hub deployment. Only applicable if hub\_deployment\_option is 'VCN or on-premises connectivity routing via DRG (existing DRG)' or 'VCN or on-premises connectivity routed through DMZ VCN with Network Virtual Appliance existing DRG (DMZ VCN will be created and DRG ID required)'. | `string` | `null` | no |
| net_appliance_boot_volume_size | The boot volume size (in GB) for the network appliances. | `number` | `60` | no |
| net_appliance_flex_shape_cpu | The number of OCPUs for the selected flex shape. Applicable to flexible shapes only. | `number` | `2` | no |
| net_appliance_flex_shape_memory | The amount of memory (in GB) for the selected flex shape. Applicable to flexible shapes only. | `number` | `56` | no |
| net_appliance_image_ocid | The custom image ocid of the user-provided virtual network appliance. | `string` | `null` | no
| net_appliance_name_prefix | Common prefix to network appliance name. To this common prefix, numbers 1 and 2 are appended to the corresponding instance. | `string` | `net-appliance-instance` | no |
| net_appliance_public_rsa_key | The SSH public key to login to Network Appliance Compute instance. | `string` | `null` | no |
| net_appliance_shape | The instance shape for the network appliance nodes. | `string` | `VM.Optimized3.Flex` | no |
| hub_deployment_option | The available options for hub deployment. Valid values: 'No cross-VCN or on-premises connectivity', 'VCN or on-premises connectivity routing via DRG (DRG will be created)', 'VCN or on-premises connectivity routing via DRG (existing DRG)', 'VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)', 'VCN or on-premises connectivity routed through DMZ VCN with Network Virtual Appliance existing DRG (DMZ VCN will be created and DRG ID required)'. All the VCNs that attach to the DRG join the topology as spokes. | `string` | `No cross-VCN or on-premises connectivity` | no |
| hub_deployment | The available options for hub deployment as an integer. 'No cross-VCN or on-premises connectivity' = 0, 'VCN or on-premises connectivity routing via DRG (DRG will be created)' = 1, 'VCN or on-premises connectivity routing via DRG (existing DRG)' = 2, 'VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)' = 3, 'VCN or on-premises connectivity routed through DMZ VCN with Network Virtual Appliance existing DRG (DMZ VCN will be created and DRG ID required)' = 4| `number` | `0`| no || hub_vcn_cidrs | List of CIDR blocks for the Hub VCN. | `list(string)` | `[192.168.0.0/26]` | no |
| hub_vcn_cidrs | List of CIDR blocks for the Hub VCN. | `list(string)` | `[192.168.0.0/26]` | no |
| hub_vcn_deploy_net_appliance_option | The network appliance option for deploying in the Hub VCN. Valid values: 'Don't deploy any network appliance at this time' (default), 'Palo Alto Networks VM-Series Firewall', 'Fortinet FortiGate Firewall'. Costs are incurred. | `string` | `Don't deploy any network appliance at this time` | no |
| hub_vcn_dns | The Hub VCN DNS name. | `string` | `null` | no |
| hub_vcn_east_west_entry_point_ocid | The OCID of a private address the Hub VCN routes traffic to for inbound internal cross-vcn traffic (East/West). This variable is to be assigned with the OCID of the indoor network load balancer's private IP address. | `string` | `null` | no |
| hub_vcn_indoor_subnet_cidr | The Hub VCN Indoor subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| hub_vcn_indoor_subnet_dns | The Hub VCN Indoor subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| hub_vcn_indoor_subnet_name | The Hub VCN Indoor subnet name. | `string` | `null` | no |
| hub_vcn_mgmt_subnet_cidr | The Hub VCN Management subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| hub_vcn_mgmt_subnet_dns | The Hub VCN Management subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| hub_vcn_mgmt_subnet_external_allowed_cidrs_for_http | List of CIDR blocks allowed to connect to Management subnet over HTTP. Leave empty for no access. | `list(string)` | `[]` | no |
| hub_vcn_mgmt_subnet_external_allowed_cidrs_for_ssh | List of CIDR blocks allowed to connect to Management subnet over SSH. Leave empty for no access. | `list(string)` | `[]` | no |
| hub_vcn_mgmt_subnet_name | The Hub VCN Management subnet Name. | `string` | `null` | no |
| hub_vcn_name | The Hub VCN name. | `string` | `null` | no |
| hub_vcn_north_south_entry_point_ocid | The OCID of a private address the Hub VCN routes traffic to for inbound external traffic (North/South). This variable is to be assigned with the OCID of the outdoor network load balancer's private IP address. | `string` | `null` | no |
| hub_vcn_outdoor_subnet_cidr | The Hub VCN Outdoor subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| hub_vcn_outdoor_subnet_dns | The Hub VCN Outdoor subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| hub_vcn_outdoor_subnet_name | The Hub VCN Outdoor subnet name. | `string` | `null` | no |
| hub_vcn_web_subnet_cidr | The Hub VCN Web subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| hub_vcn_web_subnet_dns | The Hub VCN Web subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| hub_vcn_web_subnet_is_private | Whether the Web subnet private. It is public by default. | `bool` | `false` | no |
| hub_vcn_web_subnet_jump_host_allowed_cidrs | List of CIDRs allowed to SSH into the Web subnet via a jump host eventually deployed in the Web subnet. Leave empty for no access. | `list(string)` | `[]` | no |
| hub_vcn_web_subnet_name | The Hub VCN Web subnet name. | `string` | `null` | no |
| onprem_cidrs | List of on-premises CIDR blocks allowed to connect to the Landing Zone network via a DRG. | `list(string)` | `[]` | no

### Monitoring

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| activate_service_connector | Whether Service Connector should be activated. If true, costs my incur due to usage of Object Storage bucket, Streaming or Function. | `bool` | `false` | no |
| alarm_message_format | Format of the message sent by Alarms | `string` | `PRETTY_JSON` | no |
| budget_admin_email_endpoints | List of email addresses for all budget related notifications such as budget and finance. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |
| compute_admin_email_endpoints | List of email addresses for all compute related notifications. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |
| create_alarms_as_enabled | Whether a alarms should be created in an enabled state by default. If unchecked, alarms will be created but not emit alerts. | `bool` | `false` | no |
| create_events_as_enabled | Whether events should be created in an enabled state by default. If unchecked, events will be created but not emit notifications. | `bool` | `false` | no |
| database_admin_email_endpoints | List of email addresses for all database related notifications. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |
| enable_service_connector | Whether Service Connector should be enabled. If true, a single Service Connector is managed for all services log sources and the designated target specified in 'Service Connector Target Kind'. The Service Connector resource is created in INACTIVE state. To activate, check 'Activate Service Connector?' (costs may incur). | `bool` | `false` | no |
| exainfra_admin_email_endpoints | List of email addresses for all Exadata infrastructure related notifications. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |
| existing_service_connector_bucket_key_id | An existing key used to encrypt Service Connector target Object Storage bucket. | `string` | `null` | no |
| existing_service_connector_bucket_vault_compartment_id | An existing compartment for the vault with the key used to encrypt Service Connector target Object Storage bucket. | `string` | `null` | no |
| existing_service_connector_bucket_vault_id | An existing vault for the key used to encrypt Service Connector target Object Storage bucket. | `string` | `null` | no |
| existing_service_connector_target_function_id | An existing function to be used as the Service Connector target. Only applicable if 'service\_connector\_target\_kind' is set to 'functions'. | `string` | `null` | no |
| existing_service_connector_target_stream_id | An existing stream to be used as the Service Connector target. Only applicable if 'service\_connector\_target\_kind' is set to 'streaming'. | `string` | `null` | no |
| network_admin_email_endpoints | List of email addresses for all network related notifications. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |
| notifications_advanced_options | nan | `bool` | `false` | no |
| onboard_logging_analytics | Whether Logging Analytics will be enabled in the tenancy. If true, the Logging Analytics service will be enabled in the tenancy and a new Logging Analytics Namespace will be created. If false, the existing Logging Analytics namespace will be used. Only applicable if 'service\_connector\_target\_kind' is set to 'logginganalytics'. | `bool` | `false` | no |
| security_admin_email_endpoints | List of email addresses for all security related notifications. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |
| service_connector_target_kind | Service Connector Hub target resource. Valid values are 'objectstorage', 'streaming', 'functions' or 'logginganalytics'. In case of 'objectstorage', a new bucket is created. In case of 'streaming', you can provide an existing stream ocid in 'existing\_service\_connector\_target\_stream\_id' and that stream is used. If no ocid is provided, a new stream is created. In case of 'functions', you must provide the existing function ocid in 'existing\_service\_connector\_target\_function\_id'. If case of 'logginganalytics', a log group for Logging Analytics service is created and the service is enabled if not already. | `string` | `objectstorage` | no |
| storage_admin_email_endpoints | List of email addresses for all storage related notifications. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |

### Governance

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| budget_alert_email_endpoints | List of email addresses for budget alerts. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |
| budget_alert_threshold | The threshold for triggering the alert expressed as a percentage of the monthly forecast spend. 100% is the default. | `number` | `100` | no |
| budget_amount | The amount of the budget expressed as a whole number in the currency of the customer's rate card. | `number` | `1000` | no |
| create_budget | If true, a budget is created for the enclosing compartment, based on forecast or actual spending. | `bool` | `false` | no |
