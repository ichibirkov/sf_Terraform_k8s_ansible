# sf_Terraform_k8s_ansible


terraform create:
terraform init
terraform apply

ansible:
	ansible-playbook -i Ansible/hosts.cfg Ansible/k8s.yml
	ansible-playbook -i Ansible/hosts.cfg Ansible/master.yml
	ansible-playbook -i Ansible/hosts.cfg Ansible/workers.yml

terraform destroy:
terraform destroy
