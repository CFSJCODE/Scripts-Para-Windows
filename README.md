# Scripts Para Windows — Organizado

Coleção de scripts Batch, CMD, PowerShell e Registro para manutenção, diagnóstico, configuração e administração de sistemas Windows.

A estrutura foi reorganizada por função operacional, preservando os nomes originais dos scripts para reduzir risco de quebra de uso ou referência externa.

## Estrutura

```text
Scripts-Para-Windows-Organizado/
├── Executar_Menu_Principal.bat
├── README.md
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
└── .github/workflows/
    └── validate.yml
```

## Classificação por função

| Pasta | Função | Scripts principais |
| --- | --- | --- |
| `scripts/00-menu-principal` | Menu consolidado de manutenção | `ScriptManutençãoDoWindows.bat` |
| `scripts/01-rede-e-conectividade` | Diagnóstico e configuração básica de rede | `VERIFICAÇÃO DE REDE.BAT`, `ver_ip.bat`, `placas_redes.bat`, `limpar caches.bat` |
| `scripts/02-desenvolvimento-e-pacotes` | Winget, Git, GitHub CLI e Copilot CLI | `Corrigir Winget.cmd`, `Corrigir-Git.ps1`, `Instalando GitHub CLI.bat` |
| `scripts/03-administracao-do-windows` | Consoles administrativos nativos | `Gerencie o Firewall do Windows.bat`, `Gerencie usuários.bat`, `painel_controle.bat` |
| `scripts/04-acesso-remoto` | Acesso remoto e AnyDesk | `conexao_remota.bat`, `Anydesk-Reset.cmd` |
| `scripts/05-energia-e-sessao` | Desligamento e reinicialização | `desligar.bat`, `reiniciar.bat` |
| `scripts/06-personalizacao-e-registro` | Ajustes de Registro e personalização | `fotos-windows.reg` |
| `scripts/07-utilitarios-basicos` | Atalhos utilitários simples | `Abrir_bloco_notas.bat` |

## Execução

### Menu principal

Execute o atalho da raiz:

```bat
Executar_Menu_Principal.bat
```

Ou execute diretamente:

```bat
scripts\00-menu-principal\ScriptManutençãoDoWindows.bat
```

### Validação estática do repositório

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\validate-scripts.ps1
```

## Cuidados operacionais

- Scripts que alteram serviços, Registro, PATH, Windows Update, Defender, rede, spooler ou aplicativos devem ser executados como Administrador.
- `desligar.bat` e `reiniciar.bat` executam ações imediatas e forçadas. Use com cautela.
- `fotos-windows.reg` altera chaves do Registro. Revise antes de importar.
- `Anydesk-Reset.cmd` interfere em configurações locais do AnyDesk. Use apenas quando a finalidade for deliberada.

## Arquivos removidos do pacote final

- `.git/`: metadados locais de repositório, inadequados para distribuição por ZIP.
- `Scripts-Para-Windows-main.zip`: arquivo ZIP duplicado/legado dentro do pacote original.

## Preparação para GitHub

```powershell
git init
git branch -M main
git add .
git commit -m "refactor: organiza scripts Windows por funcao"
git remote add origin https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git
git push -u origin main
```
