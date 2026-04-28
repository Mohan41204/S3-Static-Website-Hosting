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
 │  ① Checkout Code                  │
 │  ② Configure AWS Credentials      │
 │  ③ terraform init                 │
 │  ④ terraform plan                 │
 │  ⑤ terraform apply                │
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
The infrastructure logic lives inside `module/`, making it reusable across multiple environments (dev, staging, prod). The root `main.tf` simply calls the module and passes in variables — keeping the root layer clean and the module self-contained.

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

- ✅ [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.0 or later)
- ✅ [AWS CLI](https://aws.amazon.com/cli/) with valid credentials configured
- ✅ A GitHub account with repository access

---

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/your-username/s3-static-website-terraform-modules.git
cd s3-static-website-terraform-modules
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

| Secret Name | Value |
|---|---|
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key ID |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key |

---

## 🔄 CI/CD Workflow

The pipeline is defined in `.github/workflows/pipeline.yaml` and triggers automatically on every push to the `main` branch.

```yaml
name: Terraform CI/CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  terraform-deploy:
    name: Deploy Infrastructure
    runs-on: ubuntu-latest

    steps:
      - name: 📥 Checkout Code
        uses: actions/checkout@v3

      - name: 🔐 Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: ⚙️ Terraform Init
        run: terraform init

      - name: 🔍 Terraform Plan
        run: terraform plan

      - name: 🚀 Terraform Apply
        run: terraform apply -auto-approve
```

### Pipeline Stages Explained

| Stage | What It Does |
|---|---|
| **Checkout Code** | Pulls the latest code from the repository into the runner |
| **Configure AWS Credentials** | Authenticates securely with AWS using GitHub Secrets |
| **Terraform Init** | Initialises providers and connects to the remote backend |
| **Terraform Plan** | Generates an execution plan — shows what will change |
| **Terraform Apply** | Applies the plan and provisions/updates AWS infrastructure |

> 💡 **Pro Tip:** For production pipelines, separate `plan` and `apply` into two jobs with a manual approval step between them to prevent unintended infrastructure changes.

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

**Your Name**

- 🐙 [GitHub](https://github.com/your-username)
- 💼 [LinkedIn](https://linkedin.com/in/your-profile)

> _Open to collaboration and feedback! Feel free to fork the repo, open an issue, or connect on LinkedIn._

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

<div align="center">

⭐ **Found this useful? Drop a star to support the project!** ⭐

*Built with ❤️ using Terraform Modules · AWS S3 · GitHub Actions*

</div>
