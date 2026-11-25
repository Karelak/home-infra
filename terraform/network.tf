resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_ocid
  display_name   = "vps-vcn"
  dns_label      = "vcn12241612"
  cidr_blocks    = ["10.0.0.0/16"]
}

resource "oci_core_internet_gateway" "internet_gateway_vcn" {
  compartment_id = var.compartment_ocid
  display_name   = "vps-igw"
  enabled        = true
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_subnet" "subnet" {
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.vcn.id
  display_name               = "vps-subnet"
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
  display_name               = "vps-dhcp"
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
  display_name               = "vps-rt"
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway_vcn.id
    route_type        = "STATIC"
  }
}

# Mirrors the host's ufw allow-list so the cloud firewall is a second layer.
# Anything not listed here is dropped before it reaches the VPS, including
# ports Docker publishes that ufw doesn't see.
locals {
  public_tcp_ports = [
    22,   # ssh
    80,   # http
    443,  # https
    8000, # app
  ]
  public_udp_ports = [
    51820, # wireguard
    34197, # factorio
  ]
}

resource "oci_core_default_security_list" "default_security_list_for_vcn" {
  compartment_id             = var.compartment_ocid
  display_name               = "vps-seclist"
  manage_default_resource_id = oci_core_vcn.vcn.default_security_list_id

  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }

  dynamic "ingress_security_rules" {
    for_each = toset(local.public_tcp_ports)
    content {
      protocol    = "6"
      source      = "0.0.0.0/0"
      source_type = "CIDR_BLOCK"
      stateless   = false
      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = toset(local.public_udp_ports)
    content {
      protocol    = "17"
      source      = "0.0.0.0/0"
      source_type = "CIDR_BLOCK"
      stateless   = false
      udp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }

  # mosh
  ingress_security_rules {
    protocol    = "17"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    udp_options {
      min = 60000
      max = 61000
    }
  }

  # Path MTU discovery
  ingress_security_rules {
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    protocol    = "1"
    source      = oci_core_vcn.vcn.cidr_blocks[0]
    source_type = "CIDR_BLOCK"
    stateless   = false
    icmp_options {
      type = 3
    }
  }
}
