Add-Type -AssemblyName System.Windows.Forms

Write-Host " "
# 提示用户输入资源码
$resourceCode = Read-Host "请输入报纸/试卷上的资源码"
Write-Host " "

# 构建完整的 URL
$url = "https://www.xyybs.com/index.php?from=fwh&m=search&c=go&a=geturl&q=$resourceCode"

# 调用 JsonParser.ps1 脚本并传递 URL 参数
$output = ..\JsonParser\JsonParser.ps1 -url "$url" content

# 判断输出内容是否为以 https 开头的超链接
if ($output -match "^https:\/\/") {
    # 发起链接访问并获取网页源代码
    $webResponse = Invoke-WebRequest -Uri $output
    $webContent = $webResponse.Content

    # 使用正则表达式查找 //cdn.xyybs.com/uploadfile/*.* 格式的字符串
    $urls = [regex]::Matches($webContent, '(?<=\/\/cdn\.xyybs\.com\/uploadfile\/)([^\s"]+\.[^\s"]+)')

    # 获取 title 元素的内容作为默认文件名
    if ($webContent -match '<title>(.*?)<\/title>') {
        $defaultFileName = $matches[1]
    }
    else {
        $defaultFileName = "default"
    }

    # 弹出保存文件对话框
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "All Files (*.*)|*.*"
    $saveFileDialog.FileName = "$defaultFileName"
    $result = $saveFileDialog.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $selectedFilePath = $saveFileDialog.FileName

        # 遍历匹配到的字符串并下载内容
        foreach ($urlMatch in $urls) {
            $completeUrl = "http://cdn.xyybs.com/uploadfile/" + $urlMatch.Groups[1].Value

            # 移除可能的单引号
            $completeUrl = $completeUrl.Trim("'")
            Write-Host "已获取到下载地址：$completeUrl" -ForegroundColor Cyan
            try {
                # 下载并保存文件
                $fileFormat = $urlMatch.Groups[1].Value -replace '.*\.(.*)', '$1'
                $selectedFilePathWithFormat = "$selectedFilePath.$fileFormat".Trim("'")
                Write-Host "正在开始下载 $completeUrl" -ForegroundColor Green
                Write-Host "提示：正在使用原生 PowerShell 引擎下载文件，其速度可能感人，请稍等片刻" -ForegroundColor Magenta
                Invoke-WebRequest -Uri $completeUrl -OutFile $selectedFilePathWithFormat

                Write-Host "下载成功！文件已保存为: $selectedFilePathWithFormat" -ForegroundColor Cyan
            }
            catch {
                Write-Host "下载失败：$completeUrl"
            }
        }
    }
    else {
        Write-Host "已取消下载：用户已取消保存"
    }
}
else {
    # 如果不是，显示错误消息
    Write-Host "发生错误：输出内容不是以 https 开头的超链接。"
}
