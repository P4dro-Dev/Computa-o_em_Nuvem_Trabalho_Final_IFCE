resource "aws_sqs_queue" "pedidos_queue" {
  name                       = "pedidos-a-processar"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400
}
