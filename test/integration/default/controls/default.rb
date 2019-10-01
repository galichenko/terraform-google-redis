# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

gcloud_project = attribute('project_id', 
  { description: "The name of the project where resources are deployed. This should be passed to Terraform via environment variable" })

control "instance" do
  describe google_compute_instance(project: "#{gcloud_project}",  zone: 'us-central1-c', name: 'redis') do
    its('tag_count'){should eq 2}
    its('status') { should eq "RUNNING" }
    its('machine_type') { should match "n1-standard-1" }
  end
end