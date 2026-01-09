import datetime
import logging
import os
import urllib.parse

import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

TABLE_NAME = os.environ.get("TABLE_NAME")
PROCESSED_PREFIX = os.environ.get("PROCESSED_PREFIX", "processed/")

s3 = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")


def _iso_now():
    return datetime.datetime.utcnow().replace(microsecond=0).isoformat() + "Z"


def lambda_handler(event, context):
    if not TABLE_NAME:
        logger.error("TABLE_NAME is not set")
        return {"status": "error", "reason": "TABLE_NAME not set"}

    table = dynamodb.Table(TABLE_NAME)
    records = event.get("Records", [])
    processed = 0

    for record in records:
        try:
            bucket = record["s3"]["bucket"]["name"]
            key = urllib.parse.unquote_plus(record["s3"]["object"]["key"])

            if not key.startswith("incoming/"):
                logger.info("Skipping key outside incoming/: %s", key)
                continue

            suffix = key[len("incoming/") :]
            output_key = f"{PROCESSED_PREFIX}{suffix}"

            s3.copy_object(
                Bucket=bucket,
                Key=output_key,
                CopySource={"Bucket": bucket, "Key": key},
            )

            size_bytes = record["s3"]["object"].get("size")
            if size_bytes is None:
                head = s3.head_object(Bucket=bucket, Key=key)
                size_bytes = head.get("ContentLength", 0)

            table.put_item(
                Item={
                    "object_key": output_key,
                    "status": "processed",
                    "input_key": key,
                    "output_key": output_key,
                    "size_bytes": int(size_bytes),
                    "processed_at": _iso_now(),
                }
            )

            processed += 1
            logger.info("Processed %s -> %s", key, output_key)
        except Exception as exc:
            logger.exception("Failed to process record: %s", exc)

    return {"status": "ok", "processed": processed}
