# Powershell Profile
#
# Simon H Moore <simon@simonhugh.xyz>

$Modules = @(
  "PowerLine",
  "Posh-Git",
  "PSFzf",
  "Terminal-Icons"
)

# install modules
Function Invoke-Bootstrap()
{
  # install modules
  $Modules | foreach-object { Install-Module $_ -Force}
}

# Import Modules
try
{
  $Modules | foreach-object { Import-Module $_ }
} catch
{
  throw ("Module not installed, run Invoke-Bootstrap to install modules!")
}

# Alias & shortcut functions
Set-Alias -Name ls -Value Get-ChildItem
Set-Alias -Name ll -Value Get-ChildItem
function l. { Get-ChildItem -Hidden }
function .. { Set-Location .. }
function cd.. { Set-Location .. }
function cd... { Set-Locationd ..\.. }
function cd.... { Set-Locationd ..\..\.. }
function cd { Set-Locationd ~/ }
Set-Alias -Name x -Value Clear-Host

# program shortcuts
Set-Alias -Name vim -Value nvim
Set-Alias -Name v -Value nvim
Set-Alias -Name g -Value git

function find-file
{
    if ($args.Count -gt 0)
    {
        Get-ChildItem -Recurse -Filter "$args" | Foreach-Object FullName
    }
    else
    {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}

# Compute file hashes
function md5    { Get-FileHash -Algorithm MD5 $args }
function sha1   { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }
function sha384 { Get-FileHash -Algorithm SHA384 $args }
function sha512 { Get-FileHash -Algorithm SHA512 $args }

# edit this file
function Edit-Profile
{
    if ($host.Name -match "ise")
    {
        $psISE.CurrentPowerShellTab.Files.Add($profile.CurrentUserAllHosts)
    }
    else
    {
        notepad $profile.CurrentUserAllHosts
    }
}

# start starship prompt
Invoke-Expression (&starship init powershell)
