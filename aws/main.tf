############################################################################################################
## Terraform Script to setup "Ubuntu Server 20.04 LTS" VM on AWS,
# Build AWS Access Key and add it to variables.tf file
# Terraform  initialize the Environment, "terraform init"
# Terraform Check Script Before Run, "terraform plan" or Use "terraform plan -out terraform_plan_Backup.tfplan"
# Terraform Run Script, "terraform apply" Or Use "terraform apply terraform_plan_Backup.tfplan" Without Approval Promote for Automation
# Terraform Destroy Environment, "terraform destroy" Or Use "terraform destroy -auto-approve" Without Approval Promote for Automation
############################################################################################################


provider "aws" {
  profile			= "default"
  region			= var.aws_region
  access_key		= var.aws_access_key
  secret_key		= var.aws_secret_key
}

resource "aws_instance" "my_instance" {
  ami                           = var.aws_ami
  instance_type                 = var.aws_instance_type
  associate_public_ip_address   = true
  key_name                      = "key_pair_test"
  
# Run Commands in VM with user_data Script
  #user_data                    = "${file("install.sh")}"
  vpc_security_group_ids        = [aws_security_group.allow_http.id, aws_security_group.allow_ssh.id]

 connection {
    type     = "ssh"
	port     = 22
    host     = self.public_ip
    user     = var.aws_ami_user
    private_key = "${file(var.ssh_key)}"
    agent = false
    timeout = "2m"
  }
  
# Run Local Commands in VM with local-exec provisioner # 
 #provisioner "local-exec" {
    #command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install.yml '--key-file=${var.ssh_key}' -i '${self.public_ip},'"
    #command = "ansible-playbook install.yml --key-file=~/.ssh/id_rsa -i 192.168.50.81,"
    #command = "echo hello"

# Run Remote Commands in VM with remote-exec provisioner#  
 #provisioner "remote-exec" {
 #   inline = [
 #     "sudo curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -",
 #     "echo deb [ arch=amd64 ] https://apt.releases.hashicorp.com $(lsb_release -cs) main | sudo tee /etc/apt/sources.list.d/hashicorp.list",
 #     #"sudo apt-get update",
 #     #"sudo apt-get install -y ansible nomad consul"
 #     ]
 # }
}

resource "null_resource" "sleep" {
  provisioner "local-exec" {
    command      = "sleep 15"
  }
  depends_on = [aws_instance.my_instance]
}

resource "null_resource" "ansible" {
  provisioner "local-exec" {
      # Run Ansible File from Local Folder
    #command      = "ansible-playbook install.yml '--key-file=${var.ssh_key}' -i '${aws_instance.my_instance.public_ip},'"
      # Run Ansible File From Github Repository
    command      = "wget https://raw.githubusercontent.com/mjhfvi/Ansible-Examples/main/aws/install.yml && ansible-playbook install.yml '--key-file=${var.ssh_key}' -i '${aws_instance.my_instance.public_ip},'"
  }
  depends_on = [null_resource.sleep]
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic"

 ingress {
   description = "HTTP"
   from_port   = 8080
   to_port     = 8080
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
 
resource "aws_security_group" "allow_ssh" {
 name        = "allow_ssh"
 description = "Allow SSH traffic"

 ingress {
   description = "SSH"
   from_port   = 22
   to_port     = 22
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

 resource "aws_key_pair" "ssh-key" {
  key_name   = "key_pair_test"
  public_key = var.aws_public_key
}

# Add Elastic IP Address
#resource "aws_eip" "my_subnet" {
#  vpc      = true
#  instance = aws_instance.my_instance.id
#}


## Output Information to Terminal ##
output "Public_IP_Address" {
  value                             = aws_instance.my_instance.public_ip
  description                       = "Public IP Address of Instance"
}

output "Public_DNS_Address" {
  value                             = aws_instance.my_instance.public_dns
  description                       = "Public IP Address of Instance"
}

#output "Public_Elastic_IP_Address" {
#  value                             = aws_eip.my_subnet.public_ip
#  description                       = "Public Elastic IP Address of Instance"
#}