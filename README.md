# tanzu-terraform

Terraform manifests to generate Tanzu environments

## TODO

Unit test

## Common commands

Initialise and download any dependancies:
`terraform init`

Format the .tf files:
`terraform fmt`

Validate the .tf files:
`terraform validate`

Run Terraform provision (adding --auto-approve will skip the yes/no prompt):
`terraform apply`

Pull down provistion (adding --auto-approve will skip the yes/no prompt):
`terraform destroy`

Check current status:
`terraform show`

List commands for chaning state:
`terraform state`

Show the current resources being managed:
`terraform state list`

## Azure (TAP and TKG)

/Azure

## AWS (TAP and TKG)

/AWS

## GCP (TAP and TKG)

/GCP

## vSphere (TAP and TKG)

/vSphere
