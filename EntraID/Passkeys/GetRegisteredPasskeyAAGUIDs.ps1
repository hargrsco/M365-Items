#**************************************************************************************
# Microsoft does not provide support for the sample scripts under any of its 
# standard support programs or services. These scripts are provided "AS IS" 
# without any kind of warranty. Microsoft explicitly disclaims all implied 
# warranties, including but not limited to, implied warranties of merchantability 
# or fitness for a particular purpose. The responsibility for any risks arising 
# from the use or performance of these scripts and accompanying documentation lies 
# solely with you. Microsoft, its authors, and anyone involved in creating, producing, 
# or delivering these scripts shall not be held liable for any damages, including but 
# not limited to loss of business profits, interruption of business operations, loss 
# of business information, or other financial losses, that result from the use of or 
# inability to use the scripts or documentation, even if Microsoft has been informed 
# of the possibility of such damages.
#**************************************************************************************

# Check if required module is installed and install if it is not
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Beta.Users)) {
    Install-Module -Name Microsoft.Graph.Beta.Users -Force
}

if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Beta.Identity.SignIns)) {
    Install-Module -Name Microsoft.Graph.Beta.Identity.SignIns -Force
}

# Import the required modules
Import-Module Microsoft.Graph.Beta.Users
Import-Module Microsoft.Graph.Beta.Identity.SignIns

# Disconnect from Microsoft Graph
Disconnect-MgGraph

# Connect to Microsoft Graph with required scopes
Connect-MgGraph -Scope 'User.Read,UserAuthenticationMethod.Read,UserAuthenticationMethod.Read.All'

# Define the output file [If the script is run more than once, delete the file to avoid appending to it.]
$file = ".\AAGUIDs.csv"

# Initialize the file with a header
Add-Content -Path $file -Value "User ID,Display Name,AAGUID,Model"

# Retrieve all users
$UserArray = Get-MgBetaUser -All

# Iterate through each user
foreach ($user in $UserArray) {
    # Retrieve Passkey authentication methods for the user
    $fidos = Get-MgBetaUserAuthenticationFido2Method -UserId $user.Id

# Iterate through each Passkey method
foreach ($fido in $fidos) {
    # Log and write to file the Passkey details
    Write-Host "- User object ID $($user.Id, $user.DisplayName) has a Passkey with AAGUID $($fido.Aaguid) of Model type '$($fido.Model)'"
    Add-Content -Path $file -Value "$($user.Id), $($user.DisplayName), $($fido.Aaguid), $($fido.Model)"
    }
}