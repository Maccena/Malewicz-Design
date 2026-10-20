# Malewicz-Design

Skill para o Claude Code baseada no material do YouTuber Malewicz (Malewicz Design), com foco em design web, UI/UX e conversão. **Projeto não oficial, sem afiliação nem endosso do autor.**

A skill ensina o Claude a criar, revisar e auditar landing pages, web apps e dashboards, portfólios e case studies de UX/UI, aplicando as regras e medidas dos vídeos (copy antes do visual, grid de 8 pt, sistema visual enxuto, detecção de AI slop e outras).

## Instalação

Não precisa clonar o repositório: um comando baixa a versão mais recente e instala só `SKILL.md`, `references/` e `LICENSE`. Rode o comando **na pasta do projeto** onde quer usar a skill. A instalação fica em `.claude/skills/malewicz-design/`.

### Linux, macOS, Git Bash e WSL

```bash
curl -fsSL https://raw.githubusercontent.com/Maccena/Malewicz-Design/main/install.sh | bash
```

Com opções, use `bash -s --` antes delas (obrigatório quando o script vem por pipe):

```bash
curl -fsSL https://raw.githubusercontent.com/Maccena/Malewicz-Design/main/install.sh | bash -s -- --global
curl -fsSL https://raw.githubusercontent.com/Maccena/Malewicz-Design/main/install.sh | bash -s -- --force
```

### Windows (PowerShell 5.1 ou superior)

```powershell
irm https://raw.githubusercontent.com/Maccena/Malewicz-Design/main/install.ps1 | iex
```

Com opções, use este formato (o `| iex` puro não aceita parâmetros):

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/Maccena/Malewicz-Design/main/install.ps1))) -Global -Force
```

No PowerShell do Windows não use o comando `curl ... | bash`: com o WSL instalado, o `bash` é o lançador do WSL e a instalação roda dentro do Linux; e no PowerShell 5.1 o `curl` é um alias que não aceita `-fsSL`. Prefira os comandos acima.

### Opções

| Bash | PowerShell | O que faz |
|---|---|---|
| `--global` | `-Global` | Instala para todos os seus projetos, em `~/.claude/skills/malewicz-design/` |
| `--force` | `-Force` | Substitui uma instalação existente (atualiza) |
| `--version X.Y.Z` | `-Version X.Y.Z` | Instala uma versão específica (tag `vX.Y.Z`) |
| `--ref NOME` | `-Ref NOME` | Instala de um branch ou tag, por exemplo `main` |
| `--uninstall` | `-Uninstall` | Remove a skill instalada |
| `--dry-run` | `-DryRun` | Mostra o que faria, sem alterar nada |
| `-h`, `--help` | `-Help` | Ajuda |

Para instalar em outra pasta, passe o caminho do projeto no fim (`bash -s -- /caminho/do/projeto` ou `-Path`/posição no PowerShell). Códigos de saída: 0 sucesso, 1 erro de uso ou validação, 2 já instalado (use `--force`).

Atenção: `--force` e `--uninstall` removem a pasta `malewicz-design` inteira, inclusive arquivos que você tenha adicionado ou editado nela; o script lista esses arquivos antes de remover.

### Versões

Cada versão publicada tem uma tag `vX.Y.Z` e uma entrada no [CHANGELOG](CHANGELOG.md). Por padrão o instalador pega a versão mais recente.

- **Fixar uma versão:** `--version 1.0.0` (ou `-Version 1.0.0`).
- **Atualizar:** rode o mesmo comando de instalação com `--force`. O instalador mostra "instalando 1.1.0 (substituindo 1.0.0)".
- **Qual versão eu tenho?** A versão está em `metadata.version` do `SKILL.md` instalado:

  ```bash
  grep -m1 'version:' .claude/skills/malewicz-design/SKILL.md          # Linux, macOS, Git Bash
  ```

  ```powershell
  Select-String -Path .claude\skills\malewicz-design\SKILL.md -Pattern 'version:' | Select-Object -First 1
  ```

- **Remover:** o mesmo comando com `--uninstall` (`-Uninstall`).

### Instalar a partir de um clone (alternativa)

Se preferir clonar o repositório, rode o instalador de dentro dele; ele instala a cópia local:

```bash
git clone https://github.com/Maccena/Malewicz-Design && cd Malewicz-Design
bash install.sh /caminho/do/projeto              # Linux, macOS, Git Bash
```

```powershell
.\install.cmd "C:\caminho\do\projeto"            # Windows (não exige mudar a ExecutionPolicy)
```

## Uso

Abra o Claude Code no projeto. A skill é carregada quando o pedido envolve design de interface, ou chame direto:

```
/malewicz-design revise esta landing page
/malewicz-design crie o hero da página inicial do app
```

Se a pasta `.claude/skills` não existia quando a sessão começou, rode `/reload-skills` ou reinicie o Claude Code. Para compartilhar com o time, faça commit de `.claude/skills/malewicz-design` no projeto.

## Estrutura

```
SKILL.md                 roteador da skill (carregado quando relevante)
references/              regras por tema, carregadas sob demanda
  landing-page-conversao.md
  layout-grid-espacamento.md
  tipografia-cor-icones-imagens.md
  ui-de-produto-e-componentes.md
  auditoria-e-anti-padroes.md
  portfolio-e-case-study.md
  carreira-e-resume.md
install.sh, install.ps1, install.cmd   instaladores (não são copiados para o projeto)
scripts/bump-version.sh  ferramenta do mantenedor para publicar versões
CHANGELOG.md, LICENSE, .gitignore, .gitattributes
notas/por-aula/          notas intermediárias por vídeo (locais, não versionadas)
transcricoes/_originais/ legendas originais (locais, não versionadas)
```

## Publicar uma versão (mantenedores)

A versão fica em `metadata.version` no `SKILL.md`, e a tag `vX.Y.Z` é o que o instalador baixa.

1. Escreva a entrada `## X.Y.Z — data` no `CHANGELOG.md`.
2. Rode `bash scripts/bump-version.sh X.Y.Z`. Ele recusa versão sem entrada no changelog, repetida ou menor que a atual, e atualiza o `SKILL.md`.
3. Faça o commit e crie a tag, como o script imprime:

   ```bash
   git add SKILL.md CHANGELOG.md && git commit -m "Release X.Y.Z"
   git tag -a vX.Y.Z -m "vX.Y.Z" && git push origin main vX.Y.Z
   ```

Sem a tag no GitHub, o instalador falha ao resolver a "última versão" e sugere `--ref main`.

## Fonte e direitos

As referências são um resumo, em palavras próprias, de vídeos do canal Malewicz. Os vídeos, as ideias e o conteúdo original pertencem ao autor: este repositório não o representa e não é endossado por ele. A licença MIT cobre os scripts e o texto original deste repositório, não o material de terceiros.

As legendas originais e as notas intermediárias (que citam trechos curtos para verificação) ficam em `transcricoes/_originais/` e `notas/por-aula/`, ignoradas pelo Git. Quem quiser reconstruir as referências deve usar suas próprias legendas.

Resultados de conversão e números citados nas referências são relatos do autor dos vídeos, não garantias. Valores marcados "(a confirmar)" vêm de legendas automáticas e podem estar errados.

## Licença

MIT (veja `LICENSE`).
