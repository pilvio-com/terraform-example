# Pilvio Terraform resource creation example

## Prerequisite

Create a Terraform variable file `example.auto.tfvars` file with your API key and billing account it in it. In example:

```go
pilvioprops = {
  apikey           = "your pilvio api key"
  billingAccountId = "your pilvio billing account number"
}
```

## What it does

Creates on VM in Pilvio.com platform, with a parameters described in `terraform.tfvars` file.

Make sure to adjust the size of the parameters in the variables files, as well to adjust the `providers.tf` file as per your need (in example location).