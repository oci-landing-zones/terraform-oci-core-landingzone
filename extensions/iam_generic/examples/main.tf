
# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
#--------------------------------------------------------------------------------------------------------------------------------------
# 1. Rename this file to main.tf
# 2. Provide values for "Tenancy Connectivity Variables".
# 3. Replace <REPLACE-WITH-*> placeholders in "Input Variables" with appropriate values.
#--------------------------------------------------------------------------------------------------------------------------------------
module "test_iam" {
  source = "./"
# ------------------------------------------------------
# ----- Tenancy Connectivity Variables
# ------------------------------------------------------
tenancy_ocid         = "ocid1.tenancy.oc1..aaaaaaaaxbchsnzhdxyoewmoqiqzvltba2ri7gijhbd2z5ybpgorv7yhxeeq"  # Get this from OCI Console (after logging in, go to top-right-most menu item and click option "Tenancy: <your tenancy name>").
user_ocid            = "ocid1.user.oc1..aaaaaaaar6b5lgpbisg4u6zg4qygxiv553jghtuiykgslpfcmqt6inqg6xra"  # Get this from OCI Console (after logging in, go to top-right-most menu item and click option "My profile").
fingerprint          = "26:6a:a9:20:bb:6d:40:98:66:87:d2:26:fb:1d:e9:d4"  # The fingerprint can be gathered from your user account. In the "My profile page, click "API keys" on the menu in left hand side.
private_key_path     = "~/.oci/miakey.pem"  # This is the full path on your local system to the API signing private key.
private_key_password = ""  # This is the password that protects the private key, if any.
region               = "us-ashburn-1"  # The region name.
#---------------------------------------
# ----- Input Variables
#---------------------------------------
  service_label = "testm"
  parent_compartment_ocid = "ocid1.compartment.oc1..aaaaaaaafgtdbpqxxcv5c6cekesodg4c7ffhpmmtap3d4nwxhopymik26aia"
  network_compartment_ocid = "ocid1.compartment.oc1..aaaaaaaafgtdbpqxxcv5c6cekesodg4c7ffhpmmtap3d4nwxhopymik26aia"
  security_compartment_ocid = "ocid1.compartment.oc1..aaaaaaaafgtdbpqxxcv5c6cekesodg4c7ffhpmmtap3d4nwxhopymik26aia"
}