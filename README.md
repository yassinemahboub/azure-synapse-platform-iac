## Project Description

I built this repo to stand up a **secure, tidy Azure Synapse data platform** for my side projects without getting lost in portal clicks or half-remembered DNS/RBAC settings. It’s pure **Terraform** (with optional Azure DevOps pipelines), so I can go from idea → working environment in minutes and recreate the same thing for dev, test, or prod without surprises.

---

### The problem I wanted to solve

Every new analytics experiment needed the same plumbing: a resource group, a VNet, private endpoints and DNS zones, an ADLS Gen2 account, a Key Vault, a Synapse workspace with Spark, some RBAC, and diagnostics. Doing that by hand is slow and error-prone. It’s also easy to cut corners on security (“I’ll lock it down later”) when I’m just prototyping. I wanted something I could trust on day one and promote later with confidence.

---

### Medallion architecture (and how this repo sets it up)

This project follows the **Medallion** pattern to keep ingest-through-consumption clean and trustworthy:

- **Bronze** — raw, immutable landings from sources (keep schema-on-read; never rewrite history).
- **Silver** — validated and standardized data (fixed types, de-duplicated, light conformance).
- **Gold** — curated, consumption-ready marts (business views, dimensional models, KPI tables).
- **tmp** — ephemeral scratch/checkpoints (safe place for Spark/ELT working sets).
- **logs** — job/audit/lineage outputs.

#### What’s created automatically

When you apply Terraform, the **ADLS Gen2** module creates **one filesystem (container) per layer**:

```text
adls:
├─ bronze
├─ silver
├─ gold
├─ tmp
└─ logs
```

By default, **no subfolder scaffolding** is created. That stays with your data jobs (Synapse pipelines/Spark notebooks), so the infra layer doesn’t guess your domain design. If you later want a standard tree (e.g., `year=YYYY/month=MM/day=DD`), you can add it in your ELT code or extend the storage module.

#### How it maps to Synapse

- **Spark** transforms typically read **bronze** → write **silver** → publish **gold**.
- **Serverless SQL** can query parquet in bronze/silver when you don’t need a curated table.
- **Dedicated SQL Pool** (optional) is for stable, high-concurrency **gold** surfaces.

A simple flow:

1. Land raw files in **bronze** (append-only).
2. Spark notebooks validate/clean and write to **silver** (overwrite by partition).
3. Aggregate to **gold** for BI/ML serving (Parquet or Dedicated SQL tables).
4. Use **tmp** for checkpoints or shuffle data, and **logs** for job/audit output.

#### Customizing the layers

You can change which layers exist without touching module code — just override the `lake_filesystems` input:

```hcl
module "storage" {
  source              = "./modules/storage_adls"
  resource_group_name = module.rg.name
  location            = var.location
  name_prefix         = var.name_prefix
  environment         = var.environment
  tags                = var.tags

  # Add/remove layers to fit your needs
  lake_filesystems = ["bronze", "silver", "gold", "tmp", "logs"]
}
```
---

### The Global Approach

This project treats the platform like a product:

- **Small, focused modules** (network, storage, key vault, synapse, private endpoints, diagnostics, RBAC) that compose cleanly.
- **Private by default**: services are reachable through Private Endpoints with Private DNS; public access is off where it makes sense.
- **Identity over secrets**: the Synapse workspace runs with a system-assigned Managed Identity; role assignments grant least-privilege access to ADLS and Key Vault.
- **Observability from the start**: a Log Analytics workspace collects diagnostic signals so I can see what’s actually happening.
- **Environment files** (`env/dev.tfvars`, etc.) hold the knobs; the code stays the same.

I kept it opinionated enough to be safe, but not so rigid that it gets in the way.

---

### How I run it day-to-day

I change a few values in `env/dev.tfvars`, set one secret as an environment variable, and let Terraform do the rest. The exact same code promotes to test or prod by switching the tfvars file. When I’m done with a spike, I can destroy the resource group and leave no loose ends (Key Vault is soft-deleted by design, so I can recover if needed).

---

### Security posture (in plain English)

Traffic goes through **Private Endpoints** and is resolved by **Private DNS**. **Public access is disabled** where supported. Secrets live in **Key Vault** under **RBAC**, not hard-coded in Terraform. The Synapse workspace uses **Managed Identity**, so there are no storage keys floating around. **Diagnostics** stream to Log Analytics so I can audit and alert.

---

### Cost posture

Defaults are conservative: **serverless SQL** and an autoscaling **Spark** pool; **Dedicated SQL Pool** is off in dev/test. Storage replication is **GZRS** by default and can be dialed down to **LRS** per environment. Log Analytics keeps **30 days** of data unless I choose otherwise.

---

### Getting started (dev)

1. **Bootstrap remote state** (once):
   ```bash
   az login
   az account set --subscription "<SUB_ID>"

   RG=iac-state-rg; LOC=francecentral; SA=<uniqueSA>; CONTAINER=tfstate
   az group create -n $RG -l $LOC
   az storage account create -g $RG -n $SA -l $LOC --sku Standard_LRS --kind StorageV2 --min-tls-version TLS1_2
   az storage container create --account-name $SA -n $CONTAINER --auth-mode login

   terraform init \
     -backend-config="resource_group_name=$RG" \
     -backend-config="storage_account_name=$SA" \
     -backend-config="container_name=$C_
