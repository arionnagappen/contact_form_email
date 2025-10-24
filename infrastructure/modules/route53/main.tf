resource "aws_route53_zone" "main" {
  name = var.main_domain
}

data "aws_route53_zone" "main" {
  name = var.main_domain
  private_zone = false
}


resource "aws_route53_zone" "dev_domain" {
  name = var.dev_domain

  tags = {
    Environment = "dev"
  }
}

resource "aws_route53_record" "ns_record" {
  zone_id = data.aws_route53_zone.main.id
  name = var.dev_domain
  type = "NS"
  ttl = "30"
  records = data.aws_route53_zone.main.name_servers
}