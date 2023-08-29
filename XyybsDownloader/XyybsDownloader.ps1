Add-Type -AssemblyName System.Windows.Forms

Write-Host "XyybsDownloader v2.0 by WangHaonie"
Write-Host "GitHub��https://github.com/WangHaonie/BatchScripts/tree/main/XyybsDownloader"
Write-Host "�ýű����Ը����������Դ���ѧӢ�ﱨ��������������ļ�"
Write-Host " "

if (-not (Test-Path -Path .\jsonParser.ps1 -PathType Leaf)) {
    Write-Host "δ�ڵ�ǰĿ¼ $PSScriptRoot\ �ҵ� jsonParser.ps1�������޷��������С�" -ForegroundColor Red
    Write-Host "��� https://github.com/WangHaonie/BatchScripts/tree/main/JsonParser ���� jsonParser.ps1 ����ǰĿ¼��" -ForegroundColor Red
    Exit
}

$UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36 Edg/116.0.1938.62"
$resourceCode = Read-Host "�����뱨ֽ/�Ծ��ϵ���Դ��"
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
            Write-Host "�ѻ�ȡ�����ص�ַ��$completeUrl" -ForegroundColor Cyan

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
                    Write-Host "���ڿ�ʼ���� $completeUrl" -ForegroundColor Green
                    Write-Host "��ʾ������ʹ��ԭ�� PowerShell ���������ļ������ٶȿ��ܸ��ˣ����Ե�Ƭ��" -ForegroundColor Green
                    Invoke-WebRequest -Uri $completeUrl -OutFile $selectedFilePath -Headers @{ "User-Agent" = $UserAgent }
                    Write-Host " "
                    Write-Host "���سɹ����ļ��ѱ��浽: $selectedFilePath" -ForegroundColor Cyan
                } else {
                    Write-Host " "
                    Write-Host "��ȡ�����أ��û���ȡ������"
                }
            } catch {
                Write-Host "����ʧ�ܣ�$completeUrl"
            }
        }
    } else {
        Write-Host "δ�ҵ����ص�ַ��������Դ���Ƿ���ȷ" -ForegroundColor Red
    }
} else {
    Write-Host "��������������Դ���Ƿ���ȷ" -ForegroundColor Red
}

