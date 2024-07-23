## NOTE: Please don't edit this without referencing the README

## Variable defining the audit AWS account ID

variable "audit_aws_account_id" {
  type        = string
  description = "This is your Latacora Audit account.  The account id will be provided to you by Latacora."
}

locals {
  minified_policies = (fileset(path.module, "MinifiedIAM*.json"))
}


## Output to be sent to Latacora

output "latacora_aws_audit_role_arn" {
  value = aws_iam_role.latacora_aws_audit_role.arn
}

## IAM Role Trust Policy. This will allow us to assume the LatacoraAWSAuditRole

data "aws_iam_policy_document" "iam_role_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.audit_aws_account_id}:root"]
    }
  }
}

## IAM Role

resource "aws_iam_role" "latacora_aws_audit_role" {
  name               = "LatacoraAWSAuditRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.iam_role_trust_policy.json

  tags = {
    VantaDescription = "IAM Role used to communicate with the Latacora security vendor"
  }
}

## IAM Policies from Policy Documents

resource "aws_iam_policy" "latacora_policy" {
  for_each    = local.minified_policies
  name        = "LatacoraAWSAuditorPolicy${split(".", each.key)[0]}"
  path        = "/"
  description = "This policy contains a portion of minimum permissions we need to audit your AWS environment. Briefly, it contains only side-effectless operations (Describe/List), excluding a few that produce live data as opposed to just metadata about your environment. The necessary actions are split across multiple policies, this is because AWS has strict limits on policy size."
  policy      = file("${path.module}/${each.key}")
}

## IAM Policy Attachments

resource "aws_iam_role_policy_attachment" "attach_latacora_security_first_minified" {
  for_each   = aws_iam_policy.latacora_policy
  role       = aws_iam_role.latacora_aws_audit_role.name
  policy_arn = each.value.arn
}

output "latacora_audit_role_arn" {
  value = aws_iam_role.latacora_aws_audit_role.arn
}