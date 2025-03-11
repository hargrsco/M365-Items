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