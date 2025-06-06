$files = @{
    "ideavim\.ideavimrc" = "$env:USERPROFILE\.ideavimrc"
    "windows\powershell-profile.ps1" = "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
    "windows\windows-terminal-settings.json" = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    "nvim" = "$env:LOCALAPPDATA\nvim"
    "alacritty\alacritty.toml" = "$env:APPDATA\alacritty\alacritty.toml"
    "alacritty\catppuccin-mocha.toml" = "$env:APPDATA\alacritty\catppuccin-mocha.toml"
}

$sourceDir = $PSScriptRoot

foreach ($file in $files.Keys) {
    $source = Join-Path $sourceDir $file
    $target = $files[$file]

    # Check if the source file exists
    if (-Not (Test-Path $source)) {
        Write-Host "Source file $file not found in $sourceDir"
        continue
    }
 
    # Check if the target already exists
    if (Test-Path $target) {
        # If it's already a symlink, remove it
        if ((Get-Item $target).LinkType -eq "SymbolicLink") {
            Remove-Item $target -Force
        } else {
            # If it's a regular file, rename it as a backup
            Rename-Item -Path $target -NewName "$target.backup" -Force
        }
    }

    # Create the symlink
    New-Item -ItemType SymbolicLink -Path $target -Target $source -Force

    Write-Host "Created symlink for $file"
}

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    Write-Host "Oh My Posh is already installed."
} else {
    Write-Host "Installing Oh My Posh..."
    try {
        winget install JanDeDobbeleer.OhMyPosh -s winget
        Write-Host "Oh My Posh installed successfully."
    } catch {
        Write-Host "Failed to install Oh My Posh: $_"
    }
}

function Install-Npm {
    Write-Host "Installing npm..."
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        Write-Host "npm is already installed."
        return $true
    }
    else {
        try {
            # Using winget to install Node.js which includes npm
            winget install OpenJS.NodeJS
            if ($LASTEXITCODE -eq 0) {
                Write-Host "npm installed successfully."
                return $true
            }
            else {
                Write-Host "Failed to install npm."
                return $false
            }
        }
        catch {
            Write-Host "An error occurred while installing npm: $_"
            return $false
        }
    }
}

function Install-NodePackages {
    Write-Host "Installing node packages..."
    try {
        npm install -g @angular/language-service typescript typescript-language-server @vue/language-server @vue/typescript-plugin vscode-langservers-extracted@4.8.0
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Node packages installed successfully."
            return $true
        }
        else {
            Write-Host "Node package installation failed."
            return $false
        }
    }
    catch {
        Write-Host "An error occurred while installing node packages: $_"
        return $false
    }
}

# Main execution
if (Install-Npm) {
    Install-NodePackages
}
else {
    Write-Host "Aborting node package installation due to npm installation failure."
}

Write-Host "Dotfiles setup complete!"

