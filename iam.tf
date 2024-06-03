resource "aws_iam_policy" "gluepolicy" {
  name = "gluepolicy"
  policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*",
                "glue:*",
                "iam:ListRolePolicies",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "cloudwatch:PutMetricData",
                "logs:*"                
            ],
            "Resource": "*"
        }
    ]
}
  )
}
resource "aws_iam_role" "gluerole" {
  name               = "gluerole"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "glue.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

// EVENTBRIDGE IAM ROLE POLICY
resource "aws_iam_policy" "eventbridge_invoke_step_function_policy" {
  name = "tokyo_eventbridge_invoke_step_function"
  policy = jsonencode(
{
    "Version": "2012-10-17",
    "Statement": [
	{
         "Effect": "Allow",
            "Action": [
                "*"
            ],
            "Resource": "*"
     }  
    ]
  })
}

resource "aws_iam_role" "eventbridge_invoke_step_function_role" {
  name = "eventbridge_invoke_step_function_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "states.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_stepfunction_policy_to_eventbridge" {
  name = "attach_stepfunction_policy_to_eventbridge"
  roles = [aws_iam_role.eventbridge_invoke_step_function_role.name]
  policy_arn = aws_iam_policy.eventbridge_invoke_step_function_policy.arn
}

resource "aws_iam_role" "cloudtrail_cloudwatch_events_role" {
  name               = "cloudtrail_cloudwatch_events_role"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "aws_iam_role_policy_cloudTrail_cloudWatch" {
  name = "cloudTrail-cloudWatch-policy"
  role = aws_iam_role.cloudtrail_cloudwatch_events_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailCreateLogStream2014110",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream"
            ],
            "Resource": [
                "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*"
            ]
        },
        {
            "Sid": "AWSCloudTrailPutLogEvents20141101",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
                "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*"
            ]
        }
    ]
}
EOF
}
#Creating a IAM role for Eventbridge
resource "aws_iam_role" "eventbridge_role" {
  name               = "Eventbridgerole"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "events.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

#To create a Eventbridge policy
/*resource "aws_iam_policy" "eventbridge_policy" {     
  policy = data.aws_iam_policy_document.test.json
}

#To Attach the Eventbridge policy to the Eventbridge
resource "aws_iam_role_policy_attachment" "eventbridge_policy_attachment" {  
  role = aws_iam_role.eventbridge_role.name
  policy_arn = aws_iam_policy.eventbridge_policy.arn
}*/
resource "aws_iam_role_policy" "eventbridge_policy" {
  name = "eventbridge-cloudWatch-policy"
  role = aws_iam_role.eventbridge_role.id 
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSEventbridgeCreateLogStream",
            "Effect": "Allow",
            "Principal":
                {
                    "Service":
                    [
                        "events.amazonaws.com",
                        "delivery.logs.amazonaws.com"
                    ]
                },
                "Action": 
                [
                  "logs:*"
                ],
                #"Resource": 
                #    "${aws_cloudwatch_log_group.eventbridge_log_group.arn}:*"
                "Resource": "arn:aws:logs:ap-northeast:590183849298:log-group:/*:*"
                 ]
        }
    ]
}
EOF
}