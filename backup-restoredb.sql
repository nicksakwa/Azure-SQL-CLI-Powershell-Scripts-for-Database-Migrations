-- Backing up DB to Azure Blob Storage
BACKUP DATABASE YourDatabase TO URL='https://yourstorageaccount.blob.core.windows.net/yourcontainer/YourDatabase.bak' WITH COPY_ONLY

