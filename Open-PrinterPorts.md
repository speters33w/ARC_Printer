# Windows 11 Firewall Script for Printer Ports

This PowerShell script will open ports 5964 and 9100 on the local Windows Defender Firewall to allow printing from a web application on localhost (127.0.0.1).

```powershell
# Require administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires administrator privileges. Please run as administrator."
    exit
}

# Define the ports and rules
$ports = @(5964, 9100)
$ruleNamePrefix = "WebApp Printer Port "
$localIP = "127.0.0.1"

foreach ($port in $ports) {
    $ruleName = "$ruleNamePrefix$port"
    
    # Check if rule already exists
    $existingRule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
    
    if ($existingRule) {
        Write-Host "Firewall rule '$ruleName' already exists. Updating..."
        Set-NetFirewallRule -DisplayName $ruleName -Enabled True
    }
    else {
        Write-Host "Creating new firewall rule for port $port..."
        New-NetFirewallRule -DisplayName $ruleName `
                           -Direction Inbound `
                           -LocalPort $port `
                           -Protocol TCP `
                           -Action Allow `
                           -LocalAddress $localIP `
                           -Enabled True
    }
    
    # Verify the rule
    $rule = Get-NetFirewallRule -DisplayName $ruleName
    if ($rule.Enabled -eq $true) {
        Write-Host "Success: Port $port is open for $localIP"
    }
    else {
        Write-Host "Warning: Port $port rule exists but is not enabled"
    }
}

Write-Host "`nFirewall configuration complete. Ports 5964 and 9100 should now be open for localhost."
Write-Host "You may need to restart your web application for changes to take effect."

# Optional: Show the created rules
Get-NetFirewallRule -DisplayName "$ruleNamePrefix*" | Format-Table DisplayName, Enabled, Direction, Action, Protocol, LocalPort -AutoSize
```

## How to Use This Script

1. Save this script as `Open-PrinterPorts.ps1`
2. Right-click the file and select "Run with PowerShell" (must run as Administrator)
3. The script will:
   - Check for existing rules
   - Create or update firewall rules for ports 5964 and 9100
   - Restrict access to localhost (127.0.0.1) only
   - Display the results

## Notes

- Port 9100 is commonly used for raw printing (HP JetDirect, AppSocket, PDL-datastream)
- Port 5964 is sometimes used for alternative printing protocols
- The rules are inbound only (for receiving print jobs)
- Access is restricted to localhost only for security
- You may need to adjust your web app's configuration to use these ports

Would you like me to modify any aspect of this script for your specific needs?