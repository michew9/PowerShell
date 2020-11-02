## What is the purpose of this script?

This is a PowerShell script that helps automate the installation of the MipSdkRedist and MilestonePSTools modules. To setup MilestonePSTools, you would need to install the MipSdkRedist module.

## When do I use this?
In cases, where the Install-Module commands are not working, you would need to perform download the nupkg modules manually, rename the nupkg extension to zip, unblock the file and expand it into the Windows PowerShell module directory. 

All the above steps can be automated using this script. In addition, it can also help uninstall the modules by removing them from the Windows PowerShell module directory. 

## How do I use this?
The script can be executed from the command line, or a friendly menu-driven.

The following are supported options:
- _-cleanup_ This will remove the "MipSdkRedist" and "MilestonePSTools" directories in "C:\Program Files\WindowsPowerShell\Modules"
- _-install_ This will download the "MipSdkRedist" and "MilestonePSTools" packages from the Windows PowerShell Gallery and place the extracted files in the "MipSdkRedist" and "MilestonePSTools" directories in "C:\Program Files\WindowsPowerShell\Modules"
- _-logfile_ The output of this script will be appended to the specified logfile.

## Example of the usage of the script
### Getting Help from menu-driven:
```
C:\> powershell -f ManageMsPsTools.ps1

~~~~~~~~~~~~~~~~~~ Menu Title ~~~~~~~~~~~~~~~~~~
1: Cleanup - Remove Milestone MilestonePSTools and MipSdkRedist modules
2: Install - Install Milestone MilestonePSTools and MipSdkRedist modules
3: Help - Display CLI options for this script.
Q: Quit (default)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Please make a selection (1-3,Q): 3
Usage: .\ManageMsPsTools.ps1 [ -cleanup ] [ -install ] [ -logfile <logfilename> ]

 get-help .\ManageMsPsTools.ps1 -examples
 get-help .\ManageMsPsTools.ps1 -detailed
 get-help .\ManageMsPsTools.ps1 -full
```

### To remove the current install and reinstall them:
```
C:\> powershell -f ManageMsPsTools.ps1 -cleanup -install

Removing C:\Program Files\WindowsPowerShell\Modules\MipSdkRedist directory from the current system
Removing C:\Program Files\WindowsPowerShell\Modules\MilestonePSTools directory from the current system
MipSdkRedist is successfully installed .
MilestonePSTools is successfully installed .
C:\> 
```


## Reference
[MipSdkRedist 20.2.0](https://www.powershellgallery.com/packages/MipSdkRedist/20.2.0)

[MilestonePSTools 1.0.83](https://www.powershellgallery.com/packages/MilestonePSTools/1.0.83)