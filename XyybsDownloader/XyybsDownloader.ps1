Write-Host "XyybsDownloader v3.0 by WangHaonie"
Write-Host "GitHub：https://github.com/WangHaonie/BatchScripts/tree/main/XyybsDownloader"
Write-Host "该脚本可以根据输入的资源码从学英语报社官网下载听力文件"

$winver = (Get-WmiObject Win32_OperatingSystem).Version
if ([version]$winver -lt [version]"6.2") {
    Write-Host " "
    Write-Host "警告：当前系统为 Windows 8/8.1 之前的版本，可能预装了旧版本 PowerShell。" -ForegroundColor Red
    Write-Host "也就是说该脚本在当前系统上可能不会正常运行。" -ForegroundColor Red
    Write-Host " "
}

$psver = $PSVersionTable.PSVersion.Major
if ($psver -lt 3) {
    Write-Host " "
    Write-Host "警告：此脚本包含了新版本 PowerShell 才能识别的代码，" -ForegroundColor Red
    Write-Host "而当前 PowerShell 版本低于 3.0，这意味着此脚本的部分代码将不会被正确执行" -ForegroundColor Red
    Write-Host " "
}

if (-not (Test-Path -Path .\jsonParser.ps1 -PathType Leaf)) {
    Write-Host "未在当前目录 $PSScriptRoot\ 找到 jsonParser.ps1，脚本无法继续运行。" -ForegroundColor Red
    Write-Host "请从 https://github.com/WangHaonie/BatchScripts/tree/main/JsonParser 下载 jsonParser.ps1 到当前目录。" -ForegroundColor Red
    Exit
}

Add-Type -AssemblyName System.Windows.Forms
$UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36 Edg/116.0.1938.62"
Write-Host " "
$resourceCode = Read-Host "请输入报纸/试卷上的资源码"

$url = "https://www.xyybs.com/index.php?from=fwh&m=search&c=go&a=geturl&q=$resourceCode"
$output = .\jsonParser.ps1 "$url" content

if ($output -match "^https:\/\/") {
    $webResponse = Invoke-WebRequest -UseBasicParsing -Uri $output -Headers @{ "User-Agent" = $UserAgent }
    $webContent = $webResponse.Content
    $urls = [regex]::Matches($webContent, '(?<=\/\/cdn\.xyybs\.com\/uploadfile\/)([^\s"]+\.[^\s"]+)')

    if ($urls.Count -gt 0) {
        if ($webContent -match '<title>(.*?)<\/title>') {
            $defaultFileName = $matches[1]
            $defaultFileName = $defaultFileName.Trim("-手机学英语")
            if ($defaultFileName -match "《学英语》") {
                if ($webContent -match '<h3>(.*?)<\/h3>') {
                    $defaultFileName = $matches[1]
                }
            }
        } else {
            $defaultFileName = "default"
        }

        $counter = 0
        $urlCount = $urls.Count

        if ($urlCount -gt 1) {
            Write-Host " "
            Write-Host "该资源码含有 $urlCount 个文件，已自动为各个文件加上了序号" -ForegroundColor Blue
        }

        foreach ($urlMatch in $urls) {
            $completeUrl = "http://cdn.xyybs.com/uploadfile/" + $urlMatch.Groups[1].Value
            $completeUrl = $completeUrl.Trim("'")
            Write-Host " "
            Write-Host "已获取到下载地址：$completeUrl" -ForegroundColor Yellow

            try {
                $fileFormat = $urlMatch.Groups[1].Value -replace '.*\.(.*)', '$1'
                $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
                $fileFormatShow = $fileFormat.Trim(".").Trim("'").ToUpper()
                $fileFormat = $fileFormat.Trim("'")
                $saveFileDialog.Filter = "$fileFormatShow 文件 (*.$fileFormat)|*.$fileFormat|所有文件 (*.*)|*.*"

                if ($urls.Count -gt 1) {
                    $counter++
                    $saveFileDialog.FileName = "$defaultFileName" + "_" + "$counter.$fileFormat"
                } else {
                    $saveFileDialog.FileName = "$defaultFileName.$fileFormat"
                }
                
                $result = $saveFileDialog.ShowDialog()

                if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
                    $selectedFilePath = $saveFileDialog.FileName
                    $selectedFilePath = $selectedFilePath.Trim("'")
                    $targetFile = Split-Path -Path $selectedFilePath -Leaf
                    Write-Host "正在开始下载 $targetFile" -ForegroundColor Green
                    Write-Host "提示：正在使用 PowerShell 内置下载引擎下载文件，其速度可能感人，请稍等片刻" -ForegroundColor Green
                    Invoke-WebRequest -UseBasicParsing -Uri $completeUrl -OutFile $selectedFilePath -Headers @{ "User-Agent" = $UserAgent }
                    Write-Host "下载成功，文件已保存到: $selectedFilePath" -ForegroundColor Cyan
                } else {
                    Write-Host "已取消下载：用户已取消保存" -ForegroundColor Red
                }
            } catch {
                Write-Host " "
                Write-Host "无法下载 $completeUrl，可能由于本地网络或目标服务器出现了异常，这通常并不是由该脚本导致的问题"
            }
        }
    } else {
        Write-Host " "
        Write-Host "无法获取下载地址，请检查资源码是否正确" -ForegroundColor Red
    }
} else {
    Write-Host " "
    Write-Host "发生错误：请检查资源码是否正确" -ForegroundColor Red
}

