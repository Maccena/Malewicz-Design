# Tipografia, cor, ícones e imagens

Consulte ao escolher fontes, tamanhos e pesos, paleta e cores de estado, contraste (AA), estilo de ícones, tratamento de fotos, avatares, ilustrações e mockups, ou sombras, bordas, raio e gradientes. Medidas em pt/px do Figma.

## Contents

- Tipografia
- Cor
- Contraste e acessibilidade
- Ícones
- Imagens, avatares, ilustrações e mockups
- Sombras
- Bordas, divisores e raio de borda
- Gradientes
- Checklist de revisão

## Tipografia

- Use uma única família sans serif simples (títulos podem usar outra família, como no style guide de exemplo abaixo). As "seguras" e gratuitas citadas: Inter, Plus Jakarta Sans, Satoshi (Black no logo), porque fontes "funky" deixam o design de iniciante estranho.
- Em texto de leitura use sempre sans serif simples e mínima; só títulos podem ser mais "fancy" (regra dada para portfólio). Fonte decorativa conta como decoração.
- Limite a escala: 3 tamanhos e 1-2 pesos por tela (ex.: 12 regular + 12 medium em vez de regular, semibold e itálico). Evite itálico + vários pesos + várias famílias.
- Normalize tamanhos quase iguais (17 para 16, 15 para 14, 14 para 12) e zere tracking extra (ex.: 2,5), salvo quando quiser destaque.
- Resolva espaçamento, cores e contraste antes de mexer na fonte, porque com isso certo até uma fonte ruim passa.
- Crie hierarquia visual por peso e cor, não só por tamanho: o dado que importa em bold (valor do pedido, nomes), o secundário em cinza mais claro, o preço menos proeminente que o nome do produto.
- Destaque um nome subindo o tamanho em 2 (motorista 12 para 14) e deixe label e nome na mesma margem esquerda.
- Texto de botão: no botão do exemplo ficou em Medium, não bold (decisão de um botão, não regra geral). Item de menu em 14 Medium/Bold "sem ficar pesado". Badge 2 pt menor que o menu.
- Label de formulário em bold 14 (máxima visibilidade); texto auxiliar em medium 12 e cor clara. Texto de "Forgot password" pode ser pequeno e claro no desktop, porque o cursor é mais preciso que o dedo.
- Logo: tipografia o mais simples possível, letras grossas e forma super simples; ícone do logo com cerca do dobro da altura da maiúscula.
- Se uma página com pouco gráfico parece "chata" ou "minimal", conserte fontes, hierarquia e mensagem, não adicione imagem.
- Texto curto vende melhor: headline ou citação curta em extra bold 24. Quebre linhas de forma equilibrada em callouts; em subtítulo de 2 linhas, a segunda mais curta que a primeira.
- Bloco largo com poucas palavras por linha fica cômico: use bloco estreito e fonte menor. Linha com palavras demais fica ilegível (regra dada para portfólio).
- Fonte paga pode compensar: a Helvetica "noisiest" (variante a confirmar) custa cerca de US$300/ano e, segundo o autor, transforma o site da Square Block.
- Sem valor normativo de line-height nem de medida de linha em caracteres. A única entrelinha citada é 4 pt entre duas linhas de texto empilhadas num card mobile (um gap, não um line-height); num exercício de bloco de texto o autor menciona ~8 px de line-height.

### Valores concretos

Os valores abaixo vêm de exemplos específicos (coluna Contexto); não são regras gerais.

| Elemento | Tamanho / peso | Contexto |
|---|---|---|
| Logo | Satoshi Black ~16 | exemplo: app de delivery (dashboard Avo) |
| Item de menu | 14 Medium | exemplo: app de delivery (dashboard) |
| Labels e dados de tabela | 12 Medium | exemplo: app de delivery (dashboard) |
| Nome de motorista | 14 (era 12) | exemplo: app de delivery (card de motoristas) |
| Nome no card de restaurante | 16 Black | exemplo: app de delivery (tela Restaurants) |
| Horários secundários | 10, "menor fonte que funciona" | exemplo: app de delivery (driver details) |
| Título de login | 28 | exemplo: login |
| Testimonial / logo no login | 24 | exemplo: login |
| Autor do testimonial | 16 | exemplo: login |
| App bancário corrigido | Inter 24 / 16 / 12 (16 para conteúdo menos importante) | exercício |
| Spec de exemplo de projeto só de UI (não o app bancário) | 24 / 14 / 12 | anotação |
| Título de case study | 32 extra bold | portfólio |
| Subtítulo | 16 regular | portfólio |
| Título de seção | ~20 bold/extra bold | portfólio |
| Tags de categoria | semi bold, fonte menor | portfólio |
| Style guide de exemplo | Plus Jakarta Sans (corpo regular, texto 14 semi bold, ações bold) + Poppins bold (headings, 20 = maior estilo); duas famílias neste exemplo, com a segunda só nos títulos | portfólio |

### Exemplos do autor

- App bancário (exercício): partia de itálico, vários pesos e várias fontes; ficou com Inter, 3 tamanhos e 1-2 pesos antes de mexer em cor. A correção do exercício normalizou 17 para 16, 15 para 14 e 14 para 12 e chegou a 3 tamanhos, 24/16/12. A spec de exemplo de projeto só de UI e o style guide do portfólio listam outra escala, 24/14/12 (12/14/24): são duas escalas distintas, não um erro. Para case studies, recomende 24/14/12 (sugestão da skill).
- Dashboard Avo Burger: Satoshi só no logo; resto em escala curta 10/12/14/16 com peso variando por importância.

### Anti-padrões

- Várias famílias (o exemplo ruim tinha 7), itálico, muitos pesos.
- Fonte decorativa em texto de leitura.

## Cor

- Use um único acento (no exemplo, vermelho para notificação e seleção) para provar que a melhora veio de fonte e espaçamento.
- Reserve a cor de destaque para notificações e itens importantes; o selected state do menu fica em cor escura. Não exagere no verde.
- Poucas cores: evite muitas cores que brigam (cartão rosa), vários cinzas e dois vermelhos nos textos. Para apresentar paleta, 2-3 cores já bastam; o exemplo de 5 papéis foi accent, primary, secondary, tertiary e background.
- Texto principal em quase preto (#2E2E2E; a confirmar); logo em preto total. Secundários em cinzas progressivos (#6E, #8E, #AE; a confirmar).
- Labels de tabela mais claros que os dados: some +40 a +50 de lightness (acima disso some). Restaurante em #8E (a confirmar) e valor em bold na mesma tabela.
- Chips de ícone em cards de estatística: cores claras ("visível, mas não muito visível") para não roubar foco da tabela. Suba o lightness e, se ainda forte, reduza a saturation; um chip quase cinza é a versão dessaturada das cores da marca.
- Botão: cor sólida, texto e ícone brancos; reduza ~9-10 pontos de lightness (HSL) para melhorar o contraste. Botão principal de formulário em #2E (a confirmar) com texto branco.
- Estados de botão no exemplo do case: hover na cor do CTA primário, pressed em preto.
- Cor de tendência (verde melhor, vermelho pior) só no ícone ou linha, não no número. Para declínio, arraste o hue para vermelho e espelhe a linha.
- Status com bolinha de 5-6 pt sem stroke: delivered verde, in delivery outro tom de verde, pending laranja, ordered cinza.
- Sucesso em campo preenchido: stroke verde. Ação destrutiva: texto "Remove" em vermelho.
- Seleção em tab/nav, duas opções: fundo claro full-width sem cantos + linha de 4 pt, ou ícone e texto coloridos com lightness -20. Se já há cor ao lado, o indicador fica neutro (linha de 4 pt em #2E, a confirmar).
- Badge de condição: fundo na cor clareada e texto num tom mais escuro da mesma cor, em medium, porque não é botão e não deve ficar "in your face".
- Tags de categoria: fundo colorido com texto branco semi bold. Preços em verde são opcionais ("vão longe demais"); o autor prefere escuros.
- Cor forte no meio de bloco de texto quebra a concentração; use cor mais clara para o essencial.
- Mapa: comece em estilo dark (estética preto e branco); versão colorida exige sombra nos pinos (ver Sombras).
- Cor para separar caminhos de usuário: verde para iniciantes (mais orientação) e roxo para experts (atalhos), no redesign da plataforma de fundos.
- Em brand refresh com identidade reconhecida, modernize sem jogar fora: cores mais vibrantes, mas mantenha formas, gradientes e arredondamento que definem a marca.
- Ao escolher projetos para destacar numa página de marca (verde, preto e branco), use projetos nas cores da própria marca; um projeto azul no topo chocaria.

### Valores concretos

| Item | Valor |
|---|---|
| Texto escuro / ícones | #2E2E2E (a confirmar) |
| Cinzas secundários | #6E, #8E, #AE (a confirmar); no portfólio: texto #2C2C2C, rótulos #999 |
| Label vs dado em tabela | label +40 a +50 de lightness |
| Linhas do gráfico | baseline mais visível; demais +5 de lightness |
| Botão | lightness -9 a -10 (HSL) |
| Indicador de aba | linha 4 pt; texto/ícone lightness -20 (alternativa) |
| Dot de status | 5-6 pt |
| Dot de notificação | 8 pt com stroke branco |

### Exemplos do autor

- Avo Burger: acento verde só em notificação e itens importantes; menu selecionado em escuro; cards de oferta e mapa escuros contra tabela clara.
- App bancário: cores que brigam (cartão rosa) foram corrigidas indo a P&B + acento vermelho.

### Anti-padrões

- Excesso de cores e cinzas.
- Colorir o número da tendência e o indicador de aba quando já há cor ao lado.

## Contraste e acessibilidade

- Tudo que é funcional precisa passar WCAG AA; só decoração não essencial pode falhar (ex.: a cor de uma tag cujo texto continua legível no branco). Contraste alto o bastante para todos entenderem o que fazer; um modo global de alto contraste não é essencial.
- Para texto pequeno, corrija contraste escurecendo o fundo do elemento, não só aumentando o texto, porque é mais seguro.
- Use os padrões WCAG vigentes: nomes e medições mudam.
- Não dependa só de cor para estado: o restaurante fechado ganha badge "Closed" (12 bold, fundo branco), porque a cor não é acessível para todos.
- Texto sobre foto precisa de gradiente escuro por baixo (ver Gradientes).
- Admita e conserte um erro de contraste do próprio trabalho: ser crítico com o próprio design é habilidade procurada. Mostre antes e depois, com o "depois" maior.

### Valores concretos

| Caso | Resultado |
|---|---|
| Texto verde sobre botão amarelo/laranja | falha AA para texto pequeno |
| Fix: fundo verde quase preto + texto/ícone branco | passa AA para texto pequeno e grande |
| Razões do exemplo de contraste do card | 4.91, 6.78, 6.69, 13.9. O autor chama 4.91 de "não ótimo, mas bom" e 13.9 de "o mais alto", sem dizer a qual par de elementos se aplica: não reutilize como limiares. Valor 4.91 a confirmar |

### Exemplos do autor

- Botão CTA verde/amarelo de um app orgânico: errado por contraste; o autor o refez como verde quase preto + branco e diz que ter fugido do padrão foi a escolha errada.

### Anti-padrões

- Corrigir contraste só aumentando a fonte.
- Indicar fechado/inativo só por cor.

## Ícones

- Use ícones de um único set; não misture preenchido colorido, outline fino, outline grosso e sólido branco.
- Mesma espessura de traço em todo o set. Única exceção: o ícone selecionado pode ser preenchido (home cheia, resto outline), reforçado por underline arredondado na cor de acento.
- Espessura do ícone parecida com a do traço do texto vizinho (não precisa ser idêntica), porque cria coesão extra. Seta ao lado de texto: mesma espessura da fonte, no meio da altura da minúscula, a 8 do texto.
- Outline sem sombra, stroke 1,5 (testado 1,2; uma seta com 3 foi para 1,5). Ícone preenchido grande demais encolhe (casa a ~70%).
- Ícone de busca: círculo de diâmetro ímpar se a linha tem 1 pt, par se tem 2 pt (usado 14 com stroke 2), girado 45 graus.
- Em botões e menus o ícone fica a 8 do texto, igual em todos os itens, centrado verticalmente ao texto; checagem de centro óptico com o método do quadrado vermelho (red square). Perto do centro já basta quando par/ímpar impede o centro exato.
- Ícones de decoração, como o de veículo (24), usam o mesmo tamanho para carro e scooter.
- Bom/ruim: check verde e X vermelho, centrados ao texto.
- Prefira rótulo a ícone ambíguo: "Remove" em vermelho vence lixeira; X, "Edit", "Next" e "OK" soltos não dizem o que fazem.
- Cor: ícones em #2E (a confirmar); se um ficou com cor errada, volte e corrija. Em botão escuro, ícone e texto brancos.

### Valores concretos

| Item | Valor |
|---|---|
| Ícone de menu | 16x16 em #2E (a confirmar) |
| Chip de ícone em card de estatística | quadrado arredondado 38x38 |
| Ícone de veículo (decoração) | 24; scooter no card de motorista 32 (testado 40) |
| Pino de mapa | 48x48 |
| Stroke de ícone | 1,5 (app mobile); 2 no ícone de busca de 14 |
| Distância ícone-texto | 8 (número-label do chip: 4) |
| Logo: ícone vs maiúscula | ~2x a altura da maiúscula, 8 do texto |

### Exemplos do autor

- App bancário: ícones de packs misturados, traços de 3 e 1,2 e uma casa gigante; unificados em outline 1,5, selecionado preenchido.
- Portfólio ruim: ícones de vários packs (preenchido colorido, outline fino, outline colorido, outline grosso, sólido branco) citados como red flag.

### Anti-padrões

- Misturar sets, espessuras ou estilos de preenchimento.
- Espessura muito diferente da do texto.
- Ícone com sombra.

## Imagens, avatares, ilustrações e mockups

- Fotos de pessoas e avatares: máxima consistência de estilo, paleta e tamanho do rosto. Fotos aleatórias de hues diferentes bagunçam o design; fotos bem tratadas diferenciam seu trabalho.
- Escolha pessoa olhando para a câmera (cabeça levemente inclinada ok), roupa lisa e foto majoritariamente em P&B. Evite estampas (viram pixels coloridos ao encolher), cores vibrantes que roubam atenção e olhar de lado.
- Remova o fundo, exceto quando já for branco simples. O recorte pode ser meio blocky se a imagem será reduzida. Foto P&B de fundo simples dispensa recorte.
- Avatar circular: rosto no centro e foto preenchendo o círculo; um círculo-guia de ~2/3 da área deve conter a maior parte de rosto e testa em todos. Foto sem fundo leva círculo cinza atrás.
- Iguale saturação e exposição usando a foto menos saturada como referência (reduza a mais saturada; suba a exposição da mais escura sem estourar). O autor diz que esse detalhe põe você acima da maioria dos designers.
- Recolor não destrutivo: shapes com blend mode (multiply, screen, overlay ou normal) e opacidade reduzida sobre a área a trocar; fica fácil ajustar à paleta final.
- Fotos de uma marca com estilo coerente (saturação, exposição, tom). Uma foto de parede de tijolos com grafite quebraria uma marca moderna e minimalista.
- Trate imagens de produto: recorte, crie sombra e descreva só o que aparece na foto. Sem tratar, o design fica pior; em produto real raramente será tão perfeito, mas no portfólio o objetivo é parecer perfeito.
- Se não há boas fotos gratuitas, mude o conceito (o autor trocou sanduíche por hambúrguer) em vez de usar fotos feias.
- Pessoas em tabelas: fotos e nomes diferentes; pedidos podem repetir.
- Ilustração 3D/2D, foto com fade ou imagem relevante ao material quebram o visual do dashboard; mascare dentro do card (só em Dribbble shots pode vazar; foto de produto pode vazar no máximo 16) e espelhe uma cópia menor para evitar repetição.
- Mapa: use o plugin FigMap (gratuito; o MapMaker usa Google); ~800x1200 @2x; satélite não ajuda.
- Mockup: não esconda design fraco em mockup 3D ou angulado, porque o ângulo faz margens desiguais parecerem iguais e embeleza artificialmente um design medíocre. Use 1-2 mockups (header do case) e o resto das telas planas, em grid ou ligadas por flow lines.
- Decoração que define o app (PNGs de folhas, maçãs, cenouras, algumas desfocadas) pode dar vida e simpatia, desde que consistente.
- Texto de foto de testimonial/login: ver Gradientes e Sombras (drop shadow só no logo).

### Valores concretos

Exemplos do app de delivery (Avo), salvo indicação na linha.

| Item | Valor |
|---|---|
| Foto de avatar / círculo | foto ~160, círculo 148x148 |
| Avatar na tabela / lista | 36; no menu 36 (testou 32 antes); em driver details 44 |
| Foto de produto (burger) | 100-110, pode sair do card no máximo 16 |
| Pino do mapa | 48x48 |
| Célula do card de restaurante | ~160 de altura (a célula/card, não a foto); foto com raio 8 |

### Exemplos do autor

- Avo Club/Avo Burger: avatares recortados, igualados em saturação e círculo de 148; sanduíche virou hambúrguer por falta de fotos gratuitas boas.
- App bancário: mockup angulado citado como disfarce de margens erradas.

### Anti-padrões

- Avatares com estampa, cor vibrante, olhar de lado, fundos e saturações diferentes.
- Foto de produto sem tratar; descrever ingrediente que não aparece.
- Ilustração vazando do card num dashboard.
- Mockup angulado para esconder inconsistência.

## Sombras

- Mesmo em design flat, use sombra mínima onde ela cumpre função: linha selecionada (blur 12, ~10% de opacidade), pinos em mapa claro e colorido (drop shadow padrão do Figma: y 4, blur 4, 25%), porque sem ela os pinos desaparecem.
- Para telas e cards em apresentação (e tooltips): blur = 2x Y e opacidade ~15%. A relação vale só nesses casos; pinos (y 4 / blur 4 / 25%), linha selecionada (blur 12 / ~10%) e círculo de logo (blur 12 / 12%) têm valores próprios. A versão "depois" de um antes/depois leva sombra maior.
- Drop shadow só no logo sobre a foto (contexto: tela de login); nunca em texto nem na foto.
- Sombra de produto recortado: elipse com layer blur e escurecida. Sombra colorida de decoração: duplique o objeto, aplique blur e desloque sob ele.
- Sombra de contenção: gradiente preto para transparente na borda do mapa (32 de largura) sob o filtro serve de sombra.
- Fundo branco arredondado com drop shadow sutil é opção para caixas de dados em Persona.

### Valores concretos

| Uso | Valor |
|---|---|
| Tela pequena (apresentação) | y 4, blur 8, 15% |
| Screenshot / tooltip (apresentação) | y 6, blur 12, 15% |
| Tela grande (apresentação) | y 8, blur 16, ~15% |
| Linha selecionada | blur 12, ~10% |
| Pinos no mapa claro | y 4, blur 4, 25% |
| Sombra de produto | elipse, layer blur ~9, escurecida |
| Círculo de logo no card | 12% de opacidade, blur 12 |

### Anti-padrões

- Sombra em texto ou em foto.
- Pinos sem sombra em mapa colorido.

## Bordas, divisores e raio de borda

- Elemento menor leva raio menor: container principal e menu 32, cards 8, selected state do menu 8 (cantos menores que o container). Campos de formulário 2 e botão 4 (valores de contextos diferentes do app de delivery; confirme o contexto antes de aplicar).
- Retângulo largo não vira pílula: filtro de 64 de altura com raio 32 faria a diagonal diferir das laterais; use 16 e ajuste a olho para ficar uniforme. Pelo mesmo motivo o badge "Closed" tem raio 2.
- Iguale raios no mesmo conjunto (no app bancário um canto em 14 foi para 24). Em case study use um raio único (12 nas caixas) e reduza o raio ao reduzir telas.
- Cantos: squircle (square circle) é o meio-termo entre canto vivo e círculo: tem cantos suaves, não ameaçadores, porque o instinto primal associa canto vivo a perigo. Cantos totalmente vivos são processados mais rápido e associados a algo de luxo/profissional, mas são pouco amigáveis. Escolha pelo tom do produto; os raios das tabelas abaixo são do dashboard de exemplo.
- Pontas de linha arredondadas (round cap) parecem mais amigáveis; linha de gráfico grossa, nunca 1 pt.
- Campo de formulário voltado ao consumidor: maior e com borda mais grossa. Produto profissional com formulário longo: ~30 de altura e borda mais fina, para caber mais.
- Stroke interno em card vazio ("Add New Product"): cinza escuro o bastante para ser visível sobre fundo igual ao do app (#AE, a confirmar). Checkbox: stroke cinza médio, nem muito escuro nem claro, visível ao dar zoom out.
- Divisor de perfil: linha quase invisível, na cor do fundo da página, terminações retas. Divisores e zebra striping em tabela são opcionais; com bom espaço em branco o autor dispensa. Se usar divisor, a distância da cap height até a linha de cima e de baixo deve ser igual em toda linha.
- Rota futura em mapa: tracejado (traço curto, gap longo); cantos da rota com raio 4; ruas podem ser mão única.
- Baseline de gráfico sempre mais visível que as linhas intermediárias; poucas linhas de grade bastam.
- Linha selecionada em tabela: fundo branco, raio 8 e sombra mínima; alternativa, stroke mais grosso com gradiente diagonal.
- Marcador de mapa: círculo verde escuro com stroke branco interno de 4 pt; bolinha de notificação com stroke branco.

### Valores concretos

Exemplos do app de delivery (dashboard Avo), salvo indicação na linha.

| Elemento | Raio / borda |
|---|---|
| Container principal e menu | 32 |
| Cards, botão do dashboard, foto de restaurante | 8 |
| Botão pequeno / login / "Add Product" | 4 |
| Barra de filtro (64 de altura) | 16 |
| Checkbox 32x32 | 2-4, stroke ~1,5 |
| Campo de formulário | altura 40, borda 1, raio 2 |
| Badge "Closed" | 2 |
| Tag de ingrediente | 1 (2 ficava estranho) |
| Progress bar | altura 3, raio 12 |
| Card de app bancário | 24 (pill de fundo 8); o raio 32 é da spec genérica de projeto só de UI |
| Caixas de case study / swatches | 12 / 8 |
| Mapa (cantos externos) | 32 |

### Anti-padrões

- Arredondar demais um retângulo largo.
- Raios diferentes para o mesmo tipo de elemento.
- Linha de 1 pt em gráfico de destaque.

## Gradientes

- Gradiente diagonal parece mais realista que o vertical (escuro embaixo à esquerda, claro embaixo à direita).
- Botão: cor sólida; o autor acha o gradiente "demais". Gradiente do projeto fica para badge de contagem, progress bar e linha de gráfico. Na progress bar, inverta o gradiente para o tom escuro ficar junto ao fundo cinza e sempre visível.
- Logo/ícone: pode ter gradiente (verde mais azulado em cima, mais amarelado embaixo). Em swatches, cor principal 100% embaixo e a mais clara no topo.
- Card promocional: linear no canto, de #2E2E2E (a confirmar) opaco para um pouco mais claro (3E/4E; a confirmar), texto branco e as partes-chave (valor mínimo, % de desconto) destacadas em outra cor.
- Texto branco sobre mapa: gradiente horizontal da cor escura opaca para a mesma cor transparente, cobrindo a metade do texto.
- Texto/logo sobre foto: gradiente linear preto, opaco embaixo e transparente em cima; embaixo não 100% preto e topo um pouco opaco para logo e texto lerem. Em Persona: uma cor se desvanecendo em transparente na base da foto, com nome grande branco.
- Linha de gráfico: gradiente linear entre os dois verdes (ou uma cor só); opcional duplicar a forma, fechar embaixo e preencher com gradiente que some em transparente, com opacidade bem baixa.
- Halo de marcador de mapa: círculo maior com stroke branco e radial gradient invertido (opaco por fora, transparente por dentro), opacidade baixa.
- Linhas de gradiente em mapa escuro são preferidas (cor sólida também serve); em mapa colorido, cuide de sombras e da cor das linhas.
- Não use gradiente, light leak, bento ou visual de IA no lugar da mensagem: a mensagem é a parte mais importante (regra dada em página de agência).

### Exemplos do autor

- Avo Burger: card de oferta com gradiente escuro #2E (a confirmar) para mais claro; mapa com máscara horizontal; login com foto P&B e gradiente preto.
- Square Block: o autor diz não precisar de header com light leak ou gradientes porque a mensagem vende.

### Anti-padrões

- Gradiente em botão por padrão (opinião do autor).
- Texto direto sobre foto sem gradiente.
- Gradiente de efeito para compensar mensagem fraca.

## Checklist de revisão

- A página usa uma só família sans (títulos podem ter outra), no máximo 3 tamanhos e 1-2 pesos?
- A hierarquia visual aparece por peso e cor (dado importante em bold, secundário mais claro)?
- O acento aparece só em notificação, seleção e itens importantes?
- Todo texto e elemento funcional passa WCAG AA, e nenhum estado depende só de cor?
- Os ícones vêm de um único set, com a mesma espessura (compatível com o texto), só o selecionado preenchido?
- Os avatares e fotos têm mesmo estilo, saturação, exposição e tamanho de rosto, fundo removido e sem estampas ou cores vibrantes?
- Ilustrações ficam mascaradas dentro do card e mockups angulados cobrem no máximo 1-2 telas, sem esconder margens erradas?
- As sombras são mínimas, nunca caem em texto ou foto, e a relação blur = 2x Y só é usada em telas de apresentação e tooltips?
- O raio é menor nos elementos menores, igual nos pares, e nenhum retângulo largo virou pílula?
- Texto sobre foto ou mapa tem gradiente escuro por baixo, e o botão é sólido?
