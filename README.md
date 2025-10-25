# NeuFinance Sprint 2 IaC

This repository contains the Infrastructure as Code (IaC) assets for NeuFinance an original and proprietary Cloud native SOCaaS Capstone , for phase 3 of The Knowledge House Cybersecurity Fellowship. The IaC was developed using Terraform to provision and manage cloud infrastructure securely and efficiently.

Overview
The purpose of this repository is to demonstrate the implementation and evidence of Terraform-based infrastructure deployment within the NeuFinance project environment.

All configuration files within the `IaC/` directory define, provision, and manage AWS resources relevant to the Sprint 2 deliverables.

Repository Structure

| File | Description |
|------|--------------|
| `main.tf` | Root module configuration — defines the core resources for the environment. |
| `providers.tf` | Specifies cloud providers, authentication methods, and backend configuration. |
| `variables.tf` | Defines all input variables for parameterizing Terraform configurations. |
| `outputs.tf` | Captures and outputs key deployment results after `terraform apply`. |
| `opensearch.tf` | Contains configurations for AWS OpenSearch or related service deployments. |

Terraform Execution Evidence

This repository also serves as the evidence submission for Sprint 2 Terraform activity.  
The following artifacts demonstrate IaC execution and validation:

**`terraform init`** — Backend initialization and provider download logs.  
**`terraform plan`** — Execution plan output showing intended infrastructure changes.  
**`terraform apply`** — Evidence of successful deployment, including resource creation details.  
**State files (`terraform.tfstate`, `terraform.tfstate.backup`)** — Managed and version-controlled securely.

Objective
- Apply Infrastructure as Code principles using Terraform.
- Demonstrate repeatable, version-controlled environment deployment.
- Provide compliance evidence for sprint-based DevSecOps delivery.

Notes
- Terraform version: `>= 1.6`
- Provider: `AWS`
- Execution environment: CI/CD pipeline
- All sensitive variables are stored securely and not committed to the repository.

Author
Canary - NeuFinance Owner/CEO
The Knowledge House
Phase 3 Capstone
Sprint 2 – Infrastructure as Code (IaC) Evidence Repository  
