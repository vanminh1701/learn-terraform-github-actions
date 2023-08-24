### fix warning in CLI
variable "AWS_SECRET_ACCESS_KEY" {
  default = ""
}

variable "AWS_ACCESS_KEY_ID" {
  default = ""
}

variable "domain_name" {
  type        = string
  description = "The domain name to use"
  default     = "tf.tvminh.co"
}

variable "acm_certificate_arn" {
  default = "arn:aws:acm:us-east-1:357171604946:certificate/0d060d9a-c957-4e8f-a2a1-eed74ee2b3ea"
}