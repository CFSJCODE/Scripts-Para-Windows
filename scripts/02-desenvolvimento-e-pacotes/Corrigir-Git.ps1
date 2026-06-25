<#
.SYNOPSIS
    Verifica e corrige o PATH do Git no Windows.

.DESCRIPTION
    O script verifica se o comando git esta acessivel no terminal atual. Caso
    nao esteja, procura instalacoes comuns do Git e adiciona o diretorio cmd ao
    PATH da maquina. A alteracao do PATH da maquina exige Administrador.

.NOTES
    Compatibilidade: Windows 10/11, Windows PowerShell 5.1+
#>

$ErrorActionPreference = "Stop"

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Wait-IfConsole {
    if ($Host.Name -eq "ConsoleHost") {
        Read-Host "Pressione Enter para sair..."
    }
}

function Find-GitCmdPath {
    Write-Host "Procurando pela pasta cmd da instalacao do Git..." -ForegroundColor Gray

    $candidatePaths = [System.Collections.Generic.List[string]]::new()
    $programFilesX86 = [Environment]::GetEnvironmentVariable("ProgramFiles(x86)")

    if ($env:ProgramFiles) {
        $candidatePaths.Add((Join-Path $env:ProgramFiles "Git\cmd"))
    }

    if ($programFilesX86) {
        $candidatePaths.Add((Join-Path $programFilesX86 "Git\cmd"))
    }

    if ($env:LOCALAPPDATA) {
        $candidatePaths.Add((Join-Path $env:LOCALAPPDATA "Programs\Git\cmd"))
    }

    foreach ($candidatePath in $candidatePaths) {
        if (Test-Path -LiteralPath $candidatePath -PathType Container) {
            Write-Host "Encontrado em: $candidatePath" -ForegroundColor Green
            return $candidatePath
        }
    }

    Write-Host "Pasta cmd do Git nao encontrada nos diretorios padrao." -ForegroundColor Red
    return $null
}

function Add-GitPath {
    param([Parameter(Mandatory = $true)][string]$GitCmdPath)

    $machinePath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
    $pathEntries = @()

    if ($machinePath) {
        $pathEntries = $machinePath -split ";" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    }

    if ($pathEntries -contains $GitCmdPath) {
        Write-Host "O caminho '$GitCmdPath' ja existe no PATH da maquina." -ForegroundColor Cyan
        return
    }

    Write-Host "Adicionando '$GitCmdPath' ao PATH da maquina..." -ForegroundColor Yellow
    $newPath = (($pathEntries + $GitCmdPath) -join ";")
    [Environment]::SetEnvironmentVariable("Path", $newPath, [EnvironmentVariableTarget]::Machine)

    Write-Host "Caminho adicionado ao PATH da maquina." -ForegroundColor Green
    Write-Host "Reinicie o terminal, ou o computador, para aplicar a alteracao." -ForegroundColor Cyan
}

Write-Host "`n--- Verificador e corretor de PATH do Git ---`n" -ForegroundColor White

if (-not (Test-IsAdministrator)) {
    Write-Warning "Execute este script como Administrador para alterar o PATH da maquina."
    Wait-IfConsole
    exit 1
}

if (Get-Command git -ErrorAction SilentlyContinue) {
    $gitVersion = git --version
    Write-Host "Git ja esta funcional no terminal atual." -ForegroundColor Green
    Write-Host "   $gitVersion"
    Write-Host "`n--- Verificacao concluida ---`n" -ForegroundColor White
    exit 0
}

Write-Host "O comando git nao foi encontrado no terminal atual." -ForegroundColor Yellow
$gitCmdPath = Find-GitCmdPath

if ($gitCmdPath) {
    Add-GitPath -GitCmdPath $gitCmdPath
}
else {
    Write-Host "Nao foi possivel localizar a instalacao do Git." -ForegroundColor Red
    Write-Host "Instale o Git em: https://git-scm.com/" -ForegroundColor White
}

Write-Host "`n--- Verificacao concluida ---`n" -ForegroundColor White
