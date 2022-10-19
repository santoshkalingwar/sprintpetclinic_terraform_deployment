resource "aws_security_group" "AllowAll" {
  name        = "Webserverfromterraform"
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "Webserver ports enabled"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Webserver ports enabled"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Webserver ports enabled"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Webserverports"
  }
}

resource "aws_instance" "Springpetclinic" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.AllowAll.id]
  key_name = "demo"
    tags = {
    Name = "SpringpetclinicVM2"
  }
  connection {
        user        = "ubuntu"
        host        = self.public_ip
        private_key = "${file("./demo.pem")}"
    }

 provisioner "file" {
    source      = "playbook.yaml"
    destination = "/home/ubuntu/playbook.yaml"
  }

provisioner "file" {
    source      = "springpetclinic.service"
    destination = "/home/ubuntu/springpetclinic.service"
  }

  provisioner "remote-exec" {
        inline = [
            "sudo apt-add-repository ppa:ansible/ansible -y",
           "sudo apt-get update",
            "sudo apt-get install ansible -y",
             "sudo ansible-playbook playbook.yaml"


            ]
    }
}

