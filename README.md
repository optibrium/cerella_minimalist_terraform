## Optibrium Cerella Terraform

### Summary

This repository defines the Terraform scripts used to create the infrastructure resources that will host a Cerella evaluation platform.

There are expected to be minor differences in the installation of a full Cerella service.

### Pre-requisites

Below are AWS account pre-requisites,
1) An S3 bucket to hold the Terraform backend
2) A Route53 Domain hosting a valid public FQDN.
3) AWS VPC
4) AWC Subnets - Ideallly 3 /25 subnets (126 Ips each) in each AZ.
5) ACM certificate

These must be created in the same account, and must be configurable by the AWS profile used.

These can be created independently with Terraform, or via the Console.

### Architectural overview


A central EKS cluster is created with an Auto-scaling worker node pool.

An ALB with an ACM wildcard SSL certificate, is used to balance HTTPS ingress into the cluster.


### Usage instructions

Please create a VPC, Subnets, Route53 Hosted Zone, ACM certificate and an S3 bucket within the target account. If you already have a DNS domain or subdomain that you would like to use, it is possible to point NS (DNS Nameserver) records at the NS entries enumerated in the Route53 Hosted Zone.

Please copy the copy_me.tf.example file to a new location and substitute the placeholders. If you do not use AWS-Cli configuration profiles, your profile name is `default`, or can be removed entirely.
Sadly the EKS-AMI used in the Cerella module is scoped to `EU-WEST-1`, it is advised not to change this yourself, but we can supply alternative AMI-IDs if you require hosting in different regions.

Please create the resources with Terraform, and return the output to Optibrium Support.
