
resource "aws_db_instance" "genie-poc-sql" {
  instance_class          = "${var.db_instance}"
  engine                  = "mysql"
  engine_version          = "8.0"
  multi_az                = true
  storage_type            = "gp2"
  allocated_storage       = 20
  name                    = "genietestrds"
  username                = "Genieadmin"
  password                = "ofvDSiggRI5t0Dcf"
  skip_final_snapshot     = true
  db_subnet_group_name    = "${aws_db_subnet_group.genie-rds-db-subnet.name}"
  vpc_security_group_ids  = ["${var.rds_sg}"]
}

resource "aws_db_subnet_group" "genie-rds-db-subnet" {
  name       = "genie-rds-db-subnet"
  subnet_ids = ["${var.rds_subnet1}", "${var.rds_subnet2}"]
}








/*resource "aws_security_group" "genie-rds-sg" {
  vpc_id = "${var.vpc_id}"


 ingress {
    description      = "allow ssh traffic"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = ["${var.ec2_sg}"]
 
 }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
}
*/
