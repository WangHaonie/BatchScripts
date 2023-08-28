param(
    [string]$url,
    [string]$nodePath
)

if (-not $url) {
    Write-Host "用法: jsonp <url> <node.subnode>"
    return
}

$userAgent = "MyCustomUserAgent"

try {
    $response = Invoke-RestMethod -Uri $url -Method Get -Headers @{ "User-Agent" = $userAgent }
}
catch {
    Write-Host "无法读取 $url ，请确保输入了正确的 URL 并且当前网络通畅" -ForegroundColor Red
    return
}

if (-not $nodePath) {
    $response | ConvertTo-Json
    return
}

function Get-JsonValue {
    param (
        [object]$node,
        [string]$nodeName
    )

    if ($node -eq $null) {
        return $null
    }

    if ($node -is [System.Management.Automation.PSCustomObject]) {
        return $node.$nodeName
    }
    elseif ($node -is [System.Array]) {
        $index = [int]$nodeName
        if ($index -ge 0 -and $index -lt $node.Length) {
            return $node[$index]
        }
    }

    return $null
}

$nodes = $nodePath -split '\.'
$currentNode = $response

foreach ($node in $nodes) {
    $currentNode = Get-JsonValue -node $currentNode -nodeName $node
    if ($currentNode -eq $null) {
        Write-Host "在返回的内容中找不到节点 $node" -ForegroundColor Red
        return
    }
}

$currentNode
