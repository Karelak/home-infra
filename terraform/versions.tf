terraform {
  required_version = ">= 1.10"

  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "~> 9.14"
    }
  }
}
