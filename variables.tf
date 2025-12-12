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

# variables.tf

# This file defines the input variables for the Terraform module.

# ------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ------------------------------------------------------------------------------

variable "project_id" {
  description = "The GCP project ID where the custom image will be created."
  type        = string
  # This must be provided by the user, e.g., in terraform.tfvars.

}

variable "github_owner" {
  description = "Your GitHub username or organization name."
  type        = string
}

variable "github_repo_name" {
  description = "The name of your GitHub repository for this project."
  type        = string
}

# ------------------------------------------------------------------------------
# OPTIONAL VARIABLES with DEFAULTS
# ------------------------------------------------------------------------------

variable "region" {
  description = "The GCP region to run Cloud Build and store artifacts."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone to run the temporary VM for image creation."
  type        = string
  default     = "us-central1-a"
}

variable "source_image" {
  description = "The source GKE COS image to customize. [TODO update this once available. link for details on how to select a suitable image."
  type        = string
  default     = "gke-1341-gke1829001-cos-125-19216-0-94-c-nvda"
}

variable "source_image_project" {
  description = "The project where the source GKE COS image resides."
  type        = string
  default     = "gke-node-images"
}

variable "target_image_name" {
  description = "The name for the output custom image."
  type        = string
  default     = "my-gke-custom-cos"
}

variable "target_image_family" {
  description = "The image family for the output custom image."
  type        = string
  default     = "my-gke-custom-cos-family"
}

variable "trigger_name" {
  description = "The name for the Cloud Build trigger. Must be unique."
  type        = string
  default     = "gke-cos-customizer-trigger"
}
