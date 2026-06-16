# IaC-azure

Terraform configuration for the Enrich MVP (EMVP) environment on Azure. The root configuration wires together a set of local modules to build the network, compute, database, and supporting resources for the application.

State is stored in a remote Azure Storage backend, and the Azure provider is pinned to version 4.18.0.

## What gets created

The root `main.tf` calls the modules below. Each one lives under `modules/` and takes its own variables.

| Module | Resource |
|---|---|
| `azure-resource-group` | Resource group `EMVP-rg-test` in `eastus` |
| `azure-vnet` | Virtual network `EMVP-vnet-test`, address space `11.49.0.0/18` |
| `azure-subnet` | Seven subnets: webapp, sql, storage, vm, acr, bastion, waf |
| `azure-service-plan` | App Service plan, SKU `P1v2` |
| `azure-app-service` | App Service `EMVP-app-service-test` |
| `azure-sql-server` | SQL Server and database `EMVP-db-test` |
| `azure-vnet-flow-log` | VNet flow log with traffic analytics, 30-day retention |
| `azure-waf` | Application Gateway WAF (disabled by default, `count = 0`) |
| `azure-keyvault` | Key Vault (disabled by default, `count = 0`) |

The WAF and Key Vault modules ship with `count = 0`, so they are skipped until you set `count = 1`.

> Note: `main.tf` also references a `network_watcher` module at `./modules/azure-network-watcher`, but that directory is not in the repository yet. Add it or remove the block before running `terraform init`.

## Prerequisites

- Terraform 1.3 or newer
- An Azure subscription and the Azure CLI, signed in with `az login`
- Access to the backend storage account `tfmstatedata` in resource group `emvp-iac-tfm-state-data-eus-rg`

## Backend

State lives in Azure Storage. The settings are in `backend.tf`:

- Resource group: `emvp-iac-tfm-state-data-eus-rg`
- Storage account: `tfmstatedata`
- Container: `tfstate-remote-backend-modules`
- State key: `prod.modules.terraform.tfstate`

You can override any of these at init time with `-backend-config`, for example:

```bash
terraform init -backend-config="key=dev.modules.terraform.tfstate"
```

## Usage

```bash
# Download providers and connect to the remote backend
terraform init

# Review the changes before applying
terraform plan

# Apply
terraform apply
```

The flow log module reads several values from variables (`storage_account_id`, `network_security_group_id`, `log_analytics_workspace_id`, `workspace_region`, `workspace_resource_id`). Supply them through a `.tfvars` file or `-var` flags. `.tfvars` files are gitignored.

## Repository layout

```
.
├── backend.tf        # Remote state backend
├── provider.tf       # Provider and version constraints
├── main.tf           # Root config, calls the modules
├── certificate/      # Sample TLS cert for the WAF listener
└── modules/          # One directory per resource type
```

## Security notes

A few values in this repository are placeholders meant for a test environment, and they should not be used as is:

- The SQL admin credentials in `main.tf` (`admin` / `password`) are sample values. Move real credentials into Key Vault or a `.tfvars` file kept out of source control.
- The files under `certificate/` are example material, including a private key. Replace them with your own certificate and do not commit production keys.
- The subscription ID in `provider.tf` is hardcoded. Pass it through a variable or environment variable for other environments.

## Notes

`example.txt` and `create_commits.sh` are not part of the infrastructure and can be ignored when working with the Terraform configuration.
