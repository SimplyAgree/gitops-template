variable "region" {
  default     = "us-east-2"
  description = "AWS region"
  type        = string
}

variable "permission_set_group_mapping" {
  default = {
    AWSAdministratorAccess = "simplyagree-superusers"
    AWSPowerUserAccess     = "simplyagree"
    Billing                = "simplyagree-superusers"
  }
  type        = map(string)
  description = "Permission set group mappings, currently a 1:1 mapping unique keys only"
}

variable "tags" {
  default     = {}
  description = "Tags to apply to all resources"
}

variable "accounts" {
  type        = map(string)
  description = <<EOF
Map string of account name to account OU. OU should be Customers or SimplyAgree. Names get normalized to lowercase for resource names but appear as title in account names.
ex:
```
accounts = {
  "New Customer" = "Customers",
  "Pre-Stage" = "SimplyAgree"
}
```
EOF
}