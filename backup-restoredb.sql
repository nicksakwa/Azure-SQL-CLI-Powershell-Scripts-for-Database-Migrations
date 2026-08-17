-- Backing up DB to Azure Blob Storage
BACKUP DATABASE YourDatabase TO URL='https://yourstorageaccount.blob.core.windows.net/yourcontainer/YourDatabase.bak' WITH COPY_ONLY

-- Restoring DB to Managed Instance from Azure Blob Storage
RESTORE DATABASE YourDatabase FROM URL='https://yourstorageaccount.blob.core.windows.net/yourcontainer/YourDatabase.bak' 