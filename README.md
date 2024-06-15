# Pilvio Terraform resource creation example

## Prerequisite

### Pilvio api key

Create a Terraform variable file `example.auto.tfvars` file with your API key and billing account it in it. In example:

```go
pilvioprops = {
  apikey           = "your pilvio api key"
  billingAccountId = "your pilvio billing account number"
}
```

### Storagevault Configuration

**NB!** The following works with Terraform version 1.7.x (and probably up).

The plan herewith will store the state to StorageVault S3 storage. For that you need to have bucket available, where to store terraform state. There are few ways to provide access credentials to bucket, but the example herewith will use your local s3 access profile. You will need to configure the profile either with following command:

```bash
aws configure
```

Or alternatively you can create manually aws credentials and config files. 

The backend configuration is described in the file `providers.tf` under the `backend` section. 

```go
  backend "s3" {
    bucket                 = "your s3 bucket name where to store states"
    key                    = "statefile key"
    profile                = "your s3 access credentials profile"
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

```
You can always store state locally. If this is the case, you can remove the `backend` section from the file.

## What it does

Creates on VM in Pilvio.com platform, with a parameters described in `terraform.tfvars` file. The virtual server will have also one additiona disk installed. The disk capacity is provided in the `variables.tf` file in example purposes. One use case for such definition in example, is to define variables in `variables.tf` file if variables are to be rather fixed and not changed that often. And variables, which are to be updated more often, to be defined in *.tfvars file. You can use what ever method to define variables, as long as it works for you the best.

Terraform state will be stored in the Pilvio.com StorageVault cluster.

**NB!** Make sure to adjust the size of the parameters in the variables files, as well to adjust the `providers.tf` file as per your need (in example location).

## How to run

1. Make sure you have proper version of Terraform installed. Guidelines to install Terraform can be found [here](https://developer.hashicorp.com/terraform/install). 
2. Clone the repository:

```bash
git clone git@github.com:pilvio-com/terraform-example.git
```

3. Adjust the configurations according to your needs.
4. Init the terraform configuration:

```bash
terraform init
```
5. As an option step, you can validate your configuration:

```bash
terraform validate
```
If issues were found during this step, correct these and run validate again until you will receive the `Success` message.

6. Create and review the plan:

```bash
terraform plan -out myterraformplan
```

7. Apply the plan:

```bash
terraform apply myterraformplan
```

If all is good, you will receive the message after the end of plan apply similar to:

```go
result = [
  "Server Name:   testproject",
  "Server UUID:   b8ac7475-c29d-4f2e-bf54-19f5ef0645a3",
  "IP Address:    176.112.155.3",
  "Private IP:    10.20.22.34",
  "Subnet Name:   testproject-subnet",
]
```
You can log in to your newly created server:

```bash
ssh -i sshkeys/id_rsa myuser@176.112.155.3
```

## Destroy

To destroy the created vm, you will need to run:

```bash
terraform destroy
```

This command will remove the created server and all related resources in reverse order to apply.

## Real world usage

The example herewith is just an example. The real world Terraform scripts are likely more complex to provision various components of your resource infrastructure. The scripts might be containing just a statements in terraform scripts, or whole modules can be used for repeatable procedures. In real world Terraform scripts are often used as provisioning step in GitOps pipelines.

