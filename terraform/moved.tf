# Renames from the original provider export. Safe to delete once applied.
moved {
  from = oci_core_internet_gateway.internet_gateway_vcn
  to   = oci_core_internet_gateway.igw
}

moved {
  from = oci_core_default_dhcp_options.default_dhcp_options_for_vcn
  to   = oci_core_default_dhcp_options.default_dhcp
}

moved {
  from = oci_core_default_route_table.default_route_table_for_vcn
  to   = oci_core_default_route_table.default_route_table
}

moved {
  from = oci_core_default_security_list.default_security_list_for_vcn
  to   = oci_core_default_security_list.default_security_list
}
