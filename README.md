# Azure SQL CLI & PowerShell Scripts for Database Migrations

A collection of Azure CLI, PowerShell, and T-SQL scripts for provisioning Azure SQL databases,
migrating data with Azure Database Migration Service, and configuring security, partitioning,
replication, and performance monitoring.

## Dependencies

- [Azure CLI](https://learn.microsoft.com/cli/azure/) with the `datamigration` extension (`az extension add --name datamigration`)
- [Az PowerShell module](https://learn.microsoft.com/powershell/azure/) (`Az.Accounts`, `Az.Resources`, `Az.Sql`, `Az.DataMigration`)
- A SQL client (e.g. `sqlcmd` or SSMS) for running the `.sql` files
- An active Azure subscription

## How to Run

1. Log in: `az login` (Bash scripts) or `Connect-AzAccount` (PowerShell scripts).
2. Edit each script's placeholder values (`<YourResourceGroup>`, passwords, etc.) before running.
3. Run Bash scripts with `bash DataMigrationService.sh` / `bash deployazuredb.sh`.
4. Run PowerShell scripts with `pwsh ./deployazuredb.ps1` (or `.ps1` equivalents).
5. Run `.sql` files against your target server using `sqlcmd -S <server> -d <db> -i <file>.sql` or SSMS.

See [docs/system-design.md](docs/system-design.md) and
[docs/technical-reference-manual.md](docs/technical-reference-manual.md) for full architecture and
per-script documentation.
