#Prerequisites
Set-ExecutionPolicy Unrestricted 
Clear-Host
Write-Host 'Installing Prerequisites...'
Set-WinUILanguageOverride -Language en-US
Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 -Online
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null

#PSWindowsUpdate Module Install
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name PSWindowsUpdate -Force

#Add optional (including driver) updates to windows update
Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -Confirm:$false

#Windows Update
Clear-WUJob
Write-Host 'Preparing Windows Update Service...'
Import-Module PSWindowsUpdate
Write-Host 'Fetching Windows Updates...'
Get-WindowsUpdate –Download -AcceptAll | Out-Null
Write-Host 'Installing Windows Updates...'
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot | Out-Null
Write-Host 'Windows Update Completed.'

Set-Location -Path "C:\Temp\"

#HP Dependencies and exe
add-appxpackage -path "Applications\HP\HPSA9x\Dependencies\x64\netframework.appx"
add-appxpackage -path "Applications\HP\HPSA9x\Dependencies\x64\netruntime.appx"
Write-Host 'Installing HP Support Assistant...'
Start-Process Applications\HP\sp140482.exe /s -wait
Clear-Host

#Applications via EXE
Write-Host 'Installing Acrobat Reader...'
Start-Process Applications\Adobe\ReaderDC\adobeinst.exe /sAll -wait
Write-Host 'Installing Lightshot...'
Start-Process Applications\setup-lightshot.exe /SILENT
Write-Host 'Installing Sophos AV...'
Start-Process Applications\Sophos\SophosSetup.exe --quiet -wait

#Applications via MSI
Write-Host 'Installing Chrome...'
Start-Process Applications\chrome.msi -wait
Write-Host 'Installing Teams...'
Start-Process Applications\Teams\Teams_windows_x64.msi -wait

Set-Location -Path "C:\Temp\Applications\O365\"

#Applications via BAT
Write-Host 'Installing Office 365...'
Start-Process Install.bat -wait

Write-Host 'Program installations completed'
Write-Host 'The computer will restart.'

#Delete task created during first script, register last script
Unregister-ScheduledTask Pwrtask -Confirm:$false | Out-Null

Restart-Computer