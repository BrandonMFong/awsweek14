resource "aws_cloudwatch_metric_alarm" "foobar" {
  alarm_name                = "week14-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "Errors"
  namespace                 = "AWS/Lambda"
  period                    = "120"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Alert on Lambda errors"
  alarm_actions             = [aws_sns_topic.week14-sns.arn]
  datapoints_to_alarm       = "1"
}
