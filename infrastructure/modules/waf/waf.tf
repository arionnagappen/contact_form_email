resource "aws_wafv2_web_acl" "contact_form_acl" {
  name        = "contact-form-acl"
  description = "Baseline protection for POST /contact"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # ACL Level
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "contact-form-acl"
    sampled_requests_enabled   = true
  }

  # Rule 1 - Rate Limit Per IP 
  # Blocks IPs sending more than 100 requests within a 5 minute window
  # Cheap first line of defense against bot floods
  rule {
    name     = "rate-limit-per-ip"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit = 100 # Requests per 5 minutes
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "rate-limit-per-ip"
      sampled_requests_enabled = true
    }
  }

  # Rule 2 - AWS Managed Common Rule Set
  # Consists of prebuilt signitures for common attacks
  # Low maintenance protection
  rule {
    name = "aws-managed-common"
    priority = 2 

    # Use vendor defaults (block when rules match)
    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name = "AWSManagedRulesCommonRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "aws-managed-common"
      sampled_requests_enabled = true
    }
  }

  tags = {
    Application = "Email Form"
    Environment = "development"
  }
}

// --- WAF Association --- //
resource "aws_wafv2_web_acl_association" "contact_form_acl_assoc" {
  resource_arn = var.apigateway_stage_arn
  web_acl_arn  = aws_wafv2_web_acl.contact_form_acl.arn
}
