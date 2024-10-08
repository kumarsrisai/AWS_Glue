#To Create SNS Topic 
resource "aws_sns_topic" "topic" {
  name = "s3-event-notification-topic"

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:s3-event-notification-topic",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.example1.arn}"}
        }
    }]
}
POLICY
}
# S3 bucket to store Raw Data
resource "aws_s3_bucket" "example1" {
  bucket = var.s3_bucket1
  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = false
  }
   tags = {
    Name        = var.s3_bucket1
    Environment = "Dev"
  }
}

# S3 bucket to store Segregated Data
resource "aws_s3_bucket" "example2" {
  bucket = var.s3_bucket2
  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = false
  }
   tags = {
    Name        = var.s3_bucket2
    Environment = "Dev"
  }
}

# S3 bucket to store DQ1 Data
resource "aws_s3_bucket" "example3" {
  bucket = var.s3_bucket3
  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = false
  }
   tags = {
    Name        = var.s3_bucket3
    Environment = "Dev"
  }
}
# S3 bucket to store DQ1 Data
resource "aws_s3_bucket" "example4" {
  bucket = var.s3_bucket4
  # Prevent accidental deletion of this S3 bucket  
  lifecycle {
    prevent_destroy = false
  }
   tags = {
    Name        = var.s3_bucket4
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "example5" {
  bucket = var.s3_bucket5
  # Prevent accidental deletion of this S3 bucket  
  lifecycle {
    prevent_destroy = false
  }
   tags = {
    Name        = var.s3_bucket5
    Environment = "Dev"
  }
}

#To create a S3 Bucket Notofication 
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket      = aws_s3_bucket.example1.id
  eventbridge = true  
}

# Enable versioning so you can see the full revision history of your MBP files
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.example1.id
    versioning_configuration {
    status = "Enabled"   
  }
}
# Enable versioning so you can see the full revision history of your segrgated files
resource "aws_s3_bucket_versioning" "enabled1" {
  bucket = aws_s3_bucket.example2.id
    versioning_configuration {
    status = "Enabled"   
  }
}
# Enable versioning so you can see the full revision history of your DQ1 files
resource "aws_s3_bucket_versioning" "enabled2" {
  bucket = aws_s3_bucket.example3.id
    versioning_configuration {
    status = "Enabled"   
  }
}

# Enable versioning so you can see the full revision history of your DQ2 files
resource "aws_s3_bucket_versioning" "enabled3" {
  bucket = aws_s3_bucket.example4.id
    versioning_configuration {
    status = "Enabled"   
  }
}

# Enable server-side encryption by default for raw data bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.example1.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.ddsl_kms.arn
      sse_algorithm = "aws:kms"      
    }
  }
}

# Enable server-side encryption by default for extension bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "default1" {
  bucket = aws_s3_bucket.example2.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.ddsl_kms.arn
      sse_algorithm = "aws:kms"      
    }
  }
}
# Enable server-side encryption by default for DDQ1 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "default2" {
  bucket = aws_s3_bucket.example3.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.ddsl_kms.arn
      sse_algorithm = "aws:kms"      
    }
  }
}
# Enable server-side encryption by default for DDQ2 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "default3" {
  bucket = aws_s3_bucket.example4.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.ddsl_kms.arn
      sse_algorithm = "aws:kms"      
    }
  }
}
# Explicitly block all public access to the raw data S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.example1.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Explicitly block all public access to the extension S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access1" {
  bucket                  = aws_s3_bucket.example2.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
# Explicitly block all public access to the DQ1 S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access2" {
  bucket                  = aws_s3_bucket.example3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Explicitly block all public access to the DQ2 S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access3" {
  bucket                  = aws_s3_bucket.example4.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
#To create a S3 bucket with policy
resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.example2.id
  policy = data.aws_iam_policy_document.example1.json
}

#To upload the input files 
resource "aws_s3_object" "s3_upload" {
  for_each = fileset("input_dir/", "**/*.*")
  bucket = aws_s3_bucket.example1.id
  key    = each.value  
  source = "input_dir/${each.value}"
}