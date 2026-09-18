output "ec2_public_ip" {
  value       = aws_instance.api_server.public_ip
  description = "IP Publico da EC2"
}

output "sqs_queue_url" {
  value       = aws_sqs_queue.pedidos_queue.url
  description = "URL da fila SQS"
}
