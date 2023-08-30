Write-Host "XyybsDownloader v3.0 by WangHaonie"
Write-Host "GitHub��https://github.com/WangHaonie/BatchScripts/tree/main/XyybsDownloader"
Write-Host "�ýű����Ը����������Դ���ѧӢ�ﱨ��������������ļ�"

$winver = (Get-WmiObject Win32_OperatingSystem).Version
if ([version]$winver -lt [version]"6.2") {
    Write-Host " "
    Write-Host "���棺��ǰϵͳΪ Windows 8/8.1 ֮ǰ�İ汾������Ԥװ�˾ɰ汾 PowerShell��" -ForegroundColor Red
    Write-Host "Ҳ����˵�ýű��ڵ�ǰϵͳ�Ͽ��ܲ����������С�" -ForegroundColor Red
    Write-Host " "
}

$psver = $PSVersionTable.PSVersion.Major
if ($psver -lt 3) {
    Write-Host " "
    Write-Host "���棺�˽ű��������°汾 PowerShell ����ʶ��Ĵ��룬" -ForegroundColor Red
    Write-Host "����ǰ PowerShell �汾���� 3.0������ζ�Ŵ˽ű��Ĳ��ִ��뽫���ᱻ��ȷִ��" -ForegroundColor Red
    Write-Host " "
}

if (-not (Test-Path -Path .\jsonParser.ps1 -PathType Leaf)) {
    Write-Host "δ�ڵ�ǰĿ¼ $PSScriptRoot\ �ҵ� jsonParser.ps1���ű��޷��������С�" -ForegroundColor Red
    Write-Host "��� https://github.com/WangHaonie/BatchScripts/tree/main/JsonParser ���� jsonParser.ps1 ����ǰĿ¼��" -ForegroundColor Red
    Exit
}

Add-Type -AssemblyName System.Windows.Forms
$UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36 Edg/116.0.1938.62"
Write-Host " "
$resourceCode = Read-Host "�����뱨ֽ/�Ծ��ϵ���Դ��"

$url = "https://www.xyybs.com/index.php?from=fwh&m=search&c=go&a=geturl&q=$resourceCode"
$output = .\jsonParser.ps1 "$url" content

if ($output -match "^https:\/\/") {
    $webResponse = Invoke-WebRequest -UseBasicParsing -Uri $output -Headers @{ "User-Agent" = $UserAgent }
    $webContent = $webResponse.Content
    $urls = [regex]::Matches($webContent, '(?<=\/\/cdn\.xyybs\.com\/uploadfile\/)([^\s"]+\.[^\s"]+)')

    if ($urls.Count -gt 0) {
        if ($webContent -match '<title>(.*?)<\/title>') {
            $defaultFileName = $matches[1]
            $defaultFileName = $defaultFileName.Trim("-�ֻ�ѧӢ��")
            if ($defaultFileName -match "��ѧӢ�") {
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
            Write-Host "����Դ�뺬�� $urlCount ���ļ������Զ�Ϊ�����ļ����������" -ForegroundColor Blue
        }

        foreach ($urlMatch in $urls) {
            $completeUrl = "http://cdn.xyybs.com/uploadfile/" + $urlMatch.Groups[1].Value
            $completeUrl = $completeUrl.Trim("'")
            Write-Host " "
            Write-Host "�ѻ�ȡ�����ص�ַ��$completeUrl" -ForegroundColor Yellow

            try {
                $fileFormat = $urlMatch.Groups[1].Value -replace '.*\.(.*)', '$1'
                $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
                $fileFormatShow = $fileFormat.Trim(".").Trim("'").ToUpper()
                $fileFormat = $fileFormat.Trim("'")
                $saveFileDialog.Filter = "$fileFormatShow �ļ� (*.$fileFormat)|*.$fileFormat|�����ļ� (*.*)|*.*"

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
                    Write-Host "���ڿ�ʼ���� $targetFile" -ForegroundColor Green
                    Write-Host "��ʾ������ʹ�� PowerShell �����������������ļ������ٶȿ��ܸ��ˣ����Ե�Ƭ��" -ForegroundColor Green
                    Invoke-WebRequest -UseBasicParsing -Uri $completeUrl -OutFile $selectedFilePath -Headers @{ "User-Agent" = $UserAgent }
                    Write-Host "���سɹ����ļ��ѱ��浽: $selectedFilePath" -ForegroundColor Cyan
                } else {
                    Write-Host "��ȡ�����أ��û���ȡ������" -ForegroundColor Red
                }
            } catch {
                Write-Host " "
                Write-Host "�޷����� $completeUrl���������ڱ��������Ŀ��������������쳣����ͨ���������ɸýű����µ�����"
            }
        }
    } else {
        Write-Host " "
        Write-Host "�޷���ȡ���ص�ַ��������Դ���Ƿ���ȷ" -ForegroundColor Red
    }
} else {
    Write-Host " "
    Write-Host "��������������Դ���Ƿ���ȷ" -ForegroundColor Red
}

