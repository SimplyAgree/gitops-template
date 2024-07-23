data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "root" {}

data "aws_organizations_organizational_units" "units" {
  parent_id = data.aws_organizations_organization.root.roots[0].id
}

data "aws_servicecatalog_product" "provisioner" {
  id = "prod-o446g3ijfq4os"
}

data "aws_servicecatalog_provisioning_artifacts" "this" {
  product_id = data.aws_servicecatalog_product.provisioner.id
}

locals {
  provisioning_artifact = [
    for artifact in data.aws_servicecatalog_provisioning_artifacts.this.provisioning_artifact_details :
    artifact.id
    if artifact.active
  ][0]

  accounts = aws_servicecatalog_provisioned_product.account

  parent_org = {
    for account, account_parent in var.accounts :
    account => [for ou in data.aws_organizations_organizational_units.units.children :
      ou
      if account_parent == ou.name
    ][0]
  }

  identity_store_id = tolist(data.aws_ssoadmin_instances.these.identity_store_ids)[0]

  account_email = { for name, owner in var.accounts :
    name => "engineering+${replace(lower(name), " ", "-")}@simplyagree.com"
  }

  tags = { for name, parent in var.accounts :
    name => merge({
      OrgId    = "${local.parent_org[name].name}-${local.parent_org[name].id}"
      Customer = title(name)
    }, var.tags)
  }

}

resource "aws_servicecatalog_provisioned_product" "account" {
  for_each                 = var.accounts
  name                     = title(replace(each.key, " ", ""))
  product_id               = data.aws_servicecatalog_product.provisioner.id
  provisioning_artifact_id = local.provisioning_artifact

  provisioning_parameters {
    key   = "AccountEmail"
    value = local.account_email[each.key]
  }
  provisioning_parameters {
    key   = "AccountName"
    value = title(each.key)
  }
  provisioning_parameters {
    key   = "ManagedOrganizationalUnit"
    value = local.parent_org[each.key].name
  }
  provisioning_parameters {
    key   = "SSOUserEmail"
    value = local.account_email[each.key]
  }
  provisioning_parameters {
    key   = "SSOUserFirstName"
    value = "SimplyAgree"
  }
  provisioning_parameters {
    key   = "SSOUserLastName"
    value = "Engineering"
  }
  tags = local.tags[each.key]
}

