## Project Description

I built this repo to **spin up a secure Azure Synapse data platform for my side projects** without the usual portal clicking, broken permissions, or DNS rabbit holes. It’s Infrastructure-as-Code (Terraform) plus optional Azure DevOps pipelines so I can go from _idea → working analytics environment_ quickly and repeatably.

---

### The problem

- Every new data idea needs the same plumbing: **RG, VNet, private endpoints/DNS, ADLS Gen2, Key Vault, Synapse, RBAC, diagnostics**.
- Hand-building that in the portal is slow, error-prone, and hard to reproduce across **dev/test/prod**.
- Security best practices (private networking, RBAC over secrets, purge protection, logging) are easy to skip when I’m prototyping.
- Synapse naming/limits and private DNS/PE wiring are… finicky.

### The solution

A **modular Terraform project** that bakes in sane defaults and guardrails:

- One **resource group** per environment (clean blast radius).
- **Networking**: VNet + subnet for **Private Endpoints**, plus **Private DNS zones/links** for Storage, Key Vault, and Synapse.
- **Storage**: ADLS Gen2 with medallion **containers** (`bronze`, `silver`, `gold`, `tmp`, `logs`) and a `synfs` workspace container.
- **Key Vault** in **RBAC mode** with **purge protection**; no inline secrets.
- **Synapse workspace** with system-assigned **Managed Identity**, **Spark pool** (autoscale), **serverless SQL**, optional **Dedicated SQL Pool**.
- **RBAC** wiring: Synapse MI → Storage Blob Data Contributor & Key Vault Secrets User.
- **Diagnostics**: Log Analytics workspace + diagnostic settings.
- **CI/CD**: Azure DevOps YAML for plan/apply with approvals.

---

### Why it helps my side projects

- **Fast start**: clone → fill `env/dev.tfvars` → `terraform apply` → done.
- **Safe by default**: private networking, RBAC, and logging without extra work.
- **Repeatable**: same code promotes to test/prod via `env/*.tfvars`.
- **Clean teardown**: destroy the RG when I’m done (KV uses soft delete for safety).

---

### What’s inside

- `modules/` — small, focused modules: `rg`, `network`, `keyvault`, `storage_adls`, `synapse`, `private_endpoints`, `diagnostics`, `role_assignments`
- `env/` — `dev.tfvars`, `test.tfvars`, `prod.tfvars` (no secrets committed)
- `pipelines/` — Azure DevOps YAML for CI plan & CD apply
- Root `main.tf`, `providers.tf`, `variables.tf`, `outputs.tf`, `backend.tf` (empty backend block)

---

### Quick start (dev)

```bash
# 0) Remote state (once)
az login && az account set --subscription "<SUB_ID>"
az group create -n iac-state-rg -l francecentral
az storage account create -g iac-state-rg -n <uniqueSA> -l francecentral --sku Standard_LRS --kind StorageV2
az storage container create --account-name <uniqueSA> -n tfstate --auth-mode login

# 1) Init backend
terraform init \
  -backend-config="resource_group_name=iac-state-rg" \
  -backend-config="storage_account_name=<uniqueSA>" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=synapse-platform-dev.tfstate"

# 2) Configure + apply
export TF_VAR_synapse_sql_admin_password='Strong#Passw0rd!123'
terraform workspace select dev || terraform workspace new dev
terraform plan   -var-file=env/dev.tfvars -out plan-dev.tfplan
terraform apply  "plan-dev.tfplan"
