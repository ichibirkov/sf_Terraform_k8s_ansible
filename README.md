# sf_Terraform_k8s_ansible  
Все манипуляции проводились на Ubuntu 20.04.  
Перед началом убедитесь что в Вашей системе установлен Terraform и Ansible.  
Нобходимо в файл /keys/yandex.json добавить закрытый ключ для подключения к yandex cloud.

terraform create:  
terraform init  
terraform apply  

Для авторизации пользователя через SSH, необходимл добавить в конфигурационный файл Ansible - /etc/ansible/ansible.cfg, параметр host_key_checking = False.

ansible:  
	sudo ansible-playbook -i Ansible/hosts.cfg Ansible/k8s.yml  
	sudo ansible-playbook -i Ansible/hosts.cfg Ansible/master.yml  
	sudo ansible-playbook -i Ansible/hosts.cfg Ansible/worker.yml  

terraform destroy:  
terraform destroy  
