resource "aws_s3_bucket" "terraform_state" {
  bucket		  = "${var.bucket_name}"
  
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  
  ingress {
    from_port	  = 8080
    to_port	    = 8080
    protocol	  = "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami                     = "ami-785db401"
  instance_type           = "t2.micro"
  vpc_security_group_ids  = ["${aws_security_group.instance.id}"]
  
  user_data = <<-EOF
	      #!/bin/bash
	      echo "Hello, World" > index.html
	      nohup busybox httpd -f -p 8080 &
	      EOF
			  
  tags {
    Name = "terraform-example"
  }
}

resource "aws_db_instance" "example" {
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = "example_database_prod"
  username            = "admin"
  password            = "${var.db_password}"
  skip_final_snapshot = true
}
