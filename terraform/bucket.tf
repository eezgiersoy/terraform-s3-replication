resource "aws_s3_bucket" "destination" {
  bucket = "arrakis-destination-v1"
}

resource "aws_s3_bucket_versioning" "destination" {
  bucket = aws_s3_bucket.destination.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "source" {
  provider = aws.west
  bucket   = "arrakis-source-v1"
}

#resource "aws_s3_bucket_acl" "source_bucket_acl" {
#  provider = aws.west
#
#  bucket = aws_s3_bucket.source.id
#  acl    = "private"
#}

resource "aws_s3_bucket_versioning" "source" {
  provider = aws.west

  bucket = aws_s3_bucket.source.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  provider = aws.west
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.source]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.source.id


  rule {
    delete_marker_replication {
      status = "Disabled"
    }
    filter {
      prefix = "data/"
    }

    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }
  }
}