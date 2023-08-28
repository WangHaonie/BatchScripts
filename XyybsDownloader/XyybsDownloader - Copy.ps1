Add-Type -AssemblyName System.Windows.Forms

Write-Host " "
# ��ʾ�û�������Դ��
$resourceCode = Read-Host "�����뱨ֽ/�Ծ��ϵ���Դ��"
Write-Host " "

# ���������� URL
$url = "https://www.xyybs.com/index.php?from=fwh&m=search&c=go&a=geturl&q=$resourceCode"

# ���� JsonParser.ps1 �ű������� URL ����
$output = ..\JsonParser\JsonParser.ps1 -url "$url" content

# �ж���������Ƿ�Ϊ�� https ��ͷ�ĳ�����
if ($output -match "^https:\/\/") {
    # �������ӷ��ʲ���ȡ��ҳԴ����
    $webResponse = Invoke-WebRequest -Uri $output
    $webContent = $webResponse.Content

    # ʹ��������ʽ���� //cdn.xyybs.com/uploadfile/*.* ��ʽ���ַ���
    $urls = [regex]::Matches($webContent, '(?<=\/\/cdn\.xyybs\.com\/uploadfile\/)([^\s"]+\.[^\s"]+)')

    # ��ȡ title Ԫ�ص�������ΪĬ���ļ���
    if ($webContent -match '<title>(.*?)<\/title>') {
        $defaultFileName = $matches[1]
    }
    else {
        $defaultFileName = "default"
    }

    # ���������ļ��Ի���
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "All Files (*.*)|*.*"
    $saveFileDialog.FileName = "$defaultFileName"
    $result = $saveFileDialog.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $selectedFilePath = $saveFileDialog.FileName

        # ����ƥ�䵽���ַ�������������
        foreach ($urlMatch in $urls) {
            $completeUrl = "http://cdn.xyybs.com/uploadfile/" + $urlMatch.Groups[1].Value

            # �Ƴ����ܵĵ�����
            $completeUrl = $completeUrl.Trim("'")
            Write-Host "�ѻ�ȡ�����ص�ַ��$completeUrl" -ForegroundColor Cyan
            try {
                # ���ز������ļ�
                $fileFormat = $urlMatch.Groups[1].Value -replace '.*\.(.*)', '$1'
                $selectedFilePathWithFormat = "$selectedFilePath.$fileFormat".Trim("'")
                Write-Host "���ڿ�ʼ���� $completeUrl" -ForegroundColor Green
                Write-Host "��ʾ������ʹ��ԭ�� PowerShell ���������ļ������ٶȿ��ܸ��ˣ����Ե�Ƭ��" -ForegroundColor Magenta
                Invoke-WebRequest -Uri $completeUrl -OutFile $selectedFilePathWithFormat

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
    # ������ǣ���ʾ������Ϣ
    Write-Host "��������������ݲ����� https ��ͷ�ĳ����ӡ�"
}
