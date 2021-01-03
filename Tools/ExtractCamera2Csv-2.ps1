# 
## File: ExtractCamera2Csv.ps1
## Purpose: Script to extract camera related information from Milestone Surveillance database  PowerShell module.
#
# Version 1.0 Initial Release
#

$SQLServer = 'localhost'
$SQLDBName = 'Surveillance'

write-host "`nThis program will extract the camera related data from $SQLDBName database on $SQLServer`n"

function FillArray($SQLServer, $SQLDBName, $SqlQuery, $DataSet9)
{
	$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
	$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"

	$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
	$SqlCmd.CommandText = $SqlQuery
	$SqlCmd.Connection = $SqlConnection

	$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
	$SqlAdapter.SelectCommand = $SqlCmd

	$SqlAdapter.Fill($DataSet9) | out-null
 
	$SqlConnection.Close()
}

function PrintDataSet($DataSet, $col, $objtype)
{
  $cnt = $DataSet.Tables[0].Rows.Count
  write-host "There are $cnt ${objtype}:"
  for($i=0;$i -lt $cnt;$i++) {
	write-host "Rec # $i"
    for ($jj=0; $jj -lt $col; $jj++) {
      write-host "`t $($DataSet.Tables[0].Columns[$jj]) | $($DataSet.Tables[0].Rows[$i][$jj])"
    }
  }
}

$connectionstring="Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"
$SQLConnection = new-object system.data.sqlclient.SqlConnection($connectionstring)
$SQLConnection.open()

$SQLCommandText="SELECT Version FROM dbo.Sites "
$sqlCommand = New-Object system.Data.sqlclient.SqlCommand($SQLCommandText,$SQLConnection)
$version = $sqlCommand.ExecuteScalar()
Write-Host "The Milestone VMS software using $SQLDBName database is $version`n" -ForegroundColor green

## Recording Servers
##
$SqlQuery2 = "select IDRecorder, Enabled, Name, Description from dbo.Recorders order by IDRecorder "
$DataSet2 = New-Object System.Data.DataSet
FillArray $SQLServer $SQLDBName $SqlQuery2 $DataSet2

$dg2dt = $DataSet2.Tables[0]
# PrintDataSet $DataSet2 4 'Recording Servers'

## Device Groups
##
$SqlQuery3 = "select IDDeviceGroup, IDParentDeviceGroup, Name, Description, BuiltIn from dbo.DeviceGroups where DeviceType = 'Camera' order by IDDeviceGroup "
$DataSet3 = New-Object System.Data.DataSet
FillArray $SQLServer $SQLDBName $SqlQuery3 $DataSet3

$dg3dt = $DataSet3.Tables[0]
# PrintDataSet $DataSet3 4 'Device Groups'

## Device Group Members
##
$SqlQuery4 = "select IDDeviceGroup, IDDevice from dbo.DeviceGroupMembers order by IDDeviceGroup "
$DataSet4 = New-Object System.Data.DataSet
FillArray $SQLServer $SQLDBName $SqlQuery4 $DataSet4

$dg4dt = $DataSet4.Tables[0]
# PrintDataSet $DataSet4 2 'Device Group Members'

## Devices
##
$SqlQuery5 = "select IDDevice, IDHardware, Name, Description, Enabled, Settings, Settings.value('(/properties/settings/setting[name=''Codec'']/value)[1]', 'VARCHAR(20)') AS [Codec] from dbo.Devices where DeviceType = 'Camera' order by IDHardware "
$DataSet5 = New-Object System.Data.DataSet
FillArray $SQLServer $SQLDBName $SqlQuery5 $DataSet5

$dg5dt = $DataSet5.Tables[0]
# PrintDataSet $DataSet5 5 'Devices'

## Hardware
##
$SqlQuery6 = "select IDHardware, IDHardwareDriver, Name, Description, URI, LoginID, Enabled, IDRecorder, VendorProductID, DriverNumber, MacAddress, SerialNumber, DetectedModel from dbo.Hardware order by IDHardware "
$DataSet6 = New-Object System.Data.DataSet
FillArray $SQLServer $SQLDBName $SqlQuery6 $DataSet6

$dg6dt = $DataSet6.Tables[0]
# PrintDataSet $DataSet6 13 'Hardware'

$DevGroupsArray = @()
for($ii=0; $ii -lt $DataSet3.Tables[0].Rows.Count; $ii++) {
  $object = New-Object PSObject
  Add-Member -InputObject $object -MemberType NoteProperty -Name IDDeviceGroup -Value $($DataSet3.Tables[0].Rows[$ii][0])
  Add-Member -InputObject $object -MemberType NoteProperty -Name IDParentDeviceGroup -Value $($DataSet3.Tables[0].Rows[$ii][1])
  Add-Member -InputObject $object -MemberType NoteProperty -Name Name -Value $($DataSet3.Tables[0].Rows[$ii][2])
  Add-Member -InputObject $object -MemberType NoteProperty -Name Description -Value $($DataSet3.Tables[0].Rows[$ii][3])

  if ([DBNull]::Value.Equals( $($dg3dt.Rows[$ii][1]) )) {
	Add-Member -InputObject $object -MemberType NoteProperty -Name Level -Value 1  
  } else {
	Add-Member -InputObject $object -MemberType NoteProperty -Name Level -Value 99  
  }
  $DevGroupsArray += $object
}

$jj = 0
foreach ($item in $DevGroupsArray) {
#  $item
  if ($item.Level -eq 99) {
	  $curGroup = $($item.IDParentDeviceGroup)
	  $x = $DevGroupsArray | where { $_.IDDeviceGroup -eq $curGroup }
	  $item.Level = 1
	  while ([DBNull]::Value.Equals( $curGroup ) -eq $False) {
		$item.Level ++
	    $x = $DevGroupsArray | where { $_.IDDeviceGroup -eq $curGroup }
		$curGroup = $($x.IDParentDeviceGroup)  
	  }		    
    }
}

$RecSrvrArray = @()
for($ii=0; $ii -lt $DataSet2.Tables[0].Rows.Count; $ii++) {
  $object = New-Object PSObject
  Add-Member -InputObject $object -MemberType NoteProperty -Name IDRecorder -Value $($DataSet2.Tables[0].Rows[$ii][0])
  Add-Member -InputObject $object -MemberType NoteProperty -Name Enabled -Value $($DataSet2.Tables[0].Rows[$ii][1])
  Add-Member -InputObject $object -MemberType NoteProperty -Name Name -Value $($DataSet2.Tables[0].Rows[$ii][2])
  $RecSrvrArray += $object
}

$HardwareArray = @()
for($ii=0; $ii -lt $DataSet6.Tables[0].Rows.Count; $ii++) {
  $object = New-Object PSObject
  Add-Member -InputObject $object -MemberType NoteProperty -Name IDHardware -Value $($DataSet6.Tables[0].Rows[$ii][0])
  Add-Member -InputObject $object -MemberType NoteProperty -Name IDHardwareDriver -Value $($DataSet6.Tables[0].Rows[$ii][1])
  Add-Member -InputObject $object -MemberType NoteProperty -Name Name -Value $($DataSet6.Tables[0].Rows[$ii][2])
  Add-Member -InputObject $object -MemberType NoteProperty -Name Description -Value $($DataSet6.Tables[0].Rows[$ii][3])
  
  Add-Member -InputObject $object -MemberType NoteProperty -Name URI -Value $($DataSet6.Tables[0].Rows[$ii][4])
  Add-Member -InputObject $object -MemberType NoteProperty -Name LoginID -Value $($DataSet6.Tables[0].Rows[$ii][5])
  Add-Member -InputObject $object -MemberType NoteProperty -Name Enabled -Value $($DataSet6.Tables[0].Rows[$ii][6])
  Add-Member -InputObject $object -MemberType NoteProperty -Name IDRecorder -Value $($DataSet6.Tables[0].Rows[$ii][7])
  Add-Member -InputObject $object -MemberType NoteProperty -Name VendorProductID -Value $($DataSet6.Tables[0].Rows[$ii][8])
  Add-Member -InputObject $object -MemberType NoteProperty -Name DriverNumber -Value $($DataSet6.Tables[0].Rows[$ii][9])
  Add-Member -InputObject $object -MemberType NoteProperty -Name MacAddress -Value $($DataSet6.Tables[0].Rows[$ii][10])
  Add-Member -InputObject $object -MemberType NoteProperty -Name SerialNumber -Value $($DataSet6.Tables[0].Rows[$ii][11])
  Add-Member -InputObject $object -MemberType NoteProperty -Name DetectedModel -Value $($DataSet6.Tables[0].Rows[$ii][12])
  $HardwareArray += $object
}

$DevicesArray = @()
for ($ii=0; $ii -lt $DataSet5.Tables[0].Rows.Count; $ii++) {
  $object = New-Object PSObject
  Add-Member -InputObject $object -MemberType NoteProperty -Name IDDevice -Value $($DataSet5.Tables[0].Rows[$ii][0])
  Add-Member -InputObject $object -MemberType NoteProperty -Name IDHardware -Value $($DataSet5.Tables[0].Rows[$ii][1])
  Add-Member -InputObject $object -MemberType NoteProperty -Name Name -Value $($DataSet5.Tables[0].Rows[$ii][2])
  Add-Member -InputObject $object -MemberType NoteProperty -Name Description -Value $($DataSet5.Tables[0].Rows[$ii][3])
  Add-Member -InputObject $object -MemberType NoteProperty -Name Enabled -Value $($DataSet5.Tables[0].Rows[$ii][4])  
  Add-Member -InputObject $object -MemberType NoteProperty -Name Settings -Value $($DataSet5.Tables[0].Rows[$ii][5])
  Add-Member -InputObject $object -MemberType NoteProperty -Name Codec -Value $($DataSet5.Tables[0].Rows[$ii][6])

  $DevicesArray += $object
}

write-host -nonewline "Processing"
$DevGrpMemberArray = @()
for($ii=0; $ii -lt $DataSet4.Tables[0].Rows.Count; $ii++) {

  $object = New-Object PSObject
  Add-Member -InputObject $object -MemberType NoteProperty -Name IDDeviceGroup -Value $($DataSet4.Tables[0].Rows[$ii][0])
  Add-Member -InputObject $object -MemberType NoteProperty -Name IDDevice -Value $($DataSet4.Tables[0].Rows[$ii][1])

  $x = $DevicesArray | where { $_.IDDevice -eq $($object.IDDevice) }
  Add-Member -InputObject $object -MemberType NoteProperty -Name IDHardware -Value $($x.IDHardware)  
  Add-Member -InputObject $object -MemberType NoteProperty -Name DevEnabled -Value $($x.Enabled)
  Add-Member -InputObject $object -MemberType NoteProperty -Name DevName -Value $($x.Name)
  Add-Member -InputObject $object -MemberType NoteProperty -Name Settings -Value $($x.Settings)
  Add-Member -InputObject $object -MemberType NoteProperty -Name Codec -Value $($x.Codec)
  
  $x = $HardwareArray | where { $_.IDHardware -eq $($object.IDHardware) }
  Add-Member -InputObject $object -MemberType NoteProperty -Name URI -Value $($x.URI)
  Add-Member -InputObject $object -MemberType NoteProperty -Name IDRecorder -Value $($x.IDRecorder)
  Add-Member -InputObject $object -MemberType NoteProperty -Name HWName -Value $($x.Name)
  Add-Member -InputObject $object -MemberType NoteProperty -Name HWDescription -Value $($x.Description)    
  Add-Member -InputObject $object -MemberType NoteProperty -Name VendorProdID -Value $($x.VendorProductID)
  Add-Member -InputObject $object -MemberType NoteProperty -Name LoginID -Value $($x.LoginID)
  Add-Member -InputObject $object -MemberType NoteProperty -Name HWEnabled -Value $($x.Enabled)
  Add-Member -InputObject $object -MemberType NoteProperty -Name MacAddress -Value $($x.MacAddress)
  Add-Member -InputObject $object -MemberType NoteProperty -Name SerialNumber -Value $($x.SerialNumber)  
  Add-Member -InputObject $object -MemberType NoteProperty -Name DetectedModel -Value $($x.DetectedModel)
  
  $x = $RecSrvrArray | where { $_.IDRecorder -eq $($object.IDRecorder) }
  Add-Member -InputObject $object -MemberType NoteProperty -Name IDRecorderName -Value $($x.Name)

  $x = $DevGroupsArray | where { $_.IDDeviceGroup -eq $($object.IDDeviceGroup) }
  Add-Member -InputObject $object -MemberType NoteProperty -Name DGName -Value $($x.Name)
  Add-Member -InputObject $object -MemberType NoteProperty -Name DGLevel -Value $($x.Level)  
  
  $DevGrpMemberArray += $object
  if (($ii % 50) -eq 0) {
	  write-host -nonewline "."
  }
}
write-host " "

$date= get-date -format "yyyy-MM-dd-HH-mm"
$txtfilename = ".\" + $date + "-cameras.txt"
$csvfilename = ".\" + $date + "-cameras.csv"

out-file -filepath $txtfilename -inputobject $DevGrpMemberArray
$DevGrpMemberArray | Where-Object { $_.IDRecorderName -ne $Null  } | select IDRecorderName, DGName, DGLevel, DevName, DevEnabled, HWName, HWEnabled, HWDescription, VendorProdID, LoginID, URI, Codec, MacAddress, SerialNumber, DetectedModel  | Export-Csv -NoTypeInformation -Path $csvfilename 

$rc = $(Get-Content $csvfilename | Measure-Object -Line).Lines 
write-output "`n$($rc) rows of camera data successfully extracted into $csvfilename`n"

exit