resource "aws_iam_role" "myrole" {
  name = "myrole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "myrole"
  }
}


resource "aws_iam_instance_profile" "zentekprofile" {
  name = "zentekprofile"
  role = "${aws_iam_role.myrole.name}"
}


resource "aws_s3_bucket" "testzentekbuck" {
    bucket = "testzentekbuck" 
    acl = "private"   
}


resource "aws_iam_role_policy" "zentek_policy" {
  name = "zentek_policy"
  role = "${aws_iam_role.myrole.id}"

  policy = jsonencode({

  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": [
                "s3:DeleteObject",
                "s3:ListBucket"
               ],
        "Effect": "Deny",
        "Resource": "arn:aws:s3:::testzentekbuck"
        "Resource": "arn:aws:s3:::testzentekbuck/*"
      },
     {
        "Action": [
              "s3:GetObject",
              "s3:PutObject"
             ]
        "Effect": "Allow"
        "Resource": "arn:aws:s3:::testzentekbuck"
        "Resource": "arn:aws:s3:::testzentekbuck/*"
      }
  ]
})
}
