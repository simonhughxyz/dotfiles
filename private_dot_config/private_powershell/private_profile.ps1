# Powershell Profile
#
# Simon H Moore <simon@simonhugh.xyz>

#NOTE: Modules to import
$modules = @(
  "Terminal-Icons"
)
$modules | foreach-object { import-module $_ }

# Set Eviroment Variables
$ENV:FZF_DEFAULT_COMMAND = "rg --files --hidden --smart-case --glob '!.git/*'"
$ENV:FZF_DEFAULT_OPTS = " `
    --cycle `
    --reverse `
    --info=hidden `
    --border `
    --padding=0 `
    --margin=0 `
    --color=border:129,fg+:129:bold `
    --bind=ctrl-space:print-query,ctrl-b:backward-kill-word,ctrl-w:kill-word,alt-b:backward-word,alt-w:forward-word,ctrl-j:down,ctrl-k:up,ctrl-p:toggle-preview,ctrl-g:top,ctrl-a:end-of-line,ctrl-i:beginning-of-line,ctrl-d:clear-query,ctrl-h:deselect-all,ctrl-f:jump,ctrl-s:toggle,ctrl-a:toggle-all,tab:replace-query"

# Alias & shortcut functions
Set-Alias -Name dot -Value chezmoi
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
$ENV:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml"
Invoke-Expression (&starship init powershell)

# start zoxide
Invoke-Expression (& { (zoxide init powershell --cmd j | Out-String) })
Set-Alias -Name cd -Value __zoxide_z -Option AllScope -Scope Global -Force
Set-Alias -Name cdi -Value __zoxide_zi -Option AllScope -Scope Global -Force
