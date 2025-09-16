## Table of Contents

- [General](#general)
- [Identity](#identity)
- [Security](#security)
- [Three Tier Networking](#three-tier-networking)
- [EXA Networking](#exa-networking)
- [OKE Networking](#oke-networking)
- [Hub and Spoke Networking](#hub-and-spoke-networking)
- [On-Premises Networking](#on-prem-networking)
- [Monitoring](#monitoring)
- [Governance](#governance)

### <a name="general"></a> General

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| cis\_level | Determines CIS OCI Benchmark Level to apply on Landing Zone managed resources. Level 1 is be practical and prudent. Level 2 is intended for environments where security is more critical than manageability and usability. Level 2 drives the creation of an OCI Vault, buckets encryption with a customer managed key, write logs for buckets and the usage of specific policies in Security Zones. | `string` | 1 | no |
| customize\_iam | Whether Landing Zone IAM settings are to be customized. Customizable options are identity domains, groups, dynamic groups and policies. | `bool` | `false` | no |
| define\_net | Whether networking is defined as part of this Landing Zone. By default, no networking resources are created. | `bool` | `false` | no |
| display\_output | Whether to display a concise set of select resource outputs with their OCIDs and names. | `bool` | `true` | no |
| enable\_zpr | Whether ZPR is enabled as part of this Landing Zone. By default, no ZPR resources are created. | `bool` | `false` | no |
| extend\_landing\_zone\_to\_new\_region | Whether Landing Zone is being extended to another region. When set to true, compartments, groups, policies and resources at the home region are not provisioned. Use this when you want to provision a Landing Zone in a new region, but reuse existing Landing Zone resources in the home region. | `bool` | `false` | no |
| lz\_provenant\_prefix | The provenant landing zone prefix or code that identifies the client of this Landing Zone. This information goes into a freeform tag applied to all deployed resources. | `string` | `core` | no |
| lz\_provenant\_version | The provenant landing zone version. This information goes into a freeform tag applied to all deployed resources. | `string` | `null` | no |
| lz\_provenant\_label | Human-readable label used in resource descriptions. | `string` | `Core Landing Zone` | no |
| service\_label | A unique label that gets prepended to all resources deployed by the Landing Zone. Max length: 15 characters. | `any` | | yes |
| zpr\_namespace\_name | The name of ZPR security attribute namespace. | `string` | `<service_label>-zpr` | no |

### <a name="identity"></a> Identity

| Variable Name                                               | Description | Type | Default | Required |
|-------------------------------------------------------------|-------------|------|---------|----------|
| custom\_app\_compartment\_name                              | Custom name of the app compartment. | `string` | `null` | no |
| custom\_database\_compartment\_name                         | Custom name of the database compartment. | `string` | `null` | no |
| custom\_enclosing\_compartment\_name                        | Custom name of the enclosing compartment. | `string` | `null` | no |
| custom\_exainfra\_compartment\_name                         | Custom name of the exadata infrastructure compartment. | `string` | `null` | no |
| custom\_id\_domain\_ocid                                    | The existing identity domain OCID. | `string` | `null` | no |
| custom\_network\_compartment\_name                          | Custom name of the network compartment. | `string` | `null` | no |
| custom\_security\_compartment\_name                         | Custom name of the security compartment. | `string` | `null` | no |
| deploy\_app\_cmp                                            | Whether the application compartment is deployed. | `bool` | `true` | no |
| deploy\_database\_cmp                                       | Whether the database compartment is deployed. | `bool` | `true` | no |
| deploy\_exainfra\_cmp                                       | Whether a separate compartment for Exadata Cloud Service Infrastructure is deployed. | `bool` | `false` | no |
| dyn\_groups\_options                                        | IAM - Dynamic Groups | `string` | `Yes` | no |
| enclosing\_compartment\_parent\_ocid                        | The existing compartment where Landing Zone enclosing compartment is created. | `string` | `null` | no |
| existing\_ag\_admin\_group\_name                            | The existing group to which Access Governance management policies will be granted to. | `list(string)` | `[]` | no |
| existing\_announcement\_reader\_group\_name                 | The existing group to which announcement reading policies will be granted to. | `list(string)` | `[]` | no |
| existing\_appdev\_admin\_group\_name                        | The existing group to which application management policies will be granted to. | `list(string)` | `[]` | no |
| existing\_appdev\_fun\_dyn\_group\_name                     | Existing appdev dynamic group. | `string` | `"` | no |
| existing\_auditor\_group\_name                              | The existing group to which auditing policies will be granted to. | `list(string)` | `[]` | no |
| existing\_compute\_agent\_dyn\_group\_name                  | Existing compute agent dynamic group for management agent access. | `string` | `"` | no |
| existing\_cost\_admin\_group\_name                          | The existing group to which Cost management policies will be granted to. | `list(string)` | `[]` | no |
| existing\_cred\_admin\_group\_name                          | The existing group to which credentials management policies will be granted to. | `list(string)` | `[]` | no |
| existing\_database\_admin\_group\_name                      | The existing group to which database management policies will be granted to. | `list(string)` | `[]` | no |
| existing\_database\_kms\_dyn\_group\_name                   | Existing database dynamic group for database to access keys. | `string` | `"` | no |
| existing\_enclosing\_compartment\_ocid                      | The existing compartment where Landing Zone compartments (Network, Security, App, Database) are created. | `string` | `null` | no |
| existing\_exainfra\_admin\_group\_name                      | The existing group to which Exadata Cloud Service infrastructure management policies will be granted to. | `list(string)` | `[]` | no |
| existing\_iam\_admin\_group\_name                           | The existing group to which IAM management policies will be granted to. | `list(string)` | `[]` | no |
| existing\_id\_domain\_appdev\_fun\_dyn\_group\_name         | The existing dynamic group name in the existing identity domain for executing applications functions. | `string` | `"` | no |
| existing\_id\_domain\_compute\_agent\_dyn\_group\_name      | The existing dynamic group name in the existing identity domain for Compute agents. | `string` | `"` | no |
| existing\_id\_domain\_database\_kms\_dyn\_group\_name       | The existing dynamic group name in the existing identity domain for accessing database encryption keys. | `string` | `"` | no |
| existing\_id\_domain\_net\_fw\_app\_dyn\_group\_name        | The existing dynamic group name in the existing identity domain for running network firewall appliances. | `string` | `"` | no |
| existing\_id\_domain\_security\_fun\_dyn\_group\_name       | The existing dynamic group name in the existing identity domain for executing security functions. | `string` | `"` | no |
| existing\_net\_fw\_app\_dyn\_group\_name                    | Existing network firewall appliance dynamic group for reading firewall instances. | `string` | `"` | no |
| existing\_network\_admin\_group\_name                       | The existing group to which network management policies will be granted to. | `list(string)` | `[]` | no |
| existing\_security\_admin\_group\_name                      | The existing group to which security management policies will be granted to. | `list(string)` | `[]` | no |
| existing\_security\_fun\_dyn\_group\_name                   | Existing security dynamic group to run functions. | `string` | `"` | no |
| existing\_storage\_admin\_group\_name                       | The existing group to which Storage management policies will be granted to. | `list(string)` | `[]` | no |
| groups\_options                                             | Whether to deploy new groups or use existing groups. | `string` | `Yes` | no |
| identity\_domain\_option                                    | Option to use the default identity domain, create a new identity domain or use custom identity domain. Value to use: Default Domain, New Identity Domain, Use Custom Identity Domain | `string` | `Default Domain` | yes |
| new\_identity\_domain\_name                                 | The name of the new identity domain if the option to create a new identity domain is chosen. | `string` | `null` | no |
| new\_identity\_domain\_license\_type                        | the license type of new identity domain. Value to use: free, premium. | `string` | `null` | no |
| policies\_in\_root\_compartment                             | Whether policies in the Root compartment should be created or simply used. If 'CREATE', you must be sure the user executing this stack has permissions to create policies in the Root compartment. If 'USE', policies must have been created previously. | `string` | `CREATE` | no |
| rm\_existing\_ag\_admin\_group\_name                        | Only applicable to RMS deployments. The existing group to which access governance policies will be granted to. | `string` | `"` | no |
| rm\_existing\_announcement\_reader\_group\_name             | Only applicable to RMS deployments. The existing group to which announcement reader policies will be granted to. | `string` | `"` | no |
| rm\_existing\_appdev\_admin\_group\_name                    | Only applicable to RMS deployments. The existing group to which application management policies will be granted to. | `string` | `"` | no |
| rm\_existing\_auditor\_group\_name                          | Only applicable to RMS deployments. The existing group to which auditor policies will be granted to. | `string` | `"` | no |
| rm\_existing\_cost\_admin\_group\_name                      | Only applicable to RMS deployments. The existing group to which cost management policies will be granted to. | `string` | `"` | no |
| rm\_existing\_cred\_admin\_group\_name                      | Only applicable to RMS deployments. The existing group to which credentials management policies will be granted to. | `string` | `"` | no |
| rm\_existing\_database\_admin\_group\_name                  | Only applicable to RMS deployments. The existing group to which database management policies will be granted to. | `string` | `"` | no |
| rm\_existing\_exainfra\_admin\_group\_name                  | Only applicable to RMS deployments. The existing group to which Exadata Cloud Service infrastructure management policies will be granted to. | `string` | `"` | no |
| rm\_existing\_iam\_admin\_group\_name                       | Only applicable to RMS deployments. The existing group to which IAM management policies will be granted to. | `string` | `"` | no |
| rm\_existing\_id\_domain\_ag\_admin\_group\_name            | The existing access governance admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm\_existing\_id\_domain\_announcement\_reader\_group\_name | The existing announcement readers group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm\_existing\_id\_domain\_appdev\_admin\_group\_name        | The existing applications admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm\_existing\_id\_domain\_auditor\_group\_name              | The existing auditor group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm\_existing\_id\_domain\_cost\_admin\_group\_name          | The existing cost admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm\_existing\_id\_domain\_cred\_admin\_group\_name          | The existing credentials admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm\_existing\_id\_domain\_database\_admin\_group\_name      | The existing database admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm\_existing\_id\_domain\_exainfra\_admin\_group\_name      | The existing Exadata CS infrastructure admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm\_existing\_id\_domain\_iam\_admin\_group\_name           | The existing IAM admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm\_existing\_id\_domain\_network\_admin\_group\_name       | The existing network admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm\_existing\_id\_domain\_security\_admin\_group\_name      | The existing security admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm\_existing\_id\_domain\_storage\_admin\_group\_name       | The existing storage admin group name in the existing identity domain. | `list(string)` | `[]` | no |
| rm\_existing\_network\_admin\_group\_name                   | Only applicable to RMS deployments. The existing group to which network management policies will be granted to. | `string` | `"` | no |
| rm\_existing\_security\_admin\_group\_name                  | Only applicable to RMS deployments. The existing group to which security policies will be granted to. | `string` | `"` | no |
| rm\_existing\_storage\_admin\_group\_name                   | Only applicable to RMS deployments. The existing group to which storage management policies will be granted to. | `string` | `"` | no |

### <a name="security"></a> Security

| Variable Name                                   | Description | Type | Default | Required |
|-------------------------------------------------|-------------|------|---------|----------|
| bastion\_jump\_host\_boot\_volume\_size         | The boot volume size (in GB) for the bastion jump host instance. | `number` | `60` | no |
| bastion\_jump\_host\_custom\_image\_ocid        | The custom image ocid of the user-provided bastion jump host instance. The custom image takes precedence over marketplace image. | `string` | `null` | no |
| bastion\_jump\_host\_flex\_shape\_cpu           | The number of OCPUs for the selected flex shape. Applicable to flexible shapes only. | `number` | `2` | no |
| bastion\_jump\_host\_flex\_shape\_memory        | The amount of memory (in GB) for the selected flex shape. Applicable to flexible shapes only. | `number` | `56` | no |
| bastion\_jump\_host\_instance\_name             | The display name of the bastion jump host instance. | `string` | `bastion-jump-host-instance` | no |
| bastion\_jump\_host\_instance\_shape            | The instance shape for the bastion jump host instance. | `string` | `VM.Standard.E4.Flex` | no |
| bastion\_jump\_host\_marketplace\_image\_option | Options to select a jump host marketplace image. Either `Oracle Linux 8 STIG (Free)`, or `CIS Hardened Image Level 1 on Oracle Linux 8 (Paid)`. | `string` | `null` | no |
| bastion\_jump\_host\_ssh\_public\_key\_path     | The SSH public key to login to bastion jump host instance. | `string` | `null`| no |
| bastion\_service\_allowed\_cidrs                | List of the bastion service allowed cidrs. | `list(string)` | `[/]` | no |
| bastion\_service\_name                          | The bastion service name. | `string` | `null` | no |
| cloud\_guard\_admin\_email\_endpoints           | List of email addresses for Cloud Guard related notifications. | `list(string)` | `[]` | no |
| cloud\_guard\_reporting\_region                 | Cloud Guard reporting region, where Cloud Guard reporting resources are kept. If not set, it defaults to home region. | `string` | `null` | no |
| cloud\_guard\_risk\_level\_threshold            | Determines the minimum Risk level that triggers sending Cloud Guard problems to the defined Cloud Guard Email Endpoint. E.g. a setting of High will send notifications for Critical and High problems. | `string` | `High` | no |
| deploy\_bastion\_jump\_host                     | The option to deploy the bastion jump host. | `bool` | `false` | no |
| deploy\_bastion\_service                        | The option to deploy the bastion service. | `bool` | `false` | no |
| enable\_cloud\_guard                            | Determines whether the Cloud Guard service should be enabled. If true, Cloud Guard is enabled and the Root compartment is configured with a Cloud Guard target, as long as there is no pre-existing Cloud Guard target for the Root compartment (or target creation will fail). If Cloud Guard is already enabled and a target exists for the Root compartment, set this variable to false. | `bool` | `true` | no |
| enable\_cloud\_guard\_cloned\_recipes           | Whether cloned recipes are attached to the managed Cloud Guard target. If false, Oracle managed recipes are attached. | `bool` | `true` | no |
| enable\_security\_zones                         | Determines if Security Zones are enabled in Landing Zone. When set to true, the Security Zone is enabled for the enclosing compartment. If no enclosing compartment is used, then the Security Zone is not enabled. | `bool` | `false` | no |
| enable\_vault                                   | Whether to enable vault service. Set to true to deploy a vault. | `bool` | `false` | no |
| security\_zones\_reporting\_region                | The reporting region of security zones. It defaults to tenancy home region if undefined. | `string` | `null` | no |
| sz\_security\_policies                            | Additional Security Zones Policy OCIDs to add to security zone recipe (The default policies are added based on CIS level). To get a Security Zone policy OCID use the oci cli: oci cloud-guard security-policy-collection list-security-policies --compartment-id <tenancy-ocid>. | `list(string)` | `[]` | no |
| vault\_replica\_region                            | The replica region where the vault backup is located. Only applicable when vault\_type is VIRTUAL\_PRIVATE. | `string` | `null` | no |
| vault\_type                                       | The type of the vault. Options are 'DEFAULT' and 'VIRTUAL\_PRIVATE'. | `string` | `"DEFAULT"` | no |
| vss\_agent\_cis\_benchmark\_settings\_scan\_level | Valid values: STRICT, MEDIUM, LIGHTWEIGHT, NONE. STRICT: If more than 20% of the CIS benchmarks fail, then the target is assigned a risk level of Critical. MEDIUM: If more than 40% of the CIS benchmarks fail, then the target is assigned a risk level of High. LIGHTWEIGHT: If more than 80% of the CIS benchmarks fail, then the target is assigned a risk level of High. NONE: disables cis benchmark scanning. | `string` | `MEDIUM` | no |
| vss\_agent\_scan\_level                           | Valid values: STANDARD, NONE. STANDARD enables agent-based scanning. NONE disables agent-based scanning and moots any agent related attributes. | `string` | `STANDARD` | no |
| vss\_create                                       | Whether Vulnerability Scanning Service recipes and targets are enabled in the Landing Zone. | `bool` | `false` | no |
| vss\_enable\_file\_scan                           | Whether file scanning is enabled. | `bool` | `false` | no |
| vss\_folders\_to\_scan                            | A list of folders to scan. Only applies if `vss_enable_file_scan` is true. Currently, the Scanning service checks for vulnerabilities only in log4j and spring4shell. | `list(string)` | `[/]` | no |
| vss\_port\_scan\_level                            | Valid values: STANDARD, LIGHT, NONE. STANDARD checks the 1000 most common port numbers, LIGHT checks the 100 most common port numbers, NONE does not check for open ports. | `string` | `STANDARD` | no |
| vss\_scan\_day                                    | The week day for the Vulnerability Scanning Service recipe, if enabled. Only applies if vss\_scan\_schedule is WEEKLY (case insensitive). | `string` | `SUNDAY` | no |
| vss\_scan\_schedule                               | The scan schedule for the Vulnerability Scanning Service recipe, if enabled. Valid values are WEEKLY or DAILY (case insensitive). | `string` | `WEEKLY` | no |

### <a name="three-tier-networking"></a> Three Tier Networking

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| add\_tt\_vcn1 | Whether to add a VCN configured for three-tier workload deployments, with up to four subnets: web (public by default), application (private), database (private). An optional subnet (private by default) for bastion deployment is also available. The added VCN is labelled 'TT-VCN-1'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| add\_tt\_vcn2 | Whether to add a second VCN configured for three-tier workload deployments, with up to four subnets: web (public by default), application (private), database (private). An optional subnet (private by default) for bastion deployment is also available. The added VCN is labelled 'TT-VCN-2'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| add\_tt\_vcn3 | Whether to add a third VCN configured for three-tier workload deployments, with up to four subnets: web (public by default), application (private), database (private). An optional subnet (private by default) for bastion deployment is also available. The added VCN is labelled 'TT-VCN-3'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| customize\_tt\_vcn1\_subnets | If true, allows for the customization of default subnets settings. Only applicable to RMS deployments. | `bool` | `false` | no |
| customize\_tt\_vcn2\_subnets | If true, allows for the customization of default subnets settings. Only applicable to RMS deployments. | `bool` | `false` | no |
| customize\_tt\_vcn3\_subnets | If true, allows for the customization of default subnets settings. Only applicable to RMS deployments. | `bool` | `false` | no |
| deploy\_tt\_vcn1\_bastion\_subnet | Whether to deploy a subnet where you can further deploy OCI Bastion service or a jump host. | `bool` | `false` | no |
| deploy\_tt\_vcn2\_bastion\_subnet | Whether to deploy a subnet where you can further deploy OCI Bastion service or a jump host. | `bool` | `false` | no |
| deploy\_tt\_vcn3\_bastion\_subnet | Whether to deploy a subnet where you can further deploy OCI Bastion service or a jump host. | `bool` | `false` | no |
| tt\_vcn1\_app\_subnet\_cidr | The Application subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt\_vcn1\_app\_subnet\_dns | The Application subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt\_vcn1\_app\_subnet\_name | The Application subnet name. | `string` | `null` | no |
| tt\_vcn1\_attach\_to\_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| tt\_vcn1\_bastion\_is\_access\_via\_public\_endpoint | If true, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed. | `bool` | `false` | no |
| tt\_vcn1\_bastion\_subnet\_allowed\_cidrs | List of CIDR blocks allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access. | `list(string)` | `[]` | no |
| tt\_vcn1\_bastion\_subnet\_cidr | The Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt\_vcn1\_bastion\_subnet\_dns | The Bastion subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt\_vcn1\_bastion\_subnet\_name | The Bastion subnet name. | `string` | `null` | no |
| tt\_vcn1\_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[10.0.0.0/20]` | no |
| tt\_vcn1\_db\_subnet\_cidr | The Database subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt\_vcn1\_db\_subnet\_dns | The Database subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt\_vcn1\_db\_subnet\_name | The Database subnet name. | `string` | `null` | no |
| tt\_vcn1\_dns | The VCN DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt\_vcn1\_name | The VCN name. If unassigned, a default name is provided. VCN label: TT-VCN-1. | `string` | `null` | no |
| tt\_vcn1\_onprem\_route\_enable | This will drive the creation of the routes and security list rules. | `bool` | `false` | no |
| tt\_vcn1\_routable\_vcns | The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3. | `list(string)` | `[]` | no |
| tt\_vcn1\_web\_subnet\_cidr | The Web subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt\_vcn1\_web\_subnet\_dns | The Web subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt\_vcn1\_web\_subnet\_is\_private | Whether the Web subnet private. It is public by default. | `bool` | `false` | no |
| tt\_vcn1\_web\_subnet\_name | The Web subnet name. | `string` | `null` | no |
| tt\_vcn2\_app\_subnet\_cidr | The Application subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt\_vcn2\_app\_subnet\_dns | The Application subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt\_vcn2\_app\_subnet\_name | The Application subnet name. | `string` | `null` | no |
| tt\_vcn2\_attach\_to\_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| tt\_vcn2\_bastion\_is\_access\_via\_public\_endpoint | If true, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed. | `bool` | `false` | no |
| tt\_vcn2\_bastion\_subnet\_allowed\_cidrs | List of CIDRs blocks allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access. | `list(string)` | `[]` | no |
| tt\_vcn2\_bastion\_subnet\_cidr | The Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt\_vcn2\_bastion\_subnet\_dns | The Bastion subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt\_vcn2\_bastion\_subnet\_name | The Bastion subnet name. | `string` | `null` | no |
| tt\_vcn2\_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[10.1.0.0/20]` | no |
| tt\_vcn2\_db\_subnet\_cidr | The Database subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt\_vcn2\_db\_subnet\_dns | The Database subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt\_vcn2\_db\_subnet\_name | The Database subnet name. | `string` | `null` | no |
| tt\_vcn2\_dns | The VCN DNS Name. | `string` | `null` | no |
| tt\_vcn2\_name | The VCN name. If unassigned, a default name is provided. Label: TT-VCN-2. | `string` | `null` | no |
| tt\_vcn2\_onprem\_route\_enable | This will drive the creation of the routes and security list rules. | `bool` | `false` | no |
| tt\_vcn2\_routable\_vcns | The VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3. | `list(string)` | `[]` | no |
| tt\_vcn2\_web\_subnet\_cidr | The Web subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt\_vcn2\_web\_subnet\_dns | The Web subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt\_vcn2\_web\_subnet\_is\_private | Whether the Web subnet private. It is public by default. | `bool` | `false` | no |
| tt\_vcn2\_web\_subnet\_name | The Web subnet name. | `string` | `null` | no |
| tt\_vcn3\_app\_subnet\_cidr | The Application subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt\_vcn3\_app\_subnet\_dns | The Application subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt\_vcn3\_app\_subnet\_name | The Application subnet name. | `string` | `null` | no |
| tt\_vcn3\_attach\_to\_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| tt\_vcn3\_bastion\_is\_access\_via\_public\_endpoint | If true, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed. | `bool` | `false` | no |
| tt\_vcn3\_bastion\_subnet\_allowed\_cidrs | List of CIDRs allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access. 0.0.0.0/0 is not allowed. | `list(string)` | `[]` | no |
| tt\_vcn3\_bastion\_subnet\_cidr | The Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt\_vcn3\_bastion\_subnet\_dns | The Bastion subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt\_vcn3\_bastion\_subnet\_name | The Bastion subnet name. | `string` | `null` | no |
| tt\_vcn3\_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[10.2.0.0/20]` | no |
| tt\_vcn3\_db\_subnet\_cidr | The Database subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt\_vcn3\_db\_subnet\_dns | The Database subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt\_vcn3\_db\_subnet\_name | The Database subnet name. | `string` | `null` | no |
| tt\_vcn3\_dns | The VCN DNS Name. | `string` | `null` | no |
| tt\_vcn3\_name | The VCN name. If unassigned, a default name is provided. Label: TT-VCN-3. | `string` | `null` | no |
| tt\_vcn3\_onprem\_route\_enable | This will drive the creation of the routes and security list rules. | `bool` | `false` | no |
| tt\_vcn3\_routable\_vcns | The VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3. | `list(string)` | `[]` | no |
| tt\_vcn3\_web\_subnet\_cidr | The Web subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| tt\_vcn3\_web\_subnet\_dns | The Web subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| tt\_vcn3\_web\_subnet\_is\_private | Whether the Web subnet private. It is public by default. | `bool` | `false` | no |
| tt\_vcn3\_web\_subnet\_name | The Web subnet name. | `string` | `null` | no |

### <a name="exa-networking"></a> EXA Networking

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| add\_exa\_vcn1 | Whether to add a VCN configured for Exadata Cloud Service deployment, with two subnets: client (private) and backup (private). The added VCN is labelled 'EXA-VCN-1'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| add\_exa\_vcn2 | Whether to add a second VCN configured for Exadata Cloud Service deployment, with two subnets: client (private) and backup (private). The added VCN is labelled 'EXA-VCN-2'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| add\_exa\_vcn3 | Whether to add a third VCN configured for Exadata Cloud Service deployment, with two subnets: client (private) and backup (private). The added VCN is labelled 'EXA-VCN-3'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| exa\_vcn1\_attach\_to\_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| exa\_vcn1\_backup\_subnet\_cidr | The Backup subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| exa\_vcn1\_backup\_subnet\_dns | The Backup subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| exa\_vcn1\_backup\_subnet\_name | The Backup subnet name. | `string` | `null` | no |
| exa\_vcn1\_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[172.16.0.0/20]` | no |
| exa\_vcn1\_client\_subnet\_cidr | The Client subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| exa\_vcn1\_client\_subnet\_dns | The Client subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| exa\_vcn1\_client\_subnet\_name | The Client subnet name. | `string` | `null` | no |
| exa\_vcn1\_dns | The VCN DNS name. | `string` | `null` | no |
| exa\_vcn1\_name | The VCN name. If unassigned, a default name is provided. VCN label: EXA-VCN-1. | `string` | `null` | no |
| exa\_vcn1\_onprem\_route\_enable | This will drive the creation of the routes and security list rules. | `bool` | `false` | no |
| exa\_vcn1\_routable\_vcns | The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3. | `list(string)` | `[]` | no |
| exa\_vcn2\_attach\_to\_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| exa\_vcn2\_backup\_subnet\_cidr | The Backup subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| exa\_vcn2\_backup\_subnet\_dns | The Backup subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| exa\_vcn2\_backup\_subnet\_name | The Backup subnet name. | `string` | `null` | no |
| exa\_vcn2\_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[172.17.0.0/20]` | no |
| exa\_vcn2\_client\_subnet\_cidr | The Client subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| exa\_vcn2\_client\_subnet\_dns | The Client subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| exa\_vcn2\_client\_subnet\_name | The Client subnet name. | `string` | `null` | no |
| exa\_vcn2\_dns | The VCN DNS name. | `string` | `null` | no |
| exa\_vcn2\_name | The VCN name. If unassigned, a default name is provided. VCN label: EXA-VCN-2 | `string` | `null` | no |
| exa\_vcn2\_onprem\_route\_enable | This will drive the creation of the routes and security list rules. | `bool` | `false` | no |
| exa\_vcn2\_routable\_vcns | The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3. | `list(string)` | `[]` | no |
| exa\_vcn3\_attach\_to\_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| exa\_vcn3\_backup\_subnet\_cidr | The Backup subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| exa\_vcn3\_backup\_subnet\_dns | The Backup subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| exa\_vcn3\_backup\_subnet\_name | The Backup subnet name. | `string` | `null` | no |
| exa\_vcn3\_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[172.18.0.0/20]` | no |
| exa\_vcn3\_client\_subnet\_cidr | The Client subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| exa\_vcn3\_client\_subnet\_dns | The Client subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| exa\_vcn3\_client\_subnet\_name | The Client subnet name. | `string` | `null` | no |
| exa\_vcn3\_dns | The VCN DNS name. | `string` | `null` | no |
| exa\_vcn3\_name | The VCN name. If unassigned, a default name is provided. Label: EXA-VCN-3. | `string` | `null` | no |
| exa\_vcn3\_onprem\_route\_enable | This will drive the creation of the routes and security list rules. | `bool` | `false` | no |
| exa\_vcn3\_routable\_vcns | The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN2, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3. | `list(string)` | `[]` | no |

### <a name="oke-networking"></a> OKE Networking

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| add\_oke\_vcn1 | Whether to add a VCN configured for OKE workload deployments, with at least three subnets: service (public by default), workers (private) and API endpoint (private). Additionally, a private subnet for pods deployment is created if the OKE CNI Type is 'Native'. You can also enable an extra private subnet for managing the OKE cluster. The added VCN is labelled 'OKE-VCN-1'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| add\_oke\_vcn1\_mgmt\_subnet | Whether to add a private subnet for cluster management. | `bool` | `false` | no |
| add\_oke\_vcn2 | Whether to add a second VCN configured for OKE workload deployments, with at least three subnets: service (public by default), workers (private) and API endpoint (private). Additionally, a private subnet for pods deployment is created if the OKE CNI Type is 'Native'. You can also enable an extra private subnet for managing the OKE cluster. The added VCN is labelled 'OKE-VCN-2'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| add\_oke\_vcn2\_mgmt\_subnet | Whether to add a private subnet for cluster management. | `bool` | `false` | no |
| add\_oke\_vcn3 | Whether to add a third VCN configured for OKE workload deployments, with at least three subnets: service (public by default), workers (private) and API endpoint (private). Additionally, a private subnet for pods deployment is created if the OKE CNI Type is 'Native'. You can also enable an extra private subnet for managing the OKE cluster. The added VCN is labelled 'OKE-VCN-3'. The label should be used in the '*\_routable\_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology. | `bool` | `false` | no |
| add\_oke\_vcn3\_mgmt\_subnet | Whether to add a private subnet for cluster management. | `bool` | `false` | no |
| oke\_vcn1\_api\_subnet\_cidr | The API subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke\_vcn1\_api\_subnet\_dns | The API subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn1\_api\_subnet\_name | The API subnet name. | `string` | `null` | no |
| oke\_vcn1\_attach\_to\_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| oke\_vcn1\_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[10.3.0.0/16]` | no |
| oke\_vcn1\_cni\_type | The CNI type for the OKE cluster. Valid values: 'Flannel' (default), 'Native'. If 'Native', a private subnet for pods deployment is created. | `string` | `Flannel` | no |
| oke\_vcn1\_dns | The VCN DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn1\_mgmt\_subnet\_cidr | The Management subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke\_vcn1\_mgmt\_subnet\_dns | The Management subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn1\_mgmt\_subnet\_name | The Management subnet name. | `string` | `null` | no |
| oke\_vcn1\_name | The VCN name. If unassigned a default name is provided. | `string` | `null` | no |
| oke\_vcn1\_onprem\_route\_enable | This will drive the creation of the routes and security list rules. | `bool` | `false` | no |
| oke\_vcn1\_pods\_subnet\_cidr | The Pods subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke\_vcn1\_pods\_subnet\_dns | The Pods subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn1\_pods\_subnet\_name | The Pods subnet name. A private subnet for pods deployment is automatically added if oke\_vcn1\_cni\_type value is 'Native'. | `string` | `null` | no |
| oke\_vcn1\_routable\_vcns | The VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-2, OKE-VCN-3. | `list(string)` | `[]` | no |
| oke\_vcn1\_services\_subnet\_cidr | The Services subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke\_vcn1\_services\_subnet\_dns | The Services subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn1\_services\_subnet\_name | The Services subnet name. | `string` | `null` | no |
| oke\_vcn1\_workers\_subnet\_cidr | The Workers subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke\_vcn1\_workers\_subnet\_dns | The Workers subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn1\_workers\_subnet\_name | The Workers subnet name. | `string` | `null` | no |
| oke\_vcn2\_api\_subnet\_cidr | The API subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke\_vcn2\_api\_subnet\_dns | The API subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn2\_api\_subnet\_name | The API subnet name. | `string` | `null` | no |
| oke\_vcn2\_attach\_to\_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| oke\_vcn2\_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[10.4.0.0/16]` | no |
| oke\_vcn2\_cni\_type | The CNI type for the OKE cluster. Valid values: 'Flannel' (default), 'Native'. If 'Native', a private subnet for pods deployment is created. | `string` | `Flannel` | no |
| oke\_vcn2\_dns | The VCN DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn2\_mgmt\_subnet\_cidr | The Management subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke\_vcn2\_mgmt\_subnet\_dns | The Management subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn2\_mgmt\_subnet\_name | The Management subnet name. | `string` | `null` | no |
| oke\_vcn2\_name | The VCN name. If unassigned, a default name is provided. | `string` | `null` | no |
| oke\_vcn2\_onprem\_route\_enable | This will drive the creation of the routes and security list rules. | `bool` | `false` | no |
| oke\_vcn2\_pods\_subnet\_cidr | The Pods subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke\_vcn2\_pods\_subnet\_dns | nan | `string` | `null` | no |
| oke\_vcn2\_pods\_subnet\_name | The pods subnet name. A private subnet for pods deployment is automatically added if oke\_vcn2\_cni\_type value is 'Native'. | `string` | `null` | no |
| oke\_vcn2\_routable\_vcns | The VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-3. | `list(string)` | `[]` | no |
| oke\_vcn2\_services\_subnet\_cidr | The Services subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke\_vcn2\_services\_subnet\_dns | The Services subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn2\_services\_subnet\_name | The Services subnet name. | `string` | `null` | no |
| oke\_vcn2\_workers\_subnet\_cidr | The Workers subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke\_vcn2\_workers\_subnet\_dns | The Workers subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn2\_workers\_subnet\_name | The Workers subnet name. | `string` | `null` | no |
| oke\_vcn3\_api\_subnet\_cidr | The API subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke\_vcn3\_api\_subnet\_dns | The API subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn3\_api\_subnet\_name | The API subnet name. | `string` | `null` | no |
| oke\_vcn3\_attach\_to\_drg | If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing. | `bool` | `false` | no |
| oke\_vcn3\_cidrs | The list of CIDR blocks for the VCN. | `list(string)` | `[10.5.0.0/16]` | no |
| oke\_vcn3\_cni\_type | The CNI type for the OKE cluster. Valid values: 'Flannel' (default), 'Native'. If 'Native', a private subnet for pods deployment is created. | `string` | `Flannel` | no |
| oke\_vcn3\_dns | The VCN DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn3\_mgmt\_subnet\_cidr | The Management subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke\_vcn3\_mgmt\_subnet\_dns | The Management subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn3\_mgmt\_subnet\_name | The Management subnet name. | `string` | `null` | no |
| oke\_vcn3\_name | The VCN name. If unassigned, a default name is provided. | `string` | `null` | no |
| oke\_vcn3\_onprem\_route\_enable | This will drive the creation of the routes and security list rules. | `bool` | `false` | no |
| oke\_vcn3\_pods\_subnet\_cidr | The Pods subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke\_vcn3\_pods\_subnet\_dns | The Pods subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn3\_pods\_subnet\_name | The Pods subnet name. A private subnet for pods deployment is automatically added if oke\_vcn3\_cni\_type value is 'Native'. | `string` | `null` | no |
| oke\_vcn3\_routable\_vcns | The VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2. | `list(string)` | `[]` | no |
| oke\_vcn3\_services\_subnet\_cidr | The Services subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke\_vcn3\_services\_subnet\_dns | The Services subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn3\_services\_subnet\_name | The Services subnet name. | `string` | `null` | no |
| oke\_vcn3\_workers\_subnet\_cidr | The Workers subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| oke\_vcn3\_workers\_subnet\_dns | The Workers subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| oke\_vcn3\_workers\_subnet\_name | The Workers subnet name. | `string` | `null` | no |

### <a name="hub-and-spoke-networking"></a> Hub and Spoke Networking

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| customize\_hub\_vcn\_subnets | Whether to customize default subnets settings of the Hub VCN. Only applicable to RMS deployments. | `bool` | `false` | no |
| enable\_native\_firewall\_threat\_log | Enable OCI Native Firewall Threat Log. | `bool` | `false` | no |
| enable\_native\_firewall\_traffic\_log | Enable OCI Native Firewall Traffic Log. | `bool` | `false` | no |
| existing\_drg\_ocid | The OCID of an existing DRG that you want to reuse for hub deployment. Only applicable if hub\_deployment\_option is 'VCN or on-premises connectivity routing via DRG (existing DRG)' or 'VCN or on-premises connectivity routed through DMZ VCN with Network Virtual Appliance existing DRG (DMZ VCN will be created and DRG ID required)'. | `string` | `null` | no |
| hub\_deployment | The available options for hub deployment as an integer. 'No cross-VCN or on-premises connectivity' = 0, 'VCN or on-premises connectivity routing via DRG (DRG will be created)' = 1, 'VCN or on-premises connectivity routing via DRG (existing DRG)' = 2, 'VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)' = 3, 'VCN or on-premises connectivity routed through DMZ VCN with Network Virtual Appliance existing DRG (DMZ VCN will be created and DRG ID required)' = 4 | `number` | `0`| no |
| hub\_deployment\_option | The available options for hub deployment. Valid values: 'No cross-VCN or on-premises connectivity', 'VCN or on-premises connectivity routing via DRG (DRG will be created)', 'VCN or on-premises connectivity routing via DRG (existing DRG)', 'VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)', 'VCN or on-premises connectivity routed through DMZ VCN with Network Virtual Appliance existing DRG (DMZ VCN will be created and DRG ID required)'. All the VCNs that attach to the DRG join the topology as spokes. | `string` | `No cross-VCN or on-premises connectivity` | no |
| hub\_vcn\_cidrs | List of CIDR blocks for the Hub VCN. | `list(string)` | `[192.168.0.0/26]` | no |
| hub\_vcn\_cidrs | List of CIDR blocks for the Hub VCN. | `list(string)` | `[192.168.0.0/26]` | no |
| hub\_vcn\_deploy\_net\_appliance\_option | The network appliance option for deploying in the Hub VCN. Valid values: 'Don't deploy any network appliance at this time' (default), 'Palo Alto Networks VM-Series Firewall', 'Fortinet FortiGate Firewall', 'User-Provided Virtual Network Appliance', and 'OCI Native Firewall'. Costs are incurred. | `string` | `Don't deploy any network appliance at this time` | no |
| hub\_vcn\_dns | The Hub VCN DNS name. | `string` | `null` | no |
| hub\_vcn\_enable\_internet\_gateway | When checked, access from the Internet is enabled into the Hub VCN via an Internet Gateway. When unchecked, an Internet Gateway is not deployed and access from Internet is blocked. | `bool` | `true` | no |
| hub\_vcn\_east\_west\_entry\_point\_ocid | The OCID of a private address the Hub VCN routes traffic to for inbound internal cross-vcn traffic (East/West). This variable is to be assigned with the OCID of the indoor network load balancer's private IP address. | `string` | `null` | no |
| hub\_vcn\_indoor\_subnet\_cidr | The Hub VCN Indoor subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| hub\_vcn\_indoor\_subnet\_dns | The Hub VCN Indoor subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| hub\_vcn\_indoor\_subnet\_name | The Hub VCN Indoor subnet name. | `string` | `null` | no |
| hub\_vcn\_mgmt\_subnet\_cidr | The Hub VCN Management subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| hub\_vcn\_mgmt\_subnet\_dns | The Hub VCN Management subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| hub\_vcn\_mgmt\_subnet\_external\_allowed\_cidrs\_for\_http | List of CIDR blocks allowed to connect to Management subnet over HTTP. Leave empty for no access. | `list(string)` | `[]` | no |
| hub\_vcn\_mgmt\_subnet\_external\_allowed\_cidrs\_for\_ssh | List of CIDR blocks allowed to connect to Management subnet over SSH. Leave empty for no access. | `list(string)` | `[]` | no |
| hub\_vcn\_mgmt\_subnet\_name | The Hub VCN Management subnet Name. | `string` | `null` | no |
| hub\_vcn\_name | The Hub VCN name. | `string` | `null` | no |
| hub\_vcn\_north\_south\_entry\_point\_ocid | The OCID of a private address the Hub VCN routes traffic to for inbound external traffic (North/South). This variable is to be assigned with the OCID of the outdoor network load balancer's private IP address. | `string` | `null` | no |
| hub\_vcn\_outdoor\_subnet\_cidr | The Hub VCN Outdoor subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| hub\_vcn\_outdoor\_subnet\_dns | The Hub VCN Outdoor subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| hub\_vcn\_outdoor\_subnet\_name | The Hub VCN Outdoor subnet name. | `string` | `null` | no |
| hub\_vcn\_web\_subnet\_cidr | The Hub VCN Web subnet CIDR block. It must be within the VCN CIDR blocks. | `string` | `null` | no |
| hub\_vcn\_web\_subnet\_dns | The Hub VCN Web subnet DNS name. Use only letters and numbers, no special characters. | `string` | `null` | no |
| hub\_vcn\_web\_subnet\_is\_private | Whether the Web subnet private. It is public by default. | `bool` | `false` | no |
| hub\_vcn\_web\_subnet\_jump\_host\_allowed\_cidrs | List of CIDRs allowed to SSH into the Web subnet via a jump host eventually deployed in the Web subnet. Leave empty for no access. | `list(string)` | `[]` | no |
| hub\_vcn\_web\_subnet\_name | The Hub VCN Web subnet name. | `string` | `null` | no |
| net\_appliance\_boot\_volume\_size | The boot volume size (in GB) for the network appliances. | `number` | `60` | no |
| net\_appliance\_flex\_shape\_cpu | The number of OCPUs for the selected flex shape. Applicable to flexible shapes only. | `number` | `2` | no |
| net\_appliance\_flex\_shape\_memory | The amount of memory (in GB) for the selected flex shape. Applicable to flexible shapes only. | `number` | `56` | no |
| net\_appliance\_image\_ocid | The custom image ocid of the user-provided virtual network appliance. | `string` | `null` | no
| net\_appliance\_name\_prefix | Common prefix to network appliance name. To this common prefix, numbers 1 and 2 are appended to the corresponding instance. | `string` | `net-appliance-instance` | no |
| net\_appliance\_public\_rsa\_key | The SSH public key to login to Network Appliance Compute instance. | `string` | `null` | no |
| net\_appliance\_shape | The instance shape for the network appliance nodes. | `string` | `VM.Optimized3.Flex` | no |
| oci\_nfw\_ip\_ocid | Enter OCI Network Firewall's Forwarding Private IP OCID. | `string` | `null` | no |
| oci\_nfw\_policy\_ocid | Enter the OCI Network Firewall Policy OCID. | `string` | `null` | no |
| onprem\_cidrs | List of on-premises CIDR blocks allowed to connect to the Landing Zone network via a DRG. | `list(string)` | `[]` | no |

### <a name="on-prem-networking"></a> On-Premises Networking

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| cpe\_device\_shape\_vendor | Name of the device shape vendor used by the customer-premises equipment (CPE). See the list of verified CPE devices for more information. | `string` | `null` | no |
| cpe\_ip\_address | Public IP address used by the customer-premises equipment (CPE) so that a VPN connection can be established. | `string` | `null` | no |
| cpe\_name | Display name of the customer-premises equipment (CPE). | `string` | `null` | no |
| fastconnect\_virtual\_circuit\_bandwidth\_custom\_shape | Custom bandwidth level (shape) of the FastConnect virtual circuit. For example: "5 Gbps" | `string` | `1 Gbps` | no |
| fastconnect\_virtual\_circuit\_bandwidth\_shape | Bandwidth level (shape) of the Fast Connect virtual circuit. | `string` | `1 Gbps` | no |
| fastconnect\_virtual\_circuit\_bgp\_md5auth\_key | The key for BGP MD5 authentication. Only applicable if your system requires MD5 authentication. If empty or not set (null), that means you do not use BGP MD5 authentication. | `string` | `null` | no |
| fastconnect\_virtual\_circuit\_cross\_connect\_or\_cross\_connect\_group\_id | The OCID of the cross-connect or cross-connect group used for cross-connect mapping. | `string` | `null` | no |
| fastconnect\_virtual\_circuit\_customer\_asn | Your BGP ASN (either public or private). Provide this value only if there is a BGP session that goes from your edge router to Oracle. Otherwise, leave this empty or null. Can be a 2-byte or 4-byte ASN. | `string` | `null` | no |
| fastconnect\_virtual\_circuit\_customer\_bgp\_peering\_ip | The BGP IPv4 address for the edge router on the other end of the BGP session from Oracle. Must use a subnet mask from /28 to /31. | `string` | `null` | no |
| fastconnect\_virtual\_circuit\_ip\_mtu | The MTU value to assign to the FastConnect virtual circuit. Supported values are: 1500, 9000. Default is 1500. | `number` | `null` | no |
| fastconnect\_virtual\_circuit\_is\_bfd\_enabled | Set to true to enable BFD for IPv4 BGP peering, or set to false to disable BFD. If this is not set, the default is false. | `bool` | `false` | no |
| fastconnect\_virtual\_circuit\_name | The name for the FastConnect virtual circuit. | `string` | `null` | no |
| fastconnect\_virtual\_circuit\_oracle\_bgp\_peering\_ip | The IPv4 address for Oracles end of the BGP session. Must use a subnet mask from /28 to /31. | `string` | `null` | no |
| fastconnect\_virtual\_circuit\_provider\_service\_id | The OCID of the service offered by the provider (if you are connecting via a provider). | `string` | `null` | no |
| fastconnect\_virtual\_circuit\_provider\_service\_key\_name | The service key name offered by the provider for FastConnect virtual circuit. | `string` | `null` | no |
| fastconnect\_virtual\_circuit\_routing\_policy | Defines the BGP relationship for exchanging routes. (Valid values include REGIONAL, GLOBAL). | `string` | `null` | no |
| fastconnect\_virtual\_circuit\_type | The type of IP addresses used in the Fast Connect virtual circuit. Accepted values are PRIVATE, PUBLIC. | `string` | `PRIVATE` | no |
| fastconnect\_virtual\_circuit\_vlan | The number of the specific VLAN (on the cross-connect or cross-connect group) that is assigned to FastConnect virtual circuit. | `string` | `null` | no |
| ipsec\_customer\_bgp\_asn | Customer-premises networks Autonomous System Number. | `string` | `null` | no |
| ipsec\_tunnel1\_customer\_interface\_ip | The first IP CIDR block used on the customer side for BGP peering for IPSec Tunnel 1. | `string` | `null` | no |
| ipsec\_tunnel1\_ike\_version | Version of the internet key exchange (IKE), if using a CPE IKE identifier. Supported values are "V1" or "V2". | `string` | `null` | no |
| ipsec\_tunnel1\_oracle\_interface\_ip | The first IP CIDR block provided by OCI for BGP peering for IPSec Tunnel 1. | `string` | `null` | no |
| ipsec\_tunnel1\_shared\_secret | The IPSec Tunnel 1 shared secret (pre-shared key). If not provided, Oracle will generate one automatically. | `string` | `null` | no |
| ipsec\_tunnel2\_customer\_interface\_ip | The second IP CIDR block used on the customer side for BGP peering for IPSec Tunnel 2. | `string` | `null` | no |
| ipsec\_tunnel2\_ike\_version | Version of the internet key exchange (IKE), if using a CPE IKE identifier. Supported values are "V1" or "V2". | `string` | `null` | no |
| ipsec\_tunnel2\_oracle\_interface\_ip | The second IP CIDR block provided by OCI for BGP peering for IPSec Tunnel 2. | `string` | `null` | no |
| ipsec\_tunnel2\_shared\_secret | The IPSec Tunnel 2 shared secret (pre-shared key). If not provided, Oracle will generate one automatically. | `string` | `null` | no |
| ipsec\_vpn\_name | Display name of the IPSec VPN. | `string` | `null` | no |
| on\_premises\_connection\_option | The options for connecting to on-premises. Valid options are 'None', 'Create New FastConnect Virtual Circuit', 'Create New IPSec VPN', 'Create New FastConnect Virtual Circuit and IPSec VPN', or 'Use Existing On-Premises Connectivity' | `string` | `None` | no |

### <a name="monitoring"></a> Monitoring

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| activate\_service\_connector | Whether Service Connector should be activated. If true, costs my incur due to usage of Object Storage bucket, Streaming or Function. | `bool` | `false` | no |
| alarm\_message\_format | Format of the message sent by Alarms | `string` | `PRETTY_JSON` | no |
| budget\_admin\_email\_endpoints | List of email addresses for all budget related notifications such as budget and finance. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |
| compute\_admin\_email\_endpoints | List of email addresses for all compute related notifications. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |
| create\_alarms\_as\_enabled | Whether a alarms should be created in an enabled state by default. If unchecked, alarms will be created but not emit alerts. | `bool` | `false` | no |
| create\_events\_as\_enabled | Whether events should be created in an enabled state by default. If unchecked, events will be created but not emit notifications. | `bool` | `false` | no |
| database\_admin\_email\_endpoints | List of email addresses for all database related notifications. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |
| enable\_service\_connector | Whether Service Connector should be enabled. If true, a single Service Connector is managed for all services log sources and the designated target specified in 'Service Connector Target Kind'. The Service Connector resource is created in INACTIVE state. To activate, check 'Activate Service Connector?' (costs may incur). | `bool` | `false` | no |
| exainfra\_admin\_email\_endpoints | List of email addresses for all Exadata infrastructure related notifications. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |
| existing\_service\_connector\_bucket\_key\_id | An existing key used to encrypt Service Connector target Object Storage bucket. | `string` | `null` | no |
| existing\_service\_connector\_bucket\_vault\_compartment\_id | An existing compartment for the vault with the key used to encrypt Service Connector target Object Storage bucket. | `string` | `null` | no |
| existing\_service\_connector\_bucket\_vault\_id | An existing vault for the key used to encrypt Service Connector target Object Storage bucket. | `string` | `null` | no |
| existing\_service\_connector\_target\_function\_id | An existing function to be used as the Service Connector target. Only applicable if 'service\_connector\_target\_kind' is set to 'functions'. | `string` | `null` | no |
| existing\_service\_connector\_target\_stream\_id | An existing stream to be used as the Service Connector target. Only applicable if 'service\_connector\_target\_kind' is set to 'streaming'. | `string` | `null` | no |
| network\_admin\_email\_endpoints | List of email addresses for all network related notifications. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |
| notifications\_advanced\_options | nan | `bool` | `false` | no |
| onboard\_logging\_analytics | Whether Logging Analytics will be enabled in the tenancy. If true, the Logging Analytics service will be enabled in the tenancy and a new Logging Analytics Namespace will be created. If false, the existing Logging Analytics namespace will be used. Only applicable if 'service\_connector\_target\_kind' is set to 'logginganalytics'. | `bool` | `false` | no |
| security\_admin\_email\_endpoints | List of email addresses for all security related notifications. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |
| service\_connector\_target\_kind | Service Connector Hub target resource. Valid values are 'objectstorage', 'streaming', 'functions' or 'logginganalytics'. In case of 'objectstorage', a new bucket is created. In case of 'streaming', you can provide an existing stream ocid in 'existing\_service\_connector\_target\_stream\_id' and that stream is used. If no ocid is provided, a new stream is created. In case of 'functions', you must provide the existing function ocid in 'existing\_service\_connector\_target\_function\_id'. If case of 'logginganalytics', a log group for Logging Analytics service is created and the service is enabled if not already. | `string` | `objectstorage` | no |
| storage\_admin\_email\_endpoints | List of email addresses for all storage related notifications. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |

### <a name="governance"></a> Governance

| Variable Name | Description | Type | Default | Required |
|---------------|-------------|------|---------|----------|
| budget\_alert\_email\_endpoints | List of email addresses for budget alerts. (Type an email address and hit enter to enter multiple values) | `list(string)` | `[]` | no |
| budget\_alert\_threshold | The threshold for triggering the alert expressed as a percentage of the monthly forecast spend. 100% is the default. | `number` | `100` | no |
| budget\_amount | The amount of the budget expressed as a whole number in the currency of the customer's rate card. | `number` | `1000` | no |
| create\_budget | If true, a budget is created for the enclosing compartment, based on forecast or actual spending. | `bool` | `false` | no |
