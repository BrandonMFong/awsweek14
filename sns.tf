# Week 12
resource "aws_sns_topic" "week14-sns" {
  name              = "week14-sns"
  # kms_master_key_id = "ECE592"
}

resource "aws_sns_topic_subscription" "week14-sns-mail" {
  topic_arn = aws_sns_topic.week14-sns.id
  protocol  = "email"
  endpoint  = "fong.m.brandon97@gmail.com"
}

