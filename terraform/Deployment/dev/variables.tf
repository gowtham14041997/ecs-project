variable "region" {
  type          = string
  default       = "ap-south-1"
  description   = "AWS VPC region"
}

variable "subnet_cidrs" {
  type          = list(string)
  default       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  description   = "CIDRs used for public and ECS subnets"
}
