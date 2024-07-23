# Terraform AWS Account Setup Module
This technical document guides you through the usage of a Terraform module designed to configure and manage an AWS account. It details the meaning and configuration of the module's variables and also provides a step-by-step guide to using it in your Terraform setup.

## Prerequisites

Before using this module, ensure to have the following setup:
- Terraform: This module requires Terraform version 1.5.0 or higher. Install Terraform and add it to your system's PATH.

## Usage
To use this module:
Initialization: Run the following command to initialize your working directory:
```
terraform init
```
- Configuration: In your main.tf, include the module and the required variables:
```terraform
module "account_setup" {
  source   = "./modules/account-setup"
  accounts = {
    "New Customer" = "Customers",
    "Pre Stage" = "SimplyAgree"
  }
  permission_set_group_mapping = {
    AWSPowerUserAccess = "simplyagree-superusers"
    AWSPowerUserAccess = "simplyagree"
    Billing            = "simplyagree-superusers"
  }
}
```
- Execution: Run terraform plan to preview the changes and terraform apply to execute them.
terraform plan terraform apply

**Note**: Ensure to replace the variable values according to your needs. Specifically, account_email should be unique among your AWS organization.
After executing the commands, verify the configuration through AWS Management Console. Check the output of Terraform commands for error messages, if any.


<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.8.1)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (~> 5.42.0)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (5.52.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_servicecatalog_provisioned_product.account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_provisioned_product) (resource)
- [aws_ssoadmin_account_assignment.aws_administrator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) (resource)
- [aws_ssoadmin_account_assignment.aws_superusers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) (resource)
- [aws_ssoadmin_account_assignment.billing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) (resource)
- [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) (data source)
- [aws_identitystore_group.groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_group) (data source)
- [aws_organizations_organization.root](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) (data source)
- [aws_organizations_organizational_units.units](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) (data source)
- [aws_servicecatalog_product.provisioner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/servicecatalog_product) (data source)
- [aws_servicecatalog_provisioning_artifacts.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/servicecatalog_provisioning_artifacts) (data source)
- [aws_ssoadmin_instances.these](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) (data source)
- [aws_ssoadmin_permission_set.perms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_permission_set) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_accounts"></a> [accounts](#input\_accounts)

Description: Map string of account name to account OU. OU should be Customers or SimplyAgree. Names get normalized to lowercase for resource names but appear as title in account names.  
ex:
```
accounts = {
  "New Customer" = "Customers",
  "Pre-Stage" = "SimplyAgree"
}
```

Type: `map(string)`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_permission_set_group_mapping"></a> [permission\_set\_group\_mapping](#input\_permission\_set\_group\_mapping)

Description: Permission set group mappings, currently a 1:1 mapping unique keys only

Type: `map(string)`

Default:

```json
{
  "AWSAdministratorAccess": "simplyagree-superusers",
  "AWSPowerUserAccess": "simplyagree",
  "Billing": "simplyagree-superusers"
}
```

### <a name="input_region"></a> [region](#input\_region)

Description: AWS region

Type: `string`

Default: `"us-east-2"`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Tags to apply to all resources

Type: `map`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_account_contexts"></a> [account\_contexts](#output\_account\_contexts)

Description: Account contexts to be passed between modules
<!-- END_TF_DOCS -->
