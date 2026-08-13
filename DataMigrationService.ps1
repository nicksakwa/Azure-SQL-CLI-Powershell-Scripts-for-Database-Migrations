# Set up secure credentials for source and target connections
$sourcePass = ConvertTo-SecureString "<YourSourcePassword>" -AsPlainText -Force
$targetPass = ConvertTo-SecureString "<YourTargetPassword>" -AsPlainText -Force

# Start the database migration to Azure SQL Database
New-AzDataMigrationToSqlDb `
    -ResourceGroupName "<YourResourceGroup>" `
    -SqlDbInstanceName "<YourTargetServer>" `
    -Kind "SqlDb" `
    -TargetDbName "<YourTargetDB>" `
    -SourceDatabaseName "<YourSourceDB>" `
    -SourceSqlConnectionAuthentication SQLAuthentication `
    -SourceSqlConnectionDataSource "<YourSourceServer>" `
    -SourceSqlConnectionUserName "<YourSourceUser>" `
    -SourceSqlConnectionPassword $sourcePass `
    -Scope "/subscriptions/<YourSubscription>/resourceGroups/<YourResourceGroup>/providers/Microsoft.Sql/servers/<YourTargetServer>" `
    -TargetSqlConnectionAuthentication SQLAuthentication `
    -TargetSqlConnectionDataSource "<YourTargetServer>.database.windows.net" `
    -TargetSqlConnectionUserName "<YourTargetUser>" `
    -TargetSqlConnectionPassword $targetPass `
    -MigrationService "/subscriptions/<YourSubscription>/resourceGroups/<YourResourceGroup>/providers/Microsoft.DataMigration/SqlMigrationServices/<YourMigrationService>"

# Migrate specific tables from source to target database
New-AzDataMigrationToSqlDb `
    -ResourceGroupName "<YourResourceGroup>" `
    -SqlDbInstanceName "<YourTargetServer>" `
    -Kind "SqlDb" `
    -TargetDbName "<YourTargetDB>" `
    -SourceDatabaseName "<YourSourceDB>" `
    -SourceSqlConnectionAuthentication SQLAuthentication `
    -SourceSqlConnectionDataSource "<YourSourceServer>" `
    -SourceSqlConnectionUserName "<YourSourceUser>" `
    -SourceSqlConnectionPassword $sourcePass `
    -Scope "/subscriptions/<YourSubscription>/resourceGroups/<YourResourceGroup>/providers/Microsoft.Sql/servers/<YourTargetServer>" `
    -TargetSqlConnectionAuthentication SQLAuthentication `
    -TargetSqlConnectionDataSource "<YourTargetServer>.database.windows.net" `
    -TargetSqlConnectionUserName "<YourTargetUser>" `
    -TargetSqlConnectionPassword $targetPass `
    -TableList "[Person].[Person]", "[Person].[EmailAddress]" `  # Specify tables to migrate
    -MigrationService "/subscriptions/<YourSubscription>/resourceGroups/<YourResourceGroup>/providers/Microsoft.DataMigration/SqlMigrationServices/<YourMigrationService>"