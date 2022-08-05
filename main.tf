resource "aws_vpc" "lakshay_vpc" {
  cidr_block           = "10.252.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "terraform_vpc"
  }
}

resource "aws_subnet" "lakshay_public_subnet" {
  vpc_id                  = aws_vpc.lakshay_vpc.id
  cidr_block              = "10.252.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "terraform_public_subnet"
  }
}
resource "aws_subnet" "lakshay_private_subnet" {
  vpc_id                  = aws_vpc.lakshay_vpc.id
  cidr_block              = "10.252.2.0/24"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "terraform_private_subnet"
  }
}

resource "aws_internet_gateway" "lakshay_internet" {
  vpc_id = aws_vpc.lakshay_vpc.id
  tags = {
    Name = "terraform igw"
  }
}

  
resource "aws_route_table" "lakshay_public_rt" {
  vpc_id = aws_vpc.lakshay_vpc.id

  tags = {
    Name = "terraform_public_rt"
  }
}
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.lakshay_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lakshay_internet.id
}


resource "aws_route_table_association" "lakshay_public_assoc" {
  subnet_id      = aws_subnet.lakshay_public_subnet.id
  route_table_id = aws_route_table.lakshay_public_rt.id
}

resource "aws_security_group" "lakshay_sg" {
  name        = "terraform-sg"
  description = "created using terraform"
  vpc_id      = aws_vpc.lakshay_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#To launch ec2 instance
resource "aws_instance" "lakshay_instance" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = var.test
  vpc_security_group_ids = [aws_security_group.lakshay_sg.id]
  subnet_id              = aws_subnet.lakshay_public_subnet.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "terraform-server-3"
  }
  
 # provisioner "local-exec" {
   # command = templatefile("${var.host_os}-ssh-config.tpl", {
    #  hostname     = self.public_ip,
    #  user         = "ubuntu",
     # identityfile = "~/.ssh/lakshaykey"
   # })
   # interpreter = [
    #  "Powershell",
     # "-Command"
   # ]
 # }

}
