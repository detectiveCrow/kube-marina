locals {
  ami           = "ami-09d3b3274b6c5d4aa" # Amazon Linux 2 AMI (us-east-1)
  instance_type = "t3.small"
  key_name      = "lhs-test"
}

####################
# Instance Profile #
####################
resource "aws_iam_instance_profile" "bastion" {
  name = "${var.init_project}-${var.init_environment}-eks-bastion"
  role = data.terraform_remote_state.cluster.outputs.aws_iam_role.bastion.id
}

##################
# Security Group #
##################
resource "aws_security_group" "bastion-sg" {
  name   = "${var.init_project}-${var.init_environment}-eks-bastion"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "${var.init_project}-${var.init_environment}-eks-bastion"
  }
}

#######
# EIP #
#######
resource "aws_eip" "bastion" {
  vpc = true
}

resource "aws_eip_association" "bastion" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion.id
}

############
# Instance #
############
resource "aws_instance" "bastion" {
  ami           = var.bastion_ami
  instance_type = var.bastion_instance_type

  key_name             = var.bastion_keyname
  subnet_id            = element(data.terraform_remote_state.vpc.outputs.public_subnet_ids, 0)
  iam_instance_profile = aws_iam_instance_profile.bastion.name

  security_groups = [aws_security_group.bastion-sg.id]

  tags = {
    "Name" = "${var.init_project}-${var.init_environment}-eks-bastion"
  }

  user_data = <<EOF
      #! /bin/bash

      # Install Kubectl
      curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
      install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
      kubectl version --client

      # Install Helm
      curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
      chmod 700 get_helm.sh
      ./get_helm.sh
      helm version

      # Install AWS
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip awscliv2.zip
      ./aws/install
      aws --version

      # Add the kube config file 
      mkdir /home/ec2-user/.kube
      echo "${data.terraform_remote_state.cluster.outputs.kubeconfig}" >> /home/ec2-user/.kube/config
  EOF
}
