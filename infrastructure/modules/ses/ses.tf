// --- IDENTITIES --- //
resource "aws_sesv2_email_identity" "sender_identity" {
  email_identity = "arionnagappen@gmail.com"
}

resource "aws_sesv2_email_identity" "recipient_identity" {
  email_identity = "nagappen27@gmail.com"
}

// --- CONFIGURATION SET --- //
# A ruleset that SES uses when sending email.
# Lets SES know to publish events (like bounces/deliveries) to destinations.
resource "aws_sesv2_configuration_set" "contact_form_cfg" {
  configuration_set_name = "contact-form-cfg"
}

// --- EVENT DESTINATION --- //
# Attaches to the configuration set above.
# Tells SES to send events (delivery, bounce, complaint) to an SNS topic.
resource "aws_sesv2_configuration_set_event_destination" "contact_form_sns_events" {
  configuration_set_name = aws_sesv2_configuration_set.contact_form_cfg.id
  event_destination_name = "sns-delivery-bounce-complaint"

  event_destination {
    enabled = true
    matching_event_types = [ "SEND", "DELIVERY", "BOUNCE", "COMPLAINT" ]
    
    sns_destination {
      topic_arn = var.lambda_alert_arn
    }
  } 
}