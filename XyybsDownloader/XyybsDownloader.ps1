Add-Type -AssemblyName System.Windows.Forms

Write-Host "XyybsDownloader v2.0 by WangHaonie"
Write-Host "GitHub：https://github.com/WangHaonie/BatchScripts/tree/main/XyybsDownloader"
Write-Host "该脚本可以根据输入的资源码从学英语报社官网下载听力文件"
Write-Host " "

if (-not (Test-Path -Path .\jsonParser.ps1 -PathType Leaf)) {
    Write-Host "未在当前目录 $PSScriptRoot\ 找到 jsonParser.ps1，程序无法继续运行。" -ForegroundColor Red
    Write-Host "请从 https://github.com/WangHaonie/BatchScripts/tree/main/JsonParser 下载 jsonParser.ps1 到当前目录。" -ForegroundColor Red
    Exit
}

$UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36 Edg/116.0.1938.62"
$resourceCode = Read-Host "请输入报纸/试卷上的资源码"
Write-Host " "

$url = "https://www.xyybs.com/index.php?from=fwh&m=search&c=go&a=geturl&q=$resourceCode"
$output = .\jsonParser.ps1 -url "$url" content

if ($output -match "^https:\/\/") {
    $webResponse = Invoke-WebRequest -Uri $output -Headers @{ "User-Agent" = $UserAgent }
    $webContent = $webResponse.Content
    $urls = [regex]::Matches($webContent, '(?<=\/\/cdn\.xyybs\.com\/uploadfile\/)([^\s"]+\.[^\s"]+)')

    if ($urls.Count -gt 0) {
        if ($webContent -match '<title>(.*?)<\/title>') {
            $defaultFileName = $matches[1]
        } else {
            $defaultFileName = "default"
        }

        foreach ($urlMatch in $urls) {
            $completeUrl = "http://cdn.xyybs.com/uploadfile/" + $urlMatch.Groups[1].Value
            $completeUrl = $completeUrl.Trim("'")
            Write-Host "已获取到下载地址：$completeUrl" -ForegroundColor Cyan

            try {
                $fileFormat = $urlMatch.Groups[1].Value -replace '.*\.(.*)', '$1'
                $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
                $saveFileDialog.Filter = "All Files (*.*)|*.*"
                $fileFormat = $fileFormat.Trim("'")
                $saveFileDialog.FileName = "$defaultFileName.$fileFormat"
                $result = $saveFileDialog.ShowDialog()

                if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
                    $selectedFilePath = $saveFileDialog.FileName
                    $selectedFilePath = $selectedFilePath.Trim("'")
                    Write-Host " "
                    Write-Host "正在开始下载 $completeUrl" -ForegroundColor Green
                    Write-Host "提示：正在使用原生 PowerShell 引擎下载文件，其速度可能感人，请稍等片刻" -ForegroundColor Green
                    Invoke-WebRequest -Uri $completeUrl -OutFile $selectedFilePath -Headers @{ "User-Agent" = $UserAgent }
                    Write-Host " "
                    Write-Host "下载成功，文件已保存到: $selectedFilePath" -ForegroundColor Cyan
                } else {
                    Write-Host " "
                    Write-Host "已取消下载：用户已取消保存"
                }
            } catch {
                Write-Host "下载失败：$completeUrl"
            }
        }
    } else {
        Write-Host "未找到下载地址：请检查资源码是否正确" -ForegroundColor Red
    }
} else {
    Write-Host "发生错误：请检查资源码是否正确" -ForegroundColor Red
}

