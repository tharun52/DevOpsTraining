provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.name}-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.name}-internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "public_sg" {
  name   = "${var.name}-public_sg"
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_security_group_rule" "allow-ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.public_sg.id
  cidr_blocks   = [var.mac_ip]
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}
resource "aws_security_group_rule" "allow-http" {
  type              = "ingress"
  security_group_id = aws_security_group.public_sg.id
  cidr_blocks   =  ["0.0.0.0/0"]
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
}

resource "aws_security_group_rule" "allow-all-outbound" {
  type              = "egress"
  security_group_id = aws_security_group.public_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_instance" "ec2_instance" {
  ami                    = "ami-0360c520857e3138f"
  instance_type          = "t3.micro"
  key_name               = var.name
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id] 
  associate_public_ip_address = true

  tags = {
    Name = "${var.name}-instance"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install nginx -y
    echo "<html><h1>Welcome from Tharun</h1></html>" | sudo tee /var/www/html/index.html
    sudo systemctl enable nginx
    sudo systemctl start nginx
  EOF
}


output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}
