#
# @author GDev
# @date May 2022
#

variable "acm-certificate-arn" {
}

variable "alb-privacy" {
  default = true
}

variable "cerella-version" {
  default = "1.0.41"
}

variable "cluster-autoscaler-version" {
  default = "v1.22.0"
}

variable "cluster-ingress-port" {
  default = "30443"
  type    = string
}

variable "cluster-name" {
  type = string
}

variable "domain" {
  type = string
}

variable "eks-ami" {
  default = "ami-031de2a4db6a7880f"
  type    = string
}

variable "eks-instance-count" {
  default = 6
}

variable "eks-instance-type" {
  default = "t2.large"
  type    = string
}

variable "eks-version" {
  default = "1.22"
  type    = string
}

variable "ingress-cidr" {
  type = list(string)
}

variable "ingress-version" {
  default = "0.11.3"
}

variable "irsa_iam_role_name" {
  default = "external-secrets-readonly"
  type    = string
}

variable "prometheus-chart-version" {
  default = "38.0.0"
}

variable "region" {
  default = "us-west-2"
  type    = string
}

variable "registry_password" {
}

variable "registry_username" {
}

variable "subnets" {
  type = list(any)
}

variable "asg_subnets" {
  type = list(any)
}

variable "alb_subnets" {
  type = list(any)
}

variable "vpc-id" {
}

variable "service-account-name" {
  default = "external-secrets"
  type    = string
}

variable "service-account-namespace" {
  default = "kube-system"
  type    = string
}
