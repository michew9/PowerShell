
$InstanceSQL = 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL'
$instanceString = (Get-ItemProperty -Path $instanceSQL -Name MSSQLSERVER).MSSQLSERVER

Write-Output "Sql Instance = $instanceString`n"

$regSQL = 'HKLM:\SOFTWARE\VideoOS\Server\Common'

$sqlString = (Get-ItemProperty -Path $regSQL -Name Connectionstring).Connectionstring
Write-Output "Sql String = $sqlString"
## Data Source=localhost;initial catalog='Surveillance';Integrated Security=SSPI;encrypt=true;trustServerCertificate=true

# Retrieves the SQL Server address from the $sqlString variable and stores it in $sqlServer
$sqlServer = [regex]::matches($sqlString,'(?<=Source=).+?(?=;)').value

# Retrieves the SQL Server database name from the $sqlString variable and stores it in $sqlDB
$sqlDB = [regex]::matches($sqlString,'(?<=catalog='').+?(?='';)').value

Write-Output "Sql Server = $sqlServer"
Write-Output "Sql DB = $sqlDB"

$regLogSQL = 'HKLM:\SOFTWARE\Milestone\XProtect Log Server'

$LogsqlString = (Get-ItemProperty -Path $regLogSQL -Name Connectionstring).Connectionstring
Write-Output "Log Sql String = $LogsqlString"

