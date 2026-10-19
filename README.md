# Malewicz-Design

Skill para o Claude Code baseada no material do YouTuber Malewicz (Malewicz Design), com foco em design web, UI/UX e conversão. **Projeto não oficial, sem afiliação nem endosso do autor.**

A skill ensina o Claude a criar, revisar e auditar landing pages, web apps e dashboards, portfólios e case studies de UX/UI, aplicando as regras e medidas dos vídeos (copy antes do visual, grid de 8 pt, sistema visual enxuto, detecção de AI slop e outras).

## Instalação

Pré-requisito: Claude Code e uma cópia deste repositório (`git clone` ou ZIP). Os scripts copiam só `SKILL.md`, `references/` e `LICENSE`.

### Em um projeto (recomendado: dá para commitar e compartilhar com o time)

Linux, macOS ou Git Bash:

```bash
bash install.sh /caminho/do/projeto
```

Windows (PowerShell ou prompt de comando):

```powershell
.\install.cmd "C:\caminho\do\projeto"
# ou: powershell -ExecutionPolicy Bypass -File .\install.ps1 "C:\caminho\do\projeto"
```

Sem argumento, instala no diretório atual (se você estiver dentro deste repositório, o script recusa). O destino é `<projeto>/.claude/skills/malewicz-design/`. Use aspas em caminhos com espaço.

### Para todos os seus projetos

```bash
bash install.sh --global       # Linux, macOS, Git Bash
.\install.cmd -Global          # Windows
```

O destino é `~/.claude/skills/malewicz-design/`.

### Opções

| Bash | PowerShell / install.cmd | O que faz |
|---|---|---|
| `--force` | `-Force` | Substitui uma instalação existente |
| `--uninstall` | `-Uninstall` | Remove a skill instalada |
| `--dry-run` | `-DryRun` | Mostra o que faria, sem alterar nada |
| `-h`, `--help` | `-Help` | Ajuda |

Códigos de saída: 0 sucesso, 1 erro de uso ou validação, 2 já instalado (use `--force`).

Atenção: `--force` e `--uninstall` removem a pasta `malewicz-design` inteira, inclusive arquivos que você tenha adicionado ou editado nela; o script lista esses arquivos antes de remover.

## Uso

Abra o Claude Code no projeto. A skill é carregada quando o pedido envolve design de interface, ou chame direto:

```
/malewicz-design revise esta landing page
/malewicz-design crie o hero da página inicial do app
```

Se a pasta `.claude/skills` não existia quando a sessão começou, rode `/reload-skills` ou reinicie o Claude Code.

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
install.sh, install.ps1, install.cmd
LICENSE, .gitignore, .gitattributes
notas/por-aula/          notas intermediárias por vídeo (local, não versionadas)
transcricoes/_originais/ legendas originais (locais, não versionadas)
```

## Fonte e direitos

As referências são um resumo, em palavras próprias, de vídeos do canal Malewicz. Os vídeos, as ideias e o conteúdo original pertencem ao autor: este repositório não o representa e não é endossado por ele. A licença MIT cobre os scripts e o texto original deste repositório, não o material de terceiros.

As legendas originais e as notas intermediárias (que citam trechos curtos para verificação) ficam em `transcricoes/_originais/` e `notas/por-aula/`, ignoradas pelo Git. Quem quiser reconstruir as referências deve usar suas próprias legendas.

Resultados de conversão e números citados nas referências são relatos do autor dos vídeos, não garantias. Valores marcados "(a confirmar)" vêm de legendas automáticas e podem estar errados.

## Licença

MIT (veja `LICENSE`).
