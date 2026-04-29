# 🚀 S3 Static Website Hosting using Terraform Modules with GitHub Actions CI/CD

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS S3](https://img.shields.io/badge/AWS_S3-FF9900?style=for-the-badge&logo=amazons3&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![IaC](https://img.shields.io/badge/IaC-Modular-4CAF50?style=for-the-badge)

---

## 📌 Project Overview

This project demonstrates how to host a **static website on AWS S3** using a **modular Terraform architecture** and a fully automated **GitHub Actions CI/CD pipeline**.

Rather than writing all Terraform resources in a single flat file, this project follows the **Terraform Modules** pattern — a best practice used in production-grade DevOps teams. The infrastructure is broken into a reusable child module, which is called from a clean root configuration. Every push to the `main` branch triggers the GitHub Actions pipeline, which automatically provisions or updates the AWS infrastructure — zero manual steps required.

**This project showcases:**
- Real-world modular Terraform design for maintainable, scalable IaC
- End-to-end CI/CD automation with GitHub Actions
- AWS S3 static website hosting, fully configured via code
- Remote backend setup for safe Terraform state management

---

## 🏗️ Architecture

```
 👨‍💻 Developer (Local Machine)
         │
         │  git push
         ▼
 ┌────────────────────┐
 │    GitHub Repo     │
 │  (Source of Truth) │
 └─────────┬──────────┘
           │  Triggers CI/CD pipeline on push to main
           ▼
 ┌────────────────────────────────────┐
 │        GitHub Actions              │
 │        CI/CD Pipeline              │
 │                                    │
 │  ① Checkout Code                   │
 │  ② Configure AWS Credentials       │
 │  ③ terraform init                  │
 │  ④ terraform plan                  │
 │  ⑤ terraform apply                 │
 └─────────┬──────────────────────────┘
           │  Provisions Infrastructure
           ▼
 ┌────────────────────────────────────┐
 │            AWS Cloud               │
 │                                    │
 │   Root Module (main.tf)            │
 │        │                           │
 │        │ calls                     │
 │        ▼                           │
 │   Child Module (module/)           │
 │        │                           │
 │        │ creates                   │
 │        ▼                           │
 │   ┌─────────────────┐              │
 │   │    S3 Bucket    │              │
 │   │ (Static Website │              │
 │   │    Hosting)     │              │
 │   └─────────────────┘              │
 └────────────────────────────────────┘
           │
           ▼
  🌐 Public S3 Website URL
```

**Key Design Decision — Modular Terraform:**
The infrastructure logic is implemented using a reusable Terraform module inside the module/ directory. The root main.tf calls this module and passes input variables, keeping the root configuration clean and maintainable. This structure also makes it easy to extend the setup for multiple environments in the future.

---

## 🛠️ Tech Stack

| Technology | Role |
|---|---|
| **AWS S3** | Hosts the static website files with public website endpoint |
| **Terraform (Modules)** | Provisions all AWS infrastructure as reusable, versioned code |
| **GitHub Actions** | Automates the full Terraform deploy pipeline on every push |
| **HTML / CSS** | Static website content served from S3 |

---

## ✨ Features

- 🧩 **Modular Infrastructure** — Terraform child module encapsulates all S3 resources for clean separation of concerns
- 🔄 **Automated CI/CD** — GitHub Actions runs `init → plan → apply` automatically on every push to `main`
- ♻️ **Reusable & Scalable Code** — The S3 module can be reused across multiple environments by passing different variables
- 📜 **Version-Controlled Infrastructure** — Every infrastructure change is tracked in Git history, enabling rollback and auditability
- 🌍 **Public Static Website Hosting** — Website is publicly accessible via the S3 website endpoint URL
- 🔐 **Remote Backend** — Terraform state is stored remotely (S3 + DynamoDB) for team safety and consistency
- 🔒 **GitHub Secrets** — AWS credentials are stored securely and never hardcoded

---

## 📁 Project Structure

```
s3-static-website-terraform-modules/
│
├── 📁 .github/
│   └── 📁 workflows/
│       └── 📄 pipeline.yaml        # GitHub Actions CI/CD pipeline definition
│
├── 📁 WebSite/
│   └── 📄 index.html               # Static website HTML content
│
├── 📁 module/                       # Reusable Terraform child module
│   ├── 📄 main.tf                  # S3 bucket resource definitions (core logic)
│   ├── 📄 variable.tf              # Input variables accepted by the module
│   └── 📄 output.tf                # Outputs exposed by the module (e.g., website URL)
│
├── 📄 main.tf                      # Root config — calls the child module
├── 📄 provider.tf                  # AWS provider and region configuration
├── 📄 backend.tf                   # Remote backend (S3 + DynamoDB for state management)
├── 📄 variable.tf                  # Root-level input variables
├── 📄 output.tf                    # Root-level outputs (website URL, bucket name)
├── 📄 .terraform.lock.hcl          # Provider version lock file (committed to Git)
├── 📄 .gitignore                   # Excludes .terraform/, *.tfstate, secrets from Git
└── 📄 README.md                    # Project documentation
```

### File Responsibilities at a Glance

| File | Purpose |
|---|---|
| `.github/workflows/pipeline.yaml` | Defines the automated CI/CD pipeline steps |
| `WebSite/index.html` | The actual static website served from S3 |
| `module/main.tf` | Creates the S3 bucket, configures static hosting and bucket policy |
| `module/variable.tf` | Declares inputs the module expects (e.g., bucket name, tags) |
| `module/output.tf` | Returns values from the module (e.g., website endpoint URL) |
| `main.tf` | Root entry point — calls the module and passes variable values |
| `provider.tf` | Configures the AWS provider and target region |
| `backend.tf` | Configures remote state storage in S3 with DynamoDB locking |
| `variable.tf` | Root-level variable declarations |
| `output.tf` | Prints key information (website URL) after `terraform apply` |
| `.terraform.lock.hcl` | Locks provider versions for reproducible builds |
| `.gitignore` | Prevents sensitive or generated files from being committed |

---

## 🧩 Terraform Module Explanation

### Why Use Modules?

In a flat Terraform setup, all resources are written in a single `main.tf`. This works for small projects but quickly becomes messy and hard to reuse. **Modules solve this** by grouping related resources into a self-contained, reusable unit — similar to a function in programming.

### How It Works in This Project

```
Root Configuration              Child Module
──────────────────              ─────────────────────────────────────
main.tf                         module/main.tf
 └── module "s3_website" {       └── resource "aws_s3_bucket" ...
       source      = "./module"  └── resource "aws_s3_bucket_website_configuration" ...
       bucket_name = var.name    └── resource "aws_s3_bucket_policy" ...
     }
```

The **root `main.tf`** acts as the caller — it references the module, passes in variables, and receives outputs. The **child module** in `module/` contains all the actual AWS resource definitions and has no knowledge of the outside world — it only works with the inputs it receives.

### Benefits of This Approach

| Benefit | Description |
|---|---|
| ♻️ **Reusability** | Call the same module multiple times with different variables to create dev/prod environments |
| 🧼 **Clean Code** | Root configuration stays minimal; complexity is encapsulated in the module |
| 📦 **Scalability** | Easily add new modules (e.g., CloudFront, Route 53) without touching existing code |
| 🤝 **Team Collaboration** | Different team members can work on different modules independently |
| ✅ **Testability** | Modules can be tested and validated in isolation |

---

## ⚙️ Setup Instructions

### Prerequisites

Ensure the following are installed and configured before proceeding:

- ✅ [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.5.0)
- ✅ [AWS CLI](https://aws.amazon.com/cli/) with valid credentials configured
- ✅ A GitHub account with repository access

---

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/Mohan41204/S3-Static-Website-Hosting.git
cd S3-Static-Website-Hosting
```

### 2️⃣ Configure AWS Credentials Locally

```bash
aws configure
# Provide: AWS Access Key ID, Secret Access Key, Default Region
```

### 3️⃣ Initialise Terraform

Downloads the required providers and sets up the remote backend:

```bash
terraform init
```

> ⚠️ Make sure your remote backend S3 bucket and DynamoDB table already exist before running `init`. Update `backend.tf` with your bucket name and DynamoDB table name.

### 4️⃣ Preview Infrastructure Changes

Review what Terraform will create or modify:

```bash
terraform plan
```

Terraform will show a detailed breakdown of all resources the module will create.

### 5️⃣ Apply Infrastructure

Provision the AWS resources:

```bash
terraform apply
```

Type `yes` when prompted. After completion, the S3 website URL will be displayed in the output.

### 6️⃣ Add GitHub Secrets for CI/CD

To allow GitHub Actions to authenticate with AWS, add these secrets to your GitHub repository:

**Settings → Secrets and variables → Actions → New repository secret**

| Secret | Description |
|---|---|
| `MY_ARN` | GitHub Actions uses OpenID Connect (OIDC) to securely authenticate with AWS without storing long-term credentials. Push to `main` (or open a PR) — the pipeline handles everything from there.


---

## 🔄 CI/CD Workflow

The pipeline is defined in `.github/workflows/pipeline.yaml` and triggers automatically on every push to the `main` branch.

```yaml
on:
  push:
    branches: [main]
    paths:                 
      - '**.tf'
      - '**.tfvars'
      - '**.tfvars.json'
      - '.terraform.lock.hcl'
      - '.github/workflows/terraform.yml'
  pull_request:
    branches: [main]

permissions:
  id-token: write
  contents: read

jobs:
  Testing_Terraform_code:
    name: Testing terraform code
    runs-on: ubuntu-latest

    steps:
      - name: Check out code
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.MY_ARN }}
          aws-region: ap-south-1

      - name: Install TFLint
        run: |
          curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

      - name: Run TFLint
        run: tflint

      - name: Terraform Init
        run: terraform init -input=false

      - name: Terraform Validate
        run: terraform validate

      - name: Terraform Plan
        run: terraform plan -out=tfplan -input=false

      - name: Upload Terraform Plan
        uses: actions/upload-artifact@v4
        with:
          name: tfplan
          path: tfplan

  Creating_Infra:
    name: AWS infrastructure creation
    needs: Testing_Terraform_code
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'

    steps:
      - name: Check out code
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.MY_ARN }}
          aws-region: ap-south-1

      - name: Download Terraform Plan
        uses: actions/download-artifact@v4
        with:
          name: tfplan

      - name: Terraform Init
        run: terraform init -input=false

      - name: Terraform Apply
        run: terraform apply -input=false tfplan
```

### Pipeline Stages Explained

| Stage                         | What It Does                                                                        |
| ----------------------------- | ----------------------------------------------------------------------------------- |
| **Checkout Code**             | Pulls the latest Terraform code from the repository into the GitHub Actions runner  |
| **Setup Terraform**           | Installs and configures the Terraform CLI in the runner environment                 |
| **Configure AWS Credentials** | Authenticates securely with AWS using OIDC and GitHub Secrets (IAM Role assumption) |
| **Install TFLint**            | Installs TFLint to analyze Terraform code for best practices and potential issues   |
| **Run TFLint**                | Lints the Terraform code to catch errors and enforce standards                      |
| **Terraform Init**            | Initializes Terraform, downloads providers, and connects to the backend             |
| **Terraform Validate**        | Validates the Terraform configuration syntax and structure                          |
| **Terraform Plan**            | Generates an execution plan and saves it as an artifact (`tfplan`)                  |
| **Upload Terraform Plan**     | Stores the generated plan file for use in the next job                              |
| **Download Terraform Plan**   | Retrieves the saved execution plan in the deployment job                            |
| **Terraform Apply**           | Applies the saved plan to provision or update AWS infrastructure                    |

💡 Pro Tip: You’ve already implemented a strong practice by separating testing (lint + validate + plan) and deployment (apply) into two jobs. To make it production-grade, you can add a manual approval step (using environments in GitHub Actions) before the `Terraform Apply` stage to avoid accidental infrastructure changes.
---

## 🌐 Output

After a successful apply — either locally or via GitHub Actions — Terraform prints the website URL:

```
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

website_url = "http://your-bucket-name.s3-website-us-east-1.amazonaws.com"
```

You can also retrieve the output at any time by running:

```bash
terraform output website_url
```

Open the URL in your browser to view the live static website. 🎉

---

## 📸 Screenshots

> _Add your own screenshots to the `screenshots/` folder and update the paths below._

| GitHub Actions — Pipeline Success | Live S3 Static Website |
|---|---|
| ![CI/CD Pipeline](./screenshots/pipeline-success.png) | ![S3 Website](./screenshots/website-output.png) |

> 📝 **Tip:** Fork this repo, add your AWS secrets, push a commit to `main`, and watch the pipeline run live in the Actions tab.

---

## 🔮 Future Improvements

| Enhancement | Description | AWS Service |
|---|---|---|
| ☁️ **CDN Layer** | Serve content globally with low latency and caching | AWS CloudFront |
| 🌍 **Custom Domain** | Map a professional domain name (e.g., `www.mysite.com`) | AWS Route 53 |
| 🔒 **HTTPS / SSL** | Enable secure `https://` access with a free managed certificate | AWS ACM |
| 📊 **Monitoring & Logging** | Track website traffic, errors, and access patterns | AWS CloudWatch + S3 Access Logs |
| 🌿 **Multi-Environment** | Deploy separate `dev`, `staging`, and `prod` stacks | Terraform Workspaces |
| 🧪 **Terraform Validation** | Add `terraform fmt` and `terraform validate` checks to the pipeline | GitHub Actions |

---

## 👨‍💻 Author

**Mohankumar U**

- 🐙 [GitHub](https://github.com/mohan41204)
- 💼 [LinkedIn](https://www.linkedin.com/in/mohandevop)

> _Open to collaboration and feedback! Feel free to fork the repo, open an issue, or connect on LinkedIn._

---


<div align="center">

⭐ **Found this useful? Drop a star to support the project!** ⭐

*Built with ❤️ using Terraform Modules · AWS S3 · GitHub Actions*

</div>
