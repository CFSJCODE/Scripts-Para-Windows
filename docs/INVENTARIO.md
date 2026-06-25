# Inventário funcional dos scripts

Este documento registra a classificação aplicada aos scripts Windows. A organização foi feita por finalidade operacional, sem execução dos scripts.

## `00-menu-principal`
Ponto de entrada consolidado para rotinas amplas de manutenção.

- `ScriptManutençãoDoWindows.bat` — Menu integrado para manutenção do Windows: rede, SFC, Windows Update, Defender, Wi-Fi, spooler, Winget, GitHub CLI, ajustes do Explorer, registro e Docker/MeTube.

## `01-rede-e-conectividade`
Diagnóstico, consulta e correção básica de rede local, DNS e conectividade.

- `VERIFICAÇÃO DE REDE.BAT` — Menu de diagnóstico de rede com ping, tracert, route, ipconfig, nslookup, netstat, ARP, pathping, curl e testes TCP/HTTP.
- `ver_ip.bat` — Atalho para abrir `ipconfig` em uma janela do Prompt de Comando.
- `placas_redes.bat` — Abre `ncpa.cpl`, painel clássico de adaptadores de rede.
- `limpar caches.bat` — Executa `ipconfig /flushdns` em uma janela de Prompt de Comando.

## `02-desenvolvimento-e-pacotes`
Instalação e correção de ferramentas de desenvolvimento e gerenciadores de pacotes.

- `Corrigir Winget.cmd` — Verifica instalação e PATH do Winget, abrindo o Instalador de Aplicativos quando necessário.
- `Corrigir-Git.ps1` — Localiza o Git e adiciona o diretório `Git\cmd` ao PATH da máquina, quando aplicável.
- `Instalando GitHub CLI.bat` — Instala/verifica GitHub CLI via Winget, executa autenticação com `gh auth login` e instala extensão do Copilot CLI.

## `03-administracao-do-windows`
Abertura de consoles administrativos nativos do Windows.

- `Gerencie o Firewall do Windows.bat` — Abre o painel de Firewall do Windows e o console avançado `wf.msc`.
- `Gerencie usuários.bat` — Abre `netplwiz` para gerenciamento local de usuários.
- `painel_controle.bat` — Abre o Painel de Controle clássico.

## `04-acesso-remoto`
Clientes e rotinas relacionadas a acesso remoto.

- `conexao_remota.bat` — Abre o cliente de Conexão de Área de Trabalho Remota (`mstsc`).
- `Anydesk-Reset.cmd` — Rotina administrativa para reinicializar configurações locais do AnyDesk preservando dados do usuário quando possível.

## `05-energia-e-sessao`
Ações críticas de energia: desligamento e reinicialização.

- `desligar.bat` — Desliga o Windows imediatamente com fechamento forçado de processos.
- `reiniciar.bat` — Reinicia o Windows imediatamente com fechamento forçado de processos.

## `06-personalizacao-e-registro`
Ajustes de interface e Registro do Windows.

- `fotos-windows.reg` — Arquivo de Registro para reativar o Windows Photo Viewer clássico.

## `07-utilitarios-basicos`
Atalhos simples para ferramentas nativas.

- `Abrir_bloco_notas.bat` — Abre o Bloco de Notas.
