resource "aws_vpc" "om-main" { # this is name belongs to terraform
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy
  enable_dns_hostnames = var.dns_support
  enable_dns_support = var.dns_hostnames
  tags = var.tags
}

resource "aws_subnet" "om-subnet-1" {   # public subnet
    vpc_id = aws_vpc.om-main.id # it will fetch vpc id from created above code
    cidr_block = var.cidr_block
    tags = {
        Name = "${var.name}-subnet-1"
    }
}

resource "aws_subnet" "om-subnet-2" {  # private subnet
    vpc_id = aws_vpc.om-main.id # it will fetch vpc id created from above code
    cidr_block = "10.0.0.128/25"
    tags = {
        Name = "${var.name}-subnet-2"
    }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.om-main.id

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.om-main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_eip" "om-eip" {

}
resource "aws_nat_gateway" "om-nat" {
  allocation_id = aws_eip.om-eip.id
  subnet_id     = aws_subnet.om-subnet-1.id

  tags = {
    Name = "${var.name}- nat"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.om-main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.om-nat.id
  }
  tags = {
    Name = "${var.name}-private-rt"
  }
}

resource "aws_route_table_association" "public-rt-assocation-public-subnet" {
  subnet_id      = aws_subnet.om-subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private-rt-assocaiation-priavte-subnet" {
  subnet_id      = aws_subnet.om-subnet-2.id
  route_table_id = aws_route_table.private-rt.id
}