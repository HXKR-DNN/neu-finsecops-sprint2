resource "aws_vpc" "main" { cidr_block = "10.20.0.0/16" tags = { Name = "${var.project}-vpc" } }
resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.main.id cidr_block = "10.20.1.0/24" availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
  tags = { Name = "${var.project}-public-a" }
}
