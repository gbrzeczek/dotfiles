$files = @{
    ".ideavimrc" = "$env:USERPROFILE\.ideavimrc"
}

$sourceDir = $PSScriptRoot

foreach ($file in $files.Keys) {
    $source = Join-Path $sourceDir $file
    $target = $files[$file]

    # Check if the source file exists
    if (Test-Path $source) {
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
    } else {
        Write-Host "Source file $file not found in $sourceDir"
    }
}

Write-Host "Dotfiles setup complete!"

