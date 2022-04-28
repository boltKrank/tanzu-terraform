locals {
  login = {
    subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  }

  location = {
    region = "westus2"
  }

  resource_group = {
    rg1 = {
      name     = "tkg"
      location = local.location.region
    }
  }

  cluster = {
    name = "tkg01"
  }

  ssh_pub_key = "..."
}
