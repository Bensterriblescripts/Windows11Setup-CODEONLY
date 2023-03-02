Set-Location -Path "C:\Temp\"
Clear-Host

#Install userprofile required programs
Write-Host 'Installing xink...'
Start-Process Applications\xink\xinkClient.msi -wait
Write-Host 'Installing Desktop Central...'
Start-Process Applications\DesktopCentral\localsetup\setup.bat -wait
Write-Host 'Installing Sophos VPN...'
Start-Process Applications\Sophos\SophosConnect.msi /passive -wait

#uninstall cortana (completely, users cannot enable)
Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppxPackage
#set search bar to icon
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name SearchBoxTaskbarMode -Value 1 -Type DWord -Force
#remove task view button
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -Value 0 -Type DWord -Force
#remove newsfeed
#Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds -Name ShellFeedsTaskbarViewMode -Value 0 -Type DWord -Force
#remove meetnow
New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies -Name Explorer
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name HideSCAMeetNow -Value 1 -Type DWord -Force

#Taskbar & Start Menu
Import-StartLayout -LayoutPath "Config_Files\taskbarlayout.xml" -MountPath "C:\"

taskkill /im explorer.exe /f
Write-Host 'Taskbar Settings Updated.'

#Set Teams Firewall Port Access

#Write-Host 'Teams Firewall Access Applied.'

#Power Settings
Write-Host 'Power Settings Updated.'
powercfg -change monitor-timeout-dc 15
powercfg -change monitor-timeout-ac 15
powercfg -change standby-timeout-dc 120
powercfg -change standby-timeout-ac 0
powercfg /setACvalueIndex scheme_current sub_buttons lidAction 0

#Final round of updates
Write-Host 'Preparing Windows Update Service...'
Import-Module PSWindowsUpdate | Out-Null
Write-Host 'Fetching Windows Updates...'
Get-WindowsUpdate -Download -AcceptAll | Out-Null
Write-Host 'Installing Windows Updates...'
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot | Out-Null
Write-Host 'Windows Update Completed.'

#Delayed explorer restart from earlier changes due to changes taking a while to apply
#start and start-process explorer.exe not working, just continue with reboot to bring it back

#Delete temp files
Set-Location -Path "C:\"
Remove-Item -LiteralPath "C:\Temp" -Force -Recurse

Clear-RecycleBin -Force

Write-Host 'The computer will restart.'
cmd /c pause
Set-ExecutionPolicy Restricted 
Restart-Computer
