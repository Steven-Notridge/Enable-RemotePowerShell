# Created by @YuriMoskar - https://github.com/YuriMoskar/
# The easiest and most simple way to enable remote powershell commands.

# Command to enable PowerShell's side of Remote.
Enable-PSRemoting -Force

# This will set your TrustedHosts file, to include the IP Address of the Machine you're going to be connecting FROM. (This should be run on the remote machine.)
Set-Item WSMan:\localhost\Client\TrustedHosts -Value '192.168.0.1337,My-DC'

# This will allow you to check the file, to ensure your IP/Client has been added. 
Get-Item WSMan:\localhost\Client\TrustedHosts

# This is an example test, to see if PowerShell can connect and run a command remotely.
Invoke-Command -Computer 192.168.0.37 -Credential (get-credential "yuri.local\Administrator") { ls C:\ }