@echo off
setlocal

:: ============================================================================
:: Script para verificar e corrigir o erro "'winget' não é reconhecido"
:: Autor: Gemini
:: Versão: 1.0 (CMD)
:: Descrição:
:: 1. Verifica se o script está sendo executado como Administrador.
:: 2. Tenta executar o comando 'winget' para ver se já está funcionando.
:: 3. Tenta instalar/atualizar o "Instalador de Aplicativo" via Microsoft Store.
:: 4. Verifica se o caminho do winget está na variável de ambiente PATH e o adiciona se necessário.
:: 5. Realiza uma verificação final e instrui o usuário a reiniciar o terminal.
:: ============================================================================

:: --- Verificação de privilégios de Administrador ---
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo.
    echo [ERRO] Solicitando privilégios de Administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:: --- Início do Script Principal ---
cls
echo [INFO] Iniciando o script de correcao do Winget...
echo [INFO] Este script esta sendo executado como Administrador.
echo -----------------------------------------------------
timeout /t 2 /nobreak >nul

:: Passo 1: Verificar se o winget ja funciona
echo [INFO] Passo 1: Verificando a instalacao atual do winget...
winget --version >nul 2>&1
if %errorlevel% EQU 0 (
    echo [SUCESSO] O comando 'winget' ja esta funcionando no seu sistema.
    echo Versao encontrada:
    winget --version
    echo -----------------------------------------------------
    pause
    exit
) else (
    echo [AVISO] O comando 'winget' nao foi encontrado. Tentando corrigir...
)

:: Passo 2: Tentar instalar/atualizar o winget via Microsoft Store
echo.
echo [INFO] Passo 2: Tentando instalar/atualizar o 'Instalador de Aplicativo' da Microsoft Store...
echo (Isso pode levar um momento...)

start "" "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"

echo [INFO] A Microsoft Store foi aberta. Por favor, clique em 'Instalar' ou 'Atualizar' se solicitado.
echo [INFO] Aguardando 20 segundos para que a instalacao manual possa comecar...
timeout /t 20 /nobreak >nul

:: Passo 3: Verificar e corrigir a variável de ambiente PATH
echo.
echo [INFO] Passo 3: Verificando a variavel de ambiente PATH...

:: Verifica se o caminho do WindowsApps já existe no PATH
echo %Path% | find /I "%LOCALAPPDATA%\Microsoft\WindowsApps" >nul
if %errorlevel% EQU 1 (
    echo [AVISO] O caminho do Winget nao foi encontrado nas variaveis de ambiente.
    echo [INFO] Adicionando o caminho ao seu PATH de usuario...
    
    :: Usa setx para adicionar o caminho de forma persistente para o usuário
    setx Path "%%Path%%;%LOCALAPPDATA%\Microsoft\WindowsApps" >nul
    if %errorlevel% EQU 0 (
        echo [SUCESSO] O caminho foi adicionado. E necessario reiniciar o terminal (CMD ou PowerShell) para que as alteracoes tenham efeito completo.
    ) else (
        echo [ERRO] Falha ao adicionar o caminho a variavel de ambiente.
    )
) else (
    echo [INFO] O caminho do Winget ja esta configurado corretamente.
)

:: Passo 4: Verificação final
echo.
echo [INFO] Passo 4: Verificacao final...
echo [AVISO] A alteracao na variavel de ambiente foi aplicada. Para que o 'winget' seja reconhecido, voce DEVE fechar esta janela e abrir uma nova.

winget --version >nul 2>&1
if %errorlevel% EQU 0 (
    echo [SUCESSO] O Winget parece estar funcionando agora!
    winget --version
) else (
    echo [AVISO] O comando 'winget' ainda nao foi reconhecido na sessao atual.
    echo Se a instalacao na loja foi concluida, a reinicializacao do seu terminal (CMD ou PowerShell) deve resolver.
    echo Se o problema persistir, considere instalar o winget manualmente a partir do GitHub: https://github.com/microsoft/winget-cli/releases
)

echo -----------------------------------------------------
echo Script concluido.
pause
