# Exadata VCN Custom Networking

Shows a single Exadata VCN with custom client ingress, an optional integration subnet, and optional on-prem reach.

## Included Components
- Adds one Exadata VCN with customized client, backup, and integration subnet CIDRs.
- Allows explicit external CIDR access into the client tier on the approved database ports.
- Enables the optional integration subnet with its own external ingress policy.
- Marks the Exadata VCN for on-prem route creation.

## Configuration Variables

| Variable | Value | Notes |
|---------|-------|-------|
| *define_net* | *true* | Template default value. |
| *add_exa_vcn1* | *true* | Template default value. |
| *exa_vcn1_name* | *"exa-prod"* | Template default value. |
| *exa_vcn1_cidrs* | *["172.20.0.0/20"]* | Template default value. |
| *customize_exa_vcn1_subnets* | *true* | Template default value. |
| *exa_vcn1_client_subnet_cidr* | *"172.20.0.0/24"* | Template default value. |
| *exa_vcn1_backup_subnet_cidr* | *"172.20.1.0/24"* | Template default value. |
| *add_exa_vcn1_integration_subnet* | *true* | Template default value. |
| *exa_vcn1_integration_subnet_cidr* | *"172.20.2.0/24"* | Template default value. |
| *exa_vcn1_client_ingress_destination_ports* | *["TCP:1521", "TCP:1522", "TCP:5500"]* | Template default value. |
| *exa_vcn1_external_allowed_cidrs_into_client_tier* | *["198.51.100.20/32", "203.0.113.20/32"]* | Template default value. |
| *exa_vcn1_integration_ingress_destination_ports* | *["TCP:443", "TCP:8443"]* | Template default value. |
| *exa_vcn1_external_allowed_cidrs_into_integration_tier* | *["198.51.100.0/24"]* | Template default value. |
| *exa_vcn1_onprem_route_enable* | *true* | Template default value. |
| *network_admin_email_endpoints* | *["dba-network@example.com"]* | Template default value. |
| *security_admin_email_endpoints* | *["security.admin@example.com"]* | Template default value. |


## How to Use

1. Rename *main.tf.template* to *main.tf*.
2. Provide tenancy connectivity details using variables *tenancy_ocid*, *user_ocid*, *fingerprint*, *private_key_path*, *private_key_password* and *region*.
3. Run *terraform init && terraform plan && terraform apply*, or upload to OCI Resource Manager as a stack.

## OCI Resource Manager Deployment

Deploy via Resource Manager with the pre-populated variables below.

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/main.zip&zipUrlVariables=%7B%22define_net%22%3Atrue%2C%22add_exa_vcn1%22%3Atrue%2C%22exa_vcn1_name%22%3A%22exa-prod%22%2C%22exa_vcn1_cidrs%22%3A%5B%22172.20.0.0%2F20%22%5D%2C%22customize_exa_vcn1_subnets%22%3Atrue%2C%22exa_vcn1_client_subnet_cidr%22%3A%22172.20.0.0%2F24%22%2C%22exa_vcn1_backup_subnet_cidr%22%3A%22172.20.1.0%2F24%22%2C%22add_exa_vcn1_integration_subnet%22%3Atrue%2C%22exa_vcn1_integration_subnet_cidr%22%3A%22172.20.2.0%2F24%22%2C%22exa_vcn1_client_ingress_destination_ports%22%3A%5B%22TCP%3A1521%22%2C%22TCP%3A1522%22%2C%22TCP%3A5500%22%5D%2C%22exa_vcn1_external_allowed_cidrs_into_client_tier%22%3A%5B%22198.51.100.20%2F32%22%2C%22203.0.113.20%2F32%22%5D%2C%22exa_vcn1_integration_ingress_destination_ports%22%3A%5B%22TCP%3A443%22%2C%22TCP%3A8443%22%5D%2C%22exa_vcn1_external_allowed_cidrs_into_integration_tier%22%3A%5B%22198.51.100.0%2F24%22%5D%2C%22exa_vcn1_onprem_route_enable%22%3Atrue%2C%22network_admin_email_endpoints%22%3A%5B%22dba-network%40example.com%22%5D%2C%22security_admin_email_endpoints%22%3A%5B%22security.admin%40example.com%22%5D%7D)

