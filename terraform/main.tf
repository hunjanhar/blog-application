# key-pair
resource "aws_key_pair" "blog-app-ec2" {
  key_name = "blog-app-ec2"
  public_key = file("blog-app-ec2.pub")
}

resource "aws_security_group" "blog_app_security_group" {
  name        = "blog-app-sg"
  vpc_id      = aws_vpc.blog_app_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8085
    to_port     = 8085
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ingress-sg" }
}

resource "aws_instance" "ubuntu" {
  subnet_id              = aws_subnet.blog_app_subnet.id
  vpc_security_group_ids = [aws_security_group.blog_app_security_group.id]
  key_name               = aws_key_pair.blog-app-ec2.key_name
  depends_on             = [aws_security_group.blog_app_security_group, aws_key_pair.blog-app-ec2]
  instance_type          = "t3.large"
  ami                    = "ami-01a00762f46d584a1"

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "ubuntu-server"
  }
}