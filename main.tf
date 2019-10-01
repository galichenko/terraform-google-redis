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

terraform {
  required_version = "~> 0.12.0"
}

provider "local" {
  version = "~> 1.3"
}

provider "tls" {
  version = "~> 2.0"
}

data "template_file" "metadata_startup_script" {
    template = "${file("${path.module}/bootstrap.sh")}"
    vars     = {
                port = "${var.service_port}"
    }
}

resource "google_compute_instance" "main" {
  project      = "${var.project_id}"
  name         = "redis"
  tags         = ["redis"]

  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"

  metadata                = "${var.instance_metadata}"
  metadata_startup_script = "${data.template_file.metadata_startup_script.rendered}"

  boot_disk {
    initialize_params {
      image = "${var.machine_image}"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "${var.network}"
    access_config {
     // Ephemeral IP 
    }
  }
}
