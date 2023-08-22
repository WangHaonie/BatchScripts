Write-Host "CompactFileLister v3.0.0 by WangHaonie"
Write-Host "GitHub: https://github.com/WangHaonie/BatchScripts/tree/main/CompactFileLister"
Write-Host "该工具可以查询磁盘中哪些文件夹被压缩 (Compact) 存储"

$availableDrives = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -in 1,2,3,4,5 } | Select-Object -ExpandProperty DeviceID

if ($availableDrives.Count -eq 0) {
    Write-Host " "
    Write-Host "未找到可用的磁盘分区"
    Write-Host " "
    return
}

Write-Host " "
$availableDrivesList = $availableDrives -join '、'
Write-Host "可用的磁盘分区: $availableDrivesList" -ForegroundColor Green

$selectedDrive = Read-Host "请输入要扫描的盘符（不用加冒号，不区分大小写），多个盘符之间用空格分隔（如 c d e）"

$selectedDrive = $selectedDrive.ToUpper().Split(" ") | ForEach-Object { "${_}:" }

$foundCompressedFolders = $false
$compressedFolders = @()

foreach ($drive in $selectedDrive) {
    Write-Host " "
    Write-Host "正在扫描 $drive 上被压缩存储的文件夹，具体用时取决于 $drive 上文件夹的数目" -ForegroundColor Yellow
    $listOutput = & compact.exe /s:$drive\ /a /q
    $lines = $listOutput -split '\r?\n'
    $compressedFolderFound = $false

    for ($i = 1; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "will be|将得到") {
            $folderPath = $lines[$i - 1] -replace ' Listing | 列出 ', ''
            Write-Host "找到了 $folderPath" -ForegroundColor Blue
            $compressedFolderFound = $true
            $compressedFolders += $folderPath
        }
    }

    if (-not $compressedFolderFound) {
        Write-Host "在 $drive 上没有被压缩存储的文件夹" -ForegroundColor Cyan
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
    Write-Host "共找到了 $compressedFoldersCount 个压缩存储的文件夹" -ForegroundColor Green
    Write-Host "所有的文件夹路径已保存到脚本目录下，文件名为 $outputFilePath " -ForegroundColor Green
    Write-Host " "
} else {
    Write-Host " "
    Write-Host "没有在任何选定的磁盘分区上找到压缩文件夹" -ForegroundColor Red
    Write-Host " "
}