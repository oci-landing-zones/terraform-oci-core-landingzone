# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# ----------------------------------------------------------------------------------------
# -- This configuration deploys a CIS compliant landing zone with custom VCN settings.
# -- See other templates for other CIS compliant landing zones with alternative settings.
# -- 1. Rename this file to main.tf. 
# -- 2. Provide/review the variable assignments below.
# -- 3. In this folder, execute the typical Terraform workflow:
# ----- $ terraform init
# ----- $ terraform plan
# ----- $ terraform apply
# ----------------------------------------------------------------------------------------

module "core_lz" {
    source = "./."
    # ------------------------------------------------------
    # ----- Environment
    # ------------------------------------------------------
    tenancy_ocid         = "ocid1.tenancy.oc1..aaaaaaaaxbchsnzhdxyoewmoqiqzvltba2ri7gijhbd2z5ybpgorv7yhxeeq"               # Replace with your tenancy OCID.
    user_ocid            = "ocid1.user.oc1..aaaaaaaa7zuzi2s4gwrjdliikjcs2xd7bubv6ae5zryl3i7qd6eu3dfpmd6q"                  # Replace with your user OCID.
    fingerprint          = "42:f6:e4:a8:98:92:cb:e5:0b:f9:6d:d4:22:1c:8c:05" # Replace with user fingerprint.
    private_key_path     = "/Users/ronguye/.oci/oci-private-key.pem"               # Replace with user private key local path.
    private_key_password = ""                                                # Replace with private key password, if any.
    region               = "us-ashburn-1" # Replace with region name.
    service_label        = "bastionzpr"     # Prefix prepended to deployed resource names.
    secondary_region = "us-phoenix-1"

    # ------------------------------------------------------
    # ----- Networking
    # ------------------------------------------------------
    define_net  = true # enables network resources provisioning

    # --- Hub deployment option: a DRG is deployed.
    hub_deployment_option = "VCN or on-premises connectivity routing via DRG (DRG will be created)"
    hub_vcn_cidrs         = ["192.168.0.0/24"]

    # --- Spoke VCN: three-tier VCN 1
    add_tt_vcn1                   = true
    tt_vcn1_attach_to_drg         = true


    # --- Routing to Firewall. Uncomment and update the two variables below for the second time execution.
    # hub_vcn_north_south_entry_point_ocid = "replace with the OCID value in the output of nlb_private_ip_addresses.OUTDOOR-NLB"
    # hub_vcn_east_west_entry_point_ocid   = "replace with the OCID value in the output of nlb_private_ip_addresses.INDOOR_NLB"
  
    # ------------------------------------------------------
    # ----- Notifications
    # ------------------------------------------------------
    network_admin_email_endpoints  = ["email.address@example.com"] # for network-related events. Replace with a real email address.
    security_admin_email_endpoints = ["email.address@example.com"] # for security-related events. Replace with a real email address.

    # ------------------------------------------------------
    # ----- Security
    # ------------------------------------------------------
    deploy_bastion_jump_host = true
    enable_zpr = true

}