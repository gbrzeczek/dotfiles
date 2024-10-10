$files = @{
    "ideavim\.ideavimrc" = "$env:USERPROFILE\.ideavimrc"
    "windows\powershell-profile.ps1" = "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
    "windows\windows-terminal-settings.json" = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    "nvim" = "$env:LOCALAPPDATA\nvim"
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

Write-Host "Dotfiles setup complete!"

