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

