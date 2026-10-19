# Auditoria e anti-padrões

Consulte ao revisar, criticar ou "detectar design ruim" em um design, tela, site ou código recebido; ao avaliar se uma tendência de UI vale a pena; ou ao evitar AI slop num design novo.

## Contents

- Mentalidade de auditoria
- Método de auditoria passo a passo
- Red flags por área
  - Sistema visual (tipografia, cor, ícones, espaçamento)
  - Alinhamento, margens e camadas
  - Hero, key visual e copy
  - Rostos, fotos e ilustrações
  - UX, lógica e fluxos
  - Mockups e apresentação
- Tendências: veredito do autor
- AI slop
- Formato do relatório de auditoria
- Checklist rápido

## Mentalidade de auditoria

- Audite, não gere por impulso: design ruim costuma falhar num teste bem feito. Para cada elemento pergunte "como posso testar isto?" antes de opinar.
- Mantenha o "bullshit detector" ligado, inclusive para o próprio autor e para qualquer "senior": senioridade não garante acerto nem contexto correto. Desconfie de jargão excessivo. Designers reais usam a linguagem mais simples possível.
- Trate IA como gerador de volume, não de bom gosto: o gosto vem de auditar o resultado. "Bom o suficiente" gerado rápido aumenta a carga cognitiva e deixa o usuário insatisfeito mesmo sem ele saber apontar o motivo.
- Ache os erros do próprio trabalho: identificá-los é um "superpoder". Mostre versão ruim e versão corrigida lado a lado, ambas anotadas. Nenhuma v2 é perfeita; basta ser mais simples e lógica.
- Cada elemento precisa ter função. O negócio quer um produto funcional que gere dinheiro, não um prêmio de "mais bonito". Pergunte de cada item: para que serve, é redundante, precisa existir?
- Justifique cada decisão com um porquê objetivo (por que 40 aqui e 20 ali, por que este peso de traço). É a única forma de defender o design sem cair em gosto pessoal.
- Corrija em etapas, um problema por vez: atacar tudo junto intimida e faz perder itens.
- Em UI, ao contrário de decisões de estilo, a maioria dos red flags é universal: "ou é bom ou é ruim".
- Referência por popularidade (likes) não prova que funciona. Compare com empresas do mesmo nicho e considere conversão e copy, não só estética.

## Método de auditoria passo a passo

Severidade (convenção desta skill, não do autor): **crítico** = quebra a mensagem, a conversão, a lógica do fluxo ou a leitura; **importante** = enfraquece clareza ou coerência; **polimento** = detalhe de acabamento.

1. **Delimite o contexto.** Identifique tipo (landing, app, dashboard, site), público e objetivo de negócio. Sem isso, não julgue visual nem hierarquia.
2. **Leia a mensagem sem o visual.** Avalie só kicker, headline, descrição e CTA: há problema claro, benefício concreto, prova específica, CTA de baixo atrito? Texto fraco não se conserta com imagem. Teste mental: o visitante decide em menos de 2 segundos.
3. **Posicione o key visual** em relação à copy, em dois eixos: abstrato↔literal e irrelevante↔relevante (ver tabela de tendências). Pergunte: se eu removesse a imagem, a mensagem perderia algo?
4. **Conte o sistema.** Liste quantos typefaces, tamanhos, pesos, cores de fundo, cores de texto, packs de ícones, valores de espaçamento e raios existem. Excesso é achado por si só.
5. **Meça margens e alinhamentos.** Compare margem esquerda e direita (devem ser iguais na maioria dos elementos, sobretudo em mobile); trace guias em todos os elementos para expor a inconsistência. Compare padding interno e margem externa (tendência, não regra) e espaço dentro vs entre grupos.
6. **Verifique camadas e contraste** (mais perto = mais claro; fundo de página mais escuro/cinza que os cards) e estados selecionados.
7. **Audite lógica e UX**: função de cada elemento, redundâncias, rótulos, hierarquia primário/secundário, navegação por níveis, formulários, números que fecham, saída de cada fluxo.
8. **Passe o filtro de efeitos e tendências**: um único efeito aplicado a tudo? Textura de material sem relação com o produto? UI kit genérico? Isometria, blobs, bento, gradientes no lugar da mensagem?
9. **Passe o filtro de AI slop** (seção própria).
10. **Classifique, priorize e redija.** Ordem de leitura do relatório: crítico, importante, polimento. Cada achado = o que, onde, por que, como corrigir em uma linha. Se for corrigir, uma ordem possível é a da demonstração do autor: medir → margens e padding → tipografia → espaçamento entre grupos → ícones → cores (primeiro em preto/branco/cinza) → revisão final. Ícones e cor são intercambiáveis ("tudo depende de você") e começar pela tipografia é opcional.
11. **Revisão final antes de entregar**: reselecione tudo e reconfira alinhamento, bordas, linhas divisórias até a borda, tamanhos de fonte; após muitas edições algo se move meio pixel. Sobra de 1 px: esconda ajustando a altura do contêiner (o cérebro espera algo ali), não deixe vazio.

Ao auditar código, extraia os valores reais (fontes, tamanhos, cores, margens, radius) e conte os distintos em vez de julgar só pela aparência.

## Red flags por área

### Sistema visual (tipografia, cor, ícones, espaçamento)

- **Muitos typefaces, tamanhos e pesos.** Exemplo ruim do autor: 7 typefaces, 4 fundos diferentes (laranja, verde, azul, branco), vários cinzas e dois vermelhos no texto. Referência corrigida: 1 typeface, 3 tamanhos (24/16/12; 16 para conteúdo menos importante), 1–2 pesos. Detecte contando valores únicos.
- **Ícones de packs diferentes** (preenchido colorido, outline fino, outline grosso, sólido branco misturados). Regra: um único set, mesmo stroke (exemplo: 1,5), só o item selecionado pode ser preenchido. Espessura do traço do ícone próxima da espessura do traço do texto vizinho (não precisa ser idêntica).
- **Valores de espaçamento demais.** Esperado: cerca de 4 valores de espaçamento vertical (no exemplo do autor), não 6, 7, 8. Variar a distância é hierarquia visual, mas o conjunto deve ser pequeno. Diagnóstico do exemplo: 4 espaçamentos diferentes só no lado direito e 2–3 no esquerdo. Decimais (16,4; 28,15) são red flag.
- **Raios de canto desiguais** (um a 14, outros a 24): iguale.
- **Elementos gigantes sem escala** (logo, ícone ou rótulo desproporcional ao resto).
- **Cores brigando** (ex.: cartão rosa num app que não usa rosa) e dashboard todo branco e "minimalista" (entediante e mais difícil de ler).
- **Tipografia vem depois**: com espaçamento, cor e contraste corretos, até uma fonte ruim passa (o autor fez um app moderno em Comic Sans). Não culpe a fonte antes de checar esses três.
- **Normalizar escalas**: tamanhos próximos como 17/15/14 devem colapsar em 16/14/12.

### Alinhamento, margens e camadas

- **Margem esquerda ≠ direita.** É a primeira checagem de qualquer UI.
- **Margem externa menor ou igual ao padding interno do card (tendência, não regra universal).** Tendência: externa maior (exemplo: 20 fora, 16 dentro), pois o conteúdo do card é um grupo; o autor também ajusta um card para 24 em todos os lados com margem 20 e aceita espaçamento menor em cards. Antes do conserto o exemplo tinha 10 e 25; 20 = 2,5 × 8, aceitável por consistência ou migrando para o grid de 8 pt.
- **Espaço entre grupos igual ao interno.** 20 entre cards e transações (igual à margem) os funde num grupo só; suba para 24 ou 32. Valor intermediário como 30 não serve.
- **Camadas invertidas**: fundo de página mais claro que os cards, ou card escuro sobre fundo mais escuro. O que está mais perto deve ser mais claro (fundo ~4 pontos de lightness abaixo, ~95). Exceção: elemento muito distante em valor (tab bar preta) pode ficar por cima.
- **Distância logo→borda desigual**: espaço ao redor do logo ≈ 2/3 do logo em cada lado; confira também logos entre si e linhas divisórias que não chegam à borda.
- **Auto layout usado sem entender proximidade e espaçamento**, ou padding de 32 dentro de cards (32 serve para separar grupos): detecte comparando as distâncias com a hierarquia de agrupamento.
- **Fundo branco quando há janelas brancas flutuantes por cima**: a separação some.

### Hero, key visual e copy

- **Key visual bonito sem relação com o texto.** O cérebro tenta ligar texto e imagem, não acha e fica menos satisfeito; o visitante decide em menos de 2 segundos. Teste: o visual reforça a headline?
- **Visual no hero por vaidade.** Para a maioria dos produtos título + CTA bastam; visual só se amplificar o texto. Se a versão só-texto parece "chata", o problema é fonte, hierarquia ou, sobretudo, mensagem.
- **Dashboard ou UI complexa no hero de SaaS**: para quem nunca usou, é algo a aprender e atrai o olhar para linhas e colunas irrelevantes em vez da copy.
- **Blob, isometria, personagem aleatório, bolhas animadas**: parecem trabalho, mas dificultam entender o benefício e reduzem conversão (ver tabela).
- **Claims vazios**: "gold standard", "take control" (manda o usuário resolver sozinho), adjetivo vago como "best", métricas "tiradas do ar", palavras-chave de enchimento ("seamless", "empowering", "leverage"), descrição em "word salad" de IA. Detecte: dá para trocar por um número ou benefício específico?
- **CTA vago**: "Get started", "get in touch", "get a quote". Prefira baixo atrito e rótulo que diz o que acontece ("Start for free").
- **Prova duvidosa**: números que parecem inventados (a leitura do autor sobre números redondos é incerta, a confirmar), claims 10x/100x, logos de clientes que ninguém verifica, foto de banco em depoimento. (Sobre 17.000: ver observação em AI slop; a leitura do autor é incerta, a confirmar.)
- **Seção importante dependendo de side-scroll**; cor conflitante (ex.: azul) no topo de marca verde/preto; bento boxes, visuais de IA, light leaks ou gradientes usados no lugar da mensagem (o bento grid em si não é o problema: o site da agência do autor usa um).
- **Key visual que só mostra o problema** (1ª frase do headline) sem a solução, ou que mostra o oposto do produto (isometria "tudo conectado" para app que filtra).
- **Copy escrita depois do visual**: a copy deve ser escrita e iterada antes de qualquer visual.

### Rostos, fotos e ilustrações

- **Rosto no hero captura todo o foco** (visão em túnel) e o texto é ignorado; a pergunta "ela é real?" derruba muitos sites. Detecte: foto polida/perfeita demais, de banco ou "de IA".
- **Olhar fora do texto ou para a borda**: o usuário segue o olhar e sai. Olhar frontal no centro cercado de caos ofusca CTA e título. O olhar deve apontar para a headline ou o CTA.
- **Modelo de banco popular reutilizado**: dilui a marca (a mesma pessoa aparece em carne, carro e SaaS).
- **Ilustração isométrica complexa, personagens e detalhes amontoados, ilustração muito realista**: sobrecarga cognitiva; quanto mais detalhe, mais chance de "não sou eu". Ilustração simplificada/levemente distorcida pode funcionar, mas a linha para a caricatura é tênue.
- **"Teatro de métricas"** (formas, tamanhos, gráficos e tabelas sobrepostos sem contexto).
- **Avatares inconsistentes** (estampas, cores vibrantes, pessoas olhando de lado, saturações e fundos diferentes) e fotos de estilos incoerentes na mesma marca.
- **Regra geral**: o cérebro filtra como preenchimento o que parece banco de imagem, isometria e vale da estranheza (cegueira de banner). Não é questão de bonito, é de estilo reconhecível.

### UX, lógica e fluxos

- **Elemento decorativo sem função** (ex.: carrossel de tênis num app de corrida; ícone desnecessário; ilustração vazando do card). Pergunte "por que está aqui?".
- **Acesso duplicado** (foto de perfil no topo + aba perfil; menu inferior + navegação superior), geralmente por querer encher a tab bar.
- **Navegação por níveis quebrada**: seta de voltar na tela raiz (não leva a lugar nenhum) ou menu principal numa tela interna.
- **Ações mutuamente exclusivas com o mesmo peso** (Save/Cancel): uma deve ser secundária (ex.: Save preenchido, Cancel com borda). Atenção: primário/secundário depende do contexto (Send/Receive/overflow respondem a perguntas diferentes), exige lógica, não "parece bom".
- **Formulário longo com tudo obrigatório e categorias misturadas**: divida e agrupe por categoria mental (nome, contato, endereço); preferências vão para outra aba; extras no perfil.
- **Rótulos soltos**: X, "Edit", "Next", "OK" sem objeto ou destino. "Remove" (em vermelho) é melhor que ícone de lixeira.
- **Números que não fecham** (preço dobrado, pontos incoerentes), contador que não reflete a ação (carrinho com 1 item antes e depois de adicionar), pagamento com pontos sem mostrar o saldo.
- **Fluxo sem saída ou continuidade**: confirmação sem preço, número de pedido inútil, "..." sem função, sem como voltar ou adicionar outro item.
- **Cartão de crédito na dashboard só porque aparece no Dribbble**: cartão não é conta; lista de contas com variação de saldo da semana é mais útil.
- **Dados repetidos/irreais**: linhas idênticas e nomes iguais em tabelas; ETA em pedido entregue; indicar "fechado" só por cor (acessibilidade); mudar uma instância de um padrão sem atualizar as outras; números alinhados à esquerda; badge de cor forte demais.

### Mockups e apresentação

- **Mockup 3D/angulado cobrindo design fraco**: o ângulo faz margens desiguais parecerem iguais. Use 1–2 mockups no máximo (no header do case) e o resto plano.
- **UI kit conhecido ou componentes Material/Apple para tudo**: parece genérico e as pessoas reconhecem (red flag na maioria dos casos).
- **Um único efeito aplicado a tudo** (neumorphism ou glassmorphism em cada elemento): tela difícil de olhar mesmo com bom alinhamento; red flag imediato para designer experiente.
- **Mostrar só o resultado "perfeito"** sem processo ou anotação.

## Tendências: veredito do autor

O autor diz ter cunhado "glassmorphism" e co-criado "neumorphism".

| Tendência | Veredito | Critério / quando funciona |
|---|---|---|
| Novos "morphisms" (disco, metal, light leak, "balloon" do Figma) | Rejeitar como tendência: são subconjuntos de skeuomorphism, definidos só pelo material. "Não precisamos de outro morphism." | Experimentar é válido, mas não é estilo. O balloon morphism do Figma foi tratado como piada de aparência gerada por IA. |
| Discomorphism (logo do Spotify, 20º aniversário) | Textura skeuomórfica sem generalização | Só faz sentido no contexto musical. Estático é imitação de material; poderia virar estilo se usasse a câmera do dispositivo para preencher os espelhos com o rosto do usuário. |
| Skeuomorphism | Neutro: ferramenta, não obrigação | Nem todo app ou site precisa. Texturas (metal, madeira, couro) já existiam antes; use só se conectar ao contexto do produto. |
| Glassmorphism | Defendido | A translucidez mostra o que há por baixo (profundidade e contexto), ao contrário dos outros morphisms, que são opacos. Funciona com flat e com skeuomorphism pleno. Red flag se aplicado a todo elemento; ok pontual (destacar função, botão, navegação). |
| Neumorphism | Defendido, sem exagero | Minimalista, sem texturas, "extrudado" do fundo. Acessibilidade vira "não-problema" se contraste, hierarquia e tipografia estiverem certos (a borda sutil é extra, não o elemento definidor). Em tudo: red flag; ok só no background ou em ponto específico. |
| Squircle (cantos) | Meio-termo entre canto vivo e círculo, segundo o autor | Canto vivo remete a perigo e alerta (a confirmar: "alert prone"), é processado mais rápido e associado a luxo/profissional, mas não é amigável. Círculos empilhados criam um padrão estranho de movimento do olho; tornar o círculo um pouco mais quadrado reduz o "olhar de lado" e ajuda o processamento. |
| Botões reativos / AR ("bendy buttons", luz e sombra reais) | Tendência digna de acompanhar | Usar a câmera para projetar luz e sombra reais em elementos skeuomórficos, ou o poder de processamento para botões que reagem exatamente onde o toque ocorre (tocar um lado inclina o botão para lá, o outro lado clareia, a sombra muda). "Metal morphism" refletindo a interface valeria a pena. Prototipe com IA e ajuste valores com sliders. Não generalizável. |
| Elementos desenhados à mão e imperfeitos | Tendência digna de acompanhar | Reação ao AI slop e aos sites iguais: o que parece humano, irregular e pessoal se destaca (bordas irregulares, traço mais grosso numa ponta; exemplos: portfólio bem feito, app de corrida com trilhas desenhadas). O autor já usava esboços a lápis escaneados em 1999. |
| Key visual abstrato (blob, isometria, bolhas, personagem) | Mata vendas quando irrelevante | Abstração não é inimiga: funciona se for relevante à copy (a "muralha invisível" bloqueando notificações e deixando passar 5 ficou no topo do ranking). Blob e isometria genéricos ficam no extremo irrelevante. |
| Key visual literal com resultado emocional | Volta com força na era da IA | Ex.: pessoa lendo com o celular parado na mesa e 5 notificações; mostra o benefício direto e gera conexão por aspiração. Pode não servir a todo negócio. |
| Ilustração de pessoas estilo Notion | Funciona, mas gera sites iguais | Ilustração desliga o julgamento de "pessoa real"; muitas empresas migraram e passaram a parecer iguais. Menos detalhe é melhor; muitos rostos cansam, mitigue com espaço em branco. |
| Foto de banco / imagens de IA polidas | Evitar | Perfeição demais derruba a confiança; "fadiga de IA" reduz o efeito. |
| Dashboard como hero de SaaS | Evitar | Ver red flags de hero. |

As 10 versões de key visual avaliadas, na ordem apresentada (as duas últimas são as melhores): blob com elementos atacando o núcleo; personagem em pé; bolhas animadas; arte isométrica; centro atacado por objetos (metáfora clara, nada filtrado); celular com notificações vindo de todos os lados (só o problema); funil com 5 itens que passam sem destaque; celular com 3 notificações que passaram (diz 5); muralha invisível; pessoa lendo.

Conflitos a observar (conciliações abaixo são síntese da skill): (1) o curso diz que efeito único em tudo é red flag, enquanto o vídeo de tendências defende glassmorphism e neumorphism; concilie como "pontual sim, em tudo não". (2) Um vídeo recomenda hero sem visual por padrão; o outro ranqueia visuais relevantes e literais; concilie pelo critério "o visual amplifica o texto?". (3) O squircle aparece na lista de "morphisms" que são só material e, depois, como forma de canto recomendada; trate-o como forma de canto.

## AI slop

Defina slop como conteúdo genérico, de baixo esforço e reconhecível como gerado por IA. Pontos de checagem derivados do autor:

- **Copy**: "word salad" sem solução concreta, claims sem significado ("gold standard"), headline que manda o usuário resolver. Substituir por problema claro, solução fundamentada na realidade (sem "mágica de IA"), número específico e CTA de baixo atrito.
- **Caminho lógico numérico**: números que se encadeiam (17.000 pessoas → 636 notificações por dia cada → só 5 importam) formam uma narrativa que o cérebro conecta sozinho. Número exato parece mais crível que redondo; a frase do autor sobre isso é incerta (a confirmar).
- **Key visual**: blob, isometria, personagem aleatório e imagens de IA sem sentido, usados só para "ficar bonito" esperando que o aesthetic-usability effect compense o resto. Não compensa quando o visual é irrelevante.
- **Visual de IA no vale da estranheza** e fotos polidas demais: filtrados como preenchimento; confiança cai.
- **Sites todos iguais** e "azul e roxo slop": sinal de padrão sem decisão. Bento boxes e light leaks só entram aqui quando usados no lugar da mensagem.
- **UI kit genérico** e componentes padrão sem adaptação ao produto.
- **Antídotos do autor**: (a) escreva a copy primeiro e só então o visual; (b) pense na linha final do cliente (designers que entendem isso têm trabalho recorrente); (c) visual relevante e, se possível, literal com resultado emocional; (d) elementos desenhados à mão, imperfeitos e pessoais; (e) experimentos de interação nova (AR, botões reativos), prototipados com IA e refinados à mão; (f) auditar o resultado em vez de aceitar "bom o suficiente".
- **Gosto e atenção a detalhe** aparecem em sutilezas "não muito certas" que o usuário percebe subconscientemente (margens, pesos, proporções, olhar). Se algo parece "quase certo", meça antes de aprovar.
- Quando o pedido do cliente for "tirar o feel de IA", trate como remoção de abstração e irrelevância em key visuals e copy ("deslopification").

## Formato do relatório de auditoria

Formato do relatório (convenção da skill, não do autor): entregue em pt-BR, sem elogio genérico:

```
# Auditoria: <nome do design/página>

Contexto: <tipo, público, objetivo>
Veredito em 1 linha: <o principal problema e o impacto provável>

## Crítico
1. <Achado>: onde | por que é problema | como detectei (medida/contagem) | correção em 1 linha
## Importante
1. ...
## Polimento
1. ...

## Contagens do sistema
(use n/d quando a contagem não for mensurável, ex.: screenshot ou copy)
Typefaces: n | Tamanhos: n | Pesos: n | Fundos: n | Cores de texto: n | Packs de ícones: n | Valores de espaçamento: n | Radius: n | Margem esq./dir.: x / y

## O que está certo (máx. 3 itens, só se verdadeiro)

## Ordem de correção sugerida
<sugestão, a partir da ordem da demonstração do autor (ícones e cor intercambiáveis; tipografia primeiro é opcional): medir → margens/padding → tipografia → espaçamento entre grupos → ícones → cor → revisão final>

## Incertezas
<o que não foi possível verificar (sem código, sem contexto de público, sem dados de conversão)>
```

Regras do relatório: cite sempre o valor medido (ex.: "margem esquerda 24, direita 16"); nunca invente métricas de conversão; separe fato medido de opinião; se um achado depende de contexto (hierarquia primário/secundário), diga a pergunta que o designer deve responder.

## Checklist rápido

- [ ] A mensagem (headline, descrição, CTA) se sustenta sem o visual?
- [ ] O key visual reforça a copy (relevante) em vez de só decorar?
- [ ] A headline traz benefício concreto, sem claim vazio nem "word salad"?
- [ ] O CTA é de baixo atrito e diz o que acontece?
- [ ] Margem esquerda = direita, e a relação margem externa/padding interno do card é coerente (tendência: externa maior)?
- [ ] Há poucos typefaces, tamanhos e pesos, e poucos valores de espaçamento (~4, só para espaçamento)?
- [ ] Os ícones são de um único set, com stroke coerente com o texto?
- [ ] As camadas respeitam "mais perto = mais claro" e o contraste lê bem?
- [ ] Cada elemento tem função (sem decoração, acesso duplicado ou "..." vazio)?
- [ ] Rótulos são específicos e a hierarquia primário/secundário é lógica?
- [ ] Os números do fluxo fecham e há saída em cada etapa?
- [ ] Nenhum efeito (glass, neumorphism, textura) está aplicado a tudo ou fora de contexto?
- [ ] Rostos e fotos parecem reais, olham para o texto e não são de banco/IA?
- [ ] Não há blob, isometria ou dashboard no hero sem relação com a mensagem?
- [ ] Cada achado do relatório traz valor medido, severidade e correção?
