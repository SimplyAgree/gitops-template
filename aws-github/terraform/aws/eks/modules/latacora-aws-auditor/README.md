# latacora-aws-auditor
This module comes from latacora code. The latacora_aws_auditor_role.tf and MinifiedIAM*.json comes from a gist written by Latacora. It is advisable to only make changes to this code if we are copying from Latacora. 

Additionally, the only time we might want to disable this code is if we are limiting it to once per AWS account. (In the future, we might tie this to AWS account creation, not cluster creation)
Changes forked from the latacora Gist:

- The policy path is changed to be inside our module file("${path.module}/${each.key}")

Link to Gist:
https://latacora.github.io/gists/4c8db693-5a05-4fc6-9e5d-a53a202702e8/#terraform
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_iam_policy.latacora_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_role.latacora_aws_audit_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_iam_role_policy_attachment.attach_latacora_security_first_minified](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_iam_policy_document.iam_role_trust_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_audit_aws_account_id"></a> [audit\_aws\_account\_id](#input\_audit\_aws\_account\_id)

Description: This is your Latacora Audit account.  The account id will be provided to you by Latacora.

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_latacora_audit_role_arn"></a> [latacora\_audit\_role\_arn](#output\_latacora\_audit\_role\_arn)

Description: n/a

### <a name="output_latacora_aws_audit_role_arn"></a> [latacora\_aws\_audit\_role\_arn](#output\_latacora\_aws\_audit\_role\_arn)

Description: n/a
<!-- END_TF_DOCS -->