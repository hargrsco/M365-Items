<#  
********************************************************************************************************
DetectCloudEndpoint.ps1:  This script will list the Hardware OATH token object(s) in Entra ID

Usage:
======
.\DetectCloudEndpoint.ps1
        
Output:
=======
The script will return the cloud endpoint that should be used when configuring Cloud Kerberos Trust
Note: This script is not supported in PowerShell 7 Natively
   
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

********************************************************************************************************
#>

# Check if required module is installed and install if needed.
if (-not (Get-Module -ListAvailable -Name AzureADHybridAuthenticationManagement)) {
    Write-Host "**We need to install the AzureADHybridAuthenticationManagement module. Please be patient..."
    Install-Module -Name AzureADHybridAuthenticationManagement -Force
} else {
    Write-Host "**Checking to see if module needs to be updated**"
    Update-Module -Name AzureADHybridAuthenticationManagement
}
#Gets the Cloud Server Endpoint
Get-AzureADKerberosServerEndpoint