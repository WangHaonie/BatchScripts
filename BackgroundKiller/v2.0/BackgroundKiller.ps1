$processListFile = "BackgroundKillerList.cfg"
$launchTime = Get-Date -Format "yyyy/MM/dd HH:mm:ss.fff"
$processes = @()
$originalTitle = $Host.UI.RawUI.WindowTitle
$host.UI.RawUI.WindowTitle = "BackgroundKiller v2.0 by WangHaonie - 于 $launchTime 开始运行"
$statistics = @{}
$listHint = @"
# BackgroundKiller v2.0 by WangHaonie
# GitHub: https://github.com/WangHaonie/BatchScripts/tree/main/BackgroundKiller
# 该脚本可以防止指定的程序在关闭后仍在后台运行。注意请不要指定系统程序，否则会导致系统崩溃
# 
# BackgroundKiller 配置文件，用于存储监视的进程，原始文件名 BackgroundKillerList.cfg；
# 此脚本将以指定的时间为周期，不断读取该文件来刷新进程列表。关于具体的周期你可以修改脚本最后的 timeout.exe /t <休眠时间，单位秒> /nobreak，
# 但最好设置为 30，你可以根据具体情况进行修改；
# 你可以在这里添加要监视的进程，注意一行一个进程名称，不要加 .exe 后缀；
# 你可以使用 "#" 来表示注释信息，当然你也可以使用通配符 * 和 ? 来匹配更多的进程.
"@

function Write-Centered {
    param (
        [Parameter(Mandatory = $true)]
        [String]$Message
    )

    $hostWidth = $Host.UI.RawUI.WindowSize.Width
    $msgLength = $Message.Length
    $newWidth = ($hostWidth - $msgLength) / 2

    Write-Host (' ' * $newWidth) -NoNewline
    Write-Host $Message -ForegroundColor Cyan
}

function Get-ProcessList {
    param (
        [string]$filePath
    )

    $processes = Get-Content $filePath | Where-Object { $_ -notmatch '^\s*(#|$)' } | ForEach-Object { $_.Trim() } | Select-Object -Unique

    return $processes
}

while ($true) {
    Write-Centered -Message "BackgroundKiller v2.0 by WangHaonie"
    Write-Host "GitHub: https://github.com/WangHaonie/BatchScripts/tree/main/BackgroundKiller"
    Write-Host "该脚本可以防止指定的程序在关闭后仍在后台运行。注意请不要指定系统程序，否则会导致系统崩溃"
    Write-Host "脚本启动时间：$launchTime" -ForegroundColor Cyan
    Write-Host " "
    $currentTimeInit = Get-Date -Format "yyyy/MM/dd HH:mm:ss.fff"
    if (-not (Test-Path -Path $processListFile)) {
        $null = New-Item -Path $processListFile -ItemType File
        $listHint | Out-File -FilePath $processListFile -Append
        Write-Host "[$currentTimeInit][INFO] 未检测到 $processListFile，已自动创建，请添加进程" -ForegroundColor Green
    }
    else {
        $processes = Get-ProcessList -filePath $processListFile
        if ($processes.Count -eq 0) {
            Write-Host "[$currentTimeInit][ERROR] 进程列表为空，请在 $processListFile 中添加你想监视的进程名称" -ForegroundColor Red
        }
        else {
            $processes = Get-ProcessList -filePath $processListFile
            $processList = ($processes | ForEach-Object { $_ + ".exe" }) -join ", "
            Write-Host "正在监视以下进程：$processList" -ForegroundColor Cyan
            foreach ($process in $processes) {
                if (-not $statistics.ContainsKey($process)) {
                    $statistics[$process] = @{
                        MonitoringCount = 0
                        NotRunningCount = 0
                        ForegroundCount = 0
                        BackgroundCount = 0
                    }
                }
                $statistics[$process].MonitoringCount++
                $runningProcesses = Get-Process $process -ErrorAction SilentlyContinue
                $currentTime = Get-Date -Format "yyyy/MM/dd HH:mm:ss.fff"

                if ($runningProcesses.Count -eq 0) {
                    $statistics[$process].NotRunningCount++
                    Write-Host "[$currentTime][ERROR] $process.exe 没有运行。" -ForegroundColor Red
                }
                else {
                    $foregroundProcesses = $runningProcesses | Where-Object { $_.MainWindowTitle -ne "" }
                    $backgroundProcesses = $runningProcesses | Where-Object { $_.MainWindowTitle -eq "" }

                    if ($foregroundProcesses.Count -eq 0) {
                        $statistics[$process].BackgroundCount++
                        Write-Host "[$currentTime][WARN] $process.exe 正在后台运行，已结束进程..." -ForegroundColor Yellow
                        $backgroundProcesses | ForEach-Object {
                            Stop-Process -Id $_.Id -Force -ErrorAction Ignore
                        }
                    }
                    else {
                        $statistics[$process].ForegroundCount++
                        Write-Host "[$currentTime][INFO] $process.exe 正在前台运行。" -ForegroundColor Green
                    }
                }
            }
            Write-Host " "
            Write-Centered -Message "统计信息"
            foreach ($process in $processes) {
                $processStatistics = $statistics[$process]
                Write-Host "共监视了 $process.exe $($processStatistics.MonitoringCount) 次，其中有 $($processStatistics.BackgroundCount) 次在后台运行，$($processStatistics.ForegroundCount) 次在前台运行，$($processStatistics.NotRunningCount) 次没有运行。" -ForegroundColor Cyan
            }
        }
    }

    timeout.exe /t 2 /nobreak
    Clear-Host
}

$host.UI.RawUI.WindowTitle = $originalTitle