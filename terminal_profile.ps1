# -----------------------------------
# ---------- ENV Variables ----------
# -----------------------------------


$ENV:STARSHIP_CONFIG = "$HOME\.config\starship.toml"


# -----------------------------------
# ---------- Apps Launcher ----------
# -----------------------------------


$apps = @{
    'br' = @{
        'default' = @(
            'C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe', '--profile-directory="Profile 2"'
        )
        'p'       = @(
            'C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe', '--profile-directory="Default"'
        )
        'e'       = @(
            'C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe', '--profile-directory="Profile 3"'
        )
        'a'       = @(
            'C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe', '--profile-directory="Profile 9"'
        )
        'u'      = @(
            'C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe', '--profile-directory="Profile 6"'
        )
    }
    'hlm' = @{
        'default' = @(
            'C:\Users\froze\AppData\Local\imput\Helium\Application\chrome.exe'
        )
    }
}

function run {
    param (
        [Alias("app")]
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$appName,

        [Parameter(Position = 1, Mandatory = $false)]
        [string]$id = 'default'
    )

    if ($id.StartsWith("--")) {
        $id = $id.Substring(2)
    }

    if ($apps.ContainsKey($appName)) {
        $app = $apps[$appName]

        if ($app.ContainsKey($id)) {
            $command = $app[$id]

            if ($command.Length -gt 1) {
                & $command[0] $command[1..($command.Length - 1)]
            } else {
                & $command[0]
            }

            Clear-Host
        }
        else {
            Write-Host "[ERR] Profile '$id' not found for $appName."
        }
    }
    else {
        Write-Host "[ERR] App '$appName' not found."
    }
}



# ------------------------------------
# ---------- Custom Actions ----------
# ------------------------------------


function yeet {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (Test-Path -Path $Path) {
        try {
            if ((Get-Item -Path $Path).PSIsContainer) {
                Remove-Item -Path $Path -Recurse -Force
                Write-Host "Trashed -> $Path" -ForegroundColor Green
            }
            else {
                Remove-Item -Path $Path -Force
                Write-Host "Trashed -> $Path"  -ForegroundColor Green
            }
        }
        catch {
            Write-Host "[ERR] 500: $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[ERR] 404: $Path" -ForegroundColor Yellow
    }
}

function touch {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    try {
        New-Item -ItemType File -Path $FilePath -Force | Out-Null
        Write-Host "Created -> $FilePath" -ForegroundColor Green
    }
    catch {
        Write-Host "[ERR] 500: $_" -ForegroundColor Red
    }
}

function set-light {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 100)]
        [int]$Level
    )

    try {
        $initialLevel = [Math]::Max(0, $Level - 10)
        $wmi = Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods

        # Step 1: Set initial lower brightness
        $wmi.WmiSetBrightness(1, $initialLevel)

        # Wait briefly
        Start-Sleep -Seconds 2

        # Step 2: Set the actual target brightness
        $wmi.WmiSetBrightness(1, $Level)
    }
    catch {
        Write-Host "[ERR] 500: $_" -ForegroundColor Red
    }
}

function C {
    clear
}

function stop {
    Stop-Computer
}

function restart {
    Restart-Computer
}

function signout {
    shutdown /l
}

function shut {
    Add-Type -AssemblyName System.Windows.Forms
    $PowerState = [System.Windows.Forms.PowerState]::Suspend
    $Force = $false
    $DisableWake = $false
    [System.Windows.Forms.Application]::SetSuspendState($PowerState, $Force, $DisableWake)
}

function kbc {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("start", "kill")]
        [string]$Action
    )

    if ($Action -eq "start") {
        & komorebic start --whkd --bar
    } elseif ($Action -eq "kill") {
        & komorebic stop --whkd --bar
    }
}

# show wifi password
# netsh wlan show profile name="profile" key=clear

# ---------------------------
# ---------- Help -----------
# ---------------------------


function help {
    $customCommands = @{
        'run'       = @{
            syntax      = 'run [-appName] <string> [-id <string>]'
            description = 'Launch applications with specific profiles'
            parameters  = @(
                'appName: Application short name (e.g., br)',
                'id: Profile ID (default: "default")'
            )
        }
        'yeet'      = @{
            syntax      = 'yeet -Path <string>'
            description = 'Force delete files/folders'
        }
        'touch'     = @{
            syntax      = 'touch -FilePath <string>'
            description = 'Create new empty file'
        }
        'set-light' = @{
            syntax      = 'set-light -Level <0-100>'
            description = 'Set screen brightness level'
        }
        'stop'      = @{
            syntax      = 'stop'
            description = 'Shutdown computer'
        }
        'restart'   = @{
            syntax      = 'restart'
            description = 'Restart computer'
        }
        'signout'   = @{
            syntax      = 'signout'
            description = 'Sign out current user'
        }
        'shut'      = @{
            syntax      = 'shut'
            description = 'Put computer to sleep'
        }
    }

    Write-Host "`nAvailable Commands`n" -ForegroundColor Cyan

    foreach ($cmd in $customCommands.Keys) {
        Write-Host "Command: $($cmd.ToUpper())" -ForegroundColor Green

        Write-Host "  Syntax: $($customCommands[$cmd].syntax)"
        Write-Host "  Desc: $($customCommands[$cmd].description)"

        if ($customCommands[$cmd].parameters) {
            Write-Host "  Params:"
            $customCommands[$cmd].parameters | ForEach-Object {
                Write-Host "    - $_"
            }
        }

        Write-Host ""
    }
}


# -------------------------------------
# ---------- Default Actions ----------
# -------------------------------------

Invoke-Expression (&starship init powershell)
# Import-Module -Name Terminal-Icons
