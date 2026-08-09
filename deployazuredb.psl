# Azure cloud configurations

$SubscriptionId = ''
$resourceGroupName = "myResourceGroup-$(Get-Random)"
$location = "westus2"
$adminSqlLogin = "SqlAdmin"
$password = "ChangeYourAdminPassword1"

# Server configurations
$serverName = "server-$(Get-Random)"

# The sample database name
$databaseName = "mySampleDatabase"

$startIp = "0.0.0.0"
$endIp = "0.0.0.0"

# Set subscription
Set-AzContext -SubscriptionId $subscriptionId

# Create a resource group
$resourceGroup = New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create server 
$server = New-AzSqlServer -ResourceGroupName $resourceGroupName -ServerName $serverName -Location $location -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminSqlLogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))

# Create firewall rule that allows access from the specified IP range

$serverFirewallRule = New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName -ServerName $serverName -FirewallRuleName "AllowedIPs" -StartIpAddress $startIp -EndIpAddress $endIp

# Create a DB with an S0 performance level

$database = New-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $databaseName -RequestedServiceObjectiveName "S0" -SampleName "AdventureWorksLT"