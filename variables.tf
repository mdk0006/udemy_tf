variable "region" {
  default = "us-east-1"
}
variable "cidr_blocks" {
  type = list(object({
    cidr_block = string
    name       = string
  }))


  description = "This will assign the CIDR block and the tag names for the Subnet"

}

variable "env" {
  description = "Environment Name"
}