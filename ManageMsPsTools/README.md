## What is the purpose of this script?

This is a PowerShell script that helps automate the installation of the MipSdkRedist and MilestonePSTools modules. To setup MilestonePSTools, you would need to install the MipSdkRedist module.

---

## When do I use this?
In cases, where the Install-Module commands are not working, you would need to perform download the nupkg modules manually, rename the nupkg extension to zip, unblock the file and expand it into the Windows PowerShell module directory. 

All the above steps can be automated using this script. In addition, it can also help uninstall the modules by removing them from the Windows PowerShell module directory. 

---

## How do I use this?
The script can be executed from the command line, or a friendly menu-driven.

The following are supported options:
- _-uninstall_ This will uninstall the "MipSdkRedist" and "MilestonePSTools" directories in "C:\Program Files\WindowsPowerShell\Modules"
- _-install_ This will download the "MipSdkRedist" and "MilestonePSTools" packages from the Windows PowerShell Gallery and place the extracted files in the "MipSdkRedist" and "MilestonePSTools" directories in "C:\Program Files\WindowsPowerShell\Modules"
- _-download_ This will download the "MipSdkRedist" and "MilestonePSTools" package to the temporary directory on the machine
- _-tmpdir_ Specify the location of the temporary directory on the machine (default is the %TEMP%)
- _-logfile_ The output of this script will be appended to the specified logfile.

---

## Example of the usage of the script
### Getting Help from menu-driven:
```
C:\> powershell -f ManageMsPsTools.ps1

~~~~~~~~~~~~~~~~~~ Menu Title ~~~~~~~~~~~~~~~~~~
1: Uninstall - Uninstall Milestone MilestonePSTools and MipSdkRedist modules
2: Install - Install Milestone MilestonePSTools and MipSdkRedist modules
3: Download - Download Milestone MilestonePSTools and MipSdkRedist modules
4: Help - Display CLI options for this script.
Q: Quit (default)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Please make a selection (1-4,Q): 3
Usage: .\ManageMsPsTools.ps1 [ -uninstall ] [ -install ] [ -download ] [ -logfile <logfilename> ]

 get-help .\ManageMsPsTools.ps1 -examples
 get-help .\ManageMsPsTools.ps1 -detailed
 get-help .\ManageMsPsTools.ps1 -full
```

### To remove the current install and reinstall them:
```
C:\> powershell -f ManageMsPsTools.ps1 -uninstall -install

..Uninstalling module MipSdkRedist
..  Successfully uninstalled MipSdkRedist from C:\Program Files\WindowsPowerShell\Modules\MipSdkRedist directory
..Uninstalling module MilestonePSTools
..  Successfully uninstalled MilestonePSTools from C:\Program Files\WindowsPowerShell\Modules\MilestonePSTools directory
..Installing module MipSdkRedist using C:\Users\MILEST~1\AppData\Local\Temp\mipsdkredist.20.3.0.zip
..  Successfully installed MipSdkRedist .
..  Import-Module MipSdkRedist ran successfully.
..Installing module MilestonePSTools using C:\Users\MILEST~1\AppData\Local\Temp\milestonepstools.1.0.89.zip
..  Successfully installed MilestonePSTools .
..  Import-Module MilestonePSTools ran successfully.
C:\> 
```

### To download the package to c:\tmp4 directory:
```

C:\> powershell -f ManageMsPsTools.ps1 -download -tmpdir c:\tmp
..Downloading mipsdkredist.20.3.0.zip to c:\tmp
..  Successfully downloaded mipsdkredist.20.3.0.zip to c:\tmp
..Downloading milestonepstools.1.0.89.zip to c:\tmp
..  Successfully downloaded milestonepstools.1.0.89.zip to c:\tmp
```

### To uninstall the packages:
```

C:\> powershell -f ManageMsPsTools.ps1 -uninstall
..Uninstalling module MipSdkRedist
..  Successfully uninstalled MipSdkRedist from C:\Program Files\WindowsPowerShell\Modules\MipSdkRedist directory
..Uninstalling module MilestonePSTools
..  Successfully uninstalled MilestonePSTools from C:\Program Files\WindowsPowerShell\Modules\MilestonePSTools directory
```

### To install the package from c:\tmp4 directory:
```

C:\> powershell -f ManageMsPsTools.ps1 -install -tmpdir c:\tmp
..Installing module MipSdkRedist using c:\tmp\mipsdkredist.20.3.0.zip
..  Successfully installed MipSdkRedist .
..  Import-Module MipSdkRedist ran successfully.
..Installing module MilestonePSTools using c:\tmp\milestonepstools.1.0.89.zip
..  Successfully installed MilestonePSTools .
..  Import-Module MilestonePSTools ran successfully.
```

```
By default PowerShell uses TLS 1.0 and the remote ressource is configured ito use TLS 1.2. To tell PowerShell to use TLS 1.2, you need to run:

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Note: Only the current PowerShell session (PowerShell window) will be in TLS 1.2, you must therefore execute this command each time you open the PowerShell window or put it in your PowerShell profile.
```

---

## Reference
[MipSdkRedist 20.3.0](https://www.powershellgallery.com/packages/MipSdkRedist/20.3.0)

[MilestonePSTools 1.0.89](https://www.powershellgallery.com/packages/MilestonePSTools/1.0.89)
