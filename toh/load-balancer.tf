resource "aws_security_group" "devops_lb_sg_toh_backend" {
  name   = "devops-lb-sg-toh-backend"
  vpc_id = aws_vpc.devops_vpc_toh.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "devops_lb_sg_toh_frontend" {
  name   = "devops-lb-sg-toh-frontend"
  vpc_id = aws_vpc.devops_vpc_toh.id

  ingress {
    from_port   = 80
    to_port     = 80 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "devops_lb_toh_backend" {
  name               = "devops-lb-toh-backend"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.devops_lb_sg_toh_backend.id ]
  subnets = [ 
      aws_subnet.devops_vpc_toh_subnet_1.id,
      aws_subnet.devops_vpc_toh_subnet_2.id
  ]
}

resource "aws_lb" "devops_lb_toh_frontend" {
  name               = "devops-lb-toh-frontend"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.devops_lb_sg_toh_frontend.id ]
  subnets = [ 
      aws_subnet.devops_vpc_toh_subnet_1.id,
      aws_subnet.devops_vpc_toh_subnet_2.id
  ]
}

resource "aws_lb_listener" "devops_lb_listener_toh_backend" {
  load_balancer_arn = aws_lb.devops_lb_toh_backend.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops_lb_tg_toh_backend.arn
  }
}

resource "aws_lb_listener" "devops_lb_listener_toh_frontend" {
  load_balancer_arn = aws_lb.devops_lb_toh_frontend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops_lb_tg_toh_frontend.arn
  }
}

resource "aws_lb_target_group" "devops_lb_tg_toh_frontend" {
  name        = "devops-lb-tg-toh-frontend"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.devops_vpc_toh.id
}

resource "aws_lb_target_group" "devops_lb_tg_toh_backend" {
  name        = "devops-lb-tg-toh-backend"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.devops_vpc_toh.id
}