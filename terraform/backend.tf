# State lives in an OCI Object Storage bucket via its S3-compatible API.
# The bucket itself is created by hand and is deliberately NOT managed here
# (a stack can't safely manage the bucket holding its own state).
# Credentials come from AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY
# (an OCI "customer secret key"). Backend blocks can't use variables, so the
# namespace in the endpoint is hardcoded.
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
