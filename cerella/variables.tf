#
# @author GDev
# @date May 2022
#

variable "eks-instance-type" {
  default = "t2.large"
  type    = string
}

variable "eks-instance-count" {
  default = 3
}

variable "ingress-version" {
  default = "0.11.3"
}

variable "prometheus-version" {
  default = "19.2.3"
}

variable "cerella-version" {
  default = "1.0.25"
}

variable "cluster-ingress-port" {
  default = "30443"
  type    = string
}

variable "region" {
  default = "eu-west-1"
  type    = string
}

variable "eks-version" {
  default = "1.20"
  type    = string
}

variable "eks-ami" {
  default = "ami-031de2a4db6a7880f"
  type    = string
}

variable "security-group-id" {
}

variable "subnets" {
  type = list(any)
}

variable "acm-certificate-arn" {
}

variable "vpc-id" {
}

variable "cluster-name" {
}

variable "registry_username" {
}

variable "registry_password" {
}

variable "domain" {
  type = string
}

variable "alb-privacy" {
  default = true
}
