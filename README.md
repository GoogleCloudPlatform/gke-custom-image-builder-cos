# GKE Custom Image Builder - COS

This repository provides a template for building custom Container-Optimized OS (COS) images for GKE using Google Cloud Build and the COS Customizer tool.

**Disclaimer: This is not an officially supported Google product.** This project is not eligible for the Google Open Source Software Vulnerability Rewards Program.

## Overview

By using this template, you can:

*   **Automate Image Builds:** Trigger new image builds automatically based on code changes.
*   **Ensure Consistency:** Define your image customizations declaratively for consistent and repeatable builds.
*   **Integrate with Git:** Manage your customization scripts and configurations in a Git repository, providing versioning and a clear audit trail.

This template uses:
*   **Google Cloud Build:** A service that executes your builds on Google Cloud Platform's infrastructure.
*   **`cos-customizer`:** The Google-provided tool specifically for modifying Container-Optimized OS images.
*   **Terraform:** An infrastructure-as-code tool to set up the Cloud Build trigger and associated service account.

## Prerequisites

*   Obtain the “GKE Custom Image Builder Toolkit” user guide from your Google Cloud Technical Account Manager.
*   An active Google Cloud project with billing and the Cloud Build API enabled.
*   A GitHub account.
*   Google Cloud SDK (`gcloud`) and Terraform installed locally.

## How to Use This Template

1.  **Create Your Repository from this Template**

    *   Click the **Use this template** button at the top right of this page.
        *   `https://github.com/GoogleCloudPlatform/your-repo-name` (Replace `your-repo-name` with the actual repository name once it's public).
    *   Select **Create a new repository**.
    *   Follow the prompts to name your new repository and create it in your account or organization.

2.  **Connect Your GitHub Repository to Google Cloud Build**

    **Important:** You must authorize Cloud Build to access your new repository before running Terraform.

    *   **This is a crucial manual step.** Before running Terraform, you must authorize Cloud Build to access your new repository.
    *   Go to `https://console.cloud.google.com/cloud-build/triggers;region=global/connect?project=<PROJECT_ID_OR_NUMBER>`
        *   Follow the on-screen instructions to connect your new GitHub respository. Skip the optional "Create a trigger" step.
        *   Alernatively, navigate to the Cloud Build **Triggers** page in the Google Cloud Console and click **Connect repository**.
        *   Note that this is using Cloud Build Respositories 1st gen.
    *   Once the repository is connected, do not create a trigger in the console.
        *   The console may prompt you to create a trigger immediately after connection. Skip this step.
        *   You only need to establish the connection; the Terraform script in Step 6 will automatically create the correct trigger for you.

3.  **Clone Your Repository**

    *   Now that the repository is created and connected, bring it to your local machine to configure it:

    ```bash
    git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY_NAME.git
    cd YOUR_REPOSITORY_NAME
    ```

4.  **Configure Your Environment**

    *   In your local repository directory, create a `terraform.tfvars` file with the following content, **replacing the placeholder values** with your own details:

    ```terraform
    project_id       = "your-gcp-project-id"
    github_owner     = "your-github-username-or-org"
    github_repo_name = "your-github-repo-name"

    # Note: The target_image_name must include the substring "cos".
    target_image_name = "my-gke-custom-cos-image"


    # Optional: Specify a network and subnet for the *final image build step* in the *cloudbuild.yaml* file
    # If not specified, the 'default' VPC network and an auto-selected subnet will be used.
    ```

5.  **Customize the Build**

    *   **Select Base Image:** Update the `source_image` variable in your `terraform.tfvars` or `variables.tf` file with an appropriate GKE golden COS base image. Refer to the official GKE Custom Image User Guide (TODO: update this when the link is available) for details on how to choose a base image.
    *   **Modify Customization Scripts:** Add or modify shell scripts in the `scripts/cos/` directory to apply your desired customizations (e.g., installing packages, modifying kernel settings). See the `setup.sh` example provided. If you add new scripts, you will also need to update `cloudbuild.yaml` to include them as new `run-script` steps.
    *   Reference the [COS Customizer Documentation](https://cos.googlesource.com/cos/tools/+/refs/heads/master/src/cmd/cos_customizer/) for more details on available commands.
    *   **Commit and Push:**
    ```bash
    git add .
    git commit -m "Configure build and add customizations"
    git push origin main
    ```

6.  **Initialize and Deploy Terraform**

    *   Now that the repository connection exists and your environment is configured, run Terraform to create the Cloud Build trigger and associated resources:

    ```bash
    terraform init
    terraform apply
    ```

7.  **Run a Build**

    *   Push a commit to the `main` branch of your repository to trigger a build, or navigate to Cloud Build > Triggers, find the trigger named `gke-cos-customizer-trigger` (or your custom `trigger_name`), and click "RUN" to create your custom image.

8.  **Use Your Custom Image**

    *   Once the build is complete, you can use your custom image to create a new GKE node pool. The image will be named according to the `target_image_name` and `target_image_family` variables you configured.

## Best Practices

*   **Base Images:** Always start from an official GKE golden COS image appropriate for your target GKE version.
*   **Idempotency:** Ensure your customization scripts are idempotent (running them multiple times produces the same result).
*   **Testing:** Thoroughly test your custom images in a non-production environment before deploying to production.
*   **Loadpin:** Be mindful of COS's LoadPin feature, which restricts kernel module loading. Customizations requiring new kernel modules must ensure they are placed in a trusted location, or LoadPin settings must be carefully adjusted.
*   **Vulnerability Scanning:** Integrate image scanning tools into your pipeline to check for known vulnerabilities.

## Resources

*   [COS Customizer Documentation](https://cos.googlesource.com/cos/tools/+/refs/heads/master/src/cmd/cos_customizer/)
*   [Google Cloud Build Documentation](https://cloud.google.com/build/docs)
