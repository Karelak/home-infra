resource "oci_core_public_ip" "vps_public_ip" {
  compartment_id = var.compartment_ocid
  display_name   = "vps-public-ip"
  lifetime       = "RESERVED"

  lifecycle {
    prevent_destroy = true
  }
}

resource "oci_core_instance" "vps" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = "vps"
  shape               = "VM.Standard.A1.Flex"
  state               = "RUNNING"

  shape_config {
    ocpus         = 2
    memory_in_gbs = 12

  }

  source_details {
    source_type = "bootVolume"
    source_id   = var.vps_source_id
  }

  create_vnic_details {
    display_name           = "vnic"
    hostname_label         = "vnic"
    subnet_id              = oci_core_subnet.subnet.id
    private_ip             = "10.0.0.155"
    assign_public_ip       = true
    skip_source_dest_check = false
  }

  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false
  }

  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = false
  }

  launch_options {
    boot_volume_type                    = "PARAVIRTUALIZED"
    firmware                            = "UEFI_64"
    is_consistent_volume_naming_enabled = true
    is_pv_encryption_in_transit_enabled = true
    network_type                        = "PARAVIRTUALIZED"
    remote_data_volume_type             = "PARAVIRTUALIZED"
  }

  metadata = {
    ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCSTLTaH9vOb0ipvaMxWAocuDonAtVJivU6fLYAx+O9K4AS9wC3fJRM2I7ChVhSXiaz7RsFNyTenWr2wYtn4NOO7J9jGipxGo7D9nTzBHfCDcQO3sJRBbPMVkUjLy/KchqvBizSRFSDPvD+yB6c5rcN8lYmNaBvx9tot8fzHdTx2cBjhvqdU3nsuWssJqQUU1OoIskWsqhZ7Z3sBdL+QQ2249ztzXaw1AEUFMyN3DznSGazYQTsI13qTmfJiKxj1KKF8K+x/gRW9sNrnj4vZD1840h6lL4ZTpCGDSlZjgBAYTXxq7PbfxgbC5BL90Xe7XYtv72Npn0HQMZsj5a0VXEb ssh-key-2026-01-23"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [source_details]
  }
}
