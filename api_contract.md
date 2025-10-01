# Contact Form API Contract

## Endpoint
- The frontend will send form submissions to **`POST /contact`** on our API Gateway.
- This is the only endpoint in the system right now.
- It does not require authentication, but it is protected by **WAF** (rate limiting + common security rules).

## Request (what the frontend sends)
- The frontend will send a request in **JSON format** with three fields:
  - **name** → the person’s name (up to 100 characters)
  - **email** → the person’s email address (standard email format)
  - **message** → the message they type into the contact form (up to 2000 characters)

📌 Example:
{ "name": "Jane Doe", "email": "jane@example.com", "message": "Hello!" }

## Responses (what the backend returns)
- ✅ Success (200):
  { "submission_id": "uuid-generated", "status": "accepted" }
- ❌ Validation Error (400):
  { "error": "validation", "details": ["email is invalid"] }
- ❌ Too Many Requests (429):
  { "error": "rate_limited" }
- ❌ Internal Error (500):
  { "error": "internal" }

## Behind the Scenes
1. API Gateway receives the request and sends it to Lambda.
2. Lambda stores the submission in DynamoDB and sends an email via SES.
3. Lambda returns a response to API Gateway.

## Environment Variables (Lambda)
- `TABLE_NAME`: DynamoDB table where submissions are stored
- `SENDER_EMAIL`: verified SES sender email
- `RECIPIENT_EMAIL`: verified SES recipient email
