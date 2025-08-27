# OCI Landing Zone Generic Network Extension Deployment Guide

This template shows how to deploy network resources for a generic workload using an OCI Core Landing Zone configuration.
Compartments, groups and policies are deployed to facilitate "segregation of duties" for an application workload on the landing zone base layer.

The following prerequisite resources are assumed to exist prior to deploying this extension:

- A foundation landing zone with minimal, basic network structure.

As a post-requisite, add Security Lists and NSG based on your network environment:
- Ingress and Egress Rules: define allowed inbound and outbound TCP ports, e.g. ports for SSH (22), HTTPS (443), etc.

## Default Values

This template has the following parameters set:

| Variable Name | Description | Value | Options |
|---|---|---|---|
| add\_app\_subnet | Whether to add an application subnet that contains the application-specific network resources. | false | |
| add\_db\_backup\_subnet | Whether to add a database backup subnet. | false | |
| add\_db\_subnet | Whether to add a database subnet that contains the database-specific network resources. | false | |
| add\_lb\_subnet | Whether to add a load balancer subnet that contains the load balancer resources for outbound connectivity and scaling. | | |
| add\_mgmt\_subnet | Whether to add a management subnet for management purpose. This can be used for OKE workloads or it can be customized for other purposes. | false | |
| add\_spare\_subnet | Whether to add a customizable extra subnet. | false | |
| add\_web\_subnet | Select to add a Web Subnet. | false | |
| additional\_route\_tables | Optional additional route tables. | | |
| app\_nsg\_additional\_egress\_rules | Additional egress rules for app subnet nsg. This allows for the injection of additional optional security rules. | | |
| app\_nsg\_additional\_ingress\_rules | Additional ingress rules for app subnet nsg. This allows for the injection of additional optional security rules. | | |
| app\_nsg\_name | Custom name of the APP (application) NSG. | | |
| app\_subnet\_additional\_route\_rules | Optional additional route rules for the Application Subnet. | | |
| app\_subnet\_allow\_onprem\_connectivity | Whether to allow on-premises connectivity to the application subnet. | false | |
| app\_subnet\_allow\_public\_access | Whether to allow public access to the application subnet. | false | |
| app\_subnet\_cidr | CIDR Block of the app subnet. It must be within the VCN CIDR block range. | | |
| app\_subnet\_name | Name of the application subnet. | | |
| app\_subnet\_seclist\_additional\_egress\_rules | Optional additional egress rules for the Application subnet security list. | | |
| app\_subnet\_seclist\_additional\_ingress\_rules | Optional additional ingress rules for the Application subnet security list. | | |
| app\_subnet\_seclist\_name | Custom name of the APP (application) subnet security list. | | |
| customize\_names | Whether to customize the default names of the security lists and NSGs. Set to true to customize names. | false | |
| customize\_subnets | Whether to customize subnet values. Set to true to use custom values for the subnet CIDRs and names. | false | |
| db\_backup\_nsg\_additional\_egress\_rules | Additional egress rules for db backup subnet nsg. This allows for the injection of additional optional security rules. | | |
| db\_backup\_nsg\_additional\_ingress\_rules | Additional ingress rules for db backup subnet nsg. This allows for the injection of additional optional security rules. | | |
| db\_backup\_nsg\_name | Custom name of the load balancer NSG. | | |
| db\_backup\_subnet\_additional\_route\_rules | Optional additional route rules for the Database Backup Subnet. | | |
| db\_backup\_subnet\_allow\_onprem\_connectivity | Whether to allow on-premises connectivity to the Database Backup Subnet. | false | |
| db\_backup\_subnet\_allow\_public\_access | Whether to allow public access to the Database Backup Subnet. | false | |
| db\_backup\_subnet\_cidr | CIDR Block of the Database Backup Subnet. It must be within the VCN CIDR block range. | | |
| db\_backup\_subnet\_name | Name of the Database Backup Subnet. | | |
| db\_backup\_subnet\_seclist\_additional\_egress\_rules | Optional additional egress rules for the Database Backup subnet security list. | | |
| db\_backup\_subnet\_seclist\_additional\_ingress\_rules | Optional additional ingress rules for the Database Backup subnet security list. | | |
| db\_backup\_subnet\_seclist\_name | Custom name of the additional subnet security list. | | |
| db\_nsg\_additional\_egress\_rules | Additional egress rules for db subnet nsg. This allows for the injection of additional optional security rules. | | |
| db\_nsg\_additional\_ingress\_rules | Additional ingress rules for db subnet nsg. This allows for the injection of additional optional security rules. | | |
| db\_nsg\_name | Custom name of the database NSG. | | |
| db\_subnet\_additional\_route\_rules | Optional additional route rules for the Database Subnet. | | |
| db\_subnet\_allow\_onprem\_connectivity | Whether to allow on-premises connectivity to the database subnet. | false | |
| db\_subnet\_allow\_public\_access | Whether to allow public access to the Database Subnet. | false | |
| db\_subnet\_cidr | CIDR Block of the Database Subnet. | | |
| db\_subnet\_name | Name of the Database Subnet. | | |
| db\_subnet\_seclist\_additional\_egress\_rules | Optional additional egress rules for the Database subnet security list. | | |
| db\_subnet\_seclist\_additional\_ingress\_rules | Optional additional ingress rules for the Database subnet security list. | | |
| db\_subnet\_seclist\_name | Custom name of the DB (database) subnet security list. | | |
| deploy\_network\_architecture | Options for deploying a network architecture. The "Hub and Spoke" option will deploy the Workload VCN connected to an external main Hub network as a spoke. Selecting the "Standalone" option will allow each workload VCN to manage their own internet and on-premises connectivity. | | "Hub and Spoke", "Standalone" |
| deploy\_nsgs | Whether to deploy NSGs. Select true to deploy NSGs. | | |
| deploy\_security\_lists | Whether to deploy security lists. Select true to deploy security lists. | | |
| enable\_nat\_gateway | Whether to enable a NAT gateway. Set to true to enable a NAT gateway. | false | |
| enable\_service\_gateway | Whether to enable a service gateway. Set to true to enable a service gateway. | false | |
| hub\_drg\_ocid | OCID of the existing DRG. | | |
| hub\_vcn\_cidrs | CIDR block(s) of the existing Hub VCN. | | |
| internet\_gateway\_display\_name | Display name of the Internet Gateway. Default is internet-gateway. | | |
| isolated\_resources | Set to true if deploying for the Workload Admin group; set to false if deploying for the Network Admin group. | false | |
| jumphost\_cidrs | List of jumphost CIDR blocks allowed to ssh to Workload VCN subnets. | | |
| lb\_nsg\_additional\_egress\_rules | Additional egress rules for lb subnet nsg. This allows for the injection of additional optional security rules. | | |
| lb\_nsg\_additional\_ingress\_rules | Additional ingress rules for lb subnet nsg. This allows for the injection of additional optional security rules. | | |
| lb\_nsg\_name | Custom name of the load balancer NSG. | | |
| lb\_subnet\_additional\_route\_rules | Optional additional route rules for the Load Balancer Subnet. | | |
| lb\_subnet\_allow\_onprem\_connectivity | Whether to allow on-premises connectivity to the load balancer subnet. | false | |
| lb\_subnet\_allow\_public\_access | Whether to allow public access to the Load Balancer Subnet. | false | |
| lb\_subnet\_cidr | CIDR Block of the Load Balancer Subnet. | | |
| lb\_subnet\_name | Name of the Load Balancer Subnet. | | |
| lb\_subnet\_seclist\_additional\_egress\_rules | Optional additional egress rules for the Load Balancer subnet security list. | | |
| lb\_subnet\_seclist\_additional\_ingress\_rules | Optional additional ingress rules for the Load Balancer subnet security list. | | |
| lb\_subnet\_seclist\_name | Custom name of the load balancer subnet security list. | | |
| mgmt\_nsg\_additional\_egress\_rules | Additional egress rules for management subnet nsg. This allows for the injection of additional optional security rules. | | |
| mgmt\_nsg\_additional\_ingress\_rules | Additional ingress rules for management subnet nsg. This allows for the injection of additional optional security rules. | | |
| mgmt\_nsg\_name | Custom name of the MGMT (management) NSG. | | |
| mgmt\_subnet\_additional\_route\_rules | Optional additional route rules for the management Subnet. | | |
| mgmt\_subnet\_allow\_onprem\_connectivity | Whether to allow on-premises connectivity to the management subnet. | false | |
| mgmt\_subnet\_allow\_public\_access | Whether to allow public access to the Management Subnet. | false | |
| mgmt\_subnet\_cidr | CIDR Block of the Management Subnet. | | |
| mgmt\_subnet\_name | Name of the Management Subnet. | | |
| mgmt\_subnet\_seclist\_additional\_egress\_rules | Optional additional egress rules for the management subnet security list. | | |
| mgmt\_subnet\_seclist\_additional\_ingress\_rules | Optional additional ingress rules for the management subnet security list. | | |
| mgmt\_subnet\_seclist\_name | Custom name of the management subnet security list. | | |
| nat\_gateway\_block\_traffic | Whether to block traffic with the NAT gateway. Default is false. | false | |
| nat\_gateway\_display\_name | Display name of the NAT Gateway. Default is nat-gateway. | | |
| network\_compartment\_ocid | OCID of the existing network compartment. | | |
| onprem\_cidrs | CIDR block(s) of the existing on-premises connection(s). | | |
| service\_gateway\_display\_name | Display name of the Service Gateway. Default is service-gateway. | service-gateway | |
| service\_gateway\_services | Services supported by Service Gateway. Values are 'objectstorage' and 'all-services'. | all-services | |
| spare\_nsg\_additional\_egress\_rules | Additional egress rules for spare subnet nsg. This allows for the injection of additional optional security rules. | | |
| spare\_nsg\_additional\_ingress\_rules | Additional ingress rules for spare subnet nsg. This allows for the injection of additional optional security rules. | | |
| spare\_nsg\_name | Custom name of the spare NSG. | | |
| spare\_subnet\_additional\_route\_rules | Optional additional route rules for the spare subnet. | | |
| spare\_subnet\_allow\_onprem\_connectivity | Whether to allow on-premises connectivity to the spare subnet. | false | |
| spare\_subnet\_allow\_public\_access | Whether to allow public access to the spare subnet. | false | |
| spare\_subnet\_cidr | CIDR block of the spare subnet. It must be within the VCN CIDR block range. | | |
| spare\_subnet\_name | Name of the spare Subnet. | | |
| spare\_subnet\_seclist\_additional\_egress\_rules | Optional additional egress rules for the spare subnet security list. | | |
| spare\_subnet\_seclist\_additional\_ingress\_rules | Optional additional ingress rules for the spare subnet security list. | | |
| spare\_subnet\_seclist\_name | Custom name of the spare subnet security list. | | |
| web\_nsg\_additional\_egress\_rules | Additional egress rules for web subnet nsg. This allows for the injection of additional optional security rules. | | |
| web\_nsg\_additional\_ingress\_rules | Additional ingress rules for web subnet nsg. This allows for the injection of additional optional security rules. | | |
| web\_nsg\_name | Custom name of the web NSG. | | |
| web\_subnet\_additional\_route\_rules | Optional additional route rules for the web subnet. | | |
| web\_subnet\_allow\_onprem\_connectivity | Whether to allow on-premises connectivity to the web subnet. | false | |
| web\_subnet\_allow\_public\_access | Whether to allow on-premises access to Web Subnet. | false | |
| web\_subnet\_cidr | Provide the CIDR block of the Web Subnet. | | |
| web\_subnet\_name | Provide the name of the Web Subnet. | | |
| web\_subnet\_seclist\_additional\_egress\_rules | Optional additional egress rules for the web subnet security list. | | |
| web\_subnet\_seclist\_additional\_ingress\_rules | Optional additional ingress rules for the web subnet security list. | | |
| web\_subnet\_seclist\_name | Custom name of the web subnet security list. | | |
| workload\_compartment\_ocid | OCID of the existing workload compartment. | | |
| workload\_name | The name of the extension VCN. This name is appended to resources to differentiate between similar extensions. | "NetExt" | |
| workload\_vcn\_cidr\_block | CIDR block of the workload VCN. | | |


For a detailed description of all variables that can be used, see the [Variables](https://github.com/oci-landing-zones/terraform-oci-core-landingzone/blob/main/VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

With the stack created, perform a Plan, followed by an Apply using RMS UI.

## Terraform CLI Deployment

1. Rename file *terraform.tfvars.template* to *terraform.tfvars*.
2. Provide/review the variable assignments in *terraform.tfvars*.
3. In this folder, execute the typical Terraform workflow:

	``
	terraform init
	``
	
	``
	terraform plan
	``
	
	``
	terraform apply
	``

