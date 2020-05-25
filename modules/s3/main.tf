# S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  acl    = "private"
  tags = {
    Name = var.bucket_name
  }
}

# Add content to bucket
resource "null_resource" "add_src_to_s3" {
  triggers = {
    build_number = "${timestamp()}" # run it all times
  }
  provisioner "local-exec" {
    command = "aws s3 sync ${var.path_folder_content} s3://${var.bucket_name}/"
  }
  depends_on = [aws_s3_bucket.my_bucket]
}