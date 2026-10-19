---
name: malewicz-design
description: Aplica as regras de design web, UI/UX e conversão do canal Malewicz ao desenhar, melhorar ou auditar landing page (hero, headline, CTA, pricing), SaaS, web app, dashboard, tabela, formulário, tela de login e mobile: grid de 8 pt, espaçamento, tipografia, paleta, contraste, design genérico ou AI slop. Cobre também portfólio e case study de designer UX/UI e resume de designer. Resumo não oficial, sem afiliação com o autor. Applies Malewicz's UI/web design and conversion rules when building or reviewing pages and screens. Not for backend, print/branding, funnel strategy without UI, or non-designer resumes.
license: MIT
metadata:
  source: vídeos do canal Malewicz (Malewicz Design); projeto não oficial
  language: pt-BR
---

# Malewicz Design

Regras de design destiladas dos cursos e vídeos do canal Malewicz ("o autor", nas referências). Resumo não oficial, sem afiliação com ele. O conteúdo fica em `references/`; carregue só o que a tarefa pede.

## Escolha as referências

| Tarefa | Leia |
|---|---|
| Landing page, hero, headline, CTA, rostos e imagens no hero, prova social, pricing, FAQ, benchmark de concorrentes | [references/landing-page-conversao.md](references/landing-page-conversao.md) |
| Grid de 12 colunas, grid de 8 pt, quadrado vermelho, margens, padding, proximidade, alinhamento, mobile, touch targets | [references/layout-grid-espacamento.md](references/layout-grid-espacamento.md) |
| Fontes, tamanhos, paleta, contraste AA, ícones, fotos, avatares, mockups, sombras, raio | [references/tipografia-cor-icones-imagens.md](references/tipografia-cor-icones-imagens.md) |
| Web app, dashboard, navegação, cards, tabelas, formulários, botões, estados, mapas, tela de login, fluxo mobile | [references/ui-de-produto-e-componentes.md](references/ui-de-produto-e-componentes.md) |
| Auditar ou criticar um design, red flags, AI slop, tendências de UI (glassmorphism, neumorphism etc.), relatório de auditoria | [references/auditoria-e-anti-padroes.md](references/auditoria-e-anti-padroes.md) |
| Portfólio de designer (home, thumbnails), estrutura de case study, redesign de trabalho de cliente | [references/portfolio-e-case-study.md](references/portfolio-e-case-study.md) |
| Carreira de designer iniciante, resume, ATS, falsos seniors (nunca inflar, inventar ou falsificar experiência) | [references/carreira-e-resume.md](references/carreira-e-resume.md) |

Combine arquivos quando a tarefa cruza áreas. Exemplos: seção de pricing = landing + layout; tela de login = ui (já traz as medidas) + tipografia/cor para fontes e contraste; landing de fintech = landing + tipografia/cor + layout; home de portfólio = portfólio + auditoria. Cada arquivo termina com um checklist de revisão; use o de cada área tocada.

Os arquivos são longos: leia o `Contents` no topo e vá direto às seções que importam (ou use Grep nos títulos `##`) em vez de carregar tudo.

## Princípios que valem em qualquer tarefa

1. **Copy antes do visual.** A mensagem (headline, descrição, CTA) carrega a conversão; o visual só entra para amplificá-la. Nunca comece pela imagem.
2. **Todo elemento tem função.** Para cada item pergunte para que serve, se é redundante e se precisa existir. Justifique cada medida e cada escolha com um porquê objetivo, não com gosto.
3. **Sistema pequeno e consistente.** Poucas fontes, tamanhos, cores, ícones do mesmo estilo, espaçamento em múltiplos do grid de 8 pt. Inconsistência é achado de auditoria por si só.
4. **Audite, não gere por impulso.** IA gera volume, não bom gosto. Depois de produzir, passe o resultado pelo checklist da área e pela seção "AI slop" da auditoria.
5. **Contexto decide o número.** Os valores variam entre web app, login, case study e mobile (exemplo: raio de campo 2 no formulário e 8 nos cards). Escolha o valor do contexto certo e diga qual contexto usou.

## Pedido pontual

Se o pedido é um ajuste ou uma pergunta ("ajuste este padding", "troque estas fontes", "como fica o estado X?"), leia só a referência da área e responda direto: não siga o fluxo abaixo, não leia a auditoria e não monte relatório nem checklist. Se a referência não cobre o tema, diga isso e dê sua sugestão rotulada (ver "Limites de honestidade"). Pedidos de revisão, crítica ou auditoria ("revisa o hero", "o que está errado nesta tela?") não são pontuais: use "Fluxo: revisar ou auditar".

## Fluxo: criar ou melhorar páginas e telas

Para resume, carreira e portfólio, leia só a referência da área e use o checklist dela; os passos abaixo valem para páginas, telas e componentes.

```
- [ ] 1. Contexto: tipo (landing, app, portfólio...), público e objetivo de negócio. Pergunte só o que faltar e não puder ser inferido.
- [ ] 2. Se a página tem headline, subtítulo ou CTA, escreva ou critique esses textos antes de qualquer decisão visual.
- [ ] 3. Leia as referências da tabela e, sempre, as seções "AI slop" e "Checklist rápido" de references/auditoria-e-anti-padroes.md.
- [ ] 4. Produza o design ou o código aplicando as regras e os valores concretos.
- [ ] 5. Revise contra o checklist de cada referência usada e contra o "Checklist rápido" da auditoria.
- [ ] 6. Entregue com: decisões principais e o porquê, valores escolhidos (com o contexto de onde vieram) e o que ficou como suposição.
```

Em código (HTML/CSS/React), use as medidas das referências (pt/px do Figma) como px.

## Fluxo: revisar ou auditar

1. Leia [references/auditoria-e-anti-padroes.md](references/auditoria-e-anti-padroes.md) e siga o método passo a passo.
2. Leia a referência de cada área auditada, para os valores de comparação (seções "Valores concretos").
3. Em código, extraia os valores reais (fontes, tamanhos, cores, margens, raios) e conte os distintos antes de opinar.
4. Entregue no formato de relatório definido no arquivo de auditoria: crítico, importante, polimento; cada achado com o quê, onde, por quê e como corrigir.

## Limites de honestidade

- Atribua ao autor só o que está nas referências. Fora do material (por exemplo estados disabled, erro de campo, vazio e loading; line-height; breakpoints numéricos), escreva "Sugestão minha (não é do Malewicz): ..." e diga que o material não cobre.
- Valores marcados "(a confirmar)" são incertos: use-os com aviso.
- Resultados de conversão citados (aumentos percentuais) são relatos do autor, não garantias, e muitas vezes valem para um redesign inteiro. Nunca os apresente como promessa.
- Ao orientar resume, nunca sugira inflar, inventar ou falsificar experiência.
- Responda no idioma do usuário; termos técnicos de design ficam em inglês quando é o uso comum.
