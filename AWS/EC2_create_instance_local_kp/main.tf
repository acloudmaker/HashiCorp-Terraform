# See script and run mykp.sh to create key-pair before terraform apply and commands to test ssh and ping at the end
provider "aws" {
  profile    = "default"
  region     = "us-east-1"
  access_key = "Access Key ID"
  secret_key = "Secret Access Key"
}

resource "aws_key_pair" "mykp" {
  key_name   = "mykp"
  public_key = file("mykp.pub")
}

# DocRef:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
#   https://blog.jwr.io/terraform/icmp/ping/security/groups/2018/02/02/terraform-icmp-rules.html
# Use 'curl ifconfig.me' for your IP to assign to cidr_blocks below
resource "aws_security_group" "mysg" {
  name        = "mysg"
  description = "Open inbound ICMP, HTTP, HTTPS and SSH ports for connectivity"

  ingress {
    description = "Inbound ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["73.222.214.39/32"]
  }

  ingress {
    description = "Inbound SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["73.222.214.39/32"]
  }

  ingress {
    description = "Inbound HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["73.222.214.39/32"]
  }

  ingress {
    description = "Inbound HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["73.222.214.39/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name      = "MySG"
    CreatedBy = "Terraform"
  }
}


resource "aws_instance" "myec2" {
  ami           = "ami-0742b4e673072066f"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.mykp.key_name

  tags = {
    Name      = "MyEC2Server"
    CreatedBy = "Terraform"
  }

  vpc_security_group_ids = [
    aws_security_group.mysg.id
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("mykp")
    host        = self.public_ip
  }

  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_size           = 10
    volume_type           = "gp2"
    delete_on_termination = true
  }
}

output "public_dns" {
  description = "Public DNS name assigned to the EC2 instance"
  value       = aws_instance.myec2.public_dns
}

output "public_ip" {
  description = "Public IP assigned to the EC2 instance"
  value       = aws_instance.myec2.public_ip
}
