# Disabling Anonymous SMB Access on Powershell

# Define the registry path for SMB settings (Sets the path to the registry file where the setting will be changed)
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"

# Set registry variables to plug in:
$regName = "RestrictAnonymous"
$regValue = 2

# Check if the registry key exists and plug in variables that change the RestrictAnonymous setting to 2 (2 restricts all anonymous access)
if (Test-Path $regPath) {
    # Set the registry value
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue
    Write-Output "Anonymous SMB access has been disabled by setting RestrictAnonymous to 2."
} 
else {
    Write-Output "The registry path $regPath does not exist. Please ensure this script is running on a Windows system."
}

# Verify the setting status and print it to the console
$currentValue = Get-ItemProperty -Path $regPath -Name $regName
Write-Output "Current RestrictAnonymous setting: $($currentValue.RestrictAnonymous)"
