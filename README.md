# Project Overview

Sales is the lifeblood of a growing business where every missed opportunity with a prospect can turn into a sale for their competitor.

First impressions matter...

When someone fills out an online form doesn't hear back - no confirmation, no follow-up - they question the trust and credibility of the business.

On the surface, the contact form may look functional. But under the hood, it’s a flawed technical foundation that makes it easy for inquiries to slip through the cracks:

* No form validation – Leads to incomplete or unusable submissions
* No spam protection – Clutters inboxes and buries legitimate leads
* No automated confirmation – Leaves users unsure whether their message was received
* No scalability – Basic setups can’t handle spikes in inquiry volume
* No data tracking mechanisms – Makes it impossible to measure response times, track lead sources, or improve the sales pipeline

---

## Solution Overview

I designed and built a secure and reliable contact form solution to process customer inquiries in a way that improves trust, speeds up follow-up, and supports business growth.

### Architecture

The architecture diagram below illustrates how each AWS service works together to ensure reliability, scalability, and visibility throughout the contact flow.

[Architectural Diagram](/architecture_diagram/contact_form.drawio)

The solution is composed of six core components, each playing a specific role in ensuring secure, reliable inquiry handling:

**Key Components**
- **Static frontend hosted on S3 and delivered via CloudFront** – Ensures fast, global access to the contact form
- **API Gateway and Lambda backend** – Processes and validates submissions without managing servers
- **DynamoDB data storage** – Securely stores all inquiries for tracking, analytics, and future reference
- **Amazon SES integration** – Sends branded email confirmations to clients and detailed alerts to the business
- **SNS and CloudWatch alerts** – Provides real-time delivery tracking and error notifications for visibility and reliability
- **Route 53 domain routing** – Connects the solution to a custom domain with high availability

---

## How It Works

### The Frontend 

#### Route 53

I configured Amazon Route 53 to manage DNS routing for the application. 

A custom domain is mapped to the CloudFront distribution, allowing users to access the site through a branded, easy-to-remember URL instead of the default CloudFront address.

This setup improves the overall user experience and adds a layer of professionalism to the frontend. 

Route 53 also provides flexibility for future routing configurations, such as subdomains, API endpoints, or failover strategies if needed.

#### Amazon S3

I configured an S3 bucket to host the application's static files — HTML, CSS, and JavaScript. This serves as the origin for the frontend content.

To follow security best practices, I blocked all public access to the bucket and used an Origin Access Control (OAC) policy to allow only CloudFront to read from it.

Bucket ownership is set to "BucketOwnerPreferred" so that the bucket’s permissions stay consistent, even if files are uploaded from another AWS account. This can help avoid permission issues down the line — especially if the frontend is deployed through a separate CI/CD pipeline in the future.

Versioning is enabled to allow reliable rollback to a previous configuration in case of deployment errors or issues.

#### CloudFront

I configured Amazon CloudFront to deliver and cache the website content, improving load times and creating a smoother user experience.

To secure the S3 bucket, I used Origin Access Control (OAC) instead of the older Origin Access Identity (OAI). 

OAC provides a more modern and flexible approach to securing origins, including support for fine-grained IAM permissions, SSE (server-side encryption) enforcement, and the ability to use signed requests — all of which help keep the S3 bucket private while maintaining tight control over access.
