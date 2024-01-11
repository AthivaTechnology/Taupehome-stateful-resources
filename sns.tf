resource "aws_sns_topic" "leadgen_sns_topic" {
  name       = "${local.app}-leadgen-sns-topic"
  fifo_topic = false
}
resource "aws_sns_topic_subscription" "leadgen_sns_topic_target" {
  topic_arn = aws_sns_topic.leadgen_sns_topic.arn
  protocol  = local.sns_subscription_protocol
  endpoint  = local.sns_subscription_endpoint

}