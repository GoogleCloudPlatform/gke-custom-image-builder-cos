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

# main.tf

# This Terraform configuration sets up a Cloud Build trigger to create custom GKE COS images.

# Create a random suffix to ensure the bucket name is unique
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create a GCS bucket to store build scripts and artifacts
resource "google_storage_bucket" "cos_imagebuild_bucket" {
  project                     = var.project_id
  name                        = "${var.project_id}-cos-imagebuild-${random_id.bucket_suffix.hex}"
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = false
}

# Create a dedicated service account for the Cloud Build trigger
resource "google_service_account" "cos_build_trigger_sa" {
  project      = var.project_id
  account_id   = "gke-cos-build-trigger-sa"
  display_name = "GKE COS Customizer Cloud Build Trigger Service Account"
}

# Grant necessary IAM roles to the service account for Cloud Build operations
resource "google_project_iam_member" "cos_build_trigger_sa_roles" {
  for_each = toset([
    "roles/cloudbuild.builds.builder",
    "roles/compute.admin",
    "roles/storage.admin",
    "roles/iam.serviceAccountUser",
    "roles/iap.tunnelResourceAccessor"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.cos_build_trigger_sa.email}"

  depends_on = [google_service_account.cos_build_trigger_sa]
}

# Create the Cloud Build trigger
resource "google_cloudbuild_trigger" "cos_customizer_trigger" {
  project         = var.project_id
  name            = var.trigger_name
  filename        = "cloudbuild.yaml"
  service_account = google_service_account.cos_build_trigger_sa.id

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      branch = "^main$"
    }
  }

  substitutions = {
    _GCS_BUCKET                = google_storage_bucket.cos_imagebuild_bucket.name
    _GOLDEN_BASE_IMAGE         = var.source_image
    _GOLDEN_BASE_IMAGE_PROJECT = var.source_image_project
    _TARGET_IMAGE_NAME        = var.target_image_name
    _TARGET_IMAGE_FAMILY      = var.target_image_family
    _ZONE                     = var.zone
  }
}
