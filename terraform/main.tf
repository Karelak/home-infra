terraform {
  backend "s3" {
    bucket                      = "terraform-state"
    key                         = "terraform.tfstate"
    region                      = "uk-london-1"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    use_path_style              = true
    use_lockfile                = true
    endpoints = {
      s3 = "https://lrxfwv7yalgn.compat.objectstorage.uk-london-1.oraclecloud.com"
    }
  }
}