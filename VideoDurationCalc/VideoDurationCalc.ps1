param (
    [string]$videoTime,
    [double]$playbackSpeed
)

if ((!$videoTime -or !$playbackSpeed) -or ($videoTime -and !$playbackSpeed)) {
    Write-Host " "
    Write-Host "ȱ����ز������ѽ��뽻��ģʽ���У�����ȷ��ָ����ز���" -ForegroundColor Red
    Write-Host "��ʽ��watchtime.ps1 <��Ƶʱ�� HH:mm:ss> <���ű���>" -ForegroundColor Red
    Write-Host " "
    $videoTime = Read-Host "��������Ƶʱ������ʽ ʱ:��:�룩"
    $playbackSpeed = Read-Host "�����벥�ű��٣�����2����������2����"
}

try {
    $timespan = [TimeSpan]::Parse($videoTime)
    $resultTicks = [math]::Round($timespan.Ticks / $playbackSpeed)
    $resultTimeSpan = [TimeSpan]::FromTicks($resultTicks)
    $result = $resultTimeSpan.ToString("hh\:mm\:ss")
} catch {
    Write-Host " "
    Write-Host "��������ʧ�ܣ���������ز�����ʽ�����δָ���κβ���" -ForegroundColor Red
    Write-Host " "
    exit
}

Write-Host " "
Write-Host "�� $playbackSpeed ���ٲ��Ÿ�ʱ��Ϊ $videoTime ����Ƶ��Ҫ $result��"
Write-Host " "
