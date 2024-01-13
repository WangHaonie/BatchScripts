Write-Host "CompactFileLister v3.0.0 by WangHaonie"
Write-Host "GitHub: https://github.com/WangHaonie/BatchScripts/tree/main/CompactFileLister"
Write-Host "�ù��߿��Բ�ѯ��������Щ�ļ��б�ѹ�� (Compact) �洢"

$availableDrives = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -in 1,2,3,4,5 } | Select-Object -ExpandProperty DeviceID

if ($availableDrives.Count -eq 0) {
    Write-Host " "
    Write-Host "δ�ҵ����õĴ��̷���"
    Write-Host " "
    return
}

Write-Host " "
$availableDrivesList = $availableDrives -join '��'
Write-Host "���õĴ��̷���: $availableDrivesList" -ForegroundColor Green

$selectedDrive = Read-Host "������Ҫɨ����̷������ü�ð�ţ������ִ�Сд��������̷�֮���ÿո�ָ����� c d e��"

$selectedDrive = $selectedDrive.ToUpper().Split(" ") | ForEach-Object { "${_}:" }

$foundCompressedFolders = $false
$compressedFolders = @()

foreach ($drive in $selectedDrive) {
    Write-Host " "
    Write-Host "����ɨ�� $drive �ϱ�ѹ���洢���ļ��У�������ʱȡ���� $drive ���ļ��е���Ŀ" -ForegroundColor Yellow
    $listOutput = & compact.exe /s:$drive\ /a /q
    $lines = $listOutput -split '\r?\n'
    $compressedFolderFound = $false

    for ($i = 1; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "will be|���õ�") {
            $folderPath = $lines[$i - 1] -replace ' Listing | �г� ', ''
            Write-Host "�ҵ��� $folderPath" -ForegroundColor Blue
            $compressedFolderFound = $true
            $compressedFolders += $folderPath
        }
    }

    if (-not $compressedFolderFound) {
        Write-Host "�� $drive ��û�б�ѹ���洢���ļ���" -ForegroundColor Cyan
    } else {
        $foundCompressedFolders = $true
    }
}

if ($foundCompressedFolders) {
    $randomString = [System.IO.Path]::GetRandomFileName().Replace(".", "")
    $outputFilePath = "list_$randomString.txt"
    $compressedFolders | Out-File -FilePath $outputFilePath
    $compressedFoldersCount = $compressedFolders.Length
    Write-Host " "
    Write-Host "���ҵ��� $compressedFoldersCount ��ѹ���洢���ļ���" -ForegroundColor Green
    Write-Host "���е��ļ���·���ѱ��浽�ű�Ŀ¼�£��ļ���Ϊ $outputFilePath " -ForegroundColor Green
    Write-Host " "
} else {
    Write-Host " "
    Write-Host "û�����κ�ѡ���Ĵ��̷������ҵ�ѹ���ļ���" -ForegroundColor Red
    Write-Host " "
}