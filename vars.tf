variable "pscloud_company" {}
variable "pscloud_env" {}

variable "pscloud_ssm_activations" {
  type = map(object({
    name               = string
    registration_limit = number
    expiration_date    = string
    tags               = map(string)
  }))
  default = {}
}