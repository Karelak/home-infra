resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_ocid
  display_name   = "vcn-20251224-1610"
  dns_label      = "vcn12241612"
  cidr_blocks    = ["10.0.0.0/16"]
}

resource "oci_core_internet_gateway" "internet_gateway_vcn" {
  compartment_id = var.compartment_ocid
  display_name   = "Internet Gateway vcn-20251224-1610"
  enabled        = true
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_subnet" "subnet" {
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.vcn.id
  display_name               = "subnet-20251224-1610"
  dns_label                  = "subnet12241612"
  cidr_block                 = "10.0.0.0/24"
  dhcp_options_id            = oci_core_vcn.vcn.default_dhcp_options_id
  route_table_id             = oci_core_vcn.vcn.default_route_table_id
  security_list_ids          = [oci_core_vcn.vcn.default_security_list_id]
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_default_dhcp_options" "default_dhcp_options_for_vcn" {
  compartment_id             = var.compartment_ocid
  display_name               = "Default DHCP Options for vcn-20251224-1610"
  domain_name_type           = "CUSTOM_DOMAIN"
  manage_default_resource_id = oci_core_vcn.vcn.default_dhcp_options_id

  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  options {
    type                = "SearchDomain"
    search_domain_names = ["vcn12241612.oraclevcn.com"]
  }
}

resource "oci_core_default_route_table" "default_route_table_for_vcn" {
  compartment_id             = var.compartment_ocid
  display_name               = "Default Route Table for vcn-20251224-1610"
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway_vcn.id
    route_type        = "STATIC"
  }
}

# NOTE: currently allows ALL protocols from the whole internet.
# Restrict to the ports the VPS actually exposes once they're known.
resource "oci_core_default_security_list" "default_security_list_for_vcn" {
  compartment_id             = var.compartment_ocid
  display_name               = "Default Security List for vcn-20251224-1610"
  manage_default_resource_id = oci_core_vcn.vcn.default_security_list_id

  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }

  ingress_security_rules {
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
    stateless   = false
  }
}
