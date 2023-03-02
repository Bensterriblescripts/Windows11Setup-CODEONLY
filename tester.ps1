#Clean batch clutter
Set-ExecutionPolicy Unrestricted 

#Create config task to start on login
robocopy /MIR .\Setup\Scripts 'C:\Temp' /mt /e /j
