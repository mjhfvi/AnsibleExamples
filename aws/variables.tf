## EC2 Options

# Access Information #
variable "aws_access_key" {
  default                           = ""
  description                       = "AWS Access Key Id"
}

variable "aws_secret_key" {
  default                           = ""
  description                       = "AWS Secret Key"
}

# Region Information
variable "aws_region" {
  default                           = "eu-central-1"
  description                       = "The location/region where the resources are created."
}

variable "aws_availability_zone" {
  default                           = "eu-central-1a"
  description                       = "The Availability Zone where the resources are created."
}

# Image Information
variable "aws_ami" {
  default                           = "ami-0767046d1677be5a0"
  description                       = "Amazon Machine Image"
}

variable "aws_instance_type" {
  default                           = "t2.micro"
  description                       = "T2 instances micro Free Tier, 1 vCPU, 6 CPU Credits / hour, 1 Mem (GiB), EBS-Only, Low to Moderate"
}

# SSH Information
variable "aws_public_key" {
  default                           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQf8fcdqoT07qKELqQ0HHdx/PXkvieWYPV0MfrshHdzzhWk1VOls5p0yoDEF72ENrFxATotmLvMpn94LHbFXL6+cVFhdrkLKC5gN2HPXdCloq5/UoLnsHBuj9QhqUVtATS94rt09OdKJyqzxaErOJYaxXnL10hr5YEMBFgq1sPqpcTISkvSpfk2J+D13YWFubT2792KjZu2JEk9jBjtR0b8KePhCg+7Hw9/XQtatpWLkjQVqZ1qMPUJF3iFA6kd/zF+caW+nvBIoG3utWwptIF8+/eoNEt6cUu1EODCF/JbJTjk9DGjbbAxRGtRBHyT6uVD90nBJKz6YD/USqONBMdSBSgjLR9nHsJSD1Fra7n5qNjY/reNhui1FJLpOgzMivmNxSo7xqpvyAjYZYG6HpEQrXBxnEdRfpqhMpVrJ0Q+vxMs3PqEVJRgIB5G4jf/ObymsZam5Qxf0tyuZjMAFCX8V/Fj+8nuwSyhdVos1njnW+k67ZxYAbGpGwBbabBmV8= tzahi@ansible"
  description                       = "Public Key Login to VM"
  sensitive                         = true
}

variable "ssh_key" {
  default                           = "~/.ssh/id_rsa"
  description                       = "Private SSH Key path"
}

variable "pub_ssh_key" {
  default                           = "~/.ssh/id_rsa.pub"
  description                       = "Public SSH Key path"
}

variable "aws_ami_user" {
  default                           = "ubuntu"
  description                       = "User Key Login to VM"
}
