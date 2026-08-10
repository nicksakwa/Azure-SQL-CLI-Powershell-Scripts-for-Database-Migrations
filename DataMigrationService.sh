# Install ADMS extension on Azure CLI
az extension add --name datamigration 

# Create the Azure DMS service
az datamigration sql-service create --resource-group "<YourResourceGroup>" \
    --sql-migration-service-name "<YourMigrationService>" \  
    --location "<YourLocation>"                            

# Migrate schema from source to target database
az datamigration sql-server-schema \
    --action "MigrateSchema" \
    --src-sql-connection-str "Server=<YourSourceServer>;Initial Catalog=<YourSourceDB>;User ID=<YourSourceUser>;Password=<YourSourcePassword>" \
    --tgt-sql-connection-str "Server=<YourTargetServer>.database.windows.net;Initial Catalog=<YourTargetDB>;User ID=<YourTargetUser>;Password=<YourTargetPassword>"

# Create a database migration to Azure SQL Database
az datamigration sql-db create \
    --resource-group "<YourResourceGroup>" \            
    --sqldb-instance-name "<YourTargetServer>" \        
    --target-db-name "<YourTargetDB>" \                 
    --source-database-name "<YourSourceDB>" \           
    --source-sql-connection authentication="SqlAuthentication" 
        data-source="<YourSourceServer>"\              
        user-name="<YourSourceUser>" \                  
        password="<YourSourcePassword>" \               
        encrypt-connection=true trust-server-certificate=true \
    --target-sql-connection authentication="SqlAuthentication" data-source="<YourTargetServer>.database.windows.net" \  
        user-name="<YourTargetUser>" \                  
        password="<YourTargetPassword>" \               
        encrypt-connection=true trust-server-certificate=true 
    --scope "/subscriptions/<YourSubscription>/resourceGroups/<YourResourceGroup>/providers/Microsoft.Sql/servers/<YourTargetServer>" 
    --migration-service "/subscriptions/<YourSubscription>/resourceGroups/<YourResourceGroup>/providers/Microsoft.DataMigration/sqlMigrationServices/<YourMigrationService>"