Add-Type -AssemblyName System.Windows.Forms
Write-Host " "
$UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36 Edg/116.0.1938.62"
$resourceCode = Read-Host "�����뱨ֽ/�Ծ��ϵ���Դ��"
Write-Host " "
$url = "https://www.xyybs.com/index.php?from=fwh&m=search&c=go&a=geturl&q=$resourceCode"
$output = .\JsonParser.ps1 -url "$url" content

if ($output -match "^https:\/\/") {
    $webResponse = Invoke-WebRequest -Uri $output -Headers @{ "User-Agent" = $UserAgent }
    $webContent = $webResponse.Content
    $urls = [regex]::Matches($webContent, '(?<=\/\/cdn\.xyybs\.com\/uploadfile\/)([^\s"]+\.[^\s"]+)')
    if ($webContent -match '<title>(.*?)<\/title>') {
        $defaultFileName = $matches[1]
    }
    else {
        $defaultFileName = "default"
    }
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "All Files (*.*)|*.*"
    $saveFileDialog.FileName = "$defaultFileName"
    $result = $saveFileDialog.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $selectedFilePath = $saveFileDialog.FileName

        foreach ($urlMatch in $urls) {
            $completeUrl = "http://cdn.xyybs.com/uploadfile/" + $urlMatch.Groups[1].Value

            $completeUrl = $completeUrl.Trim("'")
            Write-Host "�ѻ�ȡ�����ص�ַ��$completeUrl" -ForegroundColor Cyan
            try {
                $fileFormat = $urlMatch.Groups[1].Value -replace '.*\.(.*)', '$1'
                $selectedFilePathWithFormat = "$selectedFilePath.$fileFormat".Trim("'")
                Write-Host "���ڿ�ʼ���� $completeUrl" -ForegroundColor Green
                Write-Host "��ʾ������ʹ��ԭ�� PowerShell ���������ļ������ٶȿ��ܸ��ˣ����Ե�Ƭ��" -ForegroundColor Green
                Invoke-WebRequest -Uri $completeUrl -OutFile $selectedFilePathWithFormat -Headers @{ "User-Agent" = $UserAgent }

                Write-Host "���سɹ����ļ��ѱ���Ϊ: $selectedFilePathWithFormat" -ForegroundColor Cyan
            }
            catch {
                Write-Host "����ʧ�ܣ�$completeUrl"
            }
        }
    }
    else {
        Write-Host "��ȡ�����أ��û���ȡ������"
    }
}
else {
    Write-Host "��������������Դ���Ƿ���ȷ" -ForegroundColor Red
}
