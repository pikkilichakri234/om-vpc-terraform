variable "name" {
    type = string
    default = "om"
    description = "to create the names"
}

variable "cidr_block" {
    type = string
    default = "10.0.0.0/24"
    description = "we create the cidr-blocks" 
}

variable "instance_tenancy" {
    type = string
    default = "default"
    description = "instance_tenancy is default"
}

variable "dns_hostnames" {
    type = bool
    default = true
    description = "enable dns host names"
  
}

variable "dns_support" {
    type = bool
    default = true
    description = "enable dns support names"
  
}

variable "tags" {
    type = map(string)
    default = {
      Name = "om"
      Environment = "Dev"
      Terraform = "true"
    
    }
  
}