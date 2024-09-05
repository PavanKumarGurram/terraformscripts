resource "aws_instance" "web" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t3.micro"
  # Specify the key pair to be used for SSH
  key_name               = "demp"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "HelloWorld"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/demp.pem")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "state.tf"
    destination = "/tmp/state.tf"
  }

  provisioner "local-exec" {
    command = "echo The servers IP address is ${self.public_ip}"
  }


  provisioner "remote-exec" {

    inline = [
      "sudo apt-get update -y",          # Update package lists
      "sudo apt-get install -y apache2", # Install Apache
      "sudo systemctl start apache2",    # Start Apache
      "sudo systemctl enable apache2"    # Enable Apache to start on boot
    ]
  }
}