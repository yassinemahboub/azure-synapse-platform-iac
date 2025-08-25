## Project Description

This repository contains Infrastructure-as-Code (IaC) for building a **secure, production-ready Azure Synapse data platform** using Terraform and Azure DevOps.

The project automates deployment of all critical components needed for a modern analytics environment:

- **Resource Group** dedicated to the platform
- **Networking** with VNet, subnet for private endpoints, and private DNS zones
- **ADLS Gen2 Storage** with medallion containers (`bronze`, `silver`, `gold`, `tmp`, `logs`) and a `synfs` workspace container
- **Azure Key Vault** in RBAC mode with purge protection
- **Azure Synapse Workspace** with managed identity, Spark pool (autoscale), serverless SQL, and optional Dedicated SQL Pool
- **Private Endpoints** for Storage, Key Vault, and Synapse (dev/sql)
- **Role Assignments** (Synapse MI → Storage Blob Contributor, Key Vault Secrets User)
- **Log Analytics Workspace** with diagnostic settings for observability
- **Azure DevOps Pipelines** for CI/CD (plan + apply)

### Key Features
- **Private networking by default** (public access disabled where possible)  
- **Managed Identity** end-to-end, no secrets in code  
- **Environment-specific configuration** via `env/dev.tfvars`, `env/test.tfvars`, `env/prod.tfvars`  
- **Remote state** stored in Azure Storage with locking and versioning  
- **CI/CD ready** with YAML pipelines for plan/apply gated by approvals  

### Use Cases
- Provision dev/test/prod Synapse platforms consistently
- Enforce security best practices (private endpoints, RBAC, purge protection)
- Automate deployments as part of a broader data platform strategy
- Enable analytics teams to focus on workloads instead of infra setup

---
