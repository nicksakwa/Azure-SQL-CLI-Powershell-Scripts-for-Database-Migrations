# Technical Reference Manual

This document explains every script, function, and SQL command in the repository. It is intended
to onboard new engineers so they can understand what each file does, what Azure/SQL Server features
it depends on, and how the pieces fit into the overall migration/security/monitoring workflow.

---

## 1. Root Scripts

### `DataMigrationService.sh` (Azure CLI, Bash)
Uses the `az datamigration` command group (requires `az extension add --name datamigration`, seen
at the top of the file) to drive the Azure Database Migration Service (DMS).

| Command | Purpose |
|---|---|
| `az extension add --name datamigration` | Installs the ADMS CLI extension. |
| `az datamigration sql-service create` | Creates a DMS service instance in a resource group/location. |
| `az datamigration sql-server-schema --action "MigrateSchema"` | Migrates schema only (no data) from a source SQL Server connection string to a target Azure SQL connection string. |
| `az datamigration sql-db create` | Starts a full database migration (all tables) from source to target, supplying source/target connection auth, encryption, and TLS options, scoped to the target server resource ID and DMS service ID. |
| `az datamigration sql-db create --table-list ...` | Same as above but restricts migration to specific tables (`--table-list`). |
| `az datamigration sql-db show --expand "MigrationStatusDetails"` | Polls detailed migration status. |
| `az datamigration sql-db wait --created` | Blocks the calling shell/pipeline until the migration resource reaches "created" state. |
| `az datamigration sql-db cancel --migration-operation-id` | Cancels an in-progress migration by operation ID. |

### `DataMigrationService.ps1` (PowerShell, `Az.DataMigration` module)
PowerShell equivalent of the above using the `New-AzDataMigrationToSqlDb` cmdlet.

- `ConvertTo-SecureString` — converts the plain-text placeholder passwords into `SecureString`
  objects required by the cmdlet's `-SourceSqlConnectionPassword` / `-TargetSqlConnectionPassword`
  parameters.
- `New-AzDataMigrationToSqlDb` — single call (split across backtick-continued lines) that performs
  the same full-database migration as `az datamigration sql-db create`. Parameters mirror the CLI
  flags 1:1 (`-ResourceGroupName`, `-SqlDbInstanceName`, `-TargetDbName`, `-SourceDatabaseName`,
  `-SourceSqlConnection*`, `-TargetSqlConnection*`, `-Scope`, `-MigrationService`).
- Second `New-AzDataMigrationToSqlDb` call adds `-TableList` to restrict the migration to
  `Person.Person` and `Person.EmailAddress`, mirroring the CLI `--table-list` example.

### `armtemplatedeployment.ps1` (PowerShell + ARM template)
Interactively prompts for deployment parameters, then deploys a SQL logical server via an ARM
Quickstart Template.

- `Read-Host -Prompt` (x4) — collects `$projectName`, `$location`, `$adminUser`, and
  `$adminPassword` (the last one with `-AsSecureString` so it isn't echoed/logged in plain text).
- `$resourceGroupName = "${projectName}rg"` — derives a resource group name from the project name.
- `New-AzResourceGroup -Name -Location` — creates the resource group.
- `New-AzResourceGroupDeployment -TemplateUri ... -administratorLogin -administratorLoginPassword`
  — deploys the public `sql-logical-server/azuredeploy.json` Quickstart template into that resource
  group, passing through the collected admin credentials.
- `Read-Host -Prompt "Press [ENTER] to continue ..."` — simple pause so the console output can be
  reviewed before the script/window closes.

### `deployazuredb.ps1` (PowerShell, `Az.Sql` module)
End-to-end provisioning script for a sample Azure SQL Database.

- Variables: `$SubscriptionId`, `$resourceGroupName` (suffixed with `Get-Random` for uniqueness),
  `$location`, `$adminSqlLogin`, `$password`, `$serverName`, `$databaseName`, `$startIp`/`$endIp`.
- `Set-AzContext -SubscriptionId` — selects the active Azure subscription for the session.
- `New-AzResourceGroup` — creates the resource group.
- `New-AzSqlServer -SqlAdministratorCredentials $(New-Object ... PSCredential ...)` — creates the
  logical SQL server, building a `PSCredential` in-line from the admin login and a
  `ConvertTo-SecureString`-wrapped password.
- `New-AzSqlServerFirewallRule -StartIpAddress -EndIpAddress` — opens a firewall rule (defaults to
  `0.0.0.0`-`0.0.0.0`, i.e. no external IP allowed by default — must be edited per environment).
- `New-AzSqlDatabase -RequestedServiceObjectiveName "S0" -SampleName "AdventureWorksLT"` — creates
  an S0-tier database pre-loaded with the AdventureWorksLT sample schema/data.

### `deployazuredb.sh` (Azure CLI, Bash equivalent of `deployazuredb.ps1`)

| Command | Purpose |
|---|---|
| `az account set --subscription` | Selects the active subscription. |
| `az group create` | Creates the resource group (`$resourceGroupName`, `$location`). |
| `az sql server create --admin-user --admin-password` | Creates the logical SQL server; password generated via `` `openssl rand -base64 16` ``. |
| `az sql server firewall-rule create -n AllowYourIp` | Adds a firewall rule for `$startip`-`$endip`. |
| `az sql db create --sample-name AdventureWorksLT` | Creates the sample database. |

### `backup-restoredb.sql` (T-SQL)
- `BACKUP DATABASE ... TO URL='...' WITH COPY_ONLY` — backs up a database directly to an Azure Blob
  Storage container without breaking the existing backup chain (`COPY_ONLY`).
- `RESTORE DATABASE ... FROM URL='...'` — restores a database from that blob backup, e.g. into an
  Azure SQL Managed Instance.
- Dynamic SQL example (`SELECT 'BACKUP DATABASE' + name + ...`) — illustrates generating one
  `BACKUP DATABASE` statement per row of `sys.databases`; note the sample text has a syntax typo
  (`TO DISK=` is not valid as written inside a string concatenation) and is illustrative only, not
  meant to be executed as-is.

### `partition.sql` (T-SQL)
- `CREATE PARTITION FUNCTION PartitionByMonth (datetime2) AS RANGE RIGHT FOR VALUES (...)` —
  defines 13 partitions bounded by the first day of each month in 2021.
- `CREATE PARTITION SCHEME PartitionByMonthSch AS PARTITION PartitionByMonth TO (FILEGROUP1..13)` —
  maps each of the 13 partitions to its own filegroup.
- `CREATE TABLE Order (...) ON PartitionByMonthSch (OrderDate)` — creates a table physically
  partitioned by `OrderDate` using the scheme above.

---

## 2. `DatabaseAuthentication-Security/`

### `CreateUser.sql`
- `CREATE USER [dba@contoso.com] FROM EXTERNAL PROVIDER` — creates an Azure AD (Entra ID)-backed
  database user (works against Azure SQL, not on-prem SQL Server).
- `CREATE LOGIN ... WITH PASSWORD` / `CREATE USER ... FOR LOGIN` — classic SQL-authentication login
  and mapped database user.
- `CREATE USER ... WITH PASSWORD` (x2) + `CREATE ROLE [SalesReader]` + `ALTER ROLE ... ADD MEMBER`
  + `GRANT SELECT ON SCHEMA::Sales` — demonstrates role-based access control: two users added to a
  custom role that is granted `SELECT` on the `Sales` schema.
- `CREATE OR ALTER PROCEDURE Sales.DemoProc` — a stored procedure joining
  `Production.Products`/`Sales.SalesOrderDetail`/`Sales.SalesOrderHeader` to report total sales per
  product/order date.
- `EXECUTE AS USER = 'DP300User1'` / `EXEC Sales.DemoProc` — impersonates a specific user to verify
  the procedure/query runs correctly under that user's granted permissions.

### `TDEkeys.sql`
Sets up Transparent Data Encryption (TDE):
1. `CREATE MASTER KEY ENCRYPTION BY PASSWORD` (in `master`) — root of the server's encryption
   hierarchy.
2. `CREATE CERTIFICATE MyServerCert` — server-level certificate protected by the master key.
3. `CREATE DATABASE ENCRYPTION KEY ... ENCRYPTION BY SERVER CERTIFICATE MyServerCert` — per-database
   encryption key protected by that certificate.
4. `ALTER DATABASE [TDEdemo] SET ENCRYPTION ON` — enables encryption-at-rest for the database.

### `dynamicsqlexecprocedurs.sql`
- `CREATE OR ALTER PROCEDURE Sales.DemoProc` builds a T-SQL string in `@sqlstring` and executes it
  via `EXEC sp_executesql @sqlstring` — the "safe-ish" dynamic SQL pattern (still string-built here,
  but executed through `sp_executesql` rather than raw `EXEC`). Contrast with the intentional
  anti-pattern in `sqlinjectionexample.sql`.
- `EXECUTE AS USER = 'DP300User1'; EXEC Sales.DemoProc;` — runs the procedure impersonating a
  specific user to check permission boundaries.

### `purview.sql`
- `CREATE USER <purview-account> FROM EXTERNAL PROVIDER` — creates an Azure AD identity for the
  Microsoft Purview scanning service.
- `EXEC sp_addrolemember 'db_owner', '<purview-account>'` — grants that identity `db_owner` so
  Purview can scan schema/data for classification.
- `CREATE MASTER KEY` — ensures a master key exists (required for certain scan/encryption
  operations).

### `rowlevelsecurity.sql`
Implements multi-tenant Row-Level Security (RLS):
1. `CREATE TABLE [SALES] (...)` + `INSERT INTO [Sales] VALUES (...)` — sample multi-tenant sales
   data tagged with `TenantName`.
2. `CREATE USER [TenantAdmin|Tenant1..4] WITH PASSWORD` + `GRANT SELECT [Sales] TO ...` — one login
   per tenant plus an admin, each granted `SELECT` on the table.
3. `CREATE SCHEMA sec` — dedicated schema for the security objects.
4. `CREATE FUNCTION sec.tvf_SecurityPredicatebyTenant(@TenantName)` — inline table-valued function
   returning a row only if `@TenantName` matches the caller's `USER_NAME()`, or the caller is
   `TenantAdmin`.
5. `GRANT SELECT ON sec.tvf_SecurityPredicatebyTenant TO ...` — required so each tenant user can
   invoke the predicate function.
6. `CREATE SECURITY POLICY sec.SalesPolicy ADD FILTER PREDICATE ... ON [dbo].[Sales] WITH (STATE = ON)`
   — attaches the predicate function as a filter predicate, so every query against `Sales` is
   implicitly filtered by tenant.
7. `EXECUTE AS USER = '...'; SELECT * FROM dbo.Sales; REVERT;` (repeated per tenant) — verifies each
   tenant only sees their own rows (and `TenantAdmin` sees all).

### `sensitivity-classification.sql`
- `ADD SENSITIVITY CLASSIFICATION TO [Application].[People].[EmailAddress] WITH (LABEL='PII', INFORMATION_TYPE='Email')`
  — tags a column with a data-classification label/information type, used by Azure SQL's built-in
  Data Discovery & Classification (and surfaced to Microsoft Purview).

### `sqlinjectionexample.sql` — ⚠️ Educational anti-pattern, do not run in production
- `SELECT * FROM Orders WHERE OrderId=25 ; DELETE FROM orders;` — demonstrates classic SQL
  injection via statement stacking when user input is concatenated unsanitized into a query.
- `DECLARE @v VARCHAR(255); SELECT @v = cast(0x... AS VARCHAR(255)); EXEC (@v)` — demonstrates
  hex-encoded payload obfuscation used to hide a dangerous command (e.g. `xp_cmdshell`-style
  execution) from casual inspection/signature-based filters before executing it with `EXEC`.
- **Purpose:** shown purely to teach why parameterized queries/stored procedures must be used
  instead of dynamic string concatenation.

---

## 3. `PerformanceMonitoring/`

### `classifierfunction.sql`
- `CREATE FUNCTION dbo.RGClassifier() RETURNS SYSNAME WITH SCHEMABINDING` — a Resource Governor
  classifier function. On each new session, SQL Server calls this function; it inspects
  `SUSER_NAME()` and returns the name of the workload group (`ReporterServerGroup`,
  `PrimaryServerGroup`, or `DefaultServerGroup`) that the session should be classified into, enabling
  CPU/memory resource limits per login.

### `xevents.sql`
- `SELECT ... FROM sys.dm_xe_objects obj JOIN sys.dm_xe_packages pkg ...` — lists all available
  Extended Events objects (actions, events, targets) with descriptions, useful for discovering what
  can be traced.
- `IF EXISTS (SELECT * FROM sys.server_event_sessions WHERE name='test_session') DROP EVENT SESSION ...`
  — idempotency guard that drops a prior session before recreating it.
- `CREATE EVENT SESSION test_session ON SERVER ADD EVENT sqlos.async_io_requested, ADD EVENT sqlserver.lock_acquired ADD TARGET package0.etw_classic_sync_target(...) WITH (MAX_MEMORY=4MB, MAX_EVENT_SIZE=4MB)`
  — creates a lightweight ETW-backed session tracing async I/O requests and lock acquisitions.

---

## 4. `TransRepQueries/` (SQL Server Transactional Replication)

These four scripts, run in order, configure classic transactional replication for `AdventureWorks`.

### `createdistributor.sql` (run first, on the distributor instance)
| Procedure | Purpose |
|---|---|
| `sp_adddistributor` | Registers the current server as its own distributor. |
| `sp_adddistributiondb` | Creates the `distribution` database with specified data/log file paths, sizes, and retention windows. |
| `sp_adddistpublisher` | Registers a publisher server against the distribution database. |
| `sp_addsubscriber` | Registers a subscriber server (here, an Azure SQL Database logical server). |
| `sp_replicationdboption @optname = 'publish'` | Enables the `adventureworks` database for publishing. |
| `sys.sp_addlogreader_agent` | Creates the Log Reader Agent job that reads the transaction log for replicated changes. |
| `sys.sp_adddistribution_agent` | Creates the Distribution Agent job that pushes changes from distributor to subscriber. |

### `transactionalpublication.sql` (run second, on the publisher)
- `sp_addpublication` — creates the publication `AdventureWorks_TransactionalPublication` with
  replication options (continuous replication frequency, DDL replication enabled, push/pull
  subscriptions allowed, snapshot compression, etc.).
- `sp_addpublication_snapshot` — configures/schedules the initial snapshot agent job for that
  publication (here effectively on-demand, since frequency is set to a one-time/manual type).

### `articlepublications.sql` (run third)
- `sp_addarticle` — adds `Person.Address` as a replicated article under the publication, specifying
  the source object, destination table/owner, schema options bitmask, identity range management, and
  per-operation replication commands (`@ins_cmd`/`@del_cmd`/`@upd_cmd = 'SQL'`).

### `subscription-sub-agent.sql` (run last, on the publisher, targeting the subscriber)
- `sp_addsubscription` — creates a push subscription for
  `AdventureWorks_TransactionalPublication` on the `AdventureWorksSubscriber` database, with
  automatic sync and read-only updates.
- `sp_addpushsubscription_agent` — creates the Distribution Agent job for that specific subscription,
  configuring its schedule (`@frequency_type`/`@frequency_interval`/etc.), security mode, and
  DTS/agent job placement.

---

## 5. Suggested Execution Order for New Engineers

1. **Provisioning:** `deployazuredb.sh` or `deployazuredb.ps1` (or `armtemplatedeployment.ps1`) to
   stand up a target Azure SQL Server/Database.
2. **Migration:** `DataMigrationService.sh` or `DataMigrationService.ps1` to move schema/data from
   an existing SQL Server into the newly provisioned Azure SQL Database.
3. **Security hardening:** scripts in `DatabaseAuthentication-Security/` (users/roles, TDE, RLS,
   data classification). Skip/only read `sqlinjectionexample.sql` — it is a warning example, not a
   setup step.
4. **Operational scripts:** `backup-restoredb.sql`, `partition.sql`,
   `PerformanceMonitoring/*.sql`, and `TransRepQueries/*.sql` as needed for ongoing
   backup/partitioning/monitoring/replication requirements.
