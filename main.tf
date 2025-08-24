resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
}

resource "aws_subnet" "sub01" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-2a"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "sub02" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-2b"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "myRT" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "rt1" {
    subnet_id = aws_subnet.sub01.id
    route_table_id = aws_route_table.myRT.id
  
}

resource "aws_route_table_association" "rt2" {
    subnet_id = aws_subnet.sub02.id
    route_table_id = aws_route_table.myRT.id
}

resource "aws_security_group" "mysg1" {
  name        = "mysg1"
  description = "Allow TCP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress { 
    description = "HTTP from VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress { 
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}

resource "aws_s3_bucket" "mys3bucket" {
    bucket = "anirbansbucketqedwdwd"
}

resource "aws_instance" "server1" {
    ami = "ami-07891c5a242abf4bc"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.mysg1.id]
    subnet_id = aws_subnet.sub01.id 
    user_data = base64encode(file("userdata.sh"))
}

resource "aws_instance" "server2" {
    ami = "ami-07891c5a242abf4bc"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.mysg1.id]
    subnet_id = aws_subnet.sub02.id 
    user_data = base64encode(file("userdata.sh"))
}

