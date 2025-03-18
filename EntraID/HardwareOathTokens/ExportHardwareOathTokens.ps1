<#  
********************************************************************************************************
Get-HardwareOATHTokens.ps1:  This script will list the Hardware OATH token object(s) in Entra ID

Usage:
======
.\ExportHardwareOATHTokens.ps1
        
Output:
=======
The script writes to a csv file named HWOATHTokens<dateTime>.csv in the current folder 
   
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
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
    Install-Module -Name Microsoft.Graph.Authentication -Force
}

#Import the Microsoft Graph module
Import-Module Microsoft.Graph.Authentication

# Disconnect from Microsoft Graph
Disconnect-MgGraph

# Define the required scopes
$scopes = @("Policy.Read.All")

# Authenticate and connect to Microsoft Graph
Connect-MgGraph -Scopes $scopes

$hardwareOATHTokensData = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/directory/authenticationMethodDevices/hardwareOathDevices" -OutputType PSObject

# Export the results array to a csv file
# Set up output file with date time stamp
$dateTime=get-date -format s
$dateTime=$dateTime -replace ":","_"
$dateTime=$dateTime.ToString()
$hardwareOATHTokensData.value | Export-Csv -Path ".\HWOATHTokens$dateTime.csv" -NoTypeInformation

# Disconnect from Microsoft Graph
Disconnect-MgGraph