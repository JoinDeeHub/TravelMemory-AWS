# VPC
resource "aws_vpc" "mern_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "mern-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.mern_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "mern-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.mern_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "mern-private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mern_vpc.id
}

# Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.mern_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.mern_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

# Route Table Associations
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# Security Group — Web
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.mern_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group — DB
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.mern_vpc.id

  # Allow MongoDB from Web server
  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  # Allow SSH from Web server (IMPORTANT)
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Key Pair
resource "aws_key_pair" "mern_key" {
  key_name   = "mern-key"
  public_key = file("mern-key.pub")
}

# EC2 — Web
resource "aws_instance" "web" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = aws_key_pair.mern_key.key_name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "mern-web"
  }
}

# EC2 — DB
resource "aws_instance" "db" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = aws_key_pair.mern_key.key_name

  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
    Name = "mern-db"
  }
}