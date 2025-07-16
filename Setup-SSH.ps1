#Requires -RunAsAdministrator

# Install OpenSSH Server feature
Write-Host "Installing OpenSSH Server..." -ForegroundColor Cyan
try {
    $capability = Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    if ($capability.RestartNeeded) {
        Write-Host "OpenSSH Server installed successfully, but a restart may be required." -ForegroundColor Yellow
    } else {
        Write-Host "OpenSSH Server installed successfully." -ForegroundColor Green
    }
} catch {
    Write-Host "Failed to install OpenSSH Server: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Start and configure sshd service
Write-Host "Starting SSH services..." -ForegroundColor Cyan
try {
    # Check if sshd service exists and start it
    $sshdService = Get-Service -Name sshd -ErrorAction SilentlyContinue
    if ($sshdService) {
        Start-Service sshd -ErrorAction Stop
        Set-Service -Name sshd -StartupType 'Automatic' -ErrorAction Stop
        Write-Host "OpenSSH SSH Server (sshd) service started and set to automatic." -ForegroundColor Green
    } else {
        Write-Host "sshd service not found. Installation may have failed." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Failed to start sshd service: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Start and configure ssh-agent service
try {
    $agentService = Get-Service -Name ssh-agent -ErrorAction SilentlyContinue
    if ($agentService) {
        Start-Service ssh-agent -ErrorAction Stop
        Set-Service -Name ssh-agent -StartupType 'Automatic' -ErrorAction Stop
        Write-Host "OpenSSH Authentication Agent (ssh-agent) service started and set to automatic." -ForegroundColor Green
    } else {
        Write-Host "ssh-agent service not found." -ForegroundColor Yellow
    }
} catch {
    Write-Host "Failed to start ssh-agent service: $($_.Exception.Message)" -ForegroundColor Red
}

# Add firewall rule for SSH
Write-Host "Configuring Firewall rule for SSH access..." -ForegroundColor Cyan
try {
    # Check if firewall rule already exists
    $existingRule = Get-NetFirewallRule -Name "sshd" -ErrorAction SilentlyContinue
    if ($existingRule) {
        Write-Host "SSH firewall rule already exists. Skipping creation." -ForegroundColor Yellow
    } else {
        New-NetFirewallRule -Name sshd `
                            -DisplayName 'OpenSSH Server (sshd)' `
                            -Enabled True `
                            -Direction Inbound `
                            -Protocol TCP `
                            -Action Allow `
                            -LocalPort 22 `
                            -ErrorAction Stop
        Write-Host "SSH firewall rule created successfully." -ForegroundColor Green
    }
} catch {
    Write-Host "Failed to create firewall rule: $($_.Exception.Message)" -ForegroundColor Red
}

# Verify SSH service status
Write-Host "`nVerifying SSH service status..." -ForegroundColor Cyan
try {
    $sshdStatus = Get-Service -Name sshd
    $agentStatus = Get-Service -Name ssh-agent -ErrorAction SilentlyContinue
    
    Write-Host "Service Status:" -ForegroundColor White
    Write-Host "  OpenSSH SSH Server (sshd): $($sshdStatus.Status) - Startup: $($sshdStatus.StartType)" -ForegroundColor White
    if ($agentStatus) {
        Write-Host "  OpenSSH Authentication Agent (ssh-agent): $($agentStatus.Status) - Startup: $($agentStatus.StartType)" -ForegroundColor White
    }
    
    # Get and display IP address
    $ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -ne "127.0.0.1"} | Select-Object -First 1).IPAddress
    if ($ipAddress) {
        Write-Host "`nSSH server is configured and running!" -ForegroundColor Green
        Write-Host "You can SSH into this machine using:" -ForegroundColor Green
        Write-Host "  ssh $env:USERNAME@$ipAddress" -ForegroundColor Cyan
    } else {
        Write-Host "`nSSH server is configured, but could not determine IP address." -ForegroundColor Yellow
    }
} catch {
    Write-Host "Error verifying service status: $($_.Exception.Message)" -ForegroundColor Red
}
