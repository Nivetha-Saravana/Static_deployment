# AWS Provider Configuration
provider "aws" {
  region = "us-west-2" # Replace with your AWS region
}

# AWS S3 Bucket Configuration
resource "aws_s3_bucket" "mybucket" {
  bucket = "cloudportfolionive"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "mybucket_policy" {
  bucket = aws_s3_bucket.mybucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.mybucket.arn}/*"
      }
    ]
  })
}

# GCP Provider Configuration
provider "google" {
  credentials = file("C:/Users/NIVETHA S/AppData/Roaming/gcloud/application_default_credentials.json")
  project = "tensile-yen-448309-b0" # Replace with your GCP project ID
  region  = "us-west2"          # Replace with your preferred region
}

# GCP Storage Bucket Configuration
resource "google_storage_bucket" "mybucket" {
  name     = "cloudportfolionive"
  location = "US"               # Specify the bucket's location
  force_destroy = true          # Optional: Allows bucket deletion even if objects exist

  website {
    main_page_suffix = "index.html"
    not_found_page   = "error.html"
  }

  uniform_bucket_level_access = false # Allow for fine-grained ACLs
}

resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.mybucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers" # Makes the bucket publicly readable
}

resource "google_storage_bucket_acl" "example" {
  bucket = google_storage_bucket.mybucket.name

  predefined_acl = "publicRead"
}

resource "google_storage_bucket_iam_binding" "mybucket_binding" {
  bucket = google_storage_bucket.mybucket.name

  role = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}
