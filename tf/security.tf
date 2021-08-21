# Access analyser check if external access outside organisation
resource "aws_accessanalyzer_analyzer" "AccessAnalyzer" {
  analyzer_name = "AccessAnalyzer"
  type = "ACCOUNT"
}

# Turn on s3 block public access
resource "aws_s3_account_public_access_block" "BlockPublicAccess" {
  block_public_acls = "true"
  ignore_public_acls = "true"
  block_public_policy = "true"
  restrict_public_buckets = "true"
}

#Encrypt EBS by default using aws managed key
data "aws_kms_key" "aws_managed_key" {
  key_id = "alias/aws/ebs"
}
resource "aws_ebs_encryption_by_default" "EbsDefaultEncryption" {
  enabled = true
}
resource "aws_ebs_default_kms_key" "EbsDefaultEncryption" {
  key_arn = data.aws_kms_key.aws_managed_key.arn
}
