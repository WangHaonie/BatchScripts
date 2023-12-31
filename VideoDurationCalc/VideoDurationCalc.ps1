param (
    [string]$videoTime,
    [double]$playbackSpeed
)

Write-Host "VideoDurationCalc v2.0.0 by WangHaonie"
Write-Host "GitHub: https://github.com/WangHaonie/BatchScripts/tree/main/VideoDurationCalc"
Write-Host "该工具可以计算开了倍速后的视频，需要多久才能播放完"

if ((!$videoTime -or !$playbackSpeed) -or ($videoTime -and !$playbackSpeed)) {
    Write-Host " "
    Write-Host "缺少相关参数，已进入交互模式运行，请正确地指定相关参数" -ForegroundColor Red
    Write-Host "格式：vdc <视频时长 HH:mm:ss> <播放倍速>" -ForegroundColor Red
    Write-Host " "
    $videoTime = Read-Host "请输入视频时长（格式 时:分:秒）"
    $playbackSpeed = Read-Host "请输入播放倍速，比如2倍速则输入2即可"
}

try {
    $timespan = [TimeSpan]::Parse($videoTime)
    $resultTicks = [math]::Round($timespan.Ticks / $playbackSpeed)
    $resultTimeSpan = [TimeSpan]::FromTicks($resultTicks)
    $result = $resultTimeSpan.ToString("hh\:mm\:ss")
} catch {
    Write-Host " "
    Write-Host "程序运行失败，可能是相关参数格式错误或未指定任何参数" -ForegroundColor Red
    Write-Host " "
    exit
}

Write-Host " "
Write-Host "以 $playbackSpeed 倍速播放该时长为 $videoTime 的视频需要 $result。" -ForegroundColor Cyan
Write-Host " "
