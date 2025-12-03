# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# outputs.tf

# This file defines the outputs of the Terraform module.

output "cloud_build_trigger_name" {
  description = "The name of the Cloud Build trigger created for the image pipeline."
  value       = google_cloudbuild_trigger.cos_customizer_trigger.name
}

output "service_account_email" {
  description = "The email of the service account used by the Cloud Build trigger."
  value       = google_service_account.cos_build_trigger_sa.email
}
