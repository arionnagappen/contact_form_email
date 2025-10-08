import os, json, re, uuid, datetime
import boto3
from botocore.exceptions import ClientError

TABLE_NAME = os.environ.get("TABLE_NAME", "contact_submissions")
SENDER_EMAIL = os.environ.get("SENDER_EMAIL")
RECIPIENT_EMAIL = os.environ.get("RECIPIENT_EMAIL")
CFG_SET_NAME = os.environ.get("CFG_SET_NAME") 
EMAIL_RE = re.compile(r"^[^\s@]+@[^\s@]+\.[^\s@]+$")

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(TABLE_NAME)
ses = boto3.client("ses")

def _response(status: int, payload: dict):
    return {
        "statusCode": status,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(payload),
    }

def lambda_handler(event, context):
    try:
        # HTTP API v2.0: body is a JSON string
        body = event.get("body") or ""
        data = json.loads(body) if body else {}

        name = (data.get("name") or "").strip()
        email = (data.get("email") or "").strip()
        message = (data.get("message") or "").strip()

        # Simple validation aligned to api_contract.md
        errors = []
        if not name or len(name) > 100: errors.append("name is required (≤100 chars)")
        if not email or len(email) > 254 or not EMAIL_RE.match(email): errors.append("email is invalid")
        if not message or len(message) > 2000: errors.append("message is required (≤2000 chars)")
        if errors:
            return _response(400, {"error": "validation", "details": errors})

        submission_id = str(uuid.uuid4())
        created_at = datetime.datetime.utcnow().replace(tzinfo=datetime.timezone.utc).isoformat()

        # Persist to DynamoDB
        item = {
            "submission_id": submission_id,
            "created_at": created_at,
            "name": name,
            "email": email,
            "message": message,
        }
        table.put_item(Item=item)

        # Optional: send notification email if envs provided
        if SENDER_EMAIL and RECIPIENT_EMAIL:
            ses_kwargs = {
                "Source": SENDER_EMAIL,
                "Destination": {"ToAddresses": [RECIPIENT_EMAIL]},
                "Message": {
                    "Subject": {"Data": f"New Contact Submission {submission_id}"},
                    "Body": {"Text": {"Data": f"From: {name} <{email}>\n\n{message}"}},
                },
            }
            if CFG_SET_NAME:
                ses_kwargs["ConfigurationSetName"] = CFG_SET_NAME
            try:
                ses.send_email(**ses_kwargs)
            except ClientError as e:
                # Log but don't fail the request
                print(f"SES send_email failed: {e}")

        return _response(200, {"submission_id": submission_id, "status": "accepted"})

    except Exception as e:
        print(f"Unhandled error: {e}")
        return _response(500, {"error": "internal"})
