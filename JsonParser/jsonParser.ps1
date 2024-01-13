param(
    [string]$url,
    [string]$nodePath
)

if (-not $url) {
    Write-Host "�÷�: jsonp <url> <node.subnode>"
    return
}

$userAgent = "MyCustomUserAgent"

try {
    $response = Invoke-RestMethod -Uri $url -Method Get -Headers @{ "User-Agent" = $userAgent }
}
catch {
    Write-Host "�޷���ȡ $url ����ȷ����������ȷ�� URL ���ҵ�ǰ����ͨ��" -ForegroundColor Red
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
        Write-Host "�ڷ��ص��������Ҳ����ڵ� $node" -ForegroundColor Red
        return
    }
}

$currentNode
