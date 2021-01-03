# $file = "C:\Program Files\Milestone\XProtect Smart Client\Client.exe.config"

$file = "C:\Tmp\Data\Client.exe.config"

if (Test-Path -Path $file) {
    [xml]$xml = Get-Content $file

    #$xml.SelectNodes('//configuration')
    #$xml.configuration.runtime.enforceFIPSPolicy
 
    #[xml]$(gc "$file").configuration.appSettings.add.FallThroughPriority
    # $item = $xml.configuration.appSettings.add | where-object {$_.key -eq 'FallThroughPriority'} | select value
    # Write-Host " $($item.value)" -ForegroundColor Red

    Write-Host -NoNewline "   FallThruPriority : "
    Write-Host " $(($xml.configuration.appSettings.add | where-object {$_.key -eq 'FallThroughPriority'} | select value).value)" -ForegroundColor Red
    
} else {
    Write-Warning "Could not find $file on this host!"
    Write-Warning "Either Milestone SmartClient is not installed or file has been removed!"
}
