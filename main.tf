resource "aws_s3_bucket" "saibucket" {
  bucket = "bucketsai258"

}


resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.saibucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.saibucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.saibucket.id

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

  bucket = aws_s3_bucket.saibucket.id
  acl    = "public-read"
}
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.saibucket.id
  key    = "index.html"
  source = "index.html"
    acl          = "public-read"
  content_type = "text/html"
}


resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.saibucket.id

  index_document {
    suffix = "index.html"
  }
 depends_on = [ aws_s3_bucket_acl.example ]
  #   error_document {
  #     key = "error.html"
  #   }

}