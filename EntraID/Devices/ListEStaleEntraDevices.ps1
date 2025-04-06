<#  
********************************************************************************************************
 Disclaimer:
 Microsoft does not provide support for the sample scripts under any of its 
 standard support programs or services. These scripts are provided "AS IS" 
 without any kind of warranty. Microsoft explicitly disclaims all implied 
 warranties, including but not limited to, implied warranties of merchantability 
 or fitness for a particular purpose. The responsibility for any risks arising 
 from the use or performance of these scripts and accompanying documentation lies 
 solely with you. Microsoft, its authors, and anyone involved in creating, producing, 
 or delivering these scripts shall not be held liable for any damages, including but 
 not limited to loss of business profits, interruption of business operations, loss 
 of business information, or other financial losses, that result from the use of or 
 inability to use the scripts or documentation, even if Microsoft has been informed 
 of the possibility of such damages.

Usage:
======
.\ListStaleEntraDevices.ps1
        
Output:
=======
The script will a list of devices that have not synched with Entra in over x months. For example, if you enter 3, 
it will list the all devices that have not synced in over 3 months. Along with the device name, the 
Script will output the User Princiapl Name, the device enrollment type, the operating system, and the
last sync date and time. This script will exclude servers. The output will be stored @ C:\Temp\InactiveDevices.csv. 
The script will create C:\Temp\ if it does not exist.

********************************************************************************************************
#>

#Check to see if Microsoft Graph PowerShell module is installed. If not, install it... 
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Host "**We need to install the Microsoft.Graph module. Please be patient..."
    Install-Module Microsoft.Graph -Force
} else {
    Write-Host "**Microsoft.Graph module is installed, checking to see if the module needs to be updated**"
    Update-Module Microsoft.Graph
}

#Connect to Microsoft Graph using Connect-MgGraph
Connect-MgGraph -Scopes “Device.Read.All”

#Prompt for how many months
$months = Read-Host -Prompt "Ener the number of months you would like to filter by"
#Calculate the date by x months ago
$xMonthsAgo = (Get-Date).AddMonths(-$months)

#Retrieve devices and filter based on last activity
$inactiveDevices = Get-MgDevice | Where-Object { $_.ApproximateLastSignInDateTime -lt $xMonthsAgo -and $_.TrustType -ne "ServerAD"}

#Define the path for the CSV file in “C:\Temp”
$csvFilePath = “C:\Temp\InactiveDevices.csv”
if (-Not(Test-Path "c:\Temp\")) {
    New-Item -ItemType Directory -Path "C:\Temp\"
}

#Export inactive devices to a CSV file
$inactiveDevices | Select-Object DisplayName, OperatingSystem, OperatingSystemVersion, IsManaged, TrustType, ApproximateLastSignInDateTime | Export-Csv -Path $csvFilePath -NoTypeInformation