provider "aws" {
  profile = "devops"
  region  = "us-east-1"
  shared_credentials_file = "/home/rafael/.aws/credentials"
}

resource "aws_instance" "Windows2019" {
  ami           = "ami-077f1edd46ddb3129"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.my-key.key_name}"
  security_groups = ["${aws_security_group.allow_winrm_http.name}","${aws_security_group.allow_winrm_https.name}","${aws_security_group.allow_rdp.name}"]
  tags = {
    Name = "Windows2019"
  }
}

resource "aws_key_pair" "my-key" {
  key_name = "my-key"
  public_key = "${file("/home/rafael/terraform/aws.pub")}"

}

resource "aws_security_group" "allow_winrm_http" {
  name        = "allow_winrm_http"
  description = "Allow WinRM porta 5985 http"

  ingress {
    description      = "wimrm"
    from_port        = 5985
    to_port          = 5985
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_winrm_http"
  }
}

resource "aws_security_group" "allow_winrm_https" {
  name        = "allow_winrm_https"
  description = "Allow WinRM porta 5986 https"

  ingress {
    description      = "wimrm"
    from_port        = 5986
    to_port          = 5986
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_winrm_https"
  }
}

resource "aws_security_group" "allow_rdp" {
  name        = "allow_rdp"
  description = "Allow rdp porta 3389"

  ingress {
    description      = "rdp"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_rdp"
  }
}

output "Windows2019_public_dns" {
  value = "${aws_instance.Windows2019.public_dns}"
}