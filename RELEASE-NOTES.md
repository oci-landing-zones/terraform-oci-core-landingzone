# October 31, 2024 Release Notes - 1.0.0
## New
1. Ability to deploy groups and dynamic groups in an existing identity domain.
2. Ability to define the network appliance versions. Supported versions are:
    - Palo Alto Network Firewall: 11.1.3 and 11.1.2-h1.
    - Fortinet Fortigate Firewall: 7.2.9(X64) and 7.4.4(X64)
3. Ability to deploy a network appliance custom image.
4. Bug fixes.    


# September 06, 2024 Release Notes - 0.0.1 (Early Preview Release)
## New
1. Utilizes the modules available in the [CIS OCI Foundations Benchmark Modules Collection](./README.md#modules) for actual resource management.
2. Adds the following to CIS Landing Zone:
    - Ability to use groups and dynamic groups from an existing Identity Domain as the grantees of IAM policies.
    - Streamlined user interface in Resource Manager, for better usability and improved customization.
    - Ability to deploy VCNs for OKE workload deployments, in addition to three-tier and Exadata Cloud service VCNs.
    - Ability to deploy a network firewall appliance in the Hub VCN (a.k.a. DMZ VCN).  
    - Ability to route traffic between select spoke VCNs, or in a full mesh model.
