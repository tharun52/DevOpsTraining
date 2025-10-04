# Automated Document Processing System with S3, Lambda, and DynamoDB

As a cloud architect, you are tasked with implementing an automated system using **S3 event-based triggers, Lambda functions, and DynamoDB** to process and manage text-based documents efficiently.

---

## 1. Text Processing

### Requirements
- When a new `.txt` file is uploaded to the **raw-documents/** prefix:  
  - Trigger a Lambda function to count the words in the document.  
  - Store the word count and metadata (file name, upload timestamp) in a DynamoDB table called **DocumentMetadata**.  
  - Save a processed version (with metadata added at the top of the file) to the **processed/** prefix.  

### Answer
1. Create a **Lambda function**.  
2. Create an **S3 bucket** with two folders: `processed/` and `raw-documents/`.  
3. Create a **DynamoDB table**.  
4. Add a trigger for the Lambda function:  
   - Event type: `S3 Put`  
   - Prefix: `raw-documents/`  
   - Suffix: `.txt`  
5. Lambda function code:

   ```python
   import json
   import boto3
   from datetime import datetime

   s3 = boto3.client("s3")
   dynamodb = boto3.resource("dynamodb")
   table = dynamodb.Table("TharunDocumentMetadata")  

   def lambda_handler(event, context):
       try:
           record = event["Records"][0]
           bucket = record["s3"]["bucket"]["name"]
           key = record["s3"]["object"]["key"]

           if not key.startswith("raw-documents/"):
               return {
                   "status": "ignored",
                   "message": f"Key {key} is not in raw-documents/"
               }

           # Download file
           response = s3.get_object(Bucket=bucket, Key=key)
           text = response["Body"].read().decode("utf-8")

           # Word count
           word_count = len(text.split())
           uploaded_at = datetime.now().isoformat()

           # Store metadata in DynamoDB
           table.put_item(
               Item={
                   "FileName": key,
                   "WordCount": word_count,
                   "UploadedAt": uploaded_at
               }
           )

           # Add metadata to processed file
           metadata_content = f"WordCount: {word_count}\nUploadedAt: {uploaded_at}\n\n{text}"
           dest_key = key.replace("raw-documents/", "processed/", 1)

           s3.put_object(
               Bucket=bucket,
               Key=dest_key,
               Body=metadata_content.encode("utf-8")
           )

           return {
               "status": "success",
               "message": f"Processed {key} → {dest_key}"
           }

       except Exception as e:
           return {
               "status": "error",
               "message": str(e)
           }
    ```

---

## 2. Archiving

### Requirements

* When an object in the **active-content/** prefix is tagged with `archive`:

  * Trigger a Lambda function to move the object to the **archived/** prefix.
  * Log the operation in DynamoDB, including timestamp and user (passed via metadata).

### Answer

1. Create a **Lambda function**.

2. Create two folders in S3: `active-content/` and `archived/`.

3. Create a **DynamoDB table**.

4. Add a trigger for the Lambda function:

   * Event type: `S3 Put`
   * Prefix: `active-content/`

5. Lambda function code:

   ```python
   import json
   import boto3
   from datetime import datetime

   s3 = boto3.client("s3")
   dynamodb = boto3.resource("dynamodb")
   table = dynamodb.Table("TharunDocumentMetadata")  

   def lambda_handler(event, context):
       try:
           record = event["Records"][0]
           bucket = record["s3"]["bucket"]["name"]
           key = record["s3"]["object"]["key"]
           
           if not key.startswith("active-content/"):
               return {
                   "status": "ignored",
                   "message": f"Key {key} is not in active-content/"
               }

           head = s3.head_object(Bucket=bucket, Key=key)
           metadata = head.get("Metadata", {})
           user = metadata.get("user", "unknown")

           dest_key = key.replace("active-content/", "archived/", 1)

           s3.copy_object(
               Bucket=bucket,
               CopySource={"Bucket": bucket, "Key": key},
               Key=dest_key,
               Metadata=metadata,
               MetadataDirective="REPLACE"
           )

           s3.delete_object(Bucket=bucket, Key=key)

           archived_at = datetime.now().isoformat()

           table.put_item(
               Item={
                   "FileName": dest_key,
                   "OperationType": "Archive",
                   "ArchivedAt": archived_at,
                   "User": user
               }
           )

           return {
               "status": "success",
               "message": f"Archived {key} → {dest_key}",
               "archived_at": archived_at,
               "user": user
           }

       except Exception as e:
           return {
               "status": "error",
               "message": str(e)
           }
   ```

---

## 3. Deletion Notification

### Requirements

* When an object is deleted:

  * Trigger a Lambda function to send a notification to an **SNS topic** with details (file name, prefix, deletion time, and user if available).
  * Log the deletion event in the **DynamoDB table**.

### Answer

1. Create a **Lambda function**.
2. Create a trigger for the Lambda function:

   * Event type: `S3 Delete`
3. Create an **SNS topic** and copy its ARN.
4. Lambda function code:

   ```python
   import json
   import boto3
   from datetime import datetime

   sns = boto3.client("sns")
   dynamodb = boto3.resource("dynamodb")
   table = dynamodb.Table("TharunDocumentMetadata")  
   SNS_TOPIC_ARN = "arn:aws:sns:us-east-1:853973692277:tharun-sns"

   def lambda_handler(event, context):
       try:
           record = event["Records"][0]
           bucket = record["s3"]["bucket"]["name"]
           key = record["s3"]["object"]["key"]

           user = record.get("userIdentity", {}).get("principalId", "unknown")
           deleted_at = datetime.now().isoformat()

           message = {
               "FileName": key,
               "Bucket": bucket,
               "Prefix": key.split("/")[0] if "/" in key else "",
               "DeletedAt": deleted_at,
               "User": user
           }

           sns.publish(
               TopicArn=SNS_TOPIC_ARN,
               Subject="S3 Object Deletion Notification",
               Message=json.dumps(message, indent=2)
           )

           table.put_item(
               Item={
                   "FileName": key,
                   "OperationType": "Delete",
                   "DeletedAt": deleted_at,
                   "User": user
               }
           )

           return {
               "status": "success",
               "message": f"Deletion of {key} logged and notified",
               "deleted_at": deleted_at
           }

       except Exception as e:
           return {
               "status": "error",
               "message": str(e)
           }
   ```

