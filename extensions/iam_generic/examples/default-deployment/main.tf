
# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
#--------------------------------------------------------------------------------------------------------------------------------------

module "test_iam" {
  source = "../../"

  # ------------------------------------------------------
  # ----- Tenancy Connectivity Variables
  # ------------------------------------------------------
  tenancy_ocid         = "ocid1.tenancy.oc1..aaaaaaaaxbchsnzhdxyoewmoqiqzvltba2ri7gijhbd2z5ybpgorv7yhxeeq" # Get this from OCI Console (after logging in, go to top-right-most menu item and click option "Tenancy: <your tenancy name>").
  user_ocid            = "ocid1.user.oc1..aaaaaaaap3zy2bju3g2qunqmsaiod6xfiiskwaqx5epvhdrw7u4evxfztrfq" # Get this from OCI Console (after logging in, go to top-right-most menu item and click option "My profile").
  fingerprint          = "26:6a:a9:20:bb:6d:40:98:66:87:d2:26:fb:1d:e9:d4" # The fingerprint can be gathered from your user account. In the "My profile page, click "API keys" on the menu in left hand side.
  private_key_path     = "~/.oci.miakey.pem" # This is the full path on your local system to the API signing private key.
  private_key_password = "" # This is the password that protects the private key, if any.
  region               = "us-ashburn-1" # The region name.


  #---------------------------------------
  # ----- Input Variables
  #---------------------------------------
  workload_compartment_name = ""    # Default is "workload-cmp"
  service_label             = "test"    # Required. A unique label that gets prepended to all resources deployed by the Landing Zone. Max length: 15 characters.
  parent_compartment_ocid   = "ocid1.drg.oc1.iad.aaaaaaaa3hoezjafdk2f7nav4noozjc4nbpk4gok3vjjkifroas4u6kzwxrq"    # The ocid of the parent compartment of the Landing Zone deployed
  isolate_workload          = false # The workload uses an isolated approach where network will be contained within the workload compartment instead of a shared network compartment.
  network_compartment_ocid  = "ocid1.drg.oc1.iad.aaaaaaaa3hoezjafdk2f7nav4noozjc4nbpk4gok3vjjkifroas4u6kzwxrq"    # This value is required if isolate_workload = false. Ensure that the selected network compartment is within the selected parent compartment.
  security_compartment_ocid = "ocid1.drg.oc1.iad.aaaaaaaa3hoezjafdk2f7nav4noozjc4nbpk4gok3vjjkifroas4u6kzwxrq"    # Ensure that the selected security compartment is within the selected parent compartment.
}