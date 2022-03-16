variable "gcs_region" {
  description = "The Google region to use."
  type        = string
  default     = "australia-southeast1"
}

variable "gcs_zone" {
  description = "The Google zone to use."
  type        = string
  default     = "australia-southeast1-b"
}

variable "project_id" {
  description = "An identifier for this project. Used for prefixing resource names and tagging resources."
  type        = string
}

variable "project_name" {
  description = "A name for this project. Used for prefixing resource names and tagging resources."
  type        = string
}

variable "billing_account" {
  description = "The billing account"
  type = string
}

variable "org_id" {
    description = "The ID of the organisation"
    type = string  
}

variable "project_apis" {
  description = "List of APIs to enable."
  type        = list(string)

  default = [
    "cloudkms.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "dns.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
  ]
}
