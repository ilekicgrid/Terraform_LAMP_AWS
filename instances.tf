resource "aws_db_instance" "tutorial_database" {
  allocated_storage      = var.settings.database.allocated_storage
  engine                 = var.settings.database.engine
  engine_version         = var.settings.database.engine_version
  instance_class         = var.settings.database.instance_class
  db_name                = var.settings.database.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.tutorial_db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.tutorial_db_sg.id]
  skip_final_snapshot    = var.settings.database.skip_final_snapshot
}

// Create an EC2 instance named "tutorial_web"
resource "aws_instance" "tutorial_web" {
  count                  = var.settings.web_app.count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.settings.web_app.instance_type
  subnet_id              = aws_subnet.tutorial_public_subnet[count.index].id
  key_name               = aws_key_pair.tutorial_kp.key_name
  vpc_security_group_ids = [aws_security_group.tutorial_web_sg.id]

  tags = {
    Name = "tutorial_web_${count.index}"
  }
}