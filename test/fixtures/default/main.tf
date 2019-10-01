/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "random" {
  version = "~> 2.0"
}

provider "local" {
  version = "~> 1.3"
}

provider "tls" {
  version = "~> 2.0"
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "gce-keypair-pk" {
  content  = tls_private_key.main.private_key_pem
  filename = "${path.module}/sshkey"
}

resource "google_compute_firewall" "ci-allow-ssh" {
  name                    = "ci-allow-ssh"
  project                 = var.project_id
  network                 = var.network
  priority                = "1000"

  source_ranges           = ["0.0.0.0/0"]
  target_tags             = ["redis"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

} 

resource "google_compute_firewall" "ci-allow-redis" {
  name                    = "ci-allow-redis"
  project                 = var.project_id
  network                 = var.network
  priority                = "1000"

  source_ranges           = ["0.0.0.0/0"]
  target_tags             = ["redis"]

  allow {
    protocol = "tcp"
    ports    = [var.service_port]
  }

}

module "example" {
  source       = "../../../examples/simple_example"
  project_id   = var.project_id
  network      = var.network
  service_port = var.service_port

  instance_metadata = {
     sshKeys = "ubuntu:${tls_private_key.main.public_key_openssh}"
  }

}

resource "null_resource" "wait_for_instance" {
  triggers = {
    always_run = uuid()
  }

  provisioner "remote-exec" {
    script = "${path.module}/wait-for-instance.sh"

    connection {
      type                = "ssh"
      user                = "ubuntu"
      host                = module.example.external_ip
      private_key         = tls_private_key.main.private_key_pem
    }
  }
}