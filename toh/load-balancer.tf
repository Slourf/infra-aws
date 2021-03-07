resource "aws_security_group" "sg_lb_backend" {
  name   = "${var.app_name}-sg-lb-backend"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = var.backend_port
    to_port     = var.backend_port
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

resource "aws_security_group" "sg_lb_frontend" {
  name   = "${var.app_name}-sg-lb-frontend"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = var.frontend_port
    to_port     = var.frontend_port
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

resource "aws_lb" "lb_backend" {
  name               = "${var.app_name}-lb-backend"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.sg_lb_backend.id ]
  subnets = [ 
      aws_subnet.vpc_subnet_1.id,
      aws_subnet.vpc_subnet_2.id
  ]
}

resource "aws_lb" "lb_frontend" {
  name               = "${var.app_name}-lb-frontend"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.sg_lb_frontend.id ]
  subnets = [ 
      aws_subnet.vpc_subnet_1.id,
      aws_subnet.vpc_subnet_2.id
  ]
}

resource "aws_lb_listener" "lb_listener_backend" {
  load_balancer_arn = aws_lb.lb_backend.arn
  port              = var.backend_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_backend.arn
  }
}

resource "aws_lb_listener" "lb_listener_frontend" {
  load_balancer_arn = aws_lb.lb_frontend.arn
  port              = var.frontend_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_frontend.arn
  }
}

resource "aws_lb_target_group" "lb_tg_frontend" {
  name        = "${var.app_name}-lb-tg-frontend"
  port        = var.frontend_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_lb_target_group" "lb_tg_backend" {
  name        = "${var.app_name}-lb-tg-backend"
  port        = var.backend_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
}