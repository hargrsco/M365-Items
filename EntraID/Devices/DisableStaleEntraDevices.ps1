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
.\DisableEntraStaleDevices.ps1
        
Output:
=======
The script will disable Windows 10/11 devices that have not synched with Entra in over x months. For example, if you enter 3, 
it will disable all devices that have not synced in over 3 months. Along with the device name, the 
Script will output the User Princiapl Name, the device enrollment type, the operating system, and the
last sync date and time. The output will be stored @ C:\Temp\DisabledDevices.csv. 
The script will create C:\Temp\ if it does not exist. NOTE: It may take a few minutes to reflect the accurate status in
the Microsoft Entra Admin Center.

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

# Connect to Microsoft Graph using Connect-MgGraph
Connect-MgGraph -Scopes “Device.ReadWrite.All”

# Calculate the date 6 months ago
$months = Read-Host -Prompt "Ener the number of months you would like to filter by"
#Calculate the date by x months ago
$dt = (Get-Date).AddMonths(-$months)

# Retrieve devices and filter based on last activity and Windows devices
$inactiveWindowsDevices = Get-MgDevice -All | Where-Object { $_.ApproximateLastSignInDateTime -le $dt -and $_.OperatingSystem -eq “Windows” -and $_.TrustType -ne "ServerAD"}

# Loop through each inactive Windows device and disable it
foreach ($device in $inactiveWindowsDevices) {
# Construct the parameters to disable the device
$params = @{
accountEnabled = $false
}

# Disable the device
try {
Update-MgDevice -DeviceId $device.Id -BodyParameter $params
Write-Host “Disabled device: $($device.DisplayName)”
} catch {
Write-Host “Failed to disable device: $($device.DisplayName). Error: $($_.Exception.Message)”
}
}

Write-Host “All inactive Windows devices have been processed.”
#Define the path for the CSV file in “C:\Temp”
$csvFilePath = “C:\Temp\DisabledDevices.csv”
#Create temp directory if it doesn't exist
New-Item -path "C:\Temp\" -ItemType Directory -Force | Out-Null
#Export inactive devices to a CSV file
$inactiveWindowsDevices | Select-Object DisplayName, OperatingSystem, OperatingSystemVersion, IsManaged, TrustType, ApproximateLastSignInDateTime | Export-Csv -Path $csvFilePath -NoTypeInformation