@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 > nul
title Script de Manutencao para Windows by Gemini
color 0A

:: =============================================================================
:: || VERIFICAÇÃO DE PRIVILÉGIOS DE ADMINISTRADOR                               ||
:: =============================================================================
:: Verifica se o script está sendo executado com permissões de administrador.
:: Sem isso, comandos como 'sfc' e a manipulação de serviços falharão.
reg query "HKEY_USERS\S-1-5-19" >nul 2>&1 || (
    echo.
    echo  [ERRO] Este script precisa ser executado como Administrador.
    echo.
    echo  Para fazer isso:
    echo  1. Clique com o botao direito no arquivo do script.
    echo  2. Selecione "Executar como administrador".
    echo.
    pause
    exit /b
)

:: =============================================================================
:: || MENU PRINCIPAL                                                            ||
:: =============================================================================
:menu
cls
echo =======================================================
echo.
echo                   SCRIPT DE MANUTENCAO PARA WINDOWS
echo.
echo =======================================================
echo.
echo  [1] Redefinir Licenca do AnyDesk
echo  [2] Verificar Informacoes de Rede (ipconfig)
echo  [3] Verificar e Reparar Arquivos do Sistema (SFC)
echo  [4] Verificar Atualizacoes do Windows Update
echo  [5] Verificacao Rapida do Windows Defender
echo  [6] Listar Perfis de Wi-Fi e Ver Senha
echo  [7] Resetar Spooler de Impressao
echo  [8] Teste de Velocidade da Internet
echo  [9] Opcoes de Energia
echo  [10] Gerenciador de Pacotes Winget
echo  [11] Instalar/Configurar GitHub CLI e Copilot
echo  [12] Ativar Modificacoes Nos Sons Do Windows
echo  [13] Gerenciar Interface Ribbon do Explorador de Arquivos
echo  [14] Adicionar "Assumir Propriedade" ao Menu de Contexto
echo  [15] Mostrar Pastas de Usuario em "Este PC"
echo  [16] Executar Metube com Docker
echo.
echo  [0] Sair
echo.
echo =======================================================
set /p "opcao=Escolha uma opcao e pressione Enter: "

if "%opcao%"=="1" goto :reset_anydesk
if "%opcao%"=="2" goto :network_info
if "%opcao%"=="3" goto :sfc_scan
if "%opcao%"=="4" goto :windows_update
if "%opcao%"=="5" goto :defender_scan
if "%opcao%"=="6" goto :show_wifi_profiles
if "%opcao%"=="7" goto :reset_spooler
if "%opcao%"=="8" goto :speed_test
if "%opcao%"=="9" goto :power_menu
if "%opcao%"=="10" goto :winget_menu
if "%opcao%"=="11" goto :setup_github_tools
if "%opcao%"=="12" goto :sound_modifications_menu
if "%opcao%"=="13" goto :manage_ribbon_ui_menu
if "%opcao%"=="14" goto :take_ownership_menu
if "%opcao%"=="15" goto :show_user_folders_menu
if "%opcao%"=="16" goto :run_metube_docker
if "%opcao%"=="0" goto :eof

echo.
echo Opcao invalida. Pressione qualquer tecla para tentar novamente.
pause > nul
goto :menu


:: =============================================================================
:: || 1. REDEFINIR LICENÇA DO ANYDESK                                           ||
:: =============================================================================
:reset_anydesk
cls
echo =======================================================
echo  1. REDEFININDO LICENCA DO ANYDESK
echo =======================================================
echo.
call :stop_anydesk_services
echo.
echo  - Removendo arquivos de configuracao antigos...
del /f /q "%ALLUSERSPROFILE%\AnyDesk\service.conf" >nul 2>&1
del /f /q "%APPDATA%\AnyDesk\service.conf" >nul 2>&1
echo.
echo  - Fazendo backup das configuracoes do usuario (user.conf e thumbnails)...
if exist "%APPDATA%\AnyDesk\user.conf" copy /y "%APPDATA%\AnyDesk\user.conf" "%TEMP%\user.conf.bak" >nul
if exist "%APPDATA%\AnyDesk\thumbnails" xcopy /s /e /h /y /i "%APPDATA%\AnyDesk\thumbnails" "%TEMP%\thumbnails.bak\" >nul
echo.
echo  - Limpando dados do AnyDesk...
rd /s /q "%APPDATA%\AnyDesk" >nul 2>&1
rd /s /q "%ALLUSERSPROFILE%\AnyDesk" >nul 2>&1
mkdir "%APPDATA%\AnyDesk" >nul 2>&1
mkdir "%ALLUSERSPROFILE%\AnyDesk" >nul 2>&1
echo.
call :start_anydesk_services
echo.
echo  - Aguardando a geracao do novo ID do AnyDesk...
:wait_for_id
timeout /t 2 /nobreak >nul
type "%ALLUSERSPROFILE%\AnyDesk\system.conf" 2>nul | find "ad.anynet.id=" >nul
if errorlevel 1 goto wait_for_id
echo.
echo  - Novo ID gerado. Restaurando configuracoes do usuario...
call :stop_anydesk_services
if exist "%TEMP%\user.conf.bak" move /y "%TEMP%\user.conf.bak" "%APPDATA%\AnyDesk\user.conf" >nul
if exist "%TEMP%\thumbnails.bak" xcopy /s /e /h /y /i "%TEMP%\thumbnails.bak" "%APPDATA%\AnyDesk\thumbnails\" >nul & rd /s /q "%TEMP%\thumbnails.BAK"
call :start_anydesk_services
echo.
echo =======================================================
echo  CONCLUIDO! A licenca do AnyDesk foi redefinida.
echo =======================================================
echo.
pause
goto :menu


:: =============================================================================
:: || 2. VERIFICAR INFORMAÇÕES DE REDE                                        ||
:: =============================================================================
:network_info
cls
echo =======================================================
echo  2. INFORMACOES DE REDE (IPCONFIG)
echo =======================================================
echo.
ipconfig /all
echo.
echo =======================================================
echo  Comando executado.
echo =======================================================
echo.
pause
goto :menu


:: =============================================================================
:: || 3. VERIFICAR E REPARAR ARQUIVOS DO SISTEMA (SFC)                        ||
:: =============================================================================
:sfc_scan
cls
echo =======================================================
echo  3. VERIFICADOR DE ARQUIVOS DO SISTEMA (SFC)
echo =======================================================
echo.
echo  Este processo pode demorar varios minutos e tentara
echo  reparar arquivos corrompidos ou ausentes do Windows.
echo.
sfc /scannow
echo.
echo =======================================================
echo  VERIFICACAO CONCLUIDA! Verifique o resultado acima.
echo =======================================================
echo.
pause
goto :menu


:: =============================================================================
:: || 4. VERIFICAR ATUALIZAÇÕES DO WINDOWS UPDATE                             ||
:: =============================================================================
:windows_update
cls
echo =======================================================
echo  4. VERIFICAR ATUALIZACOES DO WINDOWS UPDATE
echo =======================================================
echo.
echo  Iniciando a verificacao de atualizacoes em segundo plano...
usoclient.exe StartScan
echo.
echo  O Windows ira notifica-lo se encontrar atualizacoes
echo  disponiveis para instalacao.
echo.
echo =======================================================
echo  VERIFICACAO INICIADA!
echo =======================================================
echo.
pause
goto :menu


:: =============================================================================
:: || 5. VERIFICAÇÃO RÁPIDA DO WINDOWS DEFENDER                                 ||
:: =============================================================================
:defender_scan
cls
echo =======================================================
echo  5. VERIFICACAO RAPIDA DO WINDOWS DEFENDER
echo =======================================================
echo.
echo  Iniciando uma verificacao rapida por malware...
echo.
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
echo.
echo =======================================================
echo  VERIFICACAO RAPIDA CONCLUIDA!
echo =======================================================
echo.
pause
goto :menu


:: =============================================================================
:: || 6. LISTAR PERFIS DE WI-FI E VER SENHA                                     ||
:: =============================================================================
:show_wifi_profiles
cls
echo =======================================================
echo  6. LISTANDO PERFIS DE WI-FI E VER SENHA
echo =======================================================
echo.
netsh wlan show profiles
echo.
echo =======================================================
echo.
echo Digite o nome exato do perfil Wi-Fi que deseja consultar.
echo.
set "wifi_profile="
set /p "wifi_profile=Nome do perfil Wi-Fi: "
if not defined wifi_profile (
    echo.
    echo [AVISO] Nenhum perfil informado.
    echo.
    pause
    goto :menu
)
echo.
netsh wlan show profile name="%wifi_profile%" key=clear
echo.
echo =======================================================
echo  Comando executado.
echo =======================================================
echo.
pause
goto :menu


:: =============================================================================
:: || 7. RESETAR SPOOLER DE IMPRESSÃO                                         ||
:: =============================================================================
:reset_spooler
cls
echo =======================================================
echo  7. RESETANDO O SPOOLER DE IMPRESSAO
echo =======================================================
echo.
echo  - Parando o servico de Spooler de Impressao...
net stop spooler
echo.
echo  - Limpando a fila de impressao...
del /Q /F /S "%systemroot%\System32\spool\PRINTERS\*.*"
echo.
echo  - Iniciando o servico de Spooler de Impressao...
net start spooler
echo.
echo =======================================================
echo  O Spooler de Impressao foi resetado com sucesso!
echo =======================================================
echo.
pause
goto :menu


:: =============================================================================
:: || 8. TESTE DE VELOCIDADE DA INTERNET                                      ||
:: =============================================================================
:speed_test
cls
echo =======================================================
echo  8. EXECUTANDO TESTE DE VELOCIDADE
echo =======================================================
echo.
echo  Aguarde, baixando a ferramenta de teste e executando...
echo  Este processo pode levar um minuto.
echo.
set "ps_script=%TEMP%\speedtest_script.ps1"
(
    @echo $URL = "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip"
    @echo $output = "$env:TEMP\speedtest.zip"
    @echo $exe = "$env:TEMP\speedtest.exe"
    @echo $md = "$env:TEMP\speedtest.md"
    @echo $results = "$env:TEMP\Test.txt"
    @echo $params = "--accept-license --progress=no"
    @echo $ProgressPreference = 'SilentlyContinue'
    @echo try {
    @echo      Invoke-WebRequest -Uri $URL -OutFile $output -Headers @{"Cache-Control"="no-cache"}
    @echo      Expand-Archive -Path $output -DestinationPath "$env:TEMP\" -Force
    @echo      Start-Process -FilePath $exe -ArgumentList $params -Wait -RedirectStandardOutput $results -WindowStyle Hidden
    @echo      Get-Content $results
    @echo } catch {
    @echo      Write-Error "Ocorreu um erro durante o teste de velocidade: $_"
    @echo } finally {
    @echo      if (Test-Path -Path $output) { Remove-Item -Path $output -Force }
    @echo      if (Test-Path -Path $exe) { Remove-Item -Path $exe -Force }
    @echo      if (Test-Path -Path $md) { Remove-Item -Path $md -Force }
    @echo      if (Test-Path -Path $results) { Remove-Item -Path $results -Force }
    @echo }
) > "%ps_script%"

%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "%ps_script%"
if exist "%ps_script%" del "%ps_script%"

echo.
echo =======================================================
echo  Teste de velocidade concluido.
echo =======================================================
echo.
pause
goto :menu


:: =============================================================================
:: || 9. SUBMENU DE OPÇÕES DE ENERGIA                                         ||
:: =============================================================================
:power_menu
cls
echo =======================================================
echo.
echo                    OPCOES DE ENERGIA
echo.
echo =======================================================
echo.
echo  [1] Desligar Computador
echo  [2] Reiniciar Computador
echo  [3] Bloquear Estacao de Trabalho
echo.
echo  [0] Voltar ao Menu Principal
echo.
echo =======================================================
set /p "power_choice=Escolha uma opcao: "

if "%power_choice%"=="1" goto :shutdown_pc
if "%power_choice%"=="2" goto :restart_pc
if "%power_choice%"=="3" goto :lock_station
if "%power_choice%"=="0" goto :menu

echo.
echo Opcao Invalida. Pressione qualquer tecla para tentar novamente.
pause > nul
goto :power_menu

:shutdown_pc
cls
echo ATENCAO: Voce esta prestes a DESLIGAR o computador.
set /p "confirm=Tem certeza (S/N)? "
if /i "%confirm%"=="S" (
    echo Desligando em 3 segundos...
    shutdown /s /t 3
    goto :eof
)
echo Desligamento cancelado.
pause > nul
goto :power_menu

:restart_pc
cls
echo ATENCAO: Voce esta prestes a REINICIAR o computador.
set /p "confirm=Tem certeza (S/N)? "
if /i "%confirm%"=="S" (
    echo Reiniciando em 3 segundos...
    shutdown /r /t 3
    goto :eof
)
echo Reinicio cancelado.
pause > nul
goto :power_menu

:lock_station
echo Bloqueando a estacao de trabalho...
rundll32.exe user32.dll,LockWorkStation
goto :menu

:: =============================================================================
:: || 10. SUBMENU WINGET                                                      ||
:: =============================================================================
:winget_menu
cls
echo =======================================================
echo.
echo                    GERENCIADOR DE PACOTES WINGET
echo.
echo =======================================================
echo.
echo  [1] Instalar/Corrigir Winget
echo  [2] Procurar por um software
echo  [3] Instalar um software (usando o ID)
echo  [4] Atualizar todos os softwares
echo  [5] Listar todos os softwares instalados
echo.
echo  [0] Voltar ao Menu Principal
echo.
echo =======================================================
set /p "winget_choice=Escolha uma opcao: "

if "%winget_choice%"=="1" goto :install_fix_winget
if "%winget_choice%"=="2" goto :winget_search_interactive
if "%winget_choice%"=="3" goto :winget_install_interactive
if "%winget_choice%"=="4" goto :winget_upgrade_all
if "%winget_choice%"=="5" goto :winget_list_all
if "%winget_choice%"=="0" goto :menu

echo.
echo Opcao invalida. Pressione qualquer tecla para tentar novamente.
pause > nul
goto :winget_menu

:winget_search_interactive
cls
echo =======================================================
echo  2. PROCURAR POR UM SOFTWARE
echo =======================================================
echo.
echo  Digite o nome do software que deseja buscar.
echo  Por exemplo: vlc
echo.
set "winget_query="
set /p "winget_query=Buscar: "
if not defined winget_query (
    echo.
    echo [AVISO] Nenhum termo informado.
    echo.
    pause
    goto :winget_menu
)
echo.
winget search "%winget_query%"
echo.
echo =======================================================
echo  BUSCA CONCLUIDA! Anote o 'Id' do programa para instalar.
echo =======================================================
echo.
pause
goto :winget_menu

:winget_install_interactive
cls
echo =======================================================
echo  3. INSTALAR UM SOFTWARE
echo =======================================================
echo.
echo  Use a opcao 2 (Procurar) para encontrar o 'Id' de um programa.
echo  Digite o Id exato do pacote que deseja instalar.
echo  Por exemplo: VideoLAN.VLC
echo.
set "winget_package_id="
set /p "winget_package_id=Id do pacote: "
if not defined winget_package_id (
    echo.
    echo [AVISO] Nenhum Id informado.
    echo.
    pause
    goto :winget_menu
)
echo.
winget install --id "%winget_package_id%" --exact --accept-source-agreements --accept-package-agreements
echo.
echo =======================================================
echo  INSTALACAO CONCLUIDA!
echo =======================================================
echo.
pause
goto :winget_menu

:winget_upgrade_all
cls
echo =======================================================
echo  4. ATUALIZANDO TODOS OS SOFTWARES VIA WINGET
echo =======================================================================
echo.
echo  O Winget tentara atualizar todos os pacotes possiveis.
echo  Este processo pode demorar e pedir confirmacoes.
echo.
winget upgrade --all
echo.
echo =======================================================
echo  ATUALIZACAO CONCLUIDA!
echo =======================================================
echo.
pause
goto :winget_menu

:winget_list_all
cls
echo =======================================================
echo  5. LISTANDO TODOS OS SOFTWARES INSTALADOS
echo =======================================================
echo.
echo  O Winget vai listar todos os aplicativos reconhecidos.
echo  A lista pode ser longa.
echo.
winget list
echo.
echo =======================================================
echo  LISTAGEM CONCLUIDO!
echo =======================================================
echo.
pause
goto :winget_menu

:install_fix_winget
cls
echo =======================================================
echo  1. INSTALANDO/CORRIGINDO WINGET
echo =======================================================
echo.
setlocal
set "WINDOWS_APPS_PATH=%LOCALAPPDATA%\Microsoft\WindowsApps"

:: --- Verificação de privilégios de Administrador ---
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo.
    echo [ERRO] Solicitando privilegios de Administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
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
if not errorlevel 1 (
    echo [SUCESSO] O comando 'winget' ja esta funcionando no seu sistema.
    echo Versao encontrada:
    winget --version
    echo -----------------------------------------------------
    pause
    endlocal
    goto :winget_menu
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

:: Verifica se o caminho do WindowsApps ja existe no PATH
echo !Path! | find /I "!WINDOWS_APPS_PATH!" >nul
if errorlevel 1 (
    echo [AVISO] O caminho do Winget nao foi encontrado nas variaveis de ambiente.
    echo [INFO] Adicionando o caminho ao seu PATH de usuario...

    :: Usa setx para adicionar o caminho de forma persistente para o usuario
    setx Path "!Path!;!WINDOWS_APPS_PATH!" >nul
    if errorlevel 1 (
        echo [ERRO] Falha ao adicionar o caminho a variavel de ambiente.
    ) else (
        echo [SUCESSO] O caminho foi adicionado. E necessario reiniciar o terminal (CMD ou PowerShell^) para que as alteracoes tenham efeito completo.
    )
) else (
    echo [INFO] O caminho do Winget ja esta configurado corretamente.
)

:: Passo 4: Verificação final
echo.
echo [INFO] Passo 4: Verificacao final...
echo [AVISO] A alteracao na variavel de ambiente foi aplicada. Para que o 'winget' seja reconhecido, voce DEVE fechar esta janela e abrir uma nova.

winget --version >nul 2>&1
if not errorlevel 1 (
    echo [SUCESSO] O Winget parece estar funcionando agora!
    winget --version
) else (
    echo [AVISO] O comando 'winget' ainda nao foi reconhecido na sessao atual.
    echo Se a instalacao na loja foi concluida, a reinicializacao do seu terminal (CMD ou PowerShell^) deve resolver.
    echo Se o problema persistir, considere instalar o winget manualmente a partir do GitHub: https://github.com/microsoft/winget-cli/releases
)

echo -----------------------------------------------------
echo Script concluido.
pause
endlocal
goto :winget_menu


:: =============================================================================
:: || 11. INSTALAR/CONFIGURAR GITHUB CLI E COPILOT                            ||
:: =============================================================================
:setup_github_tools
cls
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
gh auth login -s "codespace,gist,workflow"

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
ECHO.
PAUSE
ENDLOCAL
goto :menu


:: =============================================================================
:: || 12. ATIVAR MODIFICAÇÕES NOS SONS DO WINDOWS                               ||
:: =============================================================================
:sound_modifications_menu
cls
echo =======================================================
echo.
echo        ATIVAR MODIFICACOES NOS SONS DO WINDOWS
echo.
echo =======================================================
echo.
echo  [1] Ativar Som de Saida do Windows
echo  [2] Ativar Som de Logoff do Windows
echo  [3] Ativar Som de Logon do Windows
echo  [4] Reiniciar Windows Explorer
echo.
echo  [0] Voltar ao Menu Principal
echo.
echo =======================================================
set /p "sound_choice=Escolha uma opcao: "

if "%sound_choice%"=="1" goto :enable_system_exit_sound
if "%sound_choice%"=="2" goto :enable_windows_logoff_sound
if "%sound_choice%"=="3" goto :enable_windows_logon_sound
if "%sound_choice%"=="4" call :restart_explorer_common from_sounds
if "%sound_choice%"=="0" goto :menu

echo.
echo Opcao invalida. Pressione qualquer tecla para tentar novamente.
pause > nul
goto :sound_modifications_menu

:enable_system_exit_sound
cls
echo =======================================================
echo  Ativando Som de Saida do Windows...
echo =======================================================
(
echo Windows Registry Editor Version 5.00
echo.
echo [HKEY_CURRENT_USER\AppEvents\EventLabels\SystemExit]
echo @="Exit Windows"
echo "DispFileName"="@mmres.dll,-5846"
echo "ExcludeFromCPL"=dword:00000000
) > "%TEMP%\enable_system_exit.reg"
reg import "%TEMP%\enable_system_exit.reg" >nul
del "%TEMP%\enable_system_exit.reg"
echo.
echo Som de Saida do Windows ativado.
echo =======================================================
echo.
pause
goto :sound_modifications_menu

:enable_windows_logoff_sound
cls
echo =======================================================
echo  Ativando Som de Logoff do Windows...
echo =======================================================
(
echo Windows Registry Editor Version 5.00
echo.
echo [HKEY_CURRENT_USER\AppEvents\EventLabels\WindowsLogoff]
echo @="Windows Logoff"
echo "DispFileName"="@mmres.dll,-5852"
echo "ExcludeFromCPL"=dword:00000000
) > "%TEMP%\enable_logoff_sound.reg"
reg import "%TEMP%\enable_logoff_sound.reg" >nul
del "%TEMP%\enable_logoff_sound.reg"
echo.
echo Som de Logoff do Windows ativado.
echo =======================================================
echo.
pause
goto :sound_modifications_menu

:enable_windows_logon_sound
cls
echo =======================================================
echo  Ativando Som de Logon do Windows...
echo =======================================================
(
echo Windows Registry Editor Version 5.00
echo.
echo [HKEY_CURRENT_USER\AppEvents\EventLabels\WindowsLogon]
echo @="Windows Logon"
echo "DispFileName"="@mmres.dll,-5853"
echo "ExcludeFromCPL"=dword:00000000
) > "%TEMP%\enable_logon_sound.reg"
reg import "%TEMP%\enable_logon_sound.reg" >nul
del "%TEMP%\enable_logon_sound.reg"
echo.
echo Som de Logon do Windows ativado.
echo =======================================================
echo.
pause
goto :sound_modifications_menu


:: =============================================================================
:: || 13. GERENCIAR INTERFACE RIBBON DO EXPLORADOR DE ARQUIVOS                  ||
:: =============================================================================
:manage_ribbon_ui_menu
cls
echo =======================================================
echo.
echo  GERENCIAR INTERFACE RIBBON DO EXPLORADOR DE ARQUIVOS
echo.
echo =======================================================
echo.
echo  [1] Ativar Interface Ribbon
echo  [2] Desativar Interface Ribbon
echo  [3] Reiniciar Windows Explorer
echo.
echo  [0] Voltar ao Menu Principal
echo.
echo =======================================================
set /p "ribbon_choice=Escolha uma opcao: "

if "%ribbon_choice%"=="1" goto :enable_ribbon_ui
if "%ribbon_choice%"=="2" goto :disable_ribbon_ui
if "%ribbon_choice%"=="3" call :restart_explorer_common from_ribbon
if "%ribbon_choice%"=="0" goto :menu

echo.
echo Opcao invalida. Pressione qualquer tecla para tentar novamente.
pause > nul
goto :manage_ribbon_ui_menu

:enable_ribbon_ui
cls
echo =======================================================
echo  Ativando a Interface Ribbon no Explorador de Arquivos...
echo =======================================================
(
echo Windows Registry Editor Version 5.00
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer]
echo "HubMode"=dword:00000001
) > "%TEMP%\enable_ribbon_ui.reg"
reg import "%TEMP%\enable_ribbon_ui.reg" >nul
del "%TEMP%\enable_ribbon_ui.reg"
echo.
echo Interface Ribbon ativada. Pode ser necessario reiniciar o Explorer.
echo =======================================================
echo.
pause
goto :manage_ribbon_ui_menu

:disable_ribbon_ui
cls
echo =======================================================
echo  Desativando a Interface Ribbon no Explorador de Arquivos...
echo =======================================================
(
echo Windows Registry Editor Version 5.00
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer]
echo "HubMode"=-
) > "%TEMP%\disable_ribbon_ui.reg"
reg import "%TEMP%\disable_ribbon_ui.reg" >nul
del "%TEMP%\disable_ribbon_ui.reg"
echo.
echo Interface Ribbon desativada. Pode ser necessario reiniciar o Explorer.
echo =======================================================
echo.
pause
goto :manage_ribbon_ui_menu


:: =============================================================================
:: || 14. ADICIONAR "ASSUMIR PROPRIEDADE" AO MENU DE CONTEXTO                   ||
:: =============================================================================
:take_ownership_menu
cls
echo =======================================================
echo.
echo  ADICIONAR "ASSUMIR PROPRIEDADE" AO MENU DE CONTEXTO
echo.
echo =======================================================
echo.
echo  [1] Adicionar "Assumir Propriedade" (Arquivos e Pastas)
echo  [2] Remover "Assumir Propriedade" (Arquivos e Pastas)
echo  [3] Reiniciar Windows Explorer
echo.
echo  [0] Voltar ao Menu Principal
echo.
echo =======================================================
set /p "ownership_choice=Escolha uma opcao: "

if "%ownership_choice%"=="1" goto :add_take_ownership
if "%ownership_choice%"=="2" goto :remove_take_ownership
if "%ownership_choice%"=="3" call :restart_explorer_common from_ownership
if "%ownership_choice%"=="0" goto :menu

echo.
echo Opcao invalida. Pressione qualquer tecla para tentar novamente.
pause > nul
goto :take_ownership_menu

:add_take_ownership
cls
echo =======================================================
echo  Adicionando "Assumir Propriedade" ao Menu de Contexto...
echo =======================================================
(
echo Windows Registry Editor Version 5.00
echo.
echo [HKEY_CLASSES_ROOT\*\shell\runas]
echo @="Take Ownership"
echo "NoWorkingDirectory"=""
echo.
echo [HKEY_CLASSES_ROOT\*\shell\runas\command]
echo @="cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F"
echo "IsolatedCommand"="cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F"
echo.
echo [HKEY_CLASSES_ROOT\Directory\shell\runas]
echo @="Take Ownership"
echo "NoWorkingDirectory"=""
echo.
echo [HKEY_CLASSES_ROOT\Directory\shell\runas\command]
echo @="cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t"
echo "IsolatedCommand"="cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t"
) > "%TEMP%\add_take_ownership.reg"
reg import "%TEMP%\add_take_ownership.reg" >nul
del "%TEMP%\add_take_ownership.reg"
echo.
echo "Assumir Propriedade" adicionado. Pode ser necessario reiniciar o Explorer.
echo =======================================================
echo.
pause
goto :take_ownership_menu

:remove_take_ownership
cls
echo =======================================================
echo  Removendo "Assumir Propriedade" do Menu de Contexto...
echo =======================================================
(
echo Windows Registry Editor Version 5.00
echo.
echo [-HKEY_CLASSES_ROOT\*\shell\runas]
echo.
echo [-HKEY_CLASSES_ROOT\Directory\shell\runas]
) > "%TEMP%\remove_take_ownership.reg"
reg import "%TEMP%\remove_take_ownership.reg" >nul
del "%TEMP%\remove_take_ownership.reg"
echo.
echo "Assumir Propriedade" removido. Pode ser necessario reiniciar o Explorer.
echo =======================================================
echo.
pause
goto :take_ownership_menu

:: =============================================================================
:: || 15. MOSTRAR PASTAS DE USUARIO EM "ESTE PC"                                ||
:: =============================================================================
:show_user_folders_menu
cls
echo =======================================================
echo.
echo        MOSTRAR PASTAS DE USUARIO EM "ESTE PC"
echo.
echo =======================================================
echo.
echo  [1] Mostrar Pastas de Usuario (Desktop, Documentos, Downloads, etc.)
echo  [2] Ocultar Pastas de Usuario
echo  [3] Reiniciar Windows Explorer
echo.
echo  [0] Voltar ao Menu Principal
echo.
echo =======================================================
set /p "folders_choice=Escolha uma opcao: "

if "%folders_choice%"=="1" goto :enable_user_folders
if "%folders_choice%"=="2" goto :disable_user_folders
if "%folders_choice%"=="3" call :restart_explorer_common from_userfolders
if "%folders_choice%"=="0" goto :menu

echo.
echo Opcao invalida. Pressione qualquer tecla para tentar novamente.
pause > nul
goto :show_user_folders_menu

:enable_user_folders
cls
echo =======================================================
echo  Mostrando Pastas de Usuario em "Este PC"...
echo =======================================================
(
echo Windows Registry Editor Version 5.00
echo.
echo ;Desktop
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}]
echo "HideIfEnabled"=-
echo.
echo [HKEY_CURRENT_USER\SOFTWARE\Classes\CLSID\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\ShellFolder]
echo "SortOrderIndex"=dword:00000000
echo.
echo ;Documents
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}]
echo "HideIfEnabled"=-
echo.
echo ;Downloads
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}]
echo "HideIfEnabled"=-
echo.
echo ;Music
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}]
echo "HideIfEnabled"=-
echo.
echo ;Pictures
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}]
echo "HideIfEnabled"=-
echo.
echo ;Videos
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}]
echo "HideIfEnabled"=-
) > "%TEMP%\enable_user_folders.reg"
reg import "%TEMP%\enable_user_folders.reg" >nul
del "%TEMP%\enable_user_folders.reg"
echo.
echo Pastas de Usuario agora visiveis. Pode ser necessario reiniciar o Explorer.
echo =======================================================
echo.
pause
goto :show_user_folders_menu

:disable_user_folders
cls
echo =======================================================
echo  Ocultando Pastas de Usuario em "Este PC"...
echo =======================================================
(
echo Windows Registry Editor Version 5.00
echo.
echo ;Desktop
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}]
echo "HideIfEnabled"=dword:00000001
echo.
echo ;Documents
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}]
echo "HideIfEnabled"=dword:00000001
echo.
echo ;Downloads
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}]
echo "HideIfEnabled"=dword:00000001
echo.
echo ;Music
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}]
echo "HideIfEnabled"=dword:00000001
echo.
echo ;Pictures
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}]
echo "HideIfEnabled"=dword:00000001
echo.
echo ;Videos
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}]
echo "HideIfEnabled"=dword:00000001
) > "%TEMP%\disable_user_folders.reg"
reg import "%TEMP%\disable_user_folders.reg" >nul
del "%TEMP%\disable_user_folders.reg"
echo.
echo Pastas de Usuario agora ocultas. Pode ser necessario reiniciar o Explorer.
echo =======================================================
echo.
pause
goto :show_user_folders_menu


:: =============================================================================
:: || 16. EXECUTAR METUBE COM DOCKER                                            ||
:: =============================================================================
:run_metube_docker
cls
echo =======================================================
echo.
echo          EXECUTAR METUBE COM DOCKER
echo.
echo =======================================================
echo.
echo  Esta opcao ira iniciar o container do MeTube usando Docker.
echo  Certifique-se de que o Docker Desktop esteja em execucao.
echo.
echo  O MeTube sera acessivel em http://localhost:8081
echo  Seus downloads serao salvos no caminho especificado.
echo.

set "DOWNLOAD_PATH="
set /p "DOWNLOAD_PATH=Por favor, digite o caminho COMPLETO para a pasta de downloads (Ex: C:\Users\SeuUsuario\Downloads): "

:: Remove aspas se o usuário as incluiu
set "DOWNLOAD_PATH=%DOWNLOAD_PATH:"=%"

if not exist "%DOWNLOAD_PATH%" (
    echo.
    echo [AVISO] O caminho especificado "%DOWNLOAD_PATH%" nao existe.
    echo Criando a pasta de downloads...
    mkdir "%DOWNLOAD_PATH%" >nul 2>&1
    if errorlevel 1 (
        echo [ERRO] Nao foi possivel criar a pasta "%DOWNLOAD_PATH%". Verifique as permissoes.
        echo.
        pause
        goto :menu
    ) else (
        echo Pasta criada com sucesso.
    )
)

echo.
echo Iniciando o container Docker do MeTube...
echo (Isso pode levar alguns minutos na primeira execucao para baixar a imagem)
echo.
docker run -d -p 8081:8081 -v "%DOWNLOAD_PATH%":/downloads --name metube ghcr.io/alexta69/metube
if %errorlevel% neq 0 (
    echo.
    echo [ERRO] Falha ao iniciar o container Docker do MeTube.
    echo Verifique se o Docker esta em execucao e se ha conflitos de porta (8081).
    echo Voce pode tentar remover o container existente com: docker rm -f metube
    echo.
) else (
    echo.
    echo [SUCESSO] Container MeTube iniciado em http://localhost:8081
    echo Downloads serao salvos em "%DOWNLOAD_PATH%".
    echo.
)
echo =======================================================
echo.
pause
goto :menu


:: =============================================================================
:: || SUB-ROTINA COMUM: REINICIAR WINDOWS EXPLORER                              ||
:: =============================================================================
:restart_explorer_common
cls
echo ==========================================
echo Script Para Reiniciar Windows Explorer
echo.
echo Created by "Vishal Gupta" for AskVG.com
echo Adaptado por Gustavo Leig gusleig.com
echo ==========================================
echo.
echo.
echo Passo 1: Fechando Explorer . . .
echo.
TASKKILL /F /IM explorer.exe
echo.
echo.
echo Passo 2: Iniciando Explorer . . .
start explorer.exe
echo.
echo Sucesso: Windows Explorer ativado.
echo.
echo.
PAUSE
:: Apos reiniciar, o fluxo deve voltar para o menu de onde foi chamado.
:: Verifica se veio do menu de sons, ribbon, assumir propriedade ou pastas de usuario.
if "%~1"=="from_sounds" goto :sound_modifications_menu
if "%~1"=="from_ribbon" goto :manage_ribbon_ui_menu
if "%~1"=="from_ownership" goto :take_ownership_menu
if "%~1"=="from_userfolders" goto :show_user_folders_menu
:: Fallback, se nao vier de nenhum lugar especifico.
goto :menu


:: =============================================================================
:: || SUB-ROTINAS (Funções auxiliares para o AnyDesk)                           ||
:: =============================================================================
:start_anydesk_services
echo  Iniciando servico e aplicacao AnyDesk...
sc start AnyDesk >nul 2>&1
set "AnyDeskPath1=%ProgramFiles(x86)%\AnyDesk\AnyDesk.exe"
set "AnyDeskPath2=%ProgramFiles%\AnyDesk\AnyDesk.exe"
if exist "%AnyDeskPath1%" start "" "%AnyDeskPath1%"
if exist "%AnyDeskPath2%" start "" "%AnyDeskPath2%"
goto :eof

:stop_anydesk_services
echo  Parando servico e processos do AnyDesk...
sc stop AnyDesk >nul 2>&1
taskkill /f /im "AnyDesk.exe" >nul 2>&1
:: Pequena pausa para garantir que o serviço parou completamente
timeout /t 2 /nobreak >nul
goto :eof
