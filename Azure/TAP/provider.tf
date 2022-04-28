provider "azurerm" {
  subscription_id = "${local.login.subscription_id}"
  tenant_id       = "${local.login.tenant_id}"
  features {}
}
