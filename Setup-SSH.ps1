#Requires -RunAsAdministrator

# Install OpenSSH Server feature
Write-Host "Installing OpenSSH Server..." -ForegroundColor Cyan
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start and configure sshd service
Write-Host "Starting SSH services..." -ForegroundColor Cyan
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# Start and configure ssh-agent service
Start-Service ssh-agent
Set-Service -Name ssh-agent -StartupType 'Automatic'

# Add firewall rule for SSH
Write-Host "Configuring Firewall rule for SSH access..." -ForegroundColor Cyan
New-NetFirewallRule -Name sshd `
                    -DisplayName 'OpenSSH Server (sshd)' `
                    -Enabled True `
                    -Direction Inbound `
                    -Protocol TCP `
                    -Action Allow `
                    -LocalPort 22

# Confirm SSH service status
Write-Host "`nSSH service is installed and running." -ForegroundColor Green
Write-Host "You can now SSH into this machine using your username and IP address." -ForegroundColor Green
