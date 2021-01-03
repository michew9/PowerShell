# 
## File: GetRsXml.ps1
## Purpose: Script to extract useful information from RecorderConfig.xml .
#
# Version 1.0 Initial Release
#

#$file = "C:\ProgramData\Milestone\XProtect Recording Server\RecorderConfig.xml"
$file = "C:\Tmp\Data\RecorderConfig.xml"

if (Test-Path -Path $file) {
    [xml]$xml = Get-Content $file

    Write-Host "~~~ File: $file " -ForegroundColor Cyan
    ## $xml.SelectNodes('//recorderconfig')


    Write-Host "`n---------- General Info : ----------"
    Write-Host -NoNewline "           Recording Server GUID : "
    Write-Host " $($xml.recorderconfig.recorder.id) " -ForegroundColor Yellow
    Write-Host -NoNewline "   Recording Server Display Name : "
    Write-Host " $($xml.recorderconfig.recorder.displayname) " -ForegroundColor Red    
    Write-Host -NoNewline "Recording Server Version Running : "
    Write-Host " $($xml.recorderconfig.recorder.version) " -ForegroundColor Red
    Write-Host -NoNewline "          Client Registration ID : " 
    Write-Host " $($xml.recorderconfig.recorder.ClientRegistrationId) " -ForegroundColor Red
    Write-Host -NoNewline "            Hardware Setup Delay : " 
    Write-Host " $($xml.recorderconfig.recorder.hardwarestartup.maxDelay) " -ForegroundColor Red

    Write-Host "`n---------- Port Info : ----------"
    Write-Host -NoNewline "                                     Management Server set to : "
    Write-Host " $($xml.recorderconfig.server.address) " -ForegroundColor Red
    Write-Host -NoNewline "           Port to listen for requests from Management Server : "
    Write-Host " $($xml.recorderconfig.webapi.port) " -ForegroundColor Yellow
    Write-Host -NoNewline "                                 Address of Management Server : "
    Write-Host " $($xml.recorderconfig.webapi.publicUri) " -ForegroundColor Red
    #$xml.recorderconfig.webapi.port
    #$xml.recorderconfig.webapi.publicUri

    Write-Host -NoNewline "Port when communicating with RS web server (from SmartClient) : "
    Write-Host " $($xml.recorderconfig.webserver.port) " -ForegroundColor Yellow
    
    Write-Host -NoNewline "                          Port to listen for requests from RS : "
    Write-Host " $($xml.recorderconfig.server.webapiport) " -ForegroundColor Yellow
  
    Write-Host -NoNewline " RS is registered to this management server for authorization : "
    Write-Host " $($xml.recorderconfig.server.authorizationserveraddress) " -ForegroundColor Green
    
    Write-Host -NoNewline "                                   Driver Event Listener Port : "
    Write-Host " $($xml.recorderconfig.DriverEventListener.Port) " -ForegroundColor Yellow

    Write-Host "`n---------- Database Settings : ----------"    
    Write-Host -NoNewline "                   DB Client Address : "
    Write-Host " $($xml.recorderconfig.database.database_client.address) " -ForegroundColor Green
    Write-Host -NoNewline "                      DB Client Port : "
    Write-Host " $($xml.recorderconfig.database.database_client.port) " -ForegroundColor Yellow
    
    Write-Host -NoNewline "          DB Server Socket Comm Port : "
    Write-Host " $($xml.recorderconfig.database.database_server.socket_communication.port_number) " -ForegroundColor Yellow
    Write-Host -NoNewline "       DB Server Comm Authentication : "
    Write-Host " $($xml.recorderconfig.database.database_server.socket_communication.authentication.anonymous.enable) " -ForegroundColor Cyan

    Write-Host -NoNewline "  DB Client Anonymous Authentication : "
    Write-Host " $($xml.recorderconfig.database.database_client.authentication.anonymous.enable) " -ForegroundColor Cyan
    Write-Host -NoNewline "      DB Client Basic Authentication : "
    Write-Host " $($xml.recorderconfig.database.database_client.authentication.basic.enable) " -ForegroundColor Cyan

    Write-Host "`n---------- Storage Settings : ----------"    
    Write-Host -NoNewline "       Storage Name : "
    Write-Host " $($xml.recorderconfig.database.database_default.name) " -ForegroundColor Green
    Write-Host -NoNewline "       Storage Path : "
    Write-Host " $($xml.recorderconfig.database.database_default.path) " -ForegroundColor Yellow
    # $xml.recorderconfig.database.database_default
    # $xml.recorderconfig.database.database_server.socket_communication.authentication.anonymous.basic 

    Write-Host "`n---------- Optional Settings : ----------"    
    Write-Host -NoNewline "        Alert Server Enabled : "
    Write-Host " $($xml.recorderconfig.driverservices.alert.enabled) " -ForegroundColor Cyan
    Write-Host -NoNewline "           Alert Server Port : "
    Write-Host " $($xml.recorderconfig.driverservices.alert.port) " -ForegroundColor Red

    Write-Host -NoNewline "                SMTP Enabled : "
    Write-Host " $($xml.recorderconfig.driverservices.smtp.enabled) " -ForegroundColor Cyan
    Write-Host -NoNewline "                   SMTP Port : "
    Write-Host " $($xml.recorderconfig.driverservices.smtp.port) " -ForegroundColor Red

} else {
    Write-Warning "Could not find $file on this host!"
    Write-Warning "Either this is not a Milestone Recording server or file has been removed!"
}

