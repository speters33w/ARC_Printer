# Windows 11 Firewall Script for Printer Ports

This PowerShell script will open ports 5964 and 9100 on the local Windows Defender Firewall to allow printing from a web application on localhost (127.0.0.1).

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
- Access is restricted to localhost only for security
- You may need to adjust your web app's configuration to use these ports

Would you like me to modify any aspect of this script for your specific needs?
