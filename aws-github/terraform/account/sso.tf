data "aws_ssoadmin_instances" "these" {}
data "aws_ssoadmin_permission_set" "perms" {
  for_each     = var.permission_set_group_mapping
  instance_arn = tolist(data.aws_ssoadmin_instances.these.arns)[0]
  name         = each.key
}

data "aws_identitystore_group" "groups" {
  for_each          = var.permission_set_group_mapping
  identity_store_id = local.identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value
    }
  }
}

locals {
  account_permission_sets = { for account in aws_servicecatalog_provisioned_product.account : account.name => [
    for permission_set, group_name in var.permission_set_group_mapping : {
      permission_set = permission_set
      group_name     = group_name
      account_id     = [for out in account.outputs : out.value if out.key == "AccountId"][0]
    }
  ] }

}

resource "aws_ssoadmin_account_assignment" "aws_administrator" {
  for_each           = { for account, set in local.account_permission_sets : "${account}::${set[0].permission_set}" => set[0] }
  instance_arn       = tolist(data.aws_ssoadmin_instances.these.arns)[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.perms[each.value.permission_set].arn
  principal_type     = "GROUP"
  principal_id       = data.aws_identitystore_group.groups[each.value.permission_set].group_id
  target_type        = "AWS_ACCOUNT"
  target_id          = each.value.account_id
}


resource "aws_ssoadmin_account_assignment" "aws_superusers" {
  for_each           = { for account, set in local.account_permission_sets : "${account}::${set[1].permission_set}" => set[1] }
  instance_arn       = tolist(data.aws_ssoadmin_instances.these.arns)[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.perms[each.value.permission_set].arn
  principal_type     = "GROUP"
  principal_id       = data.aws_identitystore_group.groups[each.value.permission_set].group_id
  target_type        = "AWS_ACCOUNT"
  target_id          = each.value.account_id
}

resource "aws_ssoadmin_account_assignment" "billing" {
  for_each           = { for account, set in local.account_permission_sets : "${account}::${set[2].permission_set}" => set[2] }
  instance_arn       = tolist(data.aws_ssoadmin_instances.these.arns)[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.perms[each.value.permission_set].arn
  principal_type     = "GROUP"
  principal_id       = data.aws_identitystore_group.groups[each.value.permission_set].group_id
  target_type        = "AWS_ACCOUNT"
  target_id          = each.value.account_id
}

