# Copyright (c) 2023, 2026, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

locals {
    ## RPC networks
  remote_peering_connections = {
    for peer in var.rpc_requestor_peers : # each peer_pair is a four-value tuple in the format 'ocid1.remotepeeringconnection.oc1.iad.aaaaaaaaexampleocid:us-ashburn-1:ocid1.tenancy.oc1.iad.aaaaaaaaexampleocid:ocid1.group.oc1.iad.aaaaaaaaexampleocid'
    "RPC-PEER-${index(var.rpc_requestor_peers, peer)}" => {
      display_name = "${var.service_label}-${split(":", peer)[0]}-rpc-peer"
    }
  }
}  