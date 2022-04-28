# Terraform and Azure

## Pre-requisites 

- Install Terraform ( on Mac: brew tap hashicorp/tap; brew install hashicorp/tap/terraform)
- Install Azure CLI (on Mac: brew update && brew install azure-cli)
- Authenticate / login with Azure CLI (az login)

The `az login` will return JSON with a list of things, what we want initially is the id (subscription_id)

Then run:

`az account set --subscription "subscription_id"`

The create a "Service Principal" using the following command:

`az ad sp create-for-rbac --role="Contributer" --scopes="/subscriptions/subscription_id"`   (replacing "subscription_id with the actual one)

This will return:

```JSON
{
  "appId": "xxxxxx-xxx-xxxx-xxxx-xxxxxxxxxx",
  "displayName": "azure-cli-2022-xxxx",
  "password": "xxxxxx~xxxxxx~xxxxx",
  "tenant": "xxxxx-xxxx-xxxxx-xxxx-xxxxx"
}
```

Using this and the subscription_id, add the following to the Powershell command line:

```Powershell
$Env:ARM_CLIENT_ID = "<APPID_VALUE>"
$Env:ARM_CLIENT_SECRET = "<PASSWORD_VALUE>"
$Env:ARM_SUBSCRIPTION_ID = "<SUBSCRIPTION_ID>"
$Env:ARM_TENANT_ID = "<TENANT_VALUE>"
```

At this point the Azure CLI is all set up to run Terraform to provision on Azure.
