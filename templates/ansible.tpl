[masters]
master ansible_host=${master_k8s}

[workers]
worker ansible_host=${worker_k8s}

[all:vars]
ansible_user=ubuntu
ansible_python_interpreter=/usr/bin/python3