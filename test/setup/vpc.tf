resource "google_compute_network" "default" {
  name                    = "default"
  project                 = module.project.project_id

  auto_create_subnetworks = true
}
