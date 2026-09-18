resource "aws_instance" "api_server" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = "LabInstanceProfile"

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y python3 python3-pip
    pip3 install flask boto3
    cat << 'APP' > /home/ec2-user/app.py
    ${file("../app/app.py")}
    APP
    export SQS_QUEUE_URL="${aws_sqs_queue.pedidos_queue.url}"
    echo "export SQS_QUEUE_URL=$SQS_QUEUE_URL" >> /etc/profile.d/sqs.sh
    nohup python3 /home/ec2-user/app.py > /home/ec2-user/api.log 2>&1 &
  EOF

  tags = { Name = "${var.project_name}-api-server" }
}
