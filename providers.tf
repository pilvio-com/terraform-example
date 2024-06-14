terraform {
  required_version = ">= 1.7.4"
  required_providers {
    pilvio = {
      source  = "pilvio-com/pilvio"
      version = ">=1.0.16"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.6.0"
    }
  }
  backend "s3" {
    bucket                 = "terraformstates"
    key                    = "testenvironments/terraform.tfstate"
    profile                = "pilwio"
    region                 = "us-east-1"
    skip_region_validation = true
    use_path_style         = true
    endpoints = {
      s3 = "https://s3.pilw.io"
    }
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }
}

provider "pilvio" {
  host     = "api.pilvio.com"
  apikey   = var.pilvioprops.apikey
  location = "jhv02"
}

provider "random" {

}
