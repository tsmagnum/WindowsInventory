#region Credits
# Author: Federico Lillacci
# GitHub: https://github.com/tsmagnum
# Version: 1.0
# Date: 27/06/2023
#endregion

#results file, please customize the $logPath! Use a UNC path.
$logPath = "\\server\subdir\Pc_Inv\LogInventory\"
$logfile = (Get-Date).ToString('yyyyMMdd')+"_PcInventory.csv"

#PC name
$hostname = $env:COMPUTERNAME

#OS Info
$osInfo = Get-WmiObject -Class Win32_OperatingSystem

#OS Install Date - You can change the date format after .Tostring(
$installDate = (([WMI]'').ConvertToDateTime(($osInfo).InstallDate)).ToString("dd/MM/yyyy")

#OS Version
$osVersion = $osInfo.Version

#CPU Info
$cpuInfo = (Get-WmiObject Win32_Processor).Name

#installed memory sticks 
$memorySticks = (Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Count

#total RAM
$memoryTotal = (Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum/1gb

#1st phyisical disk size 
$physicalDiskQuery = "Select * from Win32_diskDrive where DeviceID like '%PHYSICALDRIVE0%'"
$physicalDiskSize = [math]::Round(((Get-WmiObject -Query $physicalDiskQuery).Size/1gb),0)

#formatting the results string
$results = "$hostname,$osVersion,$installDate,$cpuInfo,$memorySticks,$memoryTotal,$physicalDiskSize"

#displaying the results and adding them to the CSV file
Write-Host -ForegroundColor Cyan $results
Add-Content -Path $logPath$logfile -Value $results