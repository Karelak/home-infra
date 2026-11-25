variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy."
  default     = "ocid1.tenancy.oc1..aaaaaaaasgc43xnjxouiepynydru5mcos6pg4z7bu33a3wiuhvbfm3kmcrca"
}

variable "compartment_ocid" {
  type        = string
  description = "OCID of the compartment resources are created in (currently the root compartment, i.e. the tenancy)."
  default     = "ocid1.tenancy.oc1..aaaaaaaasgc43xnjxouiepynydru5mcos6pg4z7bu33a3wiuhvbfm3kmcrca"
}

variable "user_ocid" {
  type        = string
  description = "OCID of the user the API key belongs to."
  default     = "ocid1.user.oc1..aaaaaaaa7lkrf6xlv5iexmyizitnez5uocolzglcqf3zefvhdqcgqj6ixtqq"
}

variable "fingerprint" {
  type        = string
  description = "Fingerprint of the API signing key."
  default     = "70:9f:12:3f:1c:37:22:14:9d:6c:b0:ab:69:fe:8f:3f"
}

variable "private_key_path" {
  type        = string
  description = "Path to the API signing private key (set via TF_VAR_private_key_path in CI)."
}

variable "region" {
  type    = string
  default = "uk-london-1"
}

variable "availability_domain" {
  type    = string
  default = "NHmJ:UK-LONDON-1-AD-1"
}

variable "vps_source_id" {
  type        = string
  description = "Boot volume/image the VPS was created from. Ignored after creation (lifecycle ignore_changes)."
  default     = "ocid1.image.oc1.uk-london-1.aaaaaaaahfrghsffkvpikumb7v42bsxlk23medjry234dcspckdnbifbsocq"
}
