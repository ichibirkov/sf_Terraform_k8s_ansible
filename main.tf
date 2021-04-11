terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  service_account_key_file = "./keys/yandex.json"
  cloud_id  = "b1g6m1qcj9fs4jkutujn"
  folder_id = "b1gq7mq809hm9ip47f1m"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "k8s-vm1" {
  name = "master-node"
  resources {
    cores  = 4
    memory = 4
    core_fraction  = 20
  }
  boot_disk {
    initialize_params {
      # ubuntu 20-04
      image_id  = "fd81d2d9ifd50gmvc03g"
      size = "10"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "k8s-vm2" {
  name = "worker-node"
  resources {
    cores  = 4
    memory = 4
    core_fraction  = 20
  }
  boot_disk {
    initialize_params {
      # ubuntu 20-04
      image_id  = "fd81d2d9ifd50gmvc03g"
      size = "10"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_master_node" {
  value = yandex_compute_instance.k8s-vm1.network_interface.0.ip_address
}

output "internal_ip_address_worker_node" {
  value = yandex_compute_instance.k8s-vm2.network_interface.0.ip_address
}

output "external_ip_address_master_node" {
  value = yandex_compute_instance.k8s-vm1.network_interface.0.nat_ip_address
}

output "external_ip_address_worker_node" {
  value = yandex_compute_instance.k8s-vm2.network_interface.0.nat_ip_address
}

# creating inventories for Ansible

resource "local_file" "ansible_cfg" {
  content = templatefile("${path.module}/templates/ansible.tpl",
    {
      master_k8s = yandex_compute_instance.k8s-vm1.network_interface.0.nat_ip_address
      worker_k8s = yandex_compute_instance.k8s-vm2.network_interface.0.nat_ip_address
    }
  )
  filename = "../ansible/ansible.cfg"
}
