# Created by @YuriMoskar - https://github.com/YuriMoskar
# Example for Quick Remote PowerShell Session, save this somewhere and just run it. Since this can't be done from a nested prompt, like Visual Code.
# You can use a SecureString and save that somewhere but honestly don't see the point. Being prompted is fine for me at least.
# Fill in your own variables, I've only done this to make it a bit easier to understand when looking at it. 
# 1. Should add a way to choose between normal and exchange PSSessions.
# 2. This is not a secure method to do remote scripts. (Negotiate seems better than Basic, Kerberos doesn't seem to work in homelab. Not sure if that's cert related though.)

# $Server = Read-Host -Prompt "Servername or IP - server.fqdn.local"
$Server = 'YURI-MAIL.yuri.local'
$Username = "yuri.local\Admin"
$Credentials = Get-Credential $Username
$SO = New-PSSessionOption -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true

# Open a remote session.
$RemoteSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://$Server/powershell -Credential $Credentials -Authentication Negotiate -AllowRedirection -SessionOption $SO

# We use Enter-PSSession instead of Import because Enter is more short term sessions.
Enter-PSSession $RemoteSession