resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.public-az1.id, aws_subnet.public-az2.id]
}
