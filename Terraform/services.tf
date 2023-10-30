# Create AWS RDS
resource "aws_db_instance" "MySQL" {
  allocated_storage          = each.value.storage
  identifier                 = each.value.name
  for_each                   = var.mysql
  engine                     = "mysql"
  engine_version             = "5.7"
  instance_class             = each.value.instance_type
  username                   = "dev"
  publicly_accessible        = true
  password                   = var.mysql_pass
  parameter_group_name       = each.value.param_group
  vpc_security_group_ids     = [aws_security_group.mysql-access.id]
  skip_final_snapshot        = false
  final_snapshot_identifier  = "${each.value.name}-backup"
  deletion_protection        = true
  delete_automated_backups   = false
  auto_minor_version_upgrade = false
  apply_immediately          = true     ### WARNING!!! All changes which exec reboot MySQL server do this after terraform apply. Be careful
  tags = {
    Name        = each.value.name
    Environment = "Production"
    DC          = var.short_region
    Service     = "Infrastructure"
    Role        = "MySQl"
  }
  copy_tags_to_snapshot      = true
}
