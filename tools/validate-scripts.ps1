$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$errors = [System.Collections.Generic.List[string]]::new()

function Add-ValidationError {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][int]$Line,
        [Parameter(Mandatory = $true)][string]$Message
    )

    $relativePath = Resolve-Path -LiteralPath $Path -Relative
    $errors.Add("${relativePath}:${Line}: ${Message}") | Out-Null
}

function Get-RepoFiles {
    param([string[]]$Extensions)

    Get-ChildItem -LiteralPath $repoRoot -Recurse -File |
        Where-Object {
            $_.FullName -notmatch "\\.git\\" -and
            $Extensions -contains $_.Extension.ToLowerInvariant()
        }
}

$batchFiles = @(Get-RepoFiles -Extensions @(".bat", ".cmd"))
foreach ($file in $batchFiles) {
    $lines = @(Get-Content -LiteralPath $file.FullName)
    $labels = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)

    foreach ($line in $lines) {
        if ($line -match "^\s*:([^:\s][^\s]*)") {
            [void]$labels.Add($Matches[1].TrimStart(":"))
        }
    }

    for ($index = 0; $index -lt $lines.Count; $index++) {
        $line = $lines[$index]
        $lineNumber = $index + 1

        foreach ($match in [regex]::Matches($line, "(?i)\b(?:goto|call)\s+:?([A-Za-z0-9_][A-Za-z0-9_-]*)")) {
            $label = $match.Groups[1].Value
            if ($label -ieq "eof") {
                continue
            }

            if (-not $labels.Contains($label)) {
                Add-ValidationError -Path $file.FullName -Line $lineNumber -Message "referencia label inexistente '${label}'"
            }
        }

        $checks = @(
            @{ Pattern = "(?i)\bcall\s+%user_command%"; Message = "evite executar comando arbitrario digitado pelo usuario" },
            @{ Pattern = "(?i)LOCALAPDATA"; Message = "provavel typo: use LOCALAPPDATA" },
            @{ Pattern = "(?i)gh\s+auth\s+login.*'[^']+'"; Message = "cmd.exe nao trata aspas simples como delimitador" },
            @{ Pattern = "(?i)goto\s+:restart_explorer_common\s+`""; Message = "use call :restart_explorer_common <origem> para passar parametro" },
            @{ Pattern = "(?i)chcp\s+\d+\s+::"; Message = "comentario na mesma linha do chcp vira argumento do comando" },
            @{ Pattern = "(?i)goto\s+:menu\s+::"; Message = "comentario inline depois de goto pode confundir manutencao" },
            @{ Pattern = "(?i)setx\s+Path\s+`"%%Path%%"; Message = "%%Path%% grava referencia literal em vez do PATH atual" },
            @{ Pattern = '(?i)if\s+exist\s+"%AnyDeskPath1%"\s+start\s+""\s+"%AnyDeskPath2%"'; Message = "AnyDeskPath1 deve iniciar AnyDeskPath1" }
        )

        foreach ($check in $checks) {
            if ($line -match $check.Pattern) {
                Add-ValidationError -Path $file.FullName -Line $lineNumber -Message $check.Message
            }
        }
    }
}

$powerShellFiles = @(Get-RepoFiles -Extensions @(".ps1"))
foreach ($file in $powerShellFiles) {
    $tokens = $null
    $parseErrors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors) | Out-Null

    foreach ($parseError in $parseErrors) {
        Add-ValidationError -Path $file.FullName -Line $parseError.Extent.StartLineNumber -Message $parseError.Message
    }
}

$registryFiles = @(Get-RepoFiles -Extensions @(".reg"))
foreach ($file in $registryFiles) {
    $firstContentLine = Get-Content -LiteralPath $file.FullName |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        Select-Object -First 1

    if ($firstContentLine -ne "Windows Registry Editor Version 5.00") {
        Add-ValidationError -Path $file.FullName -Line 1 -Message "arquivo .reg deve iniciar com 'Windows Registry Editor Version 5.00'"
    }
}

foreach ($requiredFile in @("README.md", ".gitignore", ".gitattributes", ".editorconfig")) {
    $path = Join-Path $repoRoot $requiredFile
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        Add-ValidationError -Path $path -Line 1 -Message "arquivo obrigatorio ausente"
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Falhas de validacao encontradas:" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
    exit 1
}

Write-Host "Validacao concluida sem erros." -ForegroundColor Green
Write-Host "Batch/CMD: $($batchFiles.Count); PowerShell: $($powerShellFiles.Count); Registry: $($registryFiles.Count)"
