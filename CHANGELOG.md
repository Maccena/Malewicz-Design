# Changelog

Cada versão publicada da skill **malewicz-design**, da mais nova para a mais antiga. A versão vive em
`metadata.version` no `SKILL.md`; cada release tem uma tag git `vX.Y.Z`, e é a tag que o instalador baixa.
Para publicar: escreva a entrada aqui, rode `scripts/bump-version.sh X.Y.Z` e siga os comandos que ele imprime.

## 1.0.0 — 2026-10-20

Primeira versão.

- `SKILL.md` como roteador, com 5 princípios gerais, fluxo de criar/melhorar, fluxo de revisar/auditar e regras de honestidade.
- Sete referências sob demanda: landing page e conversão; layout, grid e espaçamento; tipografia, cor, ícones e imagens;
  UI de produto e componentes; auditoria e anti-padrões; portfólio e case study; carreira e resume.
- Seção de fontes complementares (sites do autor) em landing page e conversão, rotulada como observação, não regra.
- Instaladores para Linux, macOS, Git Bash e Windows (PowerShell), com `--global`, `--force`, `--uninstall` e `--dry-run`.
- Instalação sem clonar, por `curl | bash` ou `irm | iex`, que baixa a tag da versão (`--version X.Y.Z` fixa uma versão, `--ref` escolhe um branch).
