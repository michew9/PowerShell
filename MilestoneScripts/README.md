## Introduction

The following are PowerShell scripts that extract Milestone related information from the Surveillance SQL Server database:

* [**Extract Camera**](https://github.com/michew9/PowerShell/blob/master/MilestoneScripts/ExtractCamera2Csv.ps1) : Simple PowerShell script to extract camera information into a CSV file. 

The following is an example of how you can perform a data extraction. You can then import the CSV into Microsoft Excel and perform the analysis on all the cameras defined/managed by the Milestone software.

```
C:\Users\XProtectUser\Desktop>powershell -f ExtractCamera2Csv.ps1

This program will extract the camera related data from Surveillance database on localhost

The Milestone VMS software using Surveillance database is 20.1.0.1

Processing....................................................................................

1229 rows of camera data successfully extracted into .\2020-12-17-08-24-cameras.csv
```

------------

The following are PowerShell scripts that leverage Milestone PsTools:

* [**List Recording Server**](https://github.com/michew9/PowerShell/blob/master/MilestoneScripts/ListRecordingSrvr.ps1) : Simple PowerShell script to list the content of the Milestone Recording Server.

