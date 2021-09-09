# Intro

Enabling Remote Powershell seemed pretty tedious on my homelab. So I'll write out steps to do it again. This was done for my Exchange 2016 Server, that is not visible to the outside world. And because of this, I didn't really care about Security. I will practice with certificates when I get to that stage.

## Initial Setup

Firstly, we need to run a few commands that will add your IP or DNS to the TrustedHosts file.

We'll start with the most basic one and self explanatory. 

`Enable-PSRemoting -Force`

This next command will set up your TrustedHosts file, to include the IP Address of the Machine you're going to be connecting FROM. You should change the -Value field to be the IP of the Server but ideally, you will be better off providing the FQDN. YURI-MAIL.yuri.local was my server for example.

`Set-Item WSMan:\localhost\Client\TrustedHosts -Value '192.168.0.1337,My-DC'`

You can double check if these settings have been applied by using - `Get-Item WSMan:\localhost\Client\TrustedHosts` - You'll see the Value's from above listed under the Value column.

## Connecting the session

I've just gone ahead and set up some basic variables to make it cleaner. 
```
$Server = 'YURI-MAIL.yuri.local'
$Username = "yuri.local\Admin"
$Credentials = Get-Credential $Username
$SO = New-PSSessionOption -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true
```
Now, you can switch out the $Server value and make it dynamic by using `$Server = Read-Host -Prompt "Servername or IP - server.fqdn.local"`. The same goes Username.

Now I'd say to try and connect to it. I'll list two examples below.

Normal;
```
$RemoteSession = New-PSSession -Credential $Credentials -Authentication Negotiate -AllowRedirection -SessionOption $SO
```
Exchange;
```
$RemoteSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://$Server/powershell -Credential $Credentials -Authentication Negotiate -AllowRedirection -SessionOption $SO
```
For Exchange (2016), you may need to log on to ECP, head into Servers > Virtual Directories > Select PowerShell (Default Web Site) > Edit > Authentication > Tick Intergrated Windows Authentication.
This may work on 2013 and 2019 but I can't confirm.

We should now be able to successfully connect our session! Give it a try by using;
```
Enter-PSSession $RemoteSession
```

---

## Tip 1

I gave Negotiate a try because I think it's more secure than Basic. I think Basic is literally plain-text. You may still have errors with Exchange, and switching to Basic is pretty simple.

Head back to ECP, Servers > Virtual Directories > Select PowerShell (Default Web Site) > Edit > Authentication > Tick Basic Authentication, instead.

With that done, change the `-Authentication` value to `Basic` instead of `Negotiate` and jobs done.

## Tip 2 

You may find this article useful, though it was not required in my case, I tried it anyway.
`https://www.codetwo.com/kb/troubleshooting-remote-powershell-connections/`

---

## Closing Notes

I'll eventually update this and add or make a new Gist, regarding the use of Certificates for this. The whole point of this for me personally, was to avoid installing Exchange Management Tools on the local machine, and being able to run those commands from 'anywhere'.

I've created Scripts of the commands above, you can find the [Setup](https://github.com/YuriMoskar/PowerShell/blob/main/Enable-RemotePowershell.ps1) and the [Connection](https://github.com/YuriMoskar/PowerShell/blob/main/Connect-Quickly.ps1) in those links.

Peace.
