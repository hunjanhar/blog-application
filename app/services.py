import os
import json
import boto3
from flask import current_app
from werkzeug.utils import secure_filename
from app import redis_client

def get_s3_client():
    return boto3.client(
        's3',
        aws_access_key_id=current_app.config['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key=current_app.config['AWS_SECRET_ACCESS_KEY'],
        region_name=current_app.config['AWS_REGION']
    )

def handle_image_upload(file):
    """Handles uploading to S3 or local disk."""
    filename = secure_filename(file.filename)
    if not filename:
        return None

    bucket_name = current_app.config['AWS_BUCKET_NAME']
    if bucket_name:
        try:
            s3 = get_s3_client()
            s3.upload_fileobj(
                file,
                bucket_name,
                filename,
                ExtraArgs={"ContentType": file.content_type}
            )
            return f"https://{bucket_name}.s3.amazonaws.com/{filename}"
        except Exception as e:
            print(f"S3 Upload Error: {e}")
            return None
    else:
        relative_path = os.path.join('static/uploads', filename)
        full_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
        file.save(full_path)
        return relative_path

def cache_set(key, data, ttl=300):
    try:
        redis_client.setex(key, ttl, json.dumps(data))
    except Exception as e:
        print(f"Redis Set Error: {e}")

def cache_get(key):
    try:
        data = redis_client.get(key)
        return json.loads(data) if data else None
    except Exception as e:
        print(f"Redis Get Error: {e}")
        return None

def cache_delete(key):
    try:
        redis_client.delete(key)
    except Exception as e:
        print(f"Redis Delete Error: {e}")