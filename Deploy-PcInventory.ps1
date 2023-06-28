#region Credits
# Author: Federico Lillacci
# GitHub: https://github.com/tsmagnum
# Version: 1.0
# Date: 27/06/2023
#endregion

#defining the errors logfile, adjust the path as needed
$failedLogDir = "C:\temp\"
$failedLogfileName = (Get-Date).ToString('yyyyMMdd-hhmm')+"_PosInventory.txt"
Set-Content "$failedLogDir$failedLogfileName" 'Offline PCs:'

#defining the results file, please customize the $logPath! Use a UNC path.
$logPath = "\\server\subdir\Pc_Inv\LogInventory\"
$logfile = (Get-Date).ToString('yyyyMMdd')+"_PosInventory.csv"

#creating the results file and setting the CSV header
Set-Content -Path $logPath$logfile "Hostname,OsInfo,InstallDate,CpuInfo,MemorySticks,MemoryTotal,PhysicalDiskSize"

#importing the targets file, adjust the path as needed
$targetPcs = Get-Content -Path "C:\scripts\pcs.txt"

#deploying the script to the target computers
foreach ($target in $targetPcs)
{
    
    
    #checking if the computer is alive and reachable
    $pingtest = Test-Connection -ComputerName $target -Quiet -Count 1 -ErrorAction SilentlyContinue
    
    if ($pingtest)
    {
    
            try
            {
                #WARNING: you have to customize the PsExec path and the script UNC path in the following line after "-command ..."
                Start-Process C:\scripts\PsExec.exe -ArgumentList "-s \\$($target) powershell.exe -inputformat none -ExecutionPolicy bypass -command \\server\path\toscript\Get-PcInventoryData.ps1" -Wait
           
            }

            catch
            {
                Write-Host "The attempted operation failed on $($target)" -ForegroundColor Red
                Write-Host "Message: [$($_.Exception.Message)"] -ForegroundColor Red
                Add-Content "$failedLogDir$failedLogfileName" "The attempted operation failed on $($target)"
            }

    }

    #if the computer is not reachable, display an error message and log it to a file
    else
    {
            $offlineMessage = "$($target) is offline"
            Write-Host $offlineMessage
            Add-Content "$failedLogDir$failedLogfileName" $offlineMessage
    }
}