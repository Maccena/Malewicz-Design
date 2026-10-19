# UI de produto e componentes

Quando consultar: ao desenhar ou criticar um web app ou produto (dashboard, admin, telas de lista, formulários, login, app mobile): navegação, cards, tabelas, campos, botões, estados, mapas, fluxo e versões mobile.

## Contents

- Planejamento e estrutura de tela
- Navegação
- Dashboard
- Cards e stat cards
- Data tables
- Formulários e campos
- Botões
- Estados e badges
- Mapas, filtros e progress bars
- Tela de login (split screen)
- Onboarding e UX de fluxo
- Mobile e component library por breakpoint
- Ordem de trabalho sugerida pelo autor
- Lacunas do material
- Checklist de revisão

Convenção: os hex de cinza citados aqui (#F5F5F5, #2E2E2E, #8E, #AE, #4E) são valores incertos (a confirmar); o curso de UX usa #2C2C2C como preto. Todos os valores estão em pt/px do Figma.

Atenção: salvo indicação contrária, os números em pt vêm de UMA tela de exemplo do autor (dashboard de delivery "Avo Burger", tela de login, action sheet de produto ou app bancário mobile) e não são regras gerais. Copie a lógica de proximidade e hierarquia, não o número.

## Planejamento e estrutura de tela

- Planeje por escrito antes de desenhar: produtos/conteúdo primeiro, depois a estrutura (abas), depois o conteúdo de cada aba. Neste curso (web design) o autor vai direto para alta fidelidade, sem wireframe low-fi, para economizar tempo, porque escrever uma ideia leva a revisar outra até a lógica fechar. No curso de UX/portfólio ele ensina wireframes low-fi a partir dos designs de alta fidelidade; escolha conforme o objetivo do projeto.
- Conheça todas as abas antes de decidir o dashboard, porque isso mostra o que é realmente útil na tela principal.
- Telas de lista de uso real (orders etc.) não levam decoração: só lista pesquisável, ordenável e filtrável, porque quem gerencia quer achar um item e agir.
- Mostre pedidos recentes no dashboard com contato direto (ligar/mandar texto ao cliente ou ao motorista), porque em emergência é preciso intervir na hora.
- Hierarquia por luminosidade: o que está mais perto do usuário é mais claro. Fundo da página cinza claro, menu e cards brancos; fundo branco atrás de janelas brancas as faz sumir. Um elemento muito distante em valor (tab bar preta) pode ficar por cima.
- Mantenha poucos valores de espaçamento no conjunto (no app bancário mobile auditado, os espaçamentos verticais caíram para cerca de 4 valores, não 6-8). Distâncias podem variar por hierarquia, mas margem esquerda e direita devem ser iguais.
- Copie o processo, não o exemplo: faça um tema próprio, porque assim o projeto serve de portfólio e pode virar produto real.

### Valores concretos (dashboard de delivery do autor)

| Item | Valor |
|---|---|
| Canvas de trabalho | 1500 x 1000 (formato de shot de Dribbble); área do produto 1120 (12 colunas) x 750 de altura |
| Altura segura de above the fold | ~750 (antes 600-660) |
| Grid | 12 colunas, gutter 32, coluna 64 (gutter menor que a coluna); produtos densos podem pedir gutter menor |
| Raio do container principal e do menu | 32 |
| Espaço entre blocos/seções na web | 24 e 32 entre elementos; 8, 16, 24 dentro deles (40 e 48 também aparecem como quadrados de referência). Na web o autor diz usar 24, 32 e 40 com mais frequência, com 8 e 16 como casos especiais |
| Fundo da página / menu | ~#F5F5F5 (ou #F1F1F1, mais escuro) / branco |

Opção segura para iniciante: 32 em tudo entre blocos. Não use auto layout até dominar o layout manual (vale as primeiras dezenas de designs), porque sem isso você não percebe quando ele estraga o espaçamento.

Anti-padrões: decorar tela de lista; fundo de página branco com janelas brancas; abrir o auto layout sem entender proximidade.

## Navegação

- Escolha entre side menu (2 colunas), menu recolhido só com ícones, ou top menu. Se há data tables largas com scroll lateral, o side menu desperdiça espaço; o recolhido pode confundir alguns usuários, o top menu libera espaço para dados.
- Menu colapsado: só ícones, expande no hover cobrindo o conteúdo e encolhe ao sair. Ícones ~40 entre si; badge sobre o ícone; redistribua as colunas da tabela com 24.
- Selected state do menu lateral: bloco escuro, texto e ícone brancos, raio 8, altura 44 (44 é bom touch target para mobile e desktop). O bloco fica a 24 das bordas do menu; o ícone fica a 12 da borda do bloco e a 16 acima/abaixo. Raio pequeno porque o elemento é pequeno.
- Cor de destaque (verde) reservada para notificações/itens importantes, porque exagerar no destaque enfraquece o selected state escuro.
- Abas/tabs: ícone+texto com a mesma distância em todas (8), texto centrado no ícone. Indicador selecionado minimalista: linha de 4 pt em escuro (#2E, a confirmar), porque colorir briga com a cor já presente à direita. Alternativas aceitas pelo autor: fundo claro full-width sem cantos + linha de 4 pt opaca, ou ícone e texto coloridos com lightness -20; "escolha a que funciona melhor".
- Tab bar mobile (exemplo mobile do autor): textos todos com mesmo tamanho (12), estilo e cor; ícones na mesma altura; largura dividida igualmente (390/5 = 78). Selecionado: ícone preenchido + underline de cantos totalmente arredondados na cor de acento.
- Navegação por níveis: tela raiz tem menu principal (tabs ou hambúrguer) e nenhuma seta de voltar; tela mais funda tem seta de voltar e sem o menu, porque seta na raiz não leva a lugar nenhum. O autor vê o Instagram, que duplica menu e navegação superior, como quebra de hierarquia e confuso.
- Não duplique o acesso ao perfil (foto no topo + aba perfil, ou dois links de perfil), prática que aparece por querer encher a tab bar.

### Valores concretos (dashboard de delivery do autor)

| Item | Valor |
|---|---|
| Side menu | 2 colunas + 1 gutter (32) fora, para menu e tabelas terem a mesma folga |
| Logo | 32 da esquerda e do topo; primeiro item do menu 64 abaixo do logo |
| Itens | 40 entre si (32 se houver muitos); texto 14 Medium; ícones 16x16; cor #2E2E2E (a confirmar) |
| Selected state | bloco a 24 das bordas do menu, raio 8, altura 44; ícone a 12 da borda do bloco e 16 acima/abaixo |
| Badge de pedidos | altura 18, fonte 2 pt ou mais menor que a do menu; não clicável, por isso menor; padding vertical igual em cima e embaixo e o texto não cruza onde as curvas laterais começam a ficar retas |
| Bolinha de notificação | 8 com stroke branco |
| Perfil no rodapé | avatar 36 (começou em 32); divisor quase invisível (cor do fundo da página), terminações retas, 18 acima/abaixo |
| Abas | 24 da lateral, 48 entre abas (o dobro); indicador 4 pt; "..." a 24 da direita |

Anti-padrões: seta de voltar na raiz; menu duplicado em tela interna; perfil duplicado; colorir o indicador de aba quando já há cor ao lado.

## Dashboard

- O dashboard é a visão de pássaro: o dado mais importante para o admin (vendas) vem primeiro. Search/filtro no topo.
- Não faça o dashboard todo branco e minimalista, porque fica entediante e mais difícil de ler. Equilibre claros e escuros entre os cantos: card de oferta com gradiente escuro (topo direito), card de motoristas branco, mapa escuro (base direita).
- Quebre o visual com ilustração 3D/2D ou foto com fade relevante ao material, mascarada dentro do card. Em dashboard a ilustração não vaza para fora do card (em shot de Dribbble pode).
- Card promocional: gradiente linear no canto de #2E2E2E (a confirmar) opaco para um pouco mais claro; texto branco com as partes-chave (valor mínimo, % de desconto: $100, 15%) em peso Black (leitura mais provável; a legenda diz só "font ... to black").
- Revise a lógica dos dados ao final: pedido "Delivered" não tem ETA (use "–"). Números do card e do gráfico devem concordar.
- Alinhamento: óptico e com decimais (0,5; 0,35) só em peça de portfólio. Para trabalho com devs, alinhe pela bounding box e sem decimais, porque o dev costuma não ligar para alinhamento óptico. Exemplo do autor: o texto "Expand map" fica a 24 pelo quadrado de referência, mas ~22 pela bounding box (cerca de 2 pt extras na caixa).
- Após qualquer ajuste fino, aplique a mesma mudança em todos os elementos do mesmo padrão. Mantenha ritmo óptico entre cards (alinhe com retângulos de outro bloco). Tolerância de 1/4 de pt na margem inferior é aceitável.
- Cards cortados saindo do canvas só em shots de Dribbble, para sugerir scroll.
- Hero com dashboard é tema de landing page e não é tratado aqui.

### Valores concretos (dashboard de delivery do autor)

| Item | Valor |
|---|---|
| Mapa / pedidos recentes | 4 colunas / 6 colunas |
| Search bar | altura 40 (39 + underline escuro de 1 pt); ícone de busca diâmetro 14, stroke 2 (círculo ímpar com linha de 1 pt, par com 2 pt), girado 45° |
| Botão secundário "Export CSV" | fundo branco, padding 12 por lado, alinhado à base da search bar |
| Título do card | a 24 da borda |
| Dados de exemplo | 64 ongoing, 137 delivered, 201 total; vendas $1.200 hoje e $45.200 no mês |

Exemplos do autor: dashboard "Avo Burger" (admin de delivery): vendas hoje/semana/mês, mapa com entregas em curso, pedidos recentes, motoristas, promoções. O projeto começou como "Avo Club" (sanduíches) e virou hamburgueria na fase de ativos porque faltavam boas fotos livres de sanduíche; o autor diz que mudar de conceito nesse estágio ainda é permitido e que, sem boa foto grátis, não se usa foto feia.

Anti-padrões: dashboard todo branco; ilustração vazando do card; ETA em pedido entregue; mudar uma instância do padrão sem atualizar as outras.

## Cards e stat cards

- Padding interno do card 24 (ou 16), nunca 32, porque 32 serve para separar grupos. Título → descrição 16 (subgrupo mais junto). Margem externa do card maior que o padding interno, porque tudo dentro é um grupo.
- Imagem no card: 24 de cada lado; texto → imagem 16 (tudo agrupado) ou 24 (imagem mais afastada), o espaço não precisa ser perfeitamente uniforme, só uniforme o bastante para ler.
- Todos os elementos externos a 24 das bordas do card (esquerda, topo, base), inclusive em gráficos: use o quadrado 24x24 como régua.
- Stat card = ícone em quadrado arredondado + número + label. Cores do quadrado claras (aumente a lightness; se ainda forte, reduza a saturation), porque deve ser visível mas não roubar foco da tabela. Um card pode ser a versão dessaturada (quase cinza) das cores do logo.
- Distância número-label pequena: 4 no stat card de pedidos (baseline do número tocando a cap height do label); ícone-texto pelo menos o dobro (8). Testado 16: longe demais. Nos cards de vendas o autor aumentou a distância número-label para 8 (+2 de cada lado).
- Para distribuir N cards numa largura: quadrado de 24 em cada lateral e divida o retângulo restante por N, removendo decimais (496/3 = 164, gap de 2; 879/5 = 175, gap de 1).
- Cor semântica de tendência só no ícone/linha (verde melhor que ontem; para pior, hue puxado para vermelho e linha espelhada), não no número.
- Gráfico de vendas: dados coerentes com o card (máximo ~4,5k na semana 2, valor a confirmar → eixo Y 5k, 2,5k, 0; o autor não reconcilia essa escala com o card, que mostra $45.200 no mês); labels do eixo alinhados à esquerda; poucas linhas de grade; baseline mais visível (as demais +5 de lightness); linha com pontas arredondadas e gradiente entre os dois verdes do projeto; área abaixo opcional com gradiente que some, opacidade bem baixa.
- Gráfico simplificado e suave é "versão portfólio" (menos info no eixo X, resto no hover); gráfico real seria mais serrilhado.
- Em case study o autor também pede: linha nunca de 1 pt, round cap, cor de destaque do produto, eixos leves mas visíveis, valor-chave em tooltip, maior valor encostando no topo do gráfico (sem vazio acima). As guias do eixo são de 1 pt, tracejadas, cinza muito claro; a regra "nunca 1 pt" vale para a linha de dados.
- Card de produto: foto sem fundo alinhada pelo quadrado 100x100 (incluindo sombra), nunca pela base do pão; alinhe card com card, não com o topo da imagem. Preço menos proeminente que o nome. Descreva só o que aparece na foto. Varie os dados (ex.: ícone de olho cortado = produto sem detalhes editáveis). Preço em verde é opcional; o autor prefere escuro. Card "Add New Product" com stroke interno visível (cinza #AE, a confirmar) sobre fundo igual ao do app.
- Card de motorista/restaurante: veja Valores concretos. Nome em 14 (era 12) para destacar, nome e label no mesmo left edge. Ícone de transporte é decoração: mesmo tamanho para carro e scooter, cinza se o motorista está em pausa. Seção autocontida (veículo) com divisória e espaçamento menor que 32.
- Foto de pessoa sem fundo precisa de círculo cinza atrás. Rostos com mesmo tamanho no círculo (guia de ~2/3 da área contendo rosto e testa), saturação/exposição igualadas à da foto menos saturada.

### Valores concretos (dashboard de delivery do autor)

| Item | Valor |
|---|---|
| Cards do dashboard | brancos, raio 8, 32 entre si; nessa tela o autor também cita raio 8 para campos |
| Quadrado de ícone do stat card | 38x38 |
| Soft grid de produtos | 4 por linha; 32 das bordas e 32 entre cards |
| Foto do produto | 100-110, pode sair do card no máximo 16; card com 24 da esquerda e dos cantos inferior/direito; 16 entre foto/nome/texto; ícones olho/settings 8 entre si |
| Ícone folha vegan | 16 do topo e da esquerda |
| Sombra da foto | elipse com layer blur ~9, escurecida |
| Card de restaurante | foto raio 8, célula ~160 de altura; nome 16 Black; endereço cinza; botão "Manage restaurant" (texto bold, ícone a 8, raio 4) + dois botões quadrados 30x30 a 8 entre si e 24 da direita; 32 entre cards (24 se agrupado) |
| Motorista no dashboard | avatar 36; 16 entre foto e texto; 24 entre motoristas; scooter 32 (testou 40) a 24 da direita |
| Overlay de sort e similares | 8 |

Anti-padrões: padding 32 dentro de card; fotos de produto sem tratamento; descrever o que não está na foto; cor de tendência no número; misturar sets de ícones.

## Data tables

- Texto puro alinhado à esquerda, na mesma linha vertical do label; valores numéricos (dinheiro, ETA) alinhados à direita, porque números maiores "saltam" para a esquerda e se vê de relance o que é maior. Reafirmado em todas as tabelas.
- Consistência linha a linha é o erro nº 1: mesmas distâncias entre campos, mesmas alturas, mesmo alinhamento em toda linha; 1 pt fora já vira bagunça.
- Dados variados, nunca linhas duplicadas: nomes de rua, pedidos, IDs, valores e ETAs diferentes, de tamanhos diferentes (inclusive minutos de 1 e 2 dígitos). Pessoas com fotos e nomes diferentes (só o primeiro nome do cliente, com comprimentos variados); pedidos podem se repetir. IDs falsos: duas letras + número.
- Campos de tamanho previsível (Order ID, valor, ETA) ficam a distâncias exatas (24); campos de texto livre (descrição, nome, endereço) ganham folga (nome até 40 em vez de 24), porque não se sabe quanto espaço vão ocupar. Não alinhe a coluna de nomes a 32 do status; status e ID, de tamanho previsível, alinham juntos.
- Labels de coluna mais claros que os dados (+40 a +50 de lightness; acima disso some). Dados em escuro (#2E2E2E, a confirmar).
- Hierarquia na tabela: valor do pedido em bold; nome em bold (o mais importante); restaurante/secundário em cinza mais claro (#8E, a confirmar). Tabela menos uniforme facilita achar o que importa.
- Ordenação visível: coluna ordenada com pequeno overlay claro (8 pt, cor do fundo mais clara) e seta na cor da fonte. Clicar na seta inverte; clicar em outra coluna ordena por ela.
- Status com bolinha colorida (5-6 pt, sem stroke) + texto, coluna perto do início para facilitar scan: delivered verde, in delivery outro verde, pending/pagamento laranja, ordered cinza. Indicadores extras úteis (ex.: motorista perto da entrega, não atende chamadas).
- Zebra striping e linhas divisórias são opcionais; com bom espaço em branco o autor dispensa. Se usar divisórias, a distância da cap height até a linha de cima = até a de baixo em toda linha ("crucial").
- A coluna de ação pode quebrar a regra e ficar alinhada à direita (driver + contato), porque a ação principal fica numa só linha.
- Tabela que rola: encosta na base do frame (sem cantos arredondados embaixo) e a última linha é cortada pela máscara, para indicar mais conteúdo. Copie blocos de linhas em ordem não uniforme (4, 8, 6) para não repetir padrão.
- Linha selecionada: fundo branco, raio 8, sombra mínima (blur 12, ~10% de opacidade) mesmo num design sem sombras; ou stroke mais grosso com gradiente diagonal; opcional deslocar colunas simetricamente (12, 8, 6, 4).
- Tabela sem label interno quando a aba já é o título; fonte maior numa tabela é aceita por variedade. Em colunas de conteúdo potencialmente longo (endereço), deixe espaço vazio.
- Data tables largas favorecem menu colapsado ou top menu.

### Valores concretos (dashboard de delivery do autor)

| Item | Valor |
|---|---|
| Linhas do dashboard | 24 de baseline a baseline; labels 12 Medium a 12 da linha divisória; dados 12 |
| Tabela Drivers | linhas a 16 acima/abaixo do conteúdo; avatar 36 a 24 da esquerda; 32 entre colunas; ações a 24 da direita |
| Colunas Orders | cliente, pedido, order ID, driver, restaurante, endereço, status, contato (call/text); valor do pedido e ETA também aparecem nas demais descrições da tabela, então a lista não é fechada |
| Colunas Drivers | Name, Status, Current delivery ID, Deliveries, Vehicle ID, Actions |
| Faixa de stats acima da tabela | ~3 cards + vendas "today" e "this month" ("this year" descartado) |

Exemplos do autor: Orders larga com linha selecionada e ETA "–" nos entregues; Drivers feita do zero em ~16/32/24.

Anti-padrões: linhas idênticas ou todos os nomes iguais; indentação irregular; distâncias diferentes entre campos de linha para linha; números à esquerda; ETA em pedido entregue.

## Formulários e campos

- Distância label → campo menor que a distância entre campos, para o label ser lido como do seu campo. Com 24 entre campos ficava parecido com label → campo; o autor usou 32 entre campos/grupos.
- Campo grande e grosso = produto moderno voltado ao consumidor. Produto profissional com forms longos usa campos de ~30 de altura e borda mais fina, para caber mais.
- Label bold 14 (visibilidade máxima); helper/dica medium 12 em cinza claro (#AE, a confirmar).
- Sinal de unidade dentro do campo ("$" a 16 da esquerda): o usuário sabe o que digitar. Campo de preço não precisa ser largo.
- Campo preenchido com sucesso: stroke verde.
- Botão principal do action sheet (form de produto): largura total, 32 de cada lado, 44 de altura contra 40 dos campos, para ficar mais proeminente ("more prominent"). No login o botão tem 2 colunas de largura e 44 de altura, porque ninguém deve confundir retângulo de botão e de campo. Reaproveite o mesmo botão entre telas.
- Action sheet (form em overlay): preto 40% de opacidade sobre o app, folha branca com a largura de 4 colunas e cantos direitos 32; X de fechar a 32.
- Formulário longo: divida e agrupe por categoria mental (nome; contato com e-mail e telefone; endereço). Preferências de notificação vão para a aba de notificações; extras no perfil, sem preenchimento imediato. Porque ninguém preenche vários campos obrigatórios com asterisco vermelho, mesmo que o negócio queira os dados.
- Tags de ingredientes no campo: padding 8, X a 8 do texto, 8 entre tags, raio 1 (2 ficava estranho), cor mais clara; tags/pills nunca com a mesma largura.
- Upload: texto de limite ("JPEG or PNG max 2 MB", 12 Medium, cinza) e "Choose Photo" com ícone a 8.

### Valores concretos (action sheet do dashboard de delivery)

| Item | Valor |
|---|---|
| Campo | altura 40, borda 1, raio 2 (o raio 8 citado para "cards/campos" no dashboard é de outra tela; o autor não reconcilia os dois valores) |
| Label → campo | 4 (8 aceitável) |
| Laterais do form / entre grupos | 32 / 32 |
| Campos lado a lado | (320 - 24) / 2 = 148 cada, 24 entre eles (320 = largura útil citada pelo autor) |
| Checkbox do filtro do mapa | 32x32 a 24 das bordas do filtro, raio 2 ou 4 (canto externo do filtro: 16), stroke interno cinza médio ~1,5; ícone-logo 24 a 16 da esquerda; 8 entre ícone e texto |
| Checkbox do form (action sheet) | 32x32, ícone vegan centralizado |
| Botão do action sheet | largura total, altura 44, 32 de cada lado e do fundo, raio 4, ícone "+" a 8 |

Anti-padrões: tags de larguras idênticas; distância label → campo igual à distância entre campos; formulário longo com categorias misturadas e tudo obrigatório; botão de ação do form do mesmo peso/forma que os campos.

## Botões

- Neste projeto o autor escolheu botão sólido, não gradiente (acha o gradiente "demais"); texto Medium (não bold) e branco com ícone branco; reduza a lightness do HSL do fundo em ~9-10 pontos para ganhar contraste.
- Ícone + texto: ponta do ícone a ~8 do texto; agrupe e centralize no botão.
- Em desktop o botão é menor e não largo (cerca de 2 colunas); a ideia de que botão grande fica bom no desktop está errada. Posição à esquerda ou direita é gosto pessoal, porque a diferença de escaneamento F vs Z é mínima.
- Secundário com menos peso e outro tamanho (ex.: 36 de altura vs 44 do principal), para diferenciar importância.
- Ações mutuamente exclusivas (Save/Cancel) não têm o mesmo peso: em geral o de salvar fica preenchido e o outro vira botão com borda e texto escuros.
- Primário/secundário depende do contexto: Send, Receive e overflow levam a processos diferentes e não respondem à mesma pergunta, então não assuma hierarquia entre eles; exige lógica, não "parece bom o bastante".
- Rótulos que dizem o que fazem: evite X, "Edit", "Next", "OK" soltos (X fecha ou remove? Edit edita o quê? Next vai para onde?). "Remove" é melhor que lixeira, em vermelho por ser destrutivo.
- Botões independentes do título/subtítulo do card alinham separadamente (quadrado 32 na base do texto, 24 da borda).
- Estado hover e pressed: veja Estados e badges.

### Valores concretos (dashboard de delivery e login do autor)

| Botão | Valor |
|---|---|
| "Send daily report" | altura 38, raio 8, 24 das bordas, ~11 em cima/embaixo (ajuste de 0,5 só em portfólio) |
| "Add driver/vehicle" | altura 40, padding lateral 12 |
| Principal do action sheet | altura 44, raio 4, largura total (32 de cada lado) |
| Principal do login | altura 44, raio 4, 2 colunas de largura |
| Secundário "Request access" | altura 36, padding 24, a 32 do topo/direita |
| Quadrados de contato | 30x30, ícone centralizado, 8 entre botões |
| Touch target documentado | 40x40 ou 44x44 (item de menu: 44) |

Anti-padrões: botão enorme em desktop por hábito; gradiente no botão (decisão do autor neste projeto); Save e Cancel idênticos; "OK/Next/Edit" sem objeto.

## Estados e badges

- Mostre os estados de cada componente no style guide/case: o exemplo do autor usa botão com cor de acento, hover na cor do CTA primário e pressed em preto; indique o espaço mínimo do componente (caixa vermelha numerada em pontos do grid).
- Selected: menu (bloco escuro), tab (linha de 4 pt), linha de tabela (sombra mínima), ícone preenchido na tab bar. Escolha um por contexto e seja consistente.
- Estado inativo/fechado também por rótulo, não só por cor, porque a cor sozinha não é acessível para todos. Badge "Closed" 12 bold, fundo branco, 8 dos cantos, raio 2 (arredondar muito cria diferença de diagonal), opacidade pode baixar.
- Badge de condição (não é botão, não deve ficar "in your face"): fundo = cor do item clareada, texto = tom mais escuro da mesma cor, Medium. O badge fica a 22 das divisórias, em cima e embaixo (não é a altura dele), com padding lateral 12.
- Restaurante fechado no mapa: logo do pino em cinza bem claro (gradiente → cor sólida). Motorista em pausa: ícone cinza.
- Campo preenchido com sucesso: stroke verde. Ação destrutiva: vermelho.
- Contadores devem refletir a ação (carrinho "1 item" antes e depois de adicionar é erro).
- Lacuna: o material não detalha disabled, erro de campo, estado vazio nem loading; não invente valores para eles. A cor de erro é conflitante: laranja (paleta) ou vermelho (legenda do fluxo), a confirmar.

Anti-padrões: depender só de cor para indicar fechado; badge de cor forte demais; contador parado.

## Mapas, filtros e progress bars

- Mapa no dashboard/lista: plugin FigMap (grátis; o autor evita MapMaker por usar Google). Estilo dark combina com estética preto e branco; para texto branco legível ("Expand map"), gradiente horizontal #2E2E2E (a confirmar) opaco → mesma cor transparente cobrindo a metade esquerda. Satellite não ajuda.
- Mapa claro/colorido: pinos somem, então use drop shadow padrão do Figma (y 4, blur 4, 25%) mesmo em design flat, e texto bold nos pinos. Gradiente preto → transparente de 32 de largura na borda esquerda como sombra, abaixo do filtro.
- Pino com poucos locais (4-5) pode ser grande de propósito, com o logo centralizado. Marcador de posição: círculo verde escuro com stroke branco interno de 4, halo com círculo maior, stroke branco e radial gradient invertido de baixa opacidade. Indicadores de status (ponto verde/cinza) ficam por cima, fora da máscara.
- Rota: segue as ruas, cantos com raio 4 (mais orgânico), ruas podem ser mão única; trecho futuro tracejado (traço curto, gap longo) e o restante ao fundo do mapa; pin do restaurante no topo. Linhas com gradiente funcionam melhor em mapa escuro; cor sólida também serve.
- Filtro sobre o mapa: barra branca de 64 de altura, 24 das bordas, raio 16 (com 32 viraria pílula e a diagonal difere das laterais; ajuste o raio a olho). Ex.: checkbox "Show open restaurants only". Mostre before/after no case study.
- Restaurants: lista de cards à esquerda (foto 3 colunas + info 3 colunas) + mapa à direita com a largura de 4 colunas (a mesma do action sheet), 32 de margem (da seleção) e cantos direitos 32 casando com o fundo. Essa tela tem grid próprio por não ter elementos diferentes acima/abaixo. Começa em grid view com opção de list/map view quando há muitos locais.
- Filtros por categoria (abas com ícone) numa barra de 64 de altura, 32 acima e abaixo.
- Progress bar: gradiente do projeto, invertido para o tom escuro ficar junto ao fundo cinza e sempre visível; altura 3, raio 12, 32 de cada lado, preenchida ~2/3 a 3/4. Horários nas pontas em fonte 10 ("menor possível que funcione"); endereços alinhados a 32 do lado e 8 do topo (referência do 8 não especificada).

### Valores concretos (dashboard de delivery do autor)

| Item | Valor |
|---|---|
| Mapa Restaurants | FigMap, New York, ~800x1200 @2x, dark primeiro, depois streets/light |
| Pinos | 48x48 |
| Filtro | altura 64, 24 das bordas, raio 16; logo 24 |
| Progress bar | 3 de altura, raio 12 |
| Driver details | avatar 44, nome bold 16 a 32 da esquerda; veículo 36; badge de condição a 22 das divisórias (em cima/embaixo), a 32 da esquerda |

## Tela de login (split screen)

- Estrutura: foto/visual em 6 colunas (cantos esquerdos 32) + formulário em 6. O form é estreito: campos em 4 colunas (6 é largo demais); título, subtítulo e campos têm larguras parecidas (4 colunas); o botão tem 2 colunas.
- Só centralizar o form fica "um pouco chato": preencha o outro lado com foto + gradiente + logo + testimonial rotativo, que dá contexto (livraria: comentários da loja; cripto: comentários de moedas).
- Muito espaço em branco ao redor do form (195 em cima/embaixo) é normal e natural, porque há elemento visual do outro lado.
- "Forgot password" pode ser pequeno e em cor clara no desktop, porque o cursor é mais preciso que o dedo. Subtexto redundante ("Please enter your details…") melhora a composição. Texto alinhado à direita ("Don't have an account") não precisa seguir o grid: traduzido, só estica para o lado oposto.
- Lado da foto: foto P&B simples dispensa recorte. Gradiente linear preto, opaco embaixo e transparente em cima (embaixo não 100% preto; topo um pouco mais opaco para logo/texto lerem). Drop shadow só no logo sobre a foto; nunca no texto ou na foto.
- Testimonial: avatar circular com o rosto no meio, texto curto com quebra de linha pensada (portfólio), pode ter emoji/coração, porque pessoas reais escrevem assim.
- Variação "login filled": campo com sucesso em stroke verde (e-mail a 12 da esquerda).

### Valores concretos (tela de login do autor)

| Item | Valor |
|---|---|
| Título | 28, cobrindo 4 colunas; 24 até o subtítulo; 48 até o 1º campo |
| Campos / botão | 40 entre campos; 40 até o botão; botão 2 colunas, 44 de altura, raio 4 |
| "Request access" | altura 36, padding 24, a 32 do topo e da direita |
| Logo sobre a foto | círculo branco 40, fonte 24 |
| Testimonial | fonte 24; autor 16 com avatar 36; linha branca 24x2; grupo a 24 da linha |
| Dots do carousel | 8x8, 8 entre eles, 64 do fundo |

Anti-padrões: campos de login de 6 colunas; shadow em texto/foto; form isolado no centro sem nada ao lado.

## Onboarding e UX de fluxo

- Pergunte a cada elemento: para que serve, é redundante, precisa existir, de onde volto, o botão diz o que faz, os números fecham? Cada elemento precisa de função, porque o negócio quer um app funcional que gere dinheiro, não prêmio de mais bonito.
- Não encha espaço com decoração (carrossel de tênis em app de corrida, onde o usuário escolhe o tênis no armário; tênis em ângulo com sombra é clichê mobile).
- Cartão de crédito na dashboard só porque aparece em Dribbble é erro: cartões têm seção própria e cartão não é conta. Prefira lista de contas com variação de saldo da última semana (menos bonito, mais útil).
- Números do fluxo precisam somar (preço dobrado, pontos que não batem); se aceita pagar com pontos, mostre o saldo (pill no topo ou na opção de pagamento).
- Todo fluxo tem saída e continuidade: confirmação com preço, número de pedido útil, "..." com função, como fechar e voltar, e como adicionar outro item depois de personalizar.
- Mostre v1 ruim ao lado da v2, ambas anotadas: identificar erros no próprio trabalho é um superpoder. O autor admite que a v2 também não é perfeita, só mais simples.
- Teste de usabilidade (exemplo hipotético do autor): se 2 de 3 usuários não achassem o detalhe do produto porque o único botão parece "add to bag", troque por "more info", com botão e imagem fazendo a mesma ação, para não ter duas ações num card pequeno.

Exemplos do autor: app de bowls v1 (X ambíguo, "Edit" sem objeto, favoritos sem botão de adicionar, preço dobrado, saldo ausente, confirmação sem preço) vs v2 (add direto da home, "Remove" vermelho, "Add more", voltar à home antes da confirmação, saldo ao escolher pontos).

Anti-padrões: X/Edit/Next/OK vagos; confirmação sem preço; elemento sem função.

## Mobile e component library por breakpoint

- Desenhe o desktop complexo primeiro, mesmo com 95% de tráfego mobile, e depois uma experiência mobile dedicada, porque projetar o grande e complexo primeiro mostra o que as pessoas usam e como adaptar. O mobile é sempre o último a ser projetado, mas deve sair melhor.
- Não encolha o desktop: o responsivo clássico (A à esquerda, B à direita → um embaixo do outro) vira página gigante. Mobile pede mentalidade própria: touch targets maiores, gráficos maiores e mais visíveis, evitar rolagem infinita.
- Component library por breakpoint, não universal: componentes responsivos e atualizáveis, ligados a views e depois a screens. Só cores e fontes (não tamanhos) vêm de uma fonte única; cada breakpoint combina de forma coesa. Universal demais gera interface chata que sacrifica as duas pontas.
- Mobile card (exemplo do app bancário mobile do autor): margem externa 20 e padding interno 16, porque o interior é um grupo. Elementos mais visuais (cartão) podem usar 24; espaço entre grupos maior (24 ou 32) para não fundir cards e lista. 20 = 2,5 x 8: mantenha por consistência ou migre ao grid de 8 pt.
- No mesmo app bancário: fundo da página ~4 pontos mais escuro (lightness ~95) com cards mais claros.
- Margem esquerda e direita exatamente iguais; linhas de texto a 4 entre si; sem decimais (4, não 4,4).
- Touch target 40x40 ou 44x44; mostre no case a caixa de toque de um ícone 16x16.

Anti-padrões: encolher o desktop em layout empilhado; library universal para todas as resoluções; esconder margens desiguais com mockup 3D angulado; um efeito (neomorphism, glassmorphism) aplicado em tudo; UI kit conhecido usado em tudo.

## Ordem de trabalho sugerida pelo autor

Sequência do projeto prático (admin de delivery):

1. Texto: tema, produtos, estrutura de abas (Dashboard, Orders, Restaurants, Drivers, Settings), conteúdo de cada aba.
2. Canvas 1500x1000, grid de 12 colunas, retângulo de produto 1120x750, quadrados vermelhos 8/16/24/32/40/48/64 fora do canvas (método do quadrado vermelho (red square)).
3. Preparo de imagens: avatares consistentes, recorte, círculo-guia, saturação/exposição igualadas, recolor não destrutivo com overlays.
4. Navegação: logo, itens, selected state, badge, perfil, botão, search.
5. Dashboard: tabela de pedidos → stat cards → vendas/gráfico → card de oferta → motoristas → mapa.
6. Orders (duplicar o dashboard, expandir a tabela), Restaurants (lista + mapa + filtro), Products (soft grid + action sheet), Drivers (tabela do zero + details), Login, menu colapsado.
7. Revisão crítica final (lógica dos dados) e variações (mapa colorido, login preenchido).

Ao corrigir UI existente: um problema por vez, começando por margens esquerda/direita; pense em preto/branco/cinza antes da cor; feche com revisão final reselecionando tudo (meio pixel desalinhado, linhas divisórias até a borda, 1px sobrando: suba o conteúdo em vez de deixar vazio).

## Lacunas do material

O material não cobre os itens abaixo. Diga isso em vez de inventar:

- Tokens de cor definitivos (hex de cinza incertos; preto #2E2E2E ou #2C2C2C).
- Família tipográfica (só tamanhos e pesos aparecem).
- Altura de cards e do gráfico de vendas.
- Estados disabled, erro de campo, vazio e loading; cor de erro conflitante (laranja ou vermelho).
- Tela Settings (citada nas abas, nunca desenhada).
- Set de ícones usado.

## Checklist de revisão

- Os textos da coluna estão à esquerda e os números à direita, com as mesmas distâncias em todas as linhas?
- A tabela tem dados variados (nomes, IDs, valores, ETAs) e sem ETA em item já concluído?
- O padding interno do card é 24 ou 16 e menor que a distância entre grupos?
- A distância label → campo é menor que a distância entre campos, e o botão principal é mais alto que os campos?
- Save/Cancel e outras ações exclusivas têm pesos diferentes, com rótulos que dizem o que fazem?
- O selected state existe, é único por contexto e o touch target é de 40-44?
- Estados fechado/inativo usam rótulo além da cor?
- O dashboard equilibra claros e escuros em vez de ser todo branco?
- Gráfico e números do card concordam, e a baseline é a linha mais visível?
- Raiz sem seta de voltar, tela funda sem menu, sem perfil duplicado?
- O fluxo tem saída, continuidade e números que somam?
- O mobile foi pensado à parte (touch targets e gráficos maiores) em vez de empilhar o desktop?
