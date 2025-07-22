
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
    # Create inbound rule
    $inboundRuleName = "$ruleNamePrefix$port Inbound"

    # Check if inbound rule already exists
    $existingInboundRule = Get-NetFirewallRule -DisplayName $inboundRuleName -ErrorAction SilentlyContinue

    if ($existingInboundRule) {
        Write-Host "Firewall rule '$inboundRuleName' already exists. Updating..."
        Set-NetFirewallRule -DisplayName $inboundRuleName -Enabled True
    }
    else {
        Write-Host "Creating new inbound firewall rule for port $port..."
        New-NetFirewallRule -DisplayName $inboundRuleName `
                           -Direction Inbound `
                           -LocalPort $port `
                           -Protocol TCP `
                           -Action Allow `
                           -LocalAddress $localIP `
                           -Enabled True
    }

    # Create outbound rule
    $outboundRuleName = "$ruleNamePrefix$port Outbound"

    # Check if outbound rule already exists
    $existingOutboundRule = Get-NetFirewallRule -DisplayName $outboundRuleName -ErrorAction SilentlyContinue

    if ($existingOutboundRule) {
        Write-Host "Firewall rule '$outboundRuleName' already exists. Updating..."
        Set-NetFirewallRule -DisplayName $outboundRuleName -Enabled True
    }
    else {
        Write-Host "Creating new outbound firewall rule for port $port..."
        New-NetFirewallRule -DisplayName $outboundRuleName `
                           -Direction Outbound `
                           -LocalPort $port `
                           -Protocol TCP `
                           -Action Allow `
                           -LocalAddress $localIP `
                           -Enabled True
    }

    # Verify the rules
    $inboundRule = Get-NetFirewallRule -DisplayName $inboundRuleName
    if ($inboundRule.Enabled -eq $true) {
        Write-Host "Success: Port $port is open for inbound traffic on $localIP"
    }
    else {
        Write-Host "Warning: Port $port inbound rule exists but is not enabled"
    }

    $outboundRule = Get-NetFirewallRule -DisplayName $outboundRuleName
    if ($outboundRule.Enabled -eq $true) {
        Write-Host "Success: Port $port is open for outbound traffic on $localIP"
    }
    else {
        Write-Host "Warning: Port $port outbound rule exists but is not enabled"
    }
}

Write-Host "`nFirewall configuration complete. Ports 5964 and 9100 should now be open bidirectionally for localhost."
Write-Host "You may need to restart your web application for changes to take effect."

# Optional: Show the created rules
Get-NetFirewallRule -DisplayName "$ruleNamePrefix*" | Format-Table DisplayName, Enabled, Direction, Action, Protocol, LocalPort -AutoSize