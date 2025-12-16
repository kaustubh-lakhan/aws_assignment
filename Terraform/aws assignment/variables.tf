variable "aws_region" {
  description = "AWS Region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "The base domain name for host-based routing "
  type        = string
  default     = "lakhan.click" # NOTE: Change this to your actual domain name
}