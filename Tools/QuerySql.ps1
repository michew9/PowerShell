# 
## File: QuerySql.ps1
## Purpose: Script to extract camera related information from Milestone Surveillance database  PowerShell module.
#
# Version 1.0 Initial Release
#

$SQLServer = 'localhost'
$SQLDBName = 'Surveillance'

# Create and open a database connection
$connectionstring="Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"
$SQLConnection = new-object system.data.sqlclient.SqlConnection($connectionstring)

function LoadTable($connectionstring, $sqlCmdText, $Table, $TabIndex)
{
    $SQLConn = new-object system.data.sqlclient.SqlConnection($connectionstring)
    $SQLConn.open()

    # Create a command object
    $sqlCommand = $SQLConn.CreateCommand()

    $sqlCommand.CommandText = $sqlCmdText

    # Execute the Command
    $sqlReader = $sqlCommand.ExecuteReader()

    # Parse the records
    while ($sqlReader.Read()) { 
        $object = New-Object PSObject
        for ($ii=0; $ii -lt $TabIndex.count; $ii++) {
            Add-Member -InputObject $object -MemberType NoteProperty -Name '$TabIndex[$ii]' -Value $sqlReader['$TabIndex[$ii]'] 
        }
       $Table += $object
       # write-host "Database: $($sqlReader['Database']) - Owner: $($sqlReader['Owner'])"
       # $sqlReader["Database"] + ", " + $sqlReader["Owner"]
    }

    # Close the database connection
    $SQLConn.Close()
}

$GroupsArray = @()
$IndexArray = "Database", "Owner"
$cmdText = "select name as 'Database' , suser_sname(owner_sid) as 'Owner' from sys.databases where name = 'Surveillance' or name = 'SurveillanceLogServerV2'"
LoadTable $connectionstring $cmdText $GroupsArray $IndexArray
$GroupsArray


$SQLConnection.open()

#Create a command object
$sqlCommand = $SQLConnection.CreateCommand()

$sqlCommand.CommandText = "select name as 'Database' , suser_sname(owner_sid) as 'Owner' from sys.databases where name = 'Surveillance' or name = 'SurveillanceLogServerV2'"

#Execute the Command
$sqlReader = $sqlCommand.ExecuteReader()

#Parse the records
while ($sqlReader.Read()) { 
    write-host "Database: $($sqlReader['Database']) - Owner: $($sqlReader['Owner'])"
    $sqlReader["Database"] + ", " + $sqlReader["Owner"]
}

# Close the database connection
$SQLConnection.Close()


$SQLConnection.open()
#Create a command object
$sqlCommand2 = $SQLConnection.CreateCommand()
$sqlCommand2.CommandText = "Select Name, Setting, LastModified from dbo.SystemSettings"
#Execute the Command
$sqlReader2 = $sqlCommand2.ExecuteReader()
#Parse the records
while ($sqlReader2.Read()) { 
    write-host "Name: $($sqlReader2['Name']) - Settings: $($sqlReader2['Setting'])"
}
# Close the database connection
$SQLConnection.Close()

#Cleanup
$SQLConnection.Dispose()





$InstanceName = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server").InstalledInstances
$Instance = $env:computername+'\'+$InstanceName
Write-Host "The SQl Server instance name is $Instance"

$inst = (get-itemproperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances
foreach ($i in $inst)
{
   $p = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL').$i
   (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$p\Setup").Edition
   (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$p\Setup").Version
}

$p = 'name', 'startname', 'startmode', 'pathname', 'description'
# Get-CimInstance Win32_Service -Filter "state = 'running'" -Property $P | FL $P
Get-CimInstance Win32_Service -Filter "Name like 'Milestone%'" -Property $P | FL $P

Get-Service | where { $_.Name -like "SQL*" } | select Name, DisplayName, ServiceName, Status, StartType
Get-CimInstance Win32_Service -Filter "Name like 'SQL%'" | select Name, Status, Pathname, Description, Started, Displayname, Startmode, Startname, State

Get-Service | where { $_.Name -like "Milestone*" } | select Name, DisplayName, ServiceName, Status, StartType
Get-CimInstance Win32_Service -Filter "Name like 'Milestone%'" | select Name, Status, Pathname, Description, Started, Displayname, Startmode, Startname, State


Get-Service | where { $_.Name -like "Milestone*" } | ForEach-Object {
write-output "Name = $($_.Name) "
write-output "DisplayName = $($_.DisplayName) "
}
