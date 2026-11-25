# Stop managing the VCN's default DHCP options. destroy = false forgets the
# resource in state without calling the provider, so OCI keeps its settings.
# Safe to delete once the apply has run.
removed {
  from = oci_core_default_dhcp_options.default_dhcp

  lifecycle {
    destroy = false
  }
}
