variable "compartment_ocid" {
  type    = string
  default = "ocid1.tenancy.oc1..aaaaaaaasgc43xnjxouiepynydru5mcos6pg4z7bu33a3wiuhvbfm3kmcrca"
}
variable "tenancy_ocid" {
  type    = string
  default = "ocid1.tenancy.oc1..aaaaaaaasgc43xnjxouiepynydru5mcos6pg4z7bu33a3wiuhvbfm3kmcrca"
}
variable "oci_core_instance--source_details-source_id--export_vps" {
  type    = string
  default = "ocid1.image.oc1.uk-london-1.aaaaaaaahfrghsffkvpikumb7v42bsxlk23medjry234dcspckdnbifbsocq"
}
variable "user_ocid" {
  type    = string
  default = "ocid1.user.oc1..aaaaaaaa7lkrf6xlv5iexmyizitnez5uocolzglcqf3zefvhdqcgqj6ixtqq"
}
variable "availability_domain" {
  type    = string
  default = "NHmJ:UK-LONDON-1-AD-1"
}
variable "region" {
  type    = string
  default = "uk-london-1"
}
variable "fingerprint" {
  type    = string
  default = "70:9f:12:3f:1c:37:22:14:9d:6c:b0:ab:69:fe:8f:3f"
}
variable "private_key_path" {
  type = string
}
variable "CreatedBy" {
  type    = string
  default = "tofu"
}