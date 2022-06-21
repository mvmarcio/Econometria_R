---
title: "Crimes Patrimoniais em MG"
output:
  html_document:
    df_print: paged
---

## **1. Introdução**

O objetivo deste trabalho é realizar uma análise da metodologia do artigo “Uma análise teórica e empírica sobre o comportamento dos crimes patrimoniais no estado de Minas Gerais no período de 2000 a 2015”. Será feita uma breve introdução do artigo focando nas metodologias adotadas e principais resultados obtidos. 

\

O artigo analisou alguns dos fatores que podem ter influenciado a evolução do número de crimes violentos contra o patrimônio em Minas Gerais. Primeiro foi realizada uma revisão de literatura sobre a teórica econômica do crime e revisitar o modelo de oferta individual de crimes de Gary S. Becker (1968). 

\

Após a revisão de literatura é feita uma análise dos dados sobre o comportamento dos crimes patrimoniais no estado mineiro utilizando a metodologia dos dados em painel. Foram utilizadas as seguintes variáveis no modelo:

![Variáveis do modelo](C:/Users/mvmar/Documents/Mestrado/2021/Pedro_USP/Econometria/variaveis.png)

O modelo populacional a ser estimado é dado por:

$$
{txcpt}_{it}=\beta_0+\beta_1\ast{gpc_{edu}}_{it}+\beta_2\ast\ {ypc_{stf}}_{it}+\beta_3\ast{tx_{urb}}_{it}+\beta_4\ast{den}_{it\ }+\beta_5\ast jov+\beta_6\ast txnsf+\beta_7\ast txph10+{\ u}_{it}
$$
Em que i é i-ésimo município no vetor de municípios mineiros na amostra e t é um determinado período de tempo no vetor da variável tempo. Assume-se que o termo de erro $u_{it}$ tem média e variância constantes ao longo do tempo e que não há auto correlação serial, isto, ele é independente ao longo dos períodos e que também não tem covariância com as variáveis explicativas.

\

Será feita a mesma análise metodológica utilizando as séries mais atuais, que vão até 2019. Houve uma única mudança nas variáveis que em jov, que será utilizada o número de jovens e não o percentual. Na base de dados original não este indicador e seria necessário cria-lo com base nas populações dos municípios da base. 

\

As principais conclusões que os autores chegaram foi que houve um significativo aumento nos crimes em cidades pequenas e que a taxa de crimes violentos contra o patrimônio está negativamente relacionada com o gasto per capita na área da educação, mas indicadores demográficos e de renda como taxa de urbanização, densidade demográfica, percentual de jovens na população e renda per capita do setor formal estão positivamente relacionados com a taxa de crimes violentos contra o patrimônio. Conclui-se pela indicação de políticas públicas de incentivo à redução da criminalidade.

## **2. Metologia de Dados em Painel**

Segundo Wooldridge (2016), a grande vantagem da metodologia dos dados em painel é que permitem analisar melhor as variações que comumente não são observadas em corte transversal, ou dados longitudinais, e ainda podem minimizar o viés e apresentar maior grau de liberdade.

\

Com isto e com base em Wooldridge (2002), os modelos de dados em painel podem ser estáticos ou dinâmicos. Num modelo de painel estático, assume-se que as variáveis explicativas são independentes dos termos de perturbação. Já no que tem a ver com a questão da heterogeneidade, pode-se assumir que esta reside nos coeficientes de regressão (que podem variar no tempo ou de indivíduo para indivíduo) ou na estrutura dos termos de perturbação. 

\

Com base no que foi exposto acima, a escolha de uma especificação de validade universal é impossível, restando-nos escolher aquela que, face aos dados em concreto e ao tipo de problema em causa, melhor se adeque. O modelo dinâmico não será abordado nesta pesquisa.

\

Os modelos estáticos de dados em painel podem ser divididos em três tipos de metodologia: modelo de dados empilhados (pooled), modelos de dados em painel em efeitos fixos ou fixed effects (FE) e modelo dados em painel em efeitos aleatórios ou random effects (RE) (Gujarati e Porter, 2011).

\

A especificação de cada modelo encontra-se abaixo:

\

i. *Pooled:* É a técnica de painel que desconsidera as dimensões de tempo e espaço, onde se empilham as observações e obtém-se a regressão. O principal problema é camuflar a heterogeneidade que possa existir entre as variáveis. Os coeficientes estimados na equação podem ser tendenciosos e inconsistentes (Gujarati e Porter, 2011).

\

ii. Efeitos Fixos: Combinam-se todas as observações, deixando que cada unidade de corte transversal tenha sua própria variável dummy (intercepto). O termo “efeitos fixos” deve-se ao fato de que, embora o intercepto possa diferir entre os indivíduos, o intercepto de cada indivíduo não varia com o tempo (Gujarati e Porter, 2011).

\

iii. Efeitos Aleatórios: Propõe diferentes termos de intercepto para cada observação, contudo, interceptos fixos ao longo do tempo. O intercepto(comum) representa o valor médio de todos os interceptos (de corte transversal) e o componente de erro $\varepsilon_i$ representa o desvio (aleatório) do intercepto individual desse valor médio. No entanto, de que $\varepsilon_i$ não é diretamente observável; ele é o que se conhece como uma variável não observável ou latente (Gujarati e Porter, 2011).

\

Segundo Wooldridge (2016), para montar um modelo de dados em painel são utilizadas duas variáveis globais: uma variável identificadora de cada município analisado (id) e a variável indicadora de tempo (que vai montar a série temporal para cada variável).

\

Como é um painel curto e cada município, e cada um deles é independente na amostra ao longo do tempo, espera-se que o modelo de efeitos fixos seja o mais adequado, pois segundo Gujarati e Porter (2011, p.603), a inferência estatística é condicional às unidades de corte transversal observadas na amostra. Isso é adequado se realmente as unidades individuais ou de corte transversal da amostra não sejam extrações aleatórias de uma amostra maior, como é o caso dos estados. Nesse caso, o modelo de efeitos fixos é adequado.

\


Porém serão realizados testes de especificação adequados para a seleção do modelo mais eficiente e consistente, como mostrado em Wooldridge (2002), Wooldridge (2016) e Gujarati e Porter (2011). Inicialmente será realizado o teste F de Chow, cuja hipótese nula é de que não há mudança estrutural, para o qual, se o valor de F calculado for menor que F tabelado não rejeitaremos a hipótese nula. O resultado deste teste apresenta qual o melhor modelo a ser utilizado para regressão, se o Pooled ou Efeitos Fixos.

\

Posteriormente será realizado o teste de Hausman, que é utilizado para testar se há simultaneidade, e qual o melhor efeito, se o Efeito Fixo ou Efeito Aleatório. Tem como hipótese nula que se não há simultaneidade, a correlação é igual a zero. Se o valor exceder o da tabela, utiliza-se o efeito fixo (Wooldridge, 2016).

\

Por fim será realizado o teste de multiplicador de Lagrange de Breusch e Pagan, que verifica a presença de efeitos aleatórios no modelo, a hipótese nula do teste é a de que não há presença de efeitos aleatórios (Wooldridge, 2002). 

\

Inicialmente, por se tratar de um painel curto, também se considera a hipótese de que os efeitos aleatórios estão correlacionados com um ou mais regressores no modelo, por isso não se colocou o termo de erro composto. Esta hipótese será testada por meio do teste de Hausman (Gujarati e Porter, 2011). 

## **3. Análise Descritiva**

### **3.1. Carregando Pacotes**

```{r}
# 1. Carregando os pacotes necessarios:
library(car) #pacote para testes do modelo de regressao
library(AER) #pacote para mais testes do modelos
library(psych) #pacote para estatisticas descritivas
library(dplyr) #pacote para organizacao e tratamento dos dados
library(tidyr) #pacote para organizacao e tratamento dos dados
library(DescTools) #pacote para correcao de outliers
library(normtest) #pacote para testes de normalidade
library(openxlsx) #leitura dos dados em excel
library(readxl) #leitura dos dados em Excel
library(stargazer) #tabelas das regressoes
library(Hmisc) #correlacoes e testes
library(plm) # dados em painel.
library(stats) # organizacao dos dados

options(scipen=999) # evita a transformação para notação científica
```

### **3.2. Baixando os Dados para a Análise**
```{r}
# 2. Mudando o diretorio:
# setwd("~/Mestrado/USP/Econometria/bases")

# 3. Baixando os dados:
base <- read_excel("C:/Users/mvmar/Documents/painel2.xls")

# 3.1. Declarando o painel:
base <- pdata.frame(base, index = c("id", "year"))

# 3.2. Corrigindo os valores faltantes:
base <- na.omit(base)

# 3.3. Balanceando o painel:
base <- make.pbalanced(base, balance.type = "shared.individuals")

pdim(base)
```
### **3.3. Estatísticas Descritivas**

A amostra da pesquisa foi balanceada e obteve 796 municípios para o estado de MG para os anos de 2000 a 2019. Os estados foram selecionados com base na disponibilidade dos dados. Os municípios desbalanceados e valores faltantes foram retirados da amostra. 

\

	Primeiramente serão realizadas as estatísticas descritivas para verificar a características dos dados. Seguem abaixo as estatísticas descritivas das variáveis do modelo:

```{r}
# 4. Observando os tipos de variaveis:
# str(base)

# 5. Estatisticas descritivas das variaveis quantitativas nao binarias:
descritivas <- data.frame(psych::describe(base[, 4:11], 
                               quant = c(.25, .75)))
descritivas
```

As estatísticas descritivas são importantes para avaliar a distribuição dos dados para uma modelagem mais assertiva para a regressão. Com exceção das da variável de taxa de urbanização, todas as demais apresentaram forte assimetria, curtose e variabilidade, pois tiveram um coeficiente de variação igual ou maior a 30%. Antes da análise de regressão serão realizados testes para a detecção de outliers nestas variáveis, pois a regressão, assim como a análise ANOVA, é um análise de variância e é sensível à presença de valores extremos (Hair et al., 2009). Problemas com dispersão, assimetria e curtose nos dados podem gerar alta variabilidade no modelo, o que não é desejável. 

\

Com exceção da variável de taxa de urbanização, todas as demais apresentaram a presença de outliers e por este motivo foi feito o ajuste dos valores extremos com base na mediana, isto é, os valores nos extremos de cada variável foram ajustados aos valores das suas respectivas medianas (Hastings, et al., 1947). Isso é feito para um melhor ajuste do modelo de regressão.

\

Seguem abaixo a correção dos outliers nas variáveis do modelo:

```{r}
# 6.3. Corrigindo os outliers na base:
base$txcpt <- Winsorize(base$txcpt, probs = c(.10, .90))
base$gpc_edu <- Winsorize(base$gpc_edu, probs = c(.05, .95))
base$ypc_stf <- Winsorize(base$ypc_stf, probs = c(.1, .90))
base$den <- Winsorize(base$den, probs = c(.10, .90))
base$jovens <- Winsorize(base$jovens, probs = c(.11, .89))
base$txnsf <- Winsorize(base$txnsf, probs = c(.05, .95))
base$txph10 <- Winsorize(base$txph10, probs = c(.05, .95))

# 6.4. Histograma e box-plot da variável dependente:
hist(base$txcpt, ylab = "Frequência", xlab = "",
     col = "white", main = "txcpt")

boxplot(base$txcpt, ylab = "Frequência", xlab = "",
        col = "white", main = "txcpt")
```

### **3.4. Correlações Lineares**

Neste caso, espera-se uma forte correlação da variável com as demais variáveis e uma correlação fraca ou moderada entre as demais. Correlações lineares próximas de 1 ou -1 indicam que uma variável pode ser transformação linear de outra (Guimarães e Lima, 2008), gerando o problema da multicolinaridade no modelo (que será testada). Neste caso, quase todas as correlações entre as variáveis independentes foram baixas ou moderadas. 

\

Seguem abaixo as correlações:

```{r}
# 10. Correlacoes. Como ha variaveis binarias no modelo, sera empregada a 
# correlacao de Spearman, que e a mais indicada quando ha este tipo de variavel.
# A correlacao de Pearson funciona bem com dados quantitativos continuos e com
# baixa variabilidade.

correlates <- rcorr(as.matrix(base[, 4:11]),
                     type=c("pearson"))

correlacoes <- data.frame(correlates$r)


# Hide upper triangle
Data1 <- base[, c(4:11)]
Data.cor <- round(cor(Data1),3)
# Data.cor

upper<-Data.cor
upper[upper.tri(Data.cor)]<-""
upper<-as.data.frame(upper)
upper
```

Vamos testar a significância estatísticas das correlações:

```{r}

# Algumas correlacoes foram acima de 0,95 e isto pode gerar multicolinearidade
# no modelo. Caso isto ocorra, algumas variaveis poderao ser retiradas.

# Signficancia das correalacoes:
correlacoes_p <- data.frame(correlates$P)
correlacoes_p
```

## **4. Modelo de Regressão**

### **4.1. Modelo Empilhado**

```{r}
# 11. Regressao por MQO: vamos avaliar o nosso modelo. 
pooled <- plm(txcpt ~ log(gpc_edu) + log(ypc_stf) + tx_urb + den + jovens + 
                      txnsf + txph10, 
              data = base, model = "pooling")

summary(pooled)
vif(pooled)
mean(vif(pooled))
```
Inicialmente foi realizado o cálculo do fator de inflação de variância (VIF) para detecção de multicolinearidade no modelo (Wooldridge, 2016). Se os VIFs forem menores que 5, rejeita-se tal presença.  Como se observa na tabela abaixo, não houve multicolinearidade entre os regressores.

\

Agora será realizado o teste de especificação de Ramsey. Como também será mostrada na tabela de resultados, a estatística do teste foi baixa no valor de 55,197, com um valor-p de 0,00, ou seja, a hipótese nula foi rejeitada, indicando que o modelo não foi adequadamente ajustado em sua forma funcional (Wooldridge, 2016). **Essa hipótese será relaxada**.

```{r}
# 8.3. Teste de especificação:
ramsey <- lm(txcpt ~ log(gpc_edu) + log(ypc_stf) + tx_urb + den + jovens + 
                      txnsf + txph10, 
              data = base)
reset(ramsey)
```

Agora vamos trabalhar com os modelos de efeitos fixos e efeitos aleatórios para fazer as comparações.

### **4.2. Modelo de Efeitos Fixos**

```{r}
# 8.4. Modelo de efeitos fixos:
fixos <-  plm(txcpt ~ log(gpc_edu) + log(ypc_stf) + tx_urb + den + jovens + 
                      txnsf + txph10, 
              data = base, model = "within")
summary(fixos)
```

### **4.3. Modelo de Efeitos Aleatórios**

```{r}
# 8.5. Modelo de efeitos aleatórios:
aleatorios <-  plm(txcpt ~ log(gpc_edu) + log(ypc_stf) + tx_urb + den + jovens + 
                           txnsf + txph10, 
                   data = base, model = "random")
summary(aleatorios)
```
### **4.4. Testes de Especificação para Escolha do Modelo**

```{r}
# 8.6. Teste de Chow: efeitos fixos x pooled
pFtest(fixos, pooled)
#F test for individual effects
#data:  crescimento ~ gini + educ_fem + invest_estad + pib_percapita
#F = 3.6877, df1 = 25, df2 = 359, p-value = 2.117e-08
#alternative hypothesis: significant effects

# 8.6. Teste LM de Breush-Pagan:
plmtest(pooled, type="bp")
#Lagrange Multiplier Test - (Breusch-Pagan) for unbalanced panels
#data:  crescimento ~ gini + educ_fem + invest_estad + pib_percapita
#chisq = 2.1467, df = 1, p-value = 0.1429
#alternative hypothesis: significant effects

# 8.7. Teste de Hausman:
phtest(fixos, aleatorios)
#Hausman Test
#data:  crescimento ~ gini + educ_fem + invest_estad + pib_percapita
#chisq = 114.71, df = 4, p-value < 2.2e-16
#alternative hypothesis: one model is inconsistent
```
No primeiro teste, comparando o modelo empilhado contra o de efeitos fixos, o valor da estatística F do teste de Chow foi de 13,949 com um valor-p de 0,00, ou seja, a hipótese nula foi rejeitada. Neste caso a heterogeneidade dos municípios foi significante.

\

Já o teste de Hausman que compara o modelo de EF contra o EA, a estatística qui-quadrado do teste foi de 184,67 e o seu valor-p foi de 0,00, indicando que há diferença entre os coeficientes de efeitos fixos e aleatórios no modelo. Dessa forma, o ideal é se trabalhar com o modelo em efeitos fixos.  

\

Por fim, o teste Teste LM de Breusch-Pagan O resultado da estatística qui-quadrado do teste 22.074 e o valor-p de 0,00 rejeitando a hipótese nula. Neste caso a presença dos efeitos aleatórios foi significante. 

**Conclusão:** Pelos testes de especificação o modelo mais robusto foi o de Efeitos Fixos.

### **4.5. Testes de Eficiência do Modelo de Efeitos Fixos**

#### **4.5.1. Teste de Wooldridge para autocorrelação Serial de Dados em Painel**

```{r}
# 8.9. Teste de autocorrelação serial: 
pbgtest(fixos)
```
A hipótese nula de não existência de autocorrelação serial nos resíduos foi rejeitada para o modelo de efeitos fixos. Neste caso, este problema deverá ser corrigido. Antes da correção será avaliada a dispersão nos resíduos. 

#### **4.5.2. Teste de Breusch-Pagan para Heterocedasticidade em Grupo**

```{r}
# 8.9. Teste de autocorrelação serial: 
bptest(fixos)
```
A hipótese nula de homocedasticidade foi rejeitada, isto é, o modelo sofre com a dispersão não aleatória nos resíduos o que atrapalha a análise da consistência dos estimadores utilizados. Este problema será corrigido por meio da ajuste nos erros-padrão robustos de White, que também irá ajustar o problema na autocorrelação residual.

#### **4.5.3. Teste Jarque-Bera de Normalidade nos Resíduos* modelo de efeitos fixos**
```{r}
# 8.9. Teste de autocorrelação serial: 
jb.norm.test(fixos$residuals)
```
O valor-p do teste Jarque-Bera foi de 0,00 rejeitando a hipótese nula de normalidade nos resíduos. Como o modelo de dados em painel cria uma série temporal para cada corte transversal a amostra ficou acima de 30 no painel, podendo dessa forma se trabalhar com a hipótese de normalidade assintótica. 

#### **4.5.4. Modelo com Erros-Padrão Robustos**

```{r}
# 8.11. Erros-padrão robustos:
fixos_robust <- coeftest(fixos, vcov. = vcovHC)

stargazer(fixos, type = "text", ci = TRUE, title = "Resultados",
          dep.var.labels = "Crescimento", decimal.mark = ",")
```

## **5. Interpretação dos Resultados do Modelo**

Os gastos com ensino tiveram efeito positivo sobre o aumento esperado nas taxas de crimes contra o patrimônio, o que não faz sentido do ponto de vista econômico. O valor do rendimento total dos empregados do setor formal também teve efeito positivo, assim como tx_urb e den. Já o número de jovens e número de empregados no setor formal tiveram efeitos negativos. Já a razão entre a população total do município e o número de policiais militares lotados na unidade (habitantes/nº policiais) teve efeito nulo.

\

O modelo com dados em painel por efeitos fixos gerou resultados inadequados do ponto de vista teórico  para este tipo de análise. Isto provavelmente ocorreu por conta da a alta correlação entre os crimes passados com os crimes no presente, o que parece ser mais adequado seria a estimação generalizada por momentos levando em consideração a variável dependente defasada. 

## **Referências Bibliográficas**

GUJARATI, D. N.; PORTER, D. C. **Econometria básica**. 5. ed. Porto Alegre: AMGH, 2011. P. 588-603.

\

HAIR Jr., J.F.; BLACK, W.C.; BABIN, B.J.; ANDERSON, R.E. & TATHAM, R.L. **Análise multivariada de dados**. 6.ed. Porto Alegre, Bookman, 2009. 688p.

\

Hastings, Jr., Cecil; Mosteller, Frederick; Tukey, John W.; Winsor, Charles P. "Low moments for small samples: a comparative study of order statistics". **Annals of Mathematical Statistics**, 1947.

\

Magalhães, MN; Lima, ACP. **Noções de Probabilidade e Estatística**. São Paulo. EDUSP, 2008.

\

WOOLDRIDGE, J. M. **Introdução à Econometria: uma abordagem moderna**. 3º ed. São Paulo: Cengage Learning, 2016.

\

WOOLDRIDGE, J., **Econometric analysis of  cross section and panel data**, MIT Press, Cambridge, Massachusett, 2002.
