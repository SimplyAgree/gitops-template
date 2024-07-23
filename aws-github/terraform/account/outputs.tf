output "account_contexts" {
  value = { for account, data in local.accounts :
    account => {
      account_id = [for out in data.outputs : out.value if out.key == "AccountId"][0]
      sso_email  = [for out in data.outputs : out.value if out.key == "AccountEmail"][0]
      tags       = data.tags_all
    }
  }
  description = "Account contexts to be passed between modules"
}
