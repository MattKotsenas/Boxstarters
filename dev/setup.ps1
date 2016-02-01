$updateEnv = {
    function Update-EnvironmentVariables
    {
        foreach($level in "Machine","User")
        {
            [Environment]::GetEnvironmentVariables($level).GetEnumerator() | % {
                # For Path variables, append the new values, if they're not already in there
                if($_.Name -match 'Path$')
                {
                    $_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -split ';' | Select -unique) -join ';'
                }
                $_
            } | Set-Content -Path { "Env:$($_.Name)" }
        }
    }
}

Update-ExecutionPolicy Unrestricted
Set-ExplorerOptions -ShowHidenFilesFoldersDrive -ShowProtectedOSFiles -ShowFileExtensions # sic
Enable-RemoteDesktop

choco install conemu -y
choco install sublimetext3 -y
choco install notepad2 -y

# Install python 3 for pip and thefuck
# Install Office 365 Pro Plus

# Visual Studio + extensions
choco install VisualStudio2015Enterprise -Version 14.0.23107.0 -y

Install-ChocolateyVsixPackage FileNesting https://visualstudiogallery.msdn.microsoft.com/3ebde8fb-26d8-4374-a0eb-1e4e2665070c/file/123284/20/File%20Nesting%20v2.2.30.vsix
Install-ChocolateyVsixPackage CodeMaid https://visualstudiogallery.msdn.microsoft.com/76293c4d-8c16-4f4a-aee6-21f83a571496/file/9356/32/CodeMaid_v0.8.1.vsix
Install-ChocolateyVsixPackage TrailingWhitespaceVisualizer https://visualstudiogallery.msdn.microsoft.com/a204e29b-1778-4dae-affd-209bea658a59/file/135653/22/Trailing%20Whitespace%20Visualizer%20v2.0.57.vsix
Install-ChocolateyVsixPackage EditorConfig https://visualstudiogallery.msdn.microsoft.com/c8bccfe2-650c-4b42-bc5c-845e21f96328/file/75539/12/EditorConfigPlugin.vsix
Install-ChocolateyVsixPackage VsVim https://visualstudiogallery.msdn.microsoft.com/59ca71b3-a4a3-46ca-8fe1-0e90e3f79329/file/6390/57/VsVim.vsix

# Resharper 9
$resharper = [System.IO.Path]::GetTempFileName() + ".exe"
Get-ChocolateyWebFile -FileFullPath $resharper -Url http://download.jetbrains.com/resharper/JetBrains.ReSharperUltimate.2015.2.exe
Start-ChocolateyProcessAsAdmin "& '$resharper' '/SpecificProductNames=ReSharper;dotPeek' '/Silent=True'"

# Git and PowerShell integration
choco install git -y -params '"/GitOnlyOnPath"'
Update-EnvironmentVariables
choco install poshgit -y
choco install git-credential-manager-for-windows -y

# Enable file and printer sharing
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes