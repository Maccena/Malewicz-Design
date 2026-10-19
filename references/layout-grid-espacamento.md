# Layout, grid e espaçamento

Consulte ao definir ou revisar grid, colunas, margens, padding, distâncias entre elementos, alinhamento, espaço em branco, hierarquia visual por tamanho/posição/camadas, layout mobile e touch targets.

## Contents

- Grid e colunas
- Método do quadrado vermelho e grid de 8 pt
- Padding, margens e proximidade
- Alinhamento
- Espaço em branco e ritmo
- Ordem de leitura e olhar
- Hierarquia visual
- Mobile, responsivo e touch targets
- Checklist de revisão

## Grid e colunas

- Use grid de 12 colunas, porque 12 divide em muitos arranjos (12, 8+4, 6+6, 4+4+4, 3s) e dá a máxima flexibilidade.
- Mantenha o gutter menor que a coluna (exemplo: dashboard Avo Burger, gutter 32 / coluna 64, o dobro): o grid fica simples de dividir e costuma gerar bom espaço em branco. Produtos densos/profissionais podem pedir gutters menores; ajuste por produto.
- Escolha uma cor de guia do layout grid que contraste com a paleta do produto (o autor trocou vermelho por azul num produto verde).
- Planeje o número de colunas de cada bloco (exemplo: app de delivery): mapa 4 colunas + lista de pedidos 6; menu lateral 2 colunas; botão de formulário em desktop 2 colunas; campos de login no máximo 4 colunas (6 é largo demais).
- Em web app, deixe 1 gutter extra fora do menu lateral (32), para menu e tabelas terem a mesma folga nos dois lados.
- Divida em número par de colunas (6+6) quando possível, porque um número ímpar (ex.: 5) deixa a coluna restante desequilibrada; o autor diz que alguns seniores conseguem usar ímpar, mas prefira par. Os layouts mais usados no case study são 1, 2 ou 3 colunas (12, 6+6, 4+4+4).
- Quando um item domina, não force colunas iguais: divida em 4 (margens ~24) e agrupe colunas estreitas + uma larga.
- Alinhe um bloco foto+texto à 2ª coluna em vez da 1ª: o desvio leve dentro do grid cria respiro e destaque, enquanto tudo na 1ª coluna se mistura. Foto decorativa pode invadir a última coluna.
- Tela de login (exemplo: login Avo Burger): foto em 6 colunas (cantos esquerdos 32) + formulário em 6; título, campos e botão com larguras parecidas (título de 28 cobrindo as 4 colunas, pode quebrar em várias linhas).
- Cards de produto em "soft grid": 4 por linha, 32 das bordas e 32 entre cards (cinco quadrados de 32 distribuídos).
- Telas com conteúdo diferente do resto (ex.: lista de restaurantes + mapa) podem ter grid próprio, quando não há elementos distintos acima/abaixo.

### Valores concretos

Exemplos do dashboard Avo Burger (app de delivery), salvo indicação na linha.

| Contexto | Valor |
|---|---|
| Frame de playground (web app, formato Dribbble) | 1500 x 1000 |
| Largura útil do produto | 1120 (12 colunas) |
| Altura do canvas principal | 750 |
| Grid web app | 12 col, gutter 32, coluna 64, tipo center |
| Grid do case study (frame estreito) | 600 de largura, 12 col, margin 24, gutter 16 |
| Menu lateral | 2 colunas |
| Project summary do case | 3 blocos de 4 colunas (colunas 1, 5 e 9) |

Fold do canvas: 600–660 era o fold antigo e 750 é seguro hoje; em outra aula o autor fala de "700 e poucos px" na maioria dos computadores (trate ~700–750 como fold desktop).

### Anti-padrões
- Colunas ímpares sem motivo; campos de login em 6 colunas; menu lateral largo quando há tabelas largas com scroll lateral (alternativas: menu recolhível só com ícones, que pode confundir alguns, ou top menu).
- Tudo na 1ª coluna, sem nenhum desvio controlado.

## Método do quadrado vermelho e grid de 8 pt

- Use o método do quadrado vermelho (red square): crie quadrados vermelhos de 8, 16, 24, 32, 40, 48 (e 64), deixe-os fora do canvas e copie-os como régua entre os elementos. Todo espaço vira múltiplo de 8.
- Use quadrados auxiliares menores quando preciso: 4 (rótulo–número), 12 (padding de botão pequeno). Para seções internas, um quadrado de metade do tamanho.
- Divida a largura entre N elementos com um quadrado de 24 em cada lateral + um retângulo no meio; divida pelo número de itens usando inteiros, sem decimais. Exemplos do autor: 496/3 ≈ 165,3, ele usou 164 e deixou 2 de gap; 879/5 = 175 cada, com gap de 1 entre eles; tab bar 390/5 = 78; campos lado a lado (320 − 24)/2 = 148 com 24 entre eles. A sobra distribuída ainda é aceitável.
- Defina o grid de 8 pt antes de colar a imagem e de anotar px; não jogue números soltos.
- Mantenha poucos valores de espaçamento: o conjunto deve ter cerca de 4 valores, não 6, 7 ou 8. As distâncias podem variar (isso é hierarquia), mas o vocabulário é pequeno. Exemplo (spec genérica de um projeto só de UI, não o app bancário): espaçamento 24, 16 e 4, texto 24/14/12, raio 32, ícone/touch target em golden ratio.
- Não use auto layout até dominar o layout manual, porque sem entender proximidade e espaçamento você não percebe quando o auto layout estraga o design (principalmente com fontes). O autor recomenda fazer as primeiras dezenas de designs sem ele; com ele ou sem, reselecione tudo no fim e confira.
- Sem decimais nas medidas de produção (4 em vez de 4,4; evite 16,4 e 28,15). Exceção só no portfólio: ajustes de 0,5 ou 0,35 para centralizar visualmente são aceitos, mas não se usam decimais para desenvolvimento.
- Tolerância: 1/4 de pixel na margem inferior é aceitável. Perfeição absoluta não é exigida; o espaço só precisa ser uniforme o bastante para ler fácil.
- Um espaço de 20 pt (2,5 x 8) pode ser mantido por consistência ou migrado para o grid de 8 pt; o autor aceita as duas escolhas.
- Guia de alinhamento no case (persona): quadrado vermelho de 60x60, com gutters de 60 entre duas colunas.

### Valores concretos

| Uso | Valor |
|---|---|
| Escala base | 8, 16, 24, 32, 40, 48, 64 |
| Mais usados na web | 24, 32, 40 |
| Dentro de grupos (grid de 8 pt do case) | 8 e 16 |
| Entre grupos (grid de 8 pt do case) | 24, 32 ou 48 conforme tipo de grupo/conteúdo |
| Margem lateral (exemplo: anotação de tela de UI) | 32 |
| Margem do frame estreito do case study (exemplo: grid de 600) | 24 |
| Distâncias "mecânicas" do case study (exemplo) | 24 e 48 (uma o dobro da outra): 24 entre itens da mesma seção e laterais, 48 entre seções |
| Seções do case Organic Shops (exemplo) | 44 em cima, 44 ou 48 embaixo; quebra a regra do próprio autor de repetir sempre as mesmas duas distâncias, então não replique |

### Anti-padrões
- 6 ou mais valores de espaçamento diferentes; decimais (16,4); medir "a olho" sem régua; especificar px sem ter definido o grid.

## Padding, margens e proximidade

- Trate a proximidade como regra de agrupamento: quanto menor a distância, mais os itens parecem pertencer juntos. 32 serve para separar grupos; por isso o padding interno de cards é 24 ou 16, não 32.
- Na web, use 24 e 32 entre elementos/seções principais e 8, 16, 24 dentro dos elementos (8 e 16 entre elementos só em casos especiais). No mobile o canvas é menor: use mais 8/16/24, com 32 entre seções.
- Hierarquize subgrupos: padding do card 24; título + descrição mais juntos (16), porque aproximar sinaliza que a descrição pertence ao título.
- Imagem no card: 24 de cada lado; texto→imagem 16 (tudo agrupado) ou 24 (imagem mais afastada, muitas vezes melhor para escanear).
- Posicione todos os elementos a 24 das bordas do card (esquerda, topo, base), inclusive gráficos; use o quadrado de 24 como régua em todo lugar.
- Mantenha a distância label→campo menor que a distância entre campos. Com 24 entre campos, o rótulo parecia solto; subiu para 32 entre grupos para o rótulo ser lido como do seu campo (label a 4 do campo, 8 aceitável).
- Mantenha o espaço entre grupos maior que dentro do grupo e a margem externa maior que o padding interno (tudo dentro do card é um grupo). Exemplo mobile (app bancário): margem 20, padding do card 16. Se o espaço entre cards e a lista de transações é igual à margem (20), os dois grupos se fundem: suba para 24 ou 32.
- Elementos mais visuais (cartão de crédito) podem usar 24 enquanto o texto usa 16; uniformizar tudo também vale.
- Opção segura para iniciante: use 32 entre todos os blocos ("espaço em branco nunca fez mal"). Alternativa mais complexa: 24 na vertical e 32 na horizontal.
- Elementos pequenos redondos (avatar): a distância diagonal ao fundo deve parecer igual à lateral/inferior; às vezes quebre o grid (18–20) para ficar visualmente certo.
- Em tabelas, campos de tamanho previsível (ID, valor, ETA) ficam a distância exata entre si (24); campos de texto livre (descrição, nome, endereço) ganham folga (nome até 40). Não alinhe a coluna de nomes a 32 do status, porque nomes têm comprimento variável.
- Seção autocontida (ex.: veículo do motorista) pode ter divisória e espaçamento menor que 32.
- Ao ajustar um espaçamento, aplique a mesma mudança em todos os elementos que usam o padrão (ex.: +4 no label→número, recentralizar, +2/−2 nos outros).
- Em card com texto + botão, alinhe o botão em separado, pois é um elemento independente (quadrado de 32 abaixo do texto, 24 da borda).

### Valores concretos

Exemplos do dashboard Avo Burger (app de delivery), salvo indicação na linha.

| Uso | Valor |
|---|---|
| Padding interno de card | 24 (ou 16) |
| Título→descrição | 16 |
| Número↔label (cards de stats) | 4; chip↔bloco de texto 8 (o dobro de 4); 16 ficou longe demais |
| Ícone↔texto (botão, filtro, aba) | 8 |
| Menu lateral | começa a 64 do logo; 40 entre itens (32 com muitos itens) |
| Item de menu selecionado | 24 de cada lado, altura 44; ícone 16 do topo/base, 12 do lado |
| Abas | 24 da lateral, 48 entre abas (o dobro) |
| Filtro do mapa | altura 64, 24 das bordas, raio 16 |
| Barra de filtros de produtos | altura 64, 32 acima/abaixo |
| Campo de formulário | altura 40 (forms longos profissionais: ~30); grupos a 32; lado a lado 24 entre eles |
| Tabela de motoristas | 16 acima/abaixo do conteúdo; 32 entre colunas; ações a 24 da direita |
| Lista de motoristas | 16 foto↔texto; 24 entre itens |
| Login (exemplo: login Avo Burger) | título→subtítulo 24; 48 até o 1º campo; 40 entre campos; 40 até o botão |
| Mobile (exemplo: app bancário) | margem 20; padding do card 16; texto a 8 do vizinho; linhas de texto a 4; entre grupos 24 ou 32 |
| Case study | 48 entre tags e summary; 24 entre título e dado; texto de concorrente a 16 dos mockups e 24 da borda |
| Ícone/callout | respiro de pelo menos o próprio tamanho; texto→borda igual à moldura |

### Exemplos do autor
- App bancário mobile: caos de margens (4 espaçamentos só à direita, 2–3 à esquerda) → corrigido com margem 20, padding 16, entre grupos 24/32, raio de card 24, uma fonte e 3 tamanhos.
- Cards de restaurante (Avo Burger): sobra de ~15 contra os 16 desejados foi aceita como "perto o bastante".

### Anti-padrões
- Padding de 32 dentro de card; espaço entre grupos igual à margem; distância label→campo igual à distância entre campos; mudar uma instância do padrão sem atualizar as demais.

## Alinhamento

- Primeira checagem de qualquer UI, sobretudo mobile: margem esquerda vs direita. Devem ser exatamente iguais na maioria dos elementos; crie guias para todos os elementos e as inconsistências aparecem.
- Texto puro alinhado à esquerda, na mesma linha vertical do label da coluna. Valores numéricos (dinheiro, ETA) à direita, porque números maiores "saltam" para a esquerda e se vê de relance que é mais dinheiro/mais tempo.
- Consistência linha a linha é o erro nº 1 de tabelas: 1 pt fora já vira bagunça. Divisor de linha: distância da cap height até a linha de cima = até a de baixo, em toda linha. Quebra permitida da regra da coluna: coluna de ação (motorista + contato) à direita.
- Preencha tabelas com dados variados, inclusive em magnitude (minutos de 1 e 2 dígitos), com pessoas sempre diferentes (os pedidos podem repetir), porque duplicatas de pessoas parecem irreais.
- Alinhe card ao card, não ao fundo do pão da foto: use o quadrado 100x100 da foto (com sombra) como referência, pois a base da imagem varia.
- Alinhamento óptico para portfólio; bounding box para trabalho entregue a devs (a caixa de texto dá ~22 em vez de 24 por ~2 pt extras), exceto se o dev for fanático por alinhamento óptico. Ao centralizar o texto de um callout, meça pela bounding box do texto, não pelas letras.
- Verifique o centro óptico de ícones com o quadrado vermelho; se par/ímpar impede o centro exato, tudo bem.
- Logo dentro de um fundo: espaço ≈ 2/3 do logo em cada lado (quase o logo inteiro seria pequeno demais em proporção).
- Texto alinhado à direita ("Don't have an account") não precisa seguir o grid: se traduzido (ex.: alemão), apenas estica para o lado oposto.
- Revisão final antes de publicar: reselecione tudo e confira alinhamento, bordas, divisórias até a borda, logos à mesma distância da linha e tamanhos de fonte, porque algo se move meio pixel após muitas mudanças. Se sobrar 1 px, esconda subindo o conteúdo (ex.: ajustando a altura da tab bar) em vez de deixar o vazio, porque o cérebro espera algo ali.
- Anotações (setas, medidas) precisam estar alinhadas às linhas e consistentes; anotação torta destrói a primeira impressão de quem mostra habilidade de alinhamento.

### Anti-padrões
- Indentação irregular de 1 pt; linhas de altura diferente; números alinhados à esquerda; margens esquerda/direita diferentes.

## Espaço em branco e ritmo

- Prefira espaço em branco generoso a conteúdo condensado; o autor não teme scroll em páginas longas. Elementos de duas Personas (ou blocos vizinhos) não devem se tocar.
- Espaço em branco não precisa ser perfeitamente uniforme, só uniforme o bastante para ler fácil.
- Muito espaço em branco em volta de um formulário (exemplo: login Avo Burger, 195 em cima/embaixo) é normal quando há um elemento visual do outro lado; centralizar só o formulário em tela vazia fica "um pouco chato" (preencha o outro lado com foto/testimonial).
- Compense rostos numerosos (ilustrações de pessoas) com bastante espaço em branco ao lado do texto, porque muitos rostos cansam cognitivamente.
- Em dashboards, equilibre áreas claras e escuras entre os cantos (oferta escura no topo direito, mapa escuro na base direita, motoristas e tabela claros); tudo branco e minimalista fica entediante e mais difícil de ler.
- Mantenha ritmo óptico entre cards (alinhar com retângulos já existentes em outro bloco).
- Em tabelas, com bom espaço em branco zebra striping e divisórias são opcionais (o autor dispensa); últimas linhas cortadas pela máscara na base do frame indicam que há mais conteúdo.

### Exemplos do autor
- Login do Avo Burger: 195 de espaço em branco vertical → natural por haver foto ao lado.

### Anti-padrões
- Dashboard todo branco e minimalista; conteúdo condensado em pouco espaço; elementos vizinhos encostando.

## Ordem de leitura e olhar

- Mostre o conteúdo mais importante above the fold: nos portfólios, ao menos 1/3 das thumbnails visíveis (metade é bom, 2/3 melhor); se o portfólio começa abaixo da fold (só foto + descrição), nada leva a rolar. Header complexo (foto, métricas, 2 CTAs) pode descer os cases um pouco abaixo da fold se mostrar coisas relevantes; mantenha o resto simples.
- Coloque a coluna de status perto do início da tabela para facilitar o scan; o dado mais importante vem primeiro (dashboard = visão de pássaro, sales primeiro).

### Anti-padrões
- Conteúdo-chave abaixo da fold.

## Hierarquia visual

- Hierarquia por tamanho: use forte progressão de tamanho do mais importante ao resto (ex.: nome >> descrição >> dados no header de resume; nome do produto mais proeminente que o preço). Elementos gigantes sem escala (logo Visa, ícone de casa, "main account") quebram a hierarquia.
- Hierarquia por camadas/luminosidade: o que está mais perto do usuário é mais claro. Fundo de página mais escuro/cinza (~#F5F5F5, ou ~#F1F1F1 se quiser mais escuro; valores a confirmar) e cards/menu brancos; em mobile, fundo da página ~4 pontos a menos de lightness (valor a confirmar). Janelas flutuantes brancas exigem fundo de página não branco. Um elemento muito distante em valor (tab bar preta) pode ficar por cima: só importa a progressão entre tons próximos. Nunca inverta camadas (página escura com cards ainda mais escuros).
- Corrija hierarquia primeiro em preto, branco e cinza (fundos escuros para primeiros planos claros), e só depois aplique cor.
- Ações que levam a processos diferentes (Send/Receive) não têm hierarquia presumível: decida por lógica, não por "parece bom o bastante".
- Ações mutuamente exclusivas (Save/Cancel) nunca com o mesmo peso: uma permanece preenchida, a outra vira botão com borda e texto escuros. Botão secundário com menos peso (36 de altura, padding 24, a 32 do topo/direita), principal mais alto que os campos (44 vs 40) para ninguém confundir retângulos de botão e campo. Em desktop, botão menor, não largo.
- Diferencie hierarquia por distância: grupos e subgrupos se anotam como "hierarchy strips" (imagem, subgrupos, categorias, descrição, ações e espaço entre grupos); use isso para justificar cada distância.
- Evite conteúdo decorativo sem função; cada elemento precisa de motivo (cartão de crédito na dashboard só porque aparece em Dribbble, carrossel de tênis em app de corrida).

### Valores concretos

| Uso | Valor |
|---|---|
| Hierarquia mobile (exercício do app bancário) | 3 tamanhos: 24 / 16 / 12; 1–2 pesos |
| Stack de cartões | cada cartão de trás a 90% do anterior |
| Botão principal / secundário | 44 / 36 |

### Anti-padrões
- Camadas invertidas (fundo claro atrás de cards escuros); elementos gigantes sem escala; Save e Cancel idênticos.

## Mobile, responsivo e touch targets

- Em plataformas complexas (ex.: plataforma de investimentos), desenhe o desktop complexo primeiro, mesmo com 95% de tráfego mobile, e depois uma experiência mobile dedicada, porque projetar o grande primeiro mostra o que as pessoas usam e como adaptar à tela pequena. Nesses casos, nunca encolha o desktop (o responsivo clássico "A à esquerda, B à direita → um embaixo do outro" gera página gigante): mobile pede touch targets maiores, gráficos maiores e mais visíveis, e evitar rolar por horas.
- Um layout quase descartado no desktop funcionou muito bem no mobile e deu boost de retenção (no case da plataforma de investimentos); teste alternativas.
- Biblioteca de design por breakpoint, não universal: componentes específicos por breakpoint; apenas cores e fontes (não tamanhos) vêm de uma fonte única. Uma biblioteca universal que se adapta a todas as resoluções vira interface chata que sacrifica as duas pontas.
- Touch target de 44 pt é bom para mobile e também para desktop (item de menu com 44 de altura); valores na tabela de medidas. Ao anotar, mostre o touch target (quadrado tracejado sobre um ícone de 16x16) para evitar a impressão de que o ícone é impossível de tocar; costuma ser esquecido. Na spec de exemplo de projeto só de UI (não o app bancário), a relação ícone/touch target aparece como golden ratio (a confirmar o valor exato).
- Se só um projeto aparece no mobile do portfólio, mostre primeiro o mais vibrante, porque cores mudas não convencem a rolar.
- Menu colapsado só com ícones libera espaço para tabelas com muitas colunas (≈40 entre ícones; colunas ganham 24): expande no hover cobrindo o conteúdo e encolhe ao sair.
- Tab bar: divida a largura pelo número de itens (390/5 = 78), texto de 12 no mesmo estilo e cor, ícones na mesma altura.
- Conteúdo longo possível (endereços): deixe espaço vazio na coluna.

### Valores concretos

| Uso | Valor |
|---|---|
| Touch target | 44x44 (ou 40x40) |
| Item de menu (touch target) | altura 44 |
| Tab bar mobile | 390 de largura, 5 itens de 78 |
| Margem mobile (exemplo: app bancário) | 20; padding de card 16 |

### Exemplos do autor
- Plataforma de investimentos (redesign 2016 → 2023): desktop primeiro, depois mobile próprio com touch targets maiores e gráficos maiores. Os resultados citados (views +400%, clicks +350%, registrations +270%, time on site +60%) pertencem ao redesign inteiro (trilhas, marca, biblioteca por breakpoint e mobile), não só ao mobile.

### Anti-padrões
- Encolher o desktop para mobile em coluna única empilhada (em plataforma complexa); biblioteca universal para todas as resoluções; ícones de 16x16 sem touch target anotado.

## Checklist de revisão

- As margens esquerda e direita são idênticas nos elementos principais?
- Todas as distâncias são múltiplos de 8 (ou do conjunto pequeno de ~4 valores definido), sem decimais?
- O espaço entre grupos é maior que o espaço dentro do grupo, e a margem externa maior que o padding interno?
- Títulos e suas descrições estão mais próximos entre si do que de outros grupos (16 vs 24/32)?
- Textos estão alinhados à esquerda no mesmo eixo e números à direita, com linhas de tabela idênticas entre si?
- O número de colunas de cada bloco faz sentido no grid de 12, com gutter menor que a coluna?
- Há espaço em branco suficiente em volta de cada grupo, sem elementos vizinhos se tocando?
- O conteúdo mais importante está above the fold e a coluna de status vem perto do início da tabela?
- O fundo mais escuro fica atrás e os elementos mais próximos do usuário são mais claros?
- O elemento mais importante é maior/mais proeminente, e ações exclusivas têm pesos diferentes?
- Os touch targets seguem a tabela de medidas, e o mobile tem layout próprio em vez de desktop encolhido?
- Fez revisão final selecionando tudo, sem sobra de 1 px nem alinhamento fora do lugar?
