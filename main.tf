resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "public1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id 
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.myrt.id 
}

resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_route_table.myrt.id 
}

resource "aws_security_group" "mysg" {
  name = "mysg"
  description = "allow http traffic"
  vpc_id = aws_vpc.myvpc.id 

  ingress {
    description = "allow inbound http"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow outbound"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2a" {
  ami = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id = aws_subnet.public1.id 
  user_data = base64encode(file("userdata.sh"))
}

resource "aws_instance" "ec2b" {
  ami = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id = aws_subnet.public2.id 
  user_data = base64encode(file("userdata1.sh"))
}

resource "aws_lb" "myalb" {
  name = "myalb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.mysg.id]
  subnets = [aws_subnet.public1.id, aws_subnet.public2.id]
}

resource "aws_lb_target_group" "mytg" {
  name = "lb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_lb_target_group_attachment" "attch1" {
  target_group_arn = aws_lb_target_group.mytg.arn
  target_id = aws_instance.ec2a.id 
  port = 80
}

resource "aws_lb_target_group_attachment" "attch2" {
  target_group_arn = aws_lb_target_group.mytg.arn
  target_id = aws_instance.ec2b.id 
  port = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.mytg.arn 
  }
}

output "lbdns" {
  value = aws_lb.myalb.dns_name 
}