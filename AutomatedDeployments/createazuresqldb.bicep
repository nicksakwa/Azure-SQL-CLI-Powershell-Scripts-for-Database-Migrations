@description('The name of the SQL logical server.')
param serverName string = uniqueString('sql', resourceGroup().id)