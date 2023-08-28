param(
    [string]$url,
    [string]$nodePath
)

if (-not $url) {
    Write-Host "Usage: JsonParser.ps1 <json URL> [node.subnode]"
    return
}

$userAgent = "MyCustomUserAgent"

try {
    $response = Invoke-RestMethod -Uri $url -Method Get -Headers @{ "User-Agent" = $userAgent }
}
catch {
    Write-Host "Error: Unable to fetch URL or parse JSON."
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

if (-not $nodePath) {
    $response | Out-String -NoQuotes
    return
}

$nodes = $nodePath -split '\.'
$currentNode = $response

foreach ($node in $nodes) {
    $currentNode = Get-JsonValue -node $currentNode -nodeName $node
    if ($currentNode -eq $null) {
        Write-Host "Error: Node $node not found."
        return
    }
}

$currentNode
