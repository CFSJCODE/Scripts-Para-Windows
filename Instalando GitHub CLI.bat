@echo off
SETLOCAL EnableDelayedExpansion

ECHO ==========================================
ECHO  Iniciando a configuracao de ferramentas GitHub
ECHO ==========================================

REM --- 0. Verificando e Instalando Winget (se necessario) ---
ECHO.
ECHO --- Verificando status do Winget ---
FOR /F "tokens=*" %%a IN ('WHERE winget 2^>NUL') DO SET "WINGET_PATH=%%a"

IF DEFINED WINGET_PATH (
    ECHO Winget encontrado em: %WINGET_PATH%
    FOR /F "tokens=*" %%i IN ('winget --version 2^>NUL') DO SET WINGET_VERSION=%%i
    IF DEFINED WINGET_VERSION (
        ECHO Versao do Winget: !WINGET_VERSION!
    ) ELSE (
        ECHO Nao foi possivel obter a versao do Winget.
    )
) ELSE (
    ECHO Winget nao encontrado. Tentando instalar...
    ECHO.
    ECHO Por favor, aguarde a janela da Microsoft Store/Instalador de Aplicativos.
    ECHO Pode ser necessario clicar em "Instalar" ou "Atualizar" se solicitado.
    ECHO.

    START "" "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
    ECHO.
    ECHO Se o Winget nao iniciar a instalacao automaticamente,
    ECHO por favor, instale manualmente o "Instalador de Aplicativos" pela Microsoft Store
    ECHO e re-execute este script.
    ECHO.
    PAUSE
    ECHO Tentando verificar o Winget novamente apos a pausa...
    FOR /F "tokens=*" %%a IN ('WHERE winget 2^>NUL') DO SET "WINGET_PATH=%%a"
    IF NOT DEFINED WINGET_PATH (
        ECHO.
        ECHO ERRO: O Winget nao foi instalado com sucesso ou nao esta no PATH.
        ECHO Por favor, instale manualmente o "Instalador de Aplicativos" pela Microsoft Store.
        ECHO.
        PAUSE
        GOTO :EOF
    )
    ECHO Winget instalado e detectado!
)

ECHO.
ECHO --- 1. Instalando GitHub CLI (gh) ---
winget install --id GitHub.cli --exact --accept-source-agreements --accept-package-agreements

IF %ERRORLEVEL% NEQ 0 (
    ECHO.
    ECHO ERRO: Falha ao instalar o GitHub CLI.
    ECHO Tente executar o script como Administrador ou verifique a conexao com a internet.
    ECHO.
    PAUSE
    GOTO :EOF
)
ECHO GitHub CLI instalado com sucesso!

ECHO.
ECHO --- 2. Autenticando no GitHub CLI ---
ECHO Voce sera redirecionado para o navegador para concluir a autenticacao.
ECHO Siga as instrucoes na tela.
gh auth login -s 'codespace,gist,workflow'

IF %ERRORLEVEL% NEQ 0 (
    ECHO.
    ECHO ERRO: Falha na autenticacao do GitHub CLI.
    ECHO Por favor, tente novamente manualmente: gh auth login
    ECHO.
    PAUSE
    GOTO :EOF
)
ECHO Autenticacao do GitHub CLI concluida!

ECHO.
ECHO --- 3. Instalando a extensao GitHub Copilot CLI ---
gh extension install github/gh-copilot

IF %ERRORLEVEL% NEQ 0 (
    ECHO.
    ECHO ERRO: Falha ao instalar a extensao gh-copilot.
    ECHO Por favor, verifique sua conexao e tente novamente.
    ECHO.
    PAUSE
    GOTO :EOF
)
ECHO Extensao GitHub Copilot CLI instalada com sucesso!

ECHO.
ECHO --- 4. Atualizando a extensao GitHub Copilot CLI (se ja existir) ---
gh extension upgrade gh-copilot

IF %ERRORLEVEL% NEQ 0 (
    ECHO.
    ECHO AVISO: Nao foi possivel atualizar a extensao gh-copilot.
    ECHO Isso pode ocorrer se a extensao ja estiver na versao mais recente ou houver um problema.
    ECHO.
) ELSE (
    ECHO Extensao GitHub Copilot CLI atualizada com sucesso!
)

ECHO.
ECHO ==========================================
ECHO  Configuracao concluida!
ECHO ==========================================
ECHO.
PAUSE
ENDLOCAL