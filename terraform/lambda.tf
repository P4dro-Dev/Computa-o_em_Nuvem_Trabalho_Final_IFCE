data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

resource "aws_lambda_function" "processar_pedidos" {
  filename         = "../lambda/function.zip"
  function_name    = "${var.project_name}-processor"
  role             = data.aws_iam_role.lab_role.arn
  handler          = "index.handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("../lambda/function.zip")
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.pedidos_queue.arn
  function_name    = aws_lambda_function.processar_pedidos.arn
  batch_size       = 1
}
