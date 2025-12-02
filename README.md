# GKE Custom Image Builder - COS

This repository provides a template for building custom Container-Optimized OS (COS) images for GKE using Google Cloud Build and the COS Customizer tool.

**This is not an officially supported Google product.** This project is not eligible for the Google Open Source Software Vulnerability Rewards Program.

## Overview

By using this template, you can:

*   **Automate Image Builds:** Trigger new image builds automatically based on code changes.
*   **Ensure Consistency:** Define your image customizations declaratively.
*   **Integrate with Git:** Manage your customization scripts and configurations in Git.

This template uses:
*   **Google Cloud Build:** To execute the customization steps.
*   **`cos-customizer`:** The Google-provided tool for modifying COS images.
*   **Terraform:** To set up the Cloud Build trigger and associated service account.

## Prerequisites

*   An active Google Cloud project with billing and the Cloud Build API enabled.
*   A GitHub account.
*   Google Cloud SDK (`gcloud`) and Terraform installed locally.

## How to Use This Template

1.  **Create Your Repository:** Click the "Use this template" button on the GitHub UI to create a new repository under your own account/organization.
2.  **Clone Your Repository:** Clone your newly created repository to your local machine.
    ```bash
    git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY_NAME.git
    cd YOUR_REPOSITORY_NAME
    ```
3.  **Configure `main.tf`:** Modify the `variable` blocks in `main.tf` to match your environment, including:
    *   `project_id`: Your Google Cloud project ID.
    *   `github_owner`: Your GitHub username or organization.
    *   `github_repo_name`: The name of the repository you created.
4.  **Customize the Build:**
    *   Edit `cloudbuild.yaml` to adjust build steps and `substitutions`.
    *   **Select Base Image:** Update the `_GOLDEN_BASE_IMAGE` substitution in `cloudbuild.yaml` with an appropriate COS base image. See [TODO update once available How to Choose a Base Image] in the GKE Custom Image User Guide.
    *   Add or modify shell scripts in the `scripts/cos/` directory to apply your desired customizations (e.g., installing packages, modifying kernel settings). See the examples provided.
    *   Reference the [COS Customizer Documentation](https://cos.googlesource.com/cos/tools/+/refs/heads/master/src/cmd/cos_customizer/) for more details on available commands.
5.  **Connect to Cloud Build:** In the Google Cloud Console, go to Cloud Build > Repositories, click "Link repository," and connect your GitHub repository.
6.  **Deploy the Trigger:** Run Terraform to create the Cloud Build trigger and associated resources:
    ```bash
    terraform init
    terraform apply
    ```
7.  **Run a Build:** Navigate to Cloud Build > Triggers, find the `cos-customizer-manual-trigger`, and click "RUN" to create your custom image.

## Best Practices

*   **Base Images:** Always start from an official GKE golden COS image appropriate for your target GKE version.
*   **Idempotency:** Ensure your customization scripts are idempotent.
*   **Testing:** Thoroughly test your custom images in a non-production environment.
*   **Loadpin:** Be mindful of COS's LoadPin feature, which restricts kernel module loading. Customizations requiring new kernel modules must ensure they are placed in a trusted location, or LoadPin settings must be carefully adjusted.
*   **Vulnerability Scanning:** Integrate image scanning tools into your pipeline.

## Resources

*   [TODO: update this when the link is available GKE Custom Image User Guide]
*   [COS Customizer Documentation](https://cos.googlesource.com/cos/tools/+/refs/heads/master/src/cmd/cos_customizer/)
*   [Google Cloud Build Documentation](https://cloud.google.com/build/docs)



