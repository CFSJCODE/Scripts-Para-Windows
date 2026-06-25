# Scripts Para Windows

Repositório com scripts para **manutenção, diagnóstico, configuração e administração de ambientes Windows**, organizados por função operacional. O objetivo é centralizar rotinas úteis para suporte técnico, automação básica, correção de ferramentas de desenvolvimento e acesso rápido a consoles nativos do sistema.

> Projeto mantido pela **CFSJ TECH** como coleção prática de utilitários Windows para uso técnico, educacional e operacional.

---

## Sumário

- [Visão geral](#visão-geral)
- [Funcionalidades](#funcionalidades)
- [Estrutura do repositório](#estrutura-do-repositório)
- [Como usar](#como-usar)
- [Execução com permissões administrativas](#execução-com-permissões-administrativas)
- [Categorias de scripts](#categorias-de-scripts)
- [Validação do repositório](#validação-do-repositório)
- [Boas práticas de segurança](#boas-práticas-de-segurança)
- [Requisitos](#requisitos)
- [Versionamento e commits](#versionamento-e-commits)
- [Aviso de responsabilidade](#aviso-de-responsabilidade)

---

## Visão geral

Este repositório reúne scripts em **Batch (`.bat`)**, **CMD (`.cmd`)**, **PowerShell (`.ps1`)** e **Registro do Windows (`.reg`)**. A organização foi feita por domínio funcional para facilitar manutenção, auditoria, execução e evolução futura.

Os scripts atendem a rotinas como:

- diagnóstico de rede;
- limpeza de cache DNS;
- abertura de painéis administrativos do Windows;
- correção de Git, Winget e GitHub CLI;
- suporte a acesso remoto;
- reinicialização e desligamento do sistema;
- ajustes de personalização via Registro;
- execução de menu principal de manutenção.

---

## Funcionalidades

### Manutenção e suporte técnico

- Menu principal para centralizar rotinas de manutenção do Windows.
- Atalhos para ferramentas administrativas nativas.
- Scripts para desligamento e reinicialização forçada.

### Rede e conectividade

- Verificação de IP local.
- Abertura de adaptadores de rede.
- Limpeza de cache DNS.
- Diagnóstico com ferramentas como `ping`, `tracert`, `ipconfig`, `nslookup`, `netstat`, `arp`, `pathping` e testes HTTP/TCP.

### Desenvolvimento e pacotes

- Correção e verificação do Winget.
- Correção do PATH do Git.
- Instalação e autenticação do GitHub CLI.
- Instalação de extensão do GitHub Copilot CLI, quando aplicável.

### Administração do Windows

- Acesso rápido ao Painel de Controle.
- Gerenciamento de usuários locais.
- Abertura das configurações do Firewall do Windows.

### Acesso remoto

- Abertura do cliente de Área de Trabalho Remota (`mstsc`).
- Rotina de reset administrativo do AnyDesk.

### Personalização e Registro

- Importação de ajustes no Registro para reativação do visualizador clássico de fotos do Windows.

---

## Estrutura do repositório

```text
Scripts-Para-Windows-Organizado/
├── .github/
│   └── workflows/
│       └── validate.yml
├── docs/
│   └── INVENTARIO.md
├── scripts/
│   ├── 00-menu-principal/
│   ├── 01-rede-e-conectividade/
│   ├── 02-desenvolvimento-e-pacotes/
│   ├── 03-administracao-do-windows/
│   ├── 04-acesso-remoto/
│   ├── 05-energia-e-sessao/
│   ├── 06-personalizacao-e-registro/
│   └── 07-utilitarios-basicos/
├── tools/
│   └── validate-scripts.ps1
├── .editorconfig
├── .gitattributes
├── .gitignore
└── README.md
```

---

## Como usar

### 1. Clonar o repositório

```powershell
git clone https://github.com/CFSJCODE/Scripts-Para-Windows.git
cd Scripts-Para-Windows
```

### 2. Executar o menu principal

Execute o script principal localizado em:

```text
scripts/00-menu-principal/ScriptManutençãoDoWindows.bat
```

Via PowerShell:

```powershell
.\scripts\00-menu-principal\ScriptManutençãoDoWindows.bat
```

Via Prompt de Comando:

```cmd
scripts\00-menu-principal\ScriptManutençãoDoWindows.bat
```

### 3. Executar scripts específicos

Exemplo para verificar informações de IP:

```powershell
.\scripts\01-rede-e-conectividade\ver_ip.bat
```

Exemplo para abrir o Painel de Controle:

```powershell
.\scripts\03-administracao-do-windows\painel_controle.bat
```

Exemplo para executar correção do Git via PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\02-desenvolvimento-e-pacotes\Corrigir-Git.ps1"
```

---

## Execução com permissões administrativas

Alguns scripts modificam configurações sensíveis do sistema. Para evitar falhas de permissão, execute o terminal como **Administrador** quando o script envolver:

- Registro do Windows;
- PATH do sistema;
- Winget;
- GitHub CLI;
- Firewall;
- rede;
- serviços do Windows;
- desligamento ou reinicialização;
- AnyDesk;
- Windows Update;
- Windows Defender.

Procedimento recomendado:

1. Abrir o Menu Iniciar.
2. Pesquisar por `PowerShell` ou `Prompt de Comando`.
3. Clicar com o botão direito.
4. Selecionar **Executar como administrador**.
5. Navegar até a pasta do repositório.
6. Executar o script desejado.

---

## Categorias de scripts

| Pasta | Finalidade | Exemplos de scripts |
|---|---|---|
| `scripts/00-menu-principal` | Menu consolidado de manutenção | `ScriptManutençãoDoWindows.bat` |
| `scripts/01-rede-e-conectividade` | Diagnóstico e configuração básica de rede | `VERIFICAÇÃO DE REDE.BAT`, `ver_ip.bat`, `placas_redes.bat`, `limpar caches.bat` |
| `scripts/02-desenvolvimento-e-pacotes` | Correção e instalação de ferramentas de desenvolvimento | `Corrigir Winget.cmd`, `Corrigir-Git.ps1`, `Instalando GitHub CLI.bat` |
| `scripts/03-administracao-do-windows` | Abertura de consoles administrativos | `Gerencie o Firewall do Windows.bat`, `Gerencie usuários.bat`, `painel_controle.bat` |
| `scripts/04-acesso-remoto` | Rotinas de acesso remoto | `conexao_remota.bat`, `Anydesk-Reset.cmd` |
| `scripts/05-energia-e-sessao` | Controle de energia e sessão | `desligar.bat`, `reiniciar.bat` |
| `scripts/06-personalizacao-e-registro` | Personalização e Registro do Windows | `fotos-windows.reg` |
| `scripts/07-utilitarios-basicos` | Utilitários simples | `Abrir_bloco_notas.bat` |

A descrição funcional detalhada está disponível em:

```text
docs/INVENTARIO.md
```

---

## Validação do repositório

O repositório inclui uma ferramenta de validação estática para verificar a estrutura e os scripts principais:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\validate-scripts.ps1
```

Também existe um workflow em:

```text
.github/workflows/validate.yml
```

Esse workflow pode ser utilizado pelo GitHub Actions para validar alterações enviadas ao repositório.

---

## Boas práticas de segurança

Antes de executar qualquer script:

- leia o conteúdo do arquivo;
- verifique se o script altera Registro, PATH, serviços ou configurações de rede;
- execute em ambiente controlado quando houver risco operacional;
- crie ponto de restauração quando houver alteração de Registro ou serviços críticos;
- evite executar scripts baixados de fontes externas sem auditoria;
- valide comandos destrutivos antes de rodar em máquinas de produção.

Scripts com atenção especial:

| Script | Motivo |
|---|---|
| `desligar.bat` | Encerra o sistema imediatamente |
| `reiniciar.bat` | Reinicia o sistema imediatamente |
| `fotos-windows.reg` | Modifica chaves do Registro |
| `Anydesk-Reset.cmd` | Altera configurações locais do AnyDesk |
| `Corrigir-Git.ps1` | Pode alterar PATH da máquina |
| `Corrigir Winget.cmd` | Interage com instalação/configuração do Winget |

---

## Requisitos

Ambiente recomendado:

- Windows 10 ou Windows 11;
- PowerShell 5.1 ou superior;
- Prompt de Comando nativo do Windows;
- permissões administrativas para scripts de manutenção avançada;
- Git instalado para versionamento;
- Winget instalado para scripts relacionados a pacotes;
- conexão com a internet para instalação de ferramentas externas.

---

## Versionamento e commits

Sugestão de padrão para commits:

```text
<tipo>: <descrição objetiva>
```

Exemplos:

```text
docs: atualiza readme principal
refactor: reorganiza scripts por categoria
fix: corrige caminho de execução do menu principal
chore: remove arquivos temporarios da raiz
```

Tipos recomendados:

| Tipo | Uso |
|---|---|
| `feat` | Nova funcionalidade ou novo script |
| `fix` | Correção de erro |
| `docs` | Documentação |
| `refactor` | Reorganização sem mudança funcional |
| `chore` | Tarefas auxiliares de manutenção |
| `test` | Validações e testes |
| `ci` | GitHub Actions ou automações de integração |

---

## Sugestões de evolução

Melhorias futuras recomendadas:

- padronizar cabeçalhos de todos os scripts;
- adicionar descrição, requisitos e riscos no início de cada arquivo;
- criar um menu PowerShell mais robusto;
- adicionar logs de execução;
- criar testes estáticos por tipo de script;
- documentar exemplos de uso por categoria;
- separar scripts destrutivos dos scripts apenas informativos;
- adicionar política de contribuição (`CONTRIBUTING.md`);
- adicionar licença formal ao repositório.

---

## Aviso de responsabilidade

Este repositório contém scripts que podem alterar configurações do Windows. O uso deve ser feito com avaliação técnica prévia. O autor não se responsabiliza por perda de dados, falhas de sistema, indisponibilidade de serviços, alterações indevidas ou execução em ambiente inadequado.

Use preferencialmente em ambiente controlado, com backup e permissões compatíveis com a ação executada.

---

## Autor

**Cláudio Francisco Dos Santos Júnior**  
CFSJ TECH  
Repositório: `CFSJCODE/Scripts-Para-Windows`
