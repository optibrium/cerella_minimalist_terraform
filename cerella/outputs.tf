#
# @author GDev
# @date May 2022
#

output "cerella_minimalist_output" {
  value = <<OUTPUT
Congratulations, you have completed a Minimalist install of Cerella ^_^

Your ALB DNS CNAME is ${aws_lb.ingress.dns_name}
OUTPUT
}
