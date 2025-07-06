@echo off 
title Pack Tools Newtwork - By Rodrigo Rosa
color 0a
mode con: cols=80 lines=30

:menu
cls
echo.
echo  ============================================
echo      Pack Tools Newtwork  - By Rodrigo Rosa    
echo  ============================================
echo.
echo  1. Testar conectividade basica (PING)
echo  2. Verificar rota ate um destino (TRACERT)
echo  3. Mostrar tabela de rotas (ROUTE)
echo  4. Ver configuracao IP completa (IPCONFIG)
echo  5. Testar conectividade DNS (NSLOOKUP)
echo  6. Mostrar conexoes ativas (NETSTAT)
echo  7. Ver informacoes ARP (Tabela de traducao)
echo  8. Testar largura de banda (PSPING)
echo  9. Verificar portas abertas (TELNET/TCPING)
echo 10. Diagnostico de rede completo
echo 11. Verificar compartilhamentos de rede (NET VIEW)
echo 12. Testar conectividade HTTP (CURL)
echo 13. Verificar qualidade de conexao (PATHPING)
echo 14. Listar adaptadores de rede (GETMAC)
echo 15. Sair
echo.
set /p opcao=Escolha uma opcao: 

if "%opcao%"=="1" goto PING
if "%opcao%"=="2" goto TRACERT
if "%opcao%"=="3" goto ROUTE
if "%opcao%"=="4" goto IPCONFIG
if "%opcao%"=="5" goto NSLOOKUP
if "%opcao%"=="6" goto NETSTAT
if "%opcao%"=="7" goto ARP
if "%opcao%"=="8" goto PSPING
if "%opcao%"=="9" goto PORTTEST
if "%opcao%"=="10" goto FULLDIAG
if "%opcao%"=="11" goto NETVIEW
if "%opcao%"=="12" goto HTTPTEST
if "%opcao%"=="13" goto PATHPING
if "%opcao%"=="14" goto GETMAC
if "%opcao%"=="15" exit

goto menu

:PING
cls
echo.
echo  ===== TESTE DE CONECTIVIDADE (PING) =====
echo.
set /p host=Digite o host ou IP para testar (ex: google.com): 
echo.
ping %host% -t
pause
goto menu

:TRACERT
cls
echo.
echo  ===== RASTREAMENTO DE ROTA (TRACERT) =====
echo.
set /p host=Digite o host ou IP para rastrear: 
echo.
tracert %host%
pause
goto menu

:ROUTE
cls
echo.
echo  ===== TABELA DE ROTAS =====
echo.
echo 1. Mostrar tabela de rotas
echo 2. Adicionar rota estatica
echo 3. Remover rota estatica
echo.
set /p subop=Escolha: 

if "%subop%"=="1" route print
if "%subop%"=="2" goto ADDROUTE
if "%subop%"=="3" goto DELROUTE
pause
goto menu

:ADDROUTE
set /p network=Digite a rede (ex: 192.168.1.0): 
set /p mask=Mascara (ex: 255.255.255.0): 
set /p gateway=Gateway (ex: 192.168.1.1): 
route add %network% mask %mask% %gateway%
pause
goto menu

:DELROUTE
set /p network=Digite a rede a remover (ex: 192.168.1.0): 
set /p mask=Mascara (ex: 255.255.255.0): 
route delete %network% mask %mask%
pause
goto menu

:IPCONFIG
cls
echo.
echo  ===== CONFIGURACAO IP =====
echo.
echo 1. Configuracao basica
echo 2. Todos os detalhes
echo 3. Renovar IP (DHCP)
echo 4. Liberar IP
echo 5. Limpar cache DNS
echo.
set /p subop=Escolha: 

if "%subop%"=="1" ipconfig
if "%subop%"=="2" ipconfig /all
if "%subop%"=="3" ipconfig /renew
if "%subop%"=="4" ipconfig /release
if "%subop%"=="5" ipconfig /flushdns
pause
goto menu

:NSLOOKUP
cls
echo.
echo  ===== TESTE DNS =====
echo.
set /p host=Digite o host para consulta DNS (enter para modo interativo): 
if "%host%"=="" (
    nslookup
) else (
    nslookup %host%
)
pause
goto menu

:NETSTAT
cls
echo.
echo  ===== CONEXOES DE REDE =====
echo.
echo 1. Conexoes ativas
echo 2. Conexoes + processos
echo 3. Estatisticas por protocolo
echo 4. Portas escutando
echo.
set /p subop=Escolha: 

if "%subop%"=="1" netstat -a
if "%subop%"=="2" netstat -ano
if "%subop%"=="3" netstat -s
if "%subop%"=="4" netstat -an | find "LISTENING"
pause
goto menu

:ARP
cls
echo.
echo  ===== TABELA ARP =====
echo.
arp -a
pause
goto menu

:PSPING
cls
echo.
echo  ===== TESTE DE LARGURA DE BANDA =====
echo.
echo Requer PSPing instalado (parte do SysInternals)
echo.
set /p host=Digite o host/IP para teste: 
set /p port=Porta (ex: 80 para HTTP): 
psping %host%:%port%
pause
goto menu

:PORTTEST
cls
echo.
echo  ===== TESTE DE PORTA =====
echo.
echo 1. Usar Telnet (requer telnet instalado)
echo 2. Usar PowerShell (Test-NetConnection)
echo.
set /p subop=Escolha: 

if "%subop%"=="1" (
    set /p host=Host/IP: 
    set /p port=Porta: 
    echo quit | telnet %host% %port%
)
if "%subop%"=="2" (
    set /p host=Host/IP: 
    set /p port=Porta: 
    powershell Test-NetConnection %host% -Port %port%
)
pause
goto menu

:FULLDIAG
cls
echo.
echo  ===== DIAGNOSTICO COMPLETO =====
echo.
echo Configuracao IP:
ipconfig /all
echo.
echo Tabela de rotas:
route print
echo.
echo Conexoes ativas:
netstat -ano
echo.
echo Tabela ARP:
arp -a
echo.
echo Teste DNS:
nslookup google.com
echo.
echo Teste de conectividade:
ping google.com -n 4
echo.
echo Rastreamento de rota:
tracert google.com -h 5
pause
goto menu

:NETVIEW
cls
echo.
echo  ===== COMPARTILHAMENTOS DE REDE =====
echo.
net view
pause
goto menu

:HTTPTEST
cls
echo.
echo  ===== TESTE HTTP =====
echo.
echo Requer cURL instalado ou PowerShell
echo.
set /p url=Digite a URL (ex: http://google.com): 
curl -I %url%
pause
goto menu

:PATHPING
cls
echo.
echo  ===== QUALIDADE DE CONEXAO (PATHPING) =====
echo.
set /p host=Digite o host ou IP para testar: 
pathping %host%
pause
goto menu

:GETMAC
cls
echo.
echo  ===== ENDERECOS MAC DOS ADAPTADORES =====
echo.
getmac /v /fo list
pause
goto menu
