

$XmlTab =
@(
    [pscustomobject]@{ 
        name="Management Server"; 
        filename="XProtect Management Server\ServerConfig.xml";  
        exist=0;
        info="MS info"},
    [pscustomobject]@{ 
        name="Recording Server";  
        filename="XProtect Recording Server\RecorderConfig.xml"; 
        exist=0;
        info="RS info"},
    [pscustomobject]@{ 
        name="Mobile Server";  
        filename="XProtect Mobile Server\VideoOS.MobileServer.Service.exe.config"; 
        exist=0;
        info="MxS info"},
    [pscustomobject]@{ 
        name="Management Client";  
        filename="XProtect Management Client\VideoOS.Administration.exe.config"; 
        exist=0;
        info="MC info"},
    [pscustomobject]@{ 
        name="Smart Client";      
        filename="XProtect Smart Client\Client.exe.config";      
        exist=0;
        info="SC info"}
)

## $RootDir = "C:\ProgramData\Milestone"
## $AltRootDir = "C:\Program Files\Milestone"
$RootDir = "C:\Tmp\Data\"
$AltRootDir = "C:\Tmp\Data\"

function ListManagementServer ( $XmlFilename )
{

    [xml]$xml = Get-Content $XmlFilename
    ## $xml.SelectNodes('//server')
 
    Write-Host "~~~ File: $XmlFilename " -ForegroundColor Cyan

    Write-Host "`n---------- General Info : ----------"
    Write-Host -NoNewline "                               Client Registration ID : "
    Write-Host " $($xml.server.ClientRegistrationId) " -ForegroundColor Red
    Write-Host -NoNewline "                                              Version : "
    Write-Host " $($xml.server.version) " -ForegroundColor Green
 
    Write-Host -NoNewline "                             Authorization Server Uri : "
    Write-Host " $($xml.server.WebApiConfig.AuthorizationServerUri) " -ForegroundColor Red
    
    Write-Host -NoNewline "                  Port to listen for requests from RS : "
    Write-Host " $($xml.server.WebApiConfig.Port) " -ForegroundColor Yellow
    
    Write-Host -NoNewline "                Use Latest Protocol for communication : "
    Write-Host " $($xml.server.UseWebApi) " -ForegroundColor Red
    
    Write-Host -NoNewline "                Use Legacy Protocol for communication : "
    Write-Host " $($xml.server.UseRemoting) " -ForegroundColor Red

    Write-Host -NoNewline "Port for authentication/config/token exchange from RS : "
    Write-Host " $($xml.server.RecorderCommunication.Port) " -ForegroundColor Yellow
    
    $xml.server.serverproxycommunication.port

    $xml.server.traycontrollercommunication.port

    $xml.server.VMOCommunication.ServerName
    $xml.server.VMOCommunication.Port
    $xml.server.VMOCommunication.HttpsPort
}

function ListRecordingServer ( $XmlFilename )
{
    [xml]$xml = Get-Content $XmlFilename

    Write-Host "~~~ File: $XmlFilename " -ForegroundColor Cyan
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
}

function ListMobileServer ( $XmlFilename )
{
    [xml]$xml = Get-Content $XmlFilename
    Write-Host "~~~ File: $XmlFilename " -ForegroundColor Cyan
    Write-Host "`n---------- General Info : ----------"
}

function ListManagementClient ( $XmlFilename )
{
    [xml]$xml = Get-Content $XmlFilename
    Write-Host "~~~ File: $XmlFilename " -ForegroundColor Cyan
    Write-Host "`n---------- General Info : ----------"
}
function ListSmartClient ( $XmlFilename )
{
    [xml]$xml = Get-Content $XmlFilename

    Write-Host "~~~ File: $XmlFilename " -ForegroundColor Cyan
    #$xml.SelectNodes('//configuration')
    #$xml.configuration.runtime.enforceFIPSPolicy
 
    #[xml]$(gc "$file").configuration.appSettings.add.FallThroughPriority
    # $item = $xml.configuration.appSettings.add | where-object {$_.key -eq 'FallThroughPriority'} | select value
    # Write-Host " $($item.value)" -ForegroundColor Red

    Write-Host "`n---------- General Info : ----------"
    Write-Host -NoNewline "   FallThruPriority : "
    Write-Host " $(($xml.configuration.appSettings.add | where-object {$_.key -eq 'FallThroughPriority'} | select value).value)" -ForegroundColor Red
}

# List all information in the XML files
Write-Host "XML :"
foreach($XmlItem in $XmlTab) {
    Write-Host "`n`n  - Name: '$($XmlItem.Name)', Filename: $($XmlItem.FileName), Info: '$($XmlItem.Info)'"

    if ( $($XmlItem.Name) -in 'Management Client' , 'Mobile Server' ) {
        $XmlFilename = "$AltRootDir\$($XmlItem.FileName)"
    } else {
        $XmlFilename = "$RootDir\$($XmlItem.FileName)"
    }
    
    if (Test-Path -Path $XmlFilename) {
        $XmlItem.exist = 1
        switch ( $($XmlItem.Name) ) {
            'Management Server' { ListManagementServer $XmlFilename }
            'Recording Server'  { ListRecordingServer $XmlFilename }
            'Mobile Server'     { ListMobileServer $XmlFilename }
            'Management Client' { ListManagementClient $XmlFilename }
            'Smart Client'      { ListManagementServer $XmlFilename }
        }
    } else {
        Write-Warning "Could not find $XmlFilename on this host!"
        Write-Warning "Either Milestone '$($XmlItem.Name)' is not installed or file has been removed!`n"        
    }
}

$XmlTab