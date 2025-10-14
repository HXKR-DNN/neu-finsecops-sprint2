<<<<<<< HEAD
variable "project" {
  description = "Project tag / name prefix"
  type        = string
  default     = "neufinsecops"
}

variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

# Set to true ONLY if you are in the AWS Organizations management account
# and have enabled trusted access for CloudTrail (see Step 5 Optional).
variable "enable_org_trail" {
  description = "Create an organization-wide CloudTrail"
  type        = bool
  default     = false
}
=======
variable "project" { default = "neufinsecops" }
variable "region"  { default = "us-east-1" }
>>>>>>> origin/main
