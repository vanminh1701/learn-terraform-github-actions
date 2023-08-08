### fix warning in CLI
variable "AWS_SECRET_ACCESS_KEY" {
  default = ""
}

variable "AWS_ACCESS_KEY_ID" {
  default = ""
}

variable "sg_inbound_rules" {
  type = list(object({
    port        = number
    proto       = string
    cidr_blocks = list(string)
  }))

  default = [
    {
      port        = 80
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 22
      proto       = "tcp"
      cidr_blocks = ["116.110.40.148/32"]

    },
    {
      port        = 8080
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}