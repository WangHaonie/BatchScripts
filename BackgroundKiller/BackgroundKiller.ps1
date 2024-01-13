function Get-CurrentTime {
    Get-Date -Format "yyyy/MM/dd HH:mm:ss.fff"
}
$launchTime = Get-CurrentTime

$scriptVersion = "v2.4"
$processListFile = "BackgroundKillerList.cfg"
$launchTime = Get-CurrentTime
$processes = @()
$originalTitle = $Host.UI.RawUI.WindowTitle
$host.UI.RawUI.WindowTitle = "BackgroundKiller $scriptVersion by WangHaonie - �� $launchTime ��ʼ����"
$statistics = @{}
$defaultTimeout = 30
$listHint = @"
# BackgroundKiller $scriptVersion by WangHaonie
# GitHub: https://github.com/WangHaonie/BatchScripts/tree/main/BackgroundKiller
# �ýű����Է�ָֹ���ĳ����ڹرպ����ں�̨���С�ע���벻Ҫָ��ϵͳ���򣬷���ᵼ��ϵͳ����
# 
# BackgroundKiller �����ļ������ڴ洢Ҫ���ӵĽ��̣�ԭʼ�ļ��� $processListFile��
#
# �˽ű�����ָ����ʱ��Ϊ���ڣ����϶�ȡ���ļ���ˢ�½����б�������޸������ֶΣ�
/timeout=30 # �������Ϊ 30����Ȼ��Ҳ���Ը��ݾ�����������޸ģ�
# ��������������Ҫ���ӵĽ��̣�ע��һ��һ���������ƣ���Ҫ�� .exe ��׺��
# �����ʹ�� "#" ����ʾע����Ϣ����Ȼ��Ҳ����ʹ��ͨ��� * �� ? ��ƥ�����Ľ��̡�
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

    $processes = Get-Content $filePath -ErrorAction Ignore | Where-Object { $_ -notmatch "^\s*(#|$|/)" } | ForEach-Object { $_.Trim() } | Select-Object -Unique

    return $processes
}

while ($true) {
    $processes = Get-ProcessList -filePath $processListFile
    $timeout = $defaultTimeout
    $detectTimeout = Get-Content $processListFile -ErrorAction Ignore | Where-Object { $_ -notmatch '^\s*#' -and $_ -match '^\s*/' } -ErrorAction Ignore | ForEach-Object { $_.Trim() } -ErrorAction Ignore | Select-Object -Unique -ErrorAction Ignore

    foreach ($line in $detectTimeout) {
        if ($line -match "/timeout=(\d+)") {
            $timeout = [int]$Matches[1]
        }
    }

    Write-Centered -Message "BackgroundKiller $scriptVersion by WangHaonie"
    Write-Host "GitHub: https://github.com/WangHaonie/BatchScripts/tree/main/BackgroundKiller"
    Write-Host "�ýű����Է�ָֹ���ĳ����ڹرպ����ں�̨���С�ע���벻Ҫָ��ϵͳ���򣬷���ᵼ��ϵͳ����"
    Write-Host "�ű��� $launchTime ��ʼ���У����õ�˯��ʱ��Ϊ $timeout ��" -ForegroundColor Cyan
    Write-Host " "

    $currentTimeInit = Get-Date -Format "yyyy/MM/dd HH:mm:ss.fff"

    if (-not (Test-Path -Path $processListFile)) {
        $null = New-Item -Path $processListFile -ItemType File
        $listHint | Out-File -FilePath $processListFile -Append
        Write-Host "[$currentTimeInit][INFO] δ��⵽ $processListFile�����Զ�����������ӽ���" -ForegroundColor Green
    }
    else {
        if ($processes.Count -eq 0) {
            Write-Host "[$currentTimeInit][ERROR] �����б�Ϊ�գ����� $processListFile �����������ӵĽ�������" -ForegroundColor Red
        }
        else {
            $processList = ($processes | ForEach-Object { $_ + ".exe" }) -join ", "
            Write-Host "[$launchTime][INFO] ��ʼ�������½��̣�$processList" -ForegroundColor White

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

                    Write-Host "[$currentTime][ERROR] $process.exe û�����С�" -ForegroundColor Red
                }
                else {
                    $foregroundProcesses = $runningProcesses | Where-Object { $_.MainWindowTitle -ne "" }
                    $backgroundProcesses = $runningProcesses | Where-Object { $_.MainWindowTitle -eq "" }

                    if ($foregroundProcesses.Count -eq 0) {
                        $statistics[$process].BackgroundCount++

                        Write-Host "[$currentTime][WARN] $process.exe ���ں�̨���У��ѽ�������..." -ForegroundColor Yellow

                        $backgroundProcesses | ForEach-Object {
                            Stop-Process -Id $_.Id -Force -ErrorAction Ignore
                        }
                    }
                    else {
                        $statistics[$process].ForegroundCount++

                        Write-Host "[$currentTime][INFO] $process.exe ����ǰ̨���С�" -ForegroundColor Green
                    }
                }
            }

            Write-Host " "
            Write-Centered -Message "ͳ����Ϣ"

            foreach ($process in $processes) {
                $processStatistics = $statistics[$process]
                Write-Host "�������� $process.exe $($processStatistics.MonitoringCount) �Σ������� $($processStatistics.BackgroundCount) ���ں�̨���У�$($processStatistics.ForegroundCount) ����ǰ̨���У�$($processStatistics.NotRunningCount) ��û�����С�" -ForegroundColor Cyan
            }
        }
    }

    timeout.exe /t $timeout /nobreak
    Clear-Host
}

$host.UI.RawUI.WindowTitle = $originalTitle