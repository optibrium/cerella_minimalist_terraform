#
# @author GDev
# @date May 2022
#

variable "acm-certificate-arn" {
}

variable "alb-privacy" {
  default = true
}

variable "cluster-autoscaler-version" {
  default = "v1.22.3"
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


variable "eks-instance-count" {
  default = 4
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

variable "ingest_service_account_namespace" {
  default = "blue"
  type    = string
}

variable "ingest_service_account_name" {
  default = "ingest"
  type    = string
}

variable "external_secret_service_account_namespace" {
  default = "kube-system"
  type    = string
}

variable "external_secret_service_account_name" {
  default = "external-secrets"
  type    = string
}

# Get addon version value by running aws eks describe-addon-versions
variable "kube_proxy_addon_version" {
  default = "v1.22.11-eksbuild.2"
  type    = string
}

variable "vpc_cni_addon_version" {
  default = "v1.11.3-eksbuild.1"
  type    = string
}

variable "coredns_addon_version" {
  default = "v1.8.7-eksbuild.1"
  type    = string
}


variable "cerella-version" {
  default = "1.0.41"
}

variable "deploy-cerella" {
  default = false
}

variable "ingest_node_desired_capacity" {
  type    = number
  default = 0
}

variable "ingest-instance-type" {
  type = string
}

variable "elasticsearch_override_file_name" {
  # if empty, then helm release will not use file to override default values
  type    = string
  default = ""
}

variable "cerella_blue_override_file_name" {
  # if empty, then helm release will not use file to override default values
  type    = string
  default = ""
}

variable "cerella_green_override_file_name" {
  # if empty, then helm release will not use file to override default values
  type    = string
  default = ""
}
