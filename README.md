# Secure and Scalable Contact Form System on AWS

## Project Overview

Sales is the lifeblood of a growing business where every missed opportunity with a prospect can turn into a sale for their competitor.

First impressions matter.

When someone fills out an online form and doesn’t hear back — no confirmation, no follow-up — they question the trust and credibility of the business.

On the surface, the contact form may look functional. But under the hood, it’s a flawed technical foundation that makes it easy for inquiries to slip through the cracks:

- No form validation: Leads to incomplete or unusable submissions  
- No spam protection: Clutters inboxes and buries legitimate leads  
- No automated confirmation: Leaves users unsure whether their message was received  
- No scalability: Basic setups can’t handle spikes in inquiry volume  
- No data tracking mechanisms: Makes it impossible to measure response times, track lead sources, or improve the sales pipeline  

## Solution Overview

I designed and built a secure and reliable contact form solution to process customer inquiries in a way that improves trust, speeds up follow-up, and supports business growth.

**[View Full Write Up Here](https://medium.com/@arionnagappen/engineering-a-contact-form-on-aws-scalable-serverless-architecture-to-restore-trust-and-capture-09d56a50f16f)**

---

## Architecture

**Architecture Overview**

**[View Architecture Diagram](architecture_diagram/contact_form copy.drawio.png)**

**Key Components**
- **Amazon S3** and **CloudFront**: Host and deliver static frontend files globally with high performance.  
- **API Gateway** and **AWS Lambda**: Serverless backend to process and validate submissions.  
- **Amazon DynamoDB**: Stores all inquiries for analytics and reference.  
- **Amazon SES**: Sends branded confirmation and alert emails.  
- **SNS** and **CloudWatch**: Provide real-time monitoring and alerting.  
- **Route 53**: Handles DNS and domain routing for a custom domain.

---

## The Frontend

### Route 53

Configured **Amazon Route 53** to manage DNS routing for the application.  
A custom domain was mapped to the **CloudFront distribution**, allowing users to access the site through a branded URL.  
This setup improves user experience and adds professionalism.

For testing purposes, a primary domain `mynewtestdomain.click` and a subdomain `dev.mynewtestdomain.click` were used.

An **SSL/TLS certificate** from **Amazon Certificate Manager (ACM)** ensures all connections use HTTPS.

### Amazon S3

An S3 bucket was used to host the application’s static files (HTML, CSS, and JavaScript).  
To follow best practices:
- Public access is blocked.
- **Origin Access Control (OAC)** restricts CloudFront access.  
- Bucket ownership is set to `BucketOwnerPreferred`.  
- **Versioning** is enabled for rollback protection.

### CloudFront

**Amazon CloudFront** delivers and caches website content to improve performance.  
**OAC** is used instead of the older **OAI**, providing better security and IAM integration.

This setup ensures:
- Fast global delivery  
- Encrypted content transfer  
- Restricted S3 access  

---

## The Backend

### Web Application Firewall (WAF)

AWS WAF protects the API Gateway using the following rules:
1. Blocks IPs sending more than 100 requests within 5 minutes.  
2. Applies **AWSManagedRulesCommonRuleSet** to block common web exploits.

### API Gateway

Acts as the bridge between frontend and backend.  
**CORS** is configured to allow requests only from the CloudFront domain.  
POST requests were tested via command line to confirm functionality.

### Lambda

The backend logic is implemented in **AWS Lambda**, which:
- Validates form input  
- Stores data in DynamoDB  
- Sends email notifications via SES  

It scales automatically and incurs cost only when invoked.  
An IAM role with least privilege permissions allows Lambda to access CloudWatch, DynamoDB, and SES.

Testing:
- Before deployment → Status Code `500` (expected failure)  
- After deployment → Status Code `200` (success)  
- Triggered a simulated crash to verify **CloudWatch Alarm** and **SNS alert** functionality.

---

## DynamoDB

Submissions are stored in **Amazon DynamoDB** with:
- On-demand capacity  
- Server-side encryption  
- Point-in-Time Recovery (PITR) enabled  

Verified successful submissions through captured entries.

---

## Simple Email Service (SES)

Upon form submission, **Lambda** triggers two email flows:
1. **Business notification email** with customer details.  
2. **Customer confirmation email** acknowledging receipt.

SES uses verified identities and integrates with SNS for bounce and complaint notifications.  
This ensures full visibility into email deliverability.

---

## Monitoring and Alerts

**Amazon CloudWatch** tracks:
- Lambda errors, latency, and invocations  
- SES bounce and complaint metrics  

**Amazon SNS** sends real-time alerts for:
- Lambda function errors  
- Email delivery issues  

This provides complete observability and fast incident response.

---

## Troubleshooting

### DNS Resolution Failure

An issue occurred where the subdomain `dev.mynewtestdomain.click` failed to resolve.  
Root cause: Mismatched **NS records** between parent and subdomain zones.  
Resolution: Updated parent zone NS records to match subdomain records.  
Verification: Successful resolution confirmed via `dig` command.

### Lambda IAM Permission Denied

Submission failed with **403 Forbidden** error due to missing DynamoDB write permissions.  
Root cause identified using **CloudWatch Logs**.  
Resolution: Updated Lambda role via Terraform to include DynamoDB read/write permissions.  
Result: Submissions processed successfully.

---

## Conclusion

At its core, this project wasn’t about building a contact form — it was about building trust.

When a customer reaches out to a business, that first interaction defines their perception of reliability and professionalism.  
If that message gets lost or delayed, it’s a missed opportunity.

By leveraging AWS, this solution ensures every message is delivered, acknowledged, and logged securely.

- **Automation** via SES and Lambda means no message is left behind.  
- **Scalability** via DynamoDB and API Gateway means the system grows with the business.  
- **Monitoring** via CloudWatch and SNS ensures issues are detected early.

The impact is not just technical — it’s the confidence it gives a business knowing every customer inquiry is handled reliably, securely, and professionally.
