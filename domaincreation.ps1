#Clean batch clutter
Set-ExecutionPolicy Unrestricted 
Clear-Host
#Enter new name for auto restart
$laptopname = Read-Host -Prompt 'Input the new laptop name to add to the domain.'

Write-Host 'Initialising...'

#Create config task to start on login
robocopy /MIR .\Setup\Scripts 'C:\Temp' /mt /e /j

Set-Location -Path "C:\Temp\"

#create scheduled task for psupdtinst
$Action = New-ScheduledTaskAction -Execute Powershell.exe -Argument "-NoProfile -NoExit -ExecutionPolicy Bypass C:\Temp\psupdtinst.ps1"
$Principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
$Trigger = New-ScheduledTaskTrigger -AtLogon
$Settings = New-ScheduledTaskSettingsSet -DontStopIfGoingOnBatteries
$Task = New-ScheduledTask -Action $Action -Principal $Principal -Trigger $Trigger -Settings $Settings
Register-ScheduledTask Pwrtask -InputObject $Task

#Remove preinstalled apps that cause issues
Write-Host 'Removing Microsoft bloatware'
Get-AppxPackage -Name MicrosoftTeams | Remove-AppxPackage -Allusers

#rename and add computer to domain in path laptops (managed)
Write-Host "After the computer restarts, log in using your domain admin account."
Add-Computer -DomainName mito.local -OUPath "OU=Laptops (Managed),DC=mito,DC=local" -NewName $laptopname -Restart