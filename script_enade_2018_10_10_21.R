# Script para o trabalho de Econometria

# 1. Importando pacotes necessarios:
library(car) # pacote para testes do modelo de regressao
library(AER) # pacote para mais testes do modelos
library(psych) # pacote para estatisticas descritivas
library(dplyr) # pacote para organizacao e tratamento dos dados
library(tidyr) # pacote para organizacao e tratamento dos dados
library(DescTools) # pacote para correcao de outliers
library(normtest) # pacote para testes de normalidade
library(openxlsx) # leitura dos dados em excel
library(readxl) # leitura dos dados em Excel
library(stargazer) # tabelas das regressoes
library(Hmisc) # correlacoes e testes
library(tidyverse) # organizar os dados
library(caret) # testes estatisticos
library(car) # econometria
library(lmtest) # testes lineares
library (sandwich) # correcao de heterocedasticidade
library(ISwR) # mudar os nomes
library(MASS) # analise multivariada
library(strucchange) # organizacao do banco de dados


# 2. Baixando os dados: 
setwd("~/Mestrado/dados/enad")

microdados <- read.table("microdados_enade_2018.txt",header = TRUE, 
                               sep=";", dec = ",", 
                               colClasses=c(DS_VT_ACE_OFG="character",
                                            DS_VT_ACE_OCE="character"))

# 3. Montando a base para funcao de producao:

# 3.1 Variaveis selecionadas:

# desempenho = NT_GER (Nota bruta da prova - Média ponderada da 
# formação geral (25%) e componente específico (75%) (valor de 0 a 100))

# esforco = QE_I23 (Quantas horas por semana, aproximadamente, você dedicou aos 
# estudos, excetuando as horas de aula?)

# raça = QE_I02 (raça cor)

# família = QE_107 (Quantas pessoas da sua família moram com você? Considere 
# seus pais, irmãos, cônjuge, filhos e outros parentes que moram na 
# mesma casa com você.)

# história = QE_I12 (Ao longo da sua trajetória acadêmica, você recebeu algum 
# tipo de bolsa de permanência? No caso de haver mais de uma opção, 
# marcar apenas a bolsa de maior duração.)

# estrutura = QE_I08 (Qual a renda total de sua família, incluindo seus rendimentos?)

# sexo = TP_SEXO

attach(microdados)
dados <- data.frame(NT_GER, QE_I23,
                          QE_I07, QE_I12, 
                          QE_I08, TP_SEXO,
                          QE_I02, CO_IES, CO_GRUPO)

detach(microdados)

# Apagando os microdados para desocupar a memoria: 
rm(microdados)

# 3.2. Renomeando as variaveis:
names(dados)
dados <- dados %>% rename("desempenho"="NT_GER", "esforco"="QE_I23", 
                          "familia"="QE_I07", 
                          "historia"="QE_I12", "estrutura"="QE_I08",
                          "sexo"="TP_SEXO", "raca"="QE_I02", "ufpr"="CO_IES",
                          "economia"="CO_GRUPO")

# 3.3. Ajustando os dados:

# a) Criando uma variável multinomial para esforço:

# A = Nenhuma, apenas assisto às aulas.
# B = De uma a três.
# C = De quatro a sete.
# D = De oito a doze.
# E = Mais de doze.

dados$esforco <- (ifelse(dados$esforco == "A", 0, 0) + 
                    ifelse(dados$esforco == "B", 1, 0) +
                         ifelse(dados$esforco == "C", 2, 0) + 
                         ifelse(dados$esforco == "D", 4, 0) +
                         ifelse(dados$esforco == "E", 5, 0))


# b) Criando uma variável multinomial para família:

# A = Nenhuma.
# B = Uma.
# C = Duas.
# D = Três.
# E = Quatro.
# F = Cinco.
# G = Seis.
# H = Sete ou mais.


dados$familia <- (ifelse(dados$familia == "A", 0, 0) + 
                    ifelse(dados$familia == "B", 1, 0) +
                    ifelse(dados$familia == "C", 2, 0) + 
                    ifelse(dados$familia == "D", 4, 0) +
                    ifelse(dados$familia == "E", 5, 0) +
                    ifelse(dados$familia == "F", 5, 0) +
                    ifelse(dados$familia == "G", 5, 0) +
                    ifelse(dados$familia == "H", 5, 0))

# c) Criando uma variável binaria dicotomica para historia: 1 se recebeu auxilio
# ou 0 caso contrário:

# A = Nenhum.
# B = Auxílio moradia.
# C = Auxílio alimentação.
# D = Auxílio moradia e alimentação.
# E = Auxílio Permanência.
# F = Outro tipo de auxílio.

dados$historia <- ifelse(dados$historia == "A", 0, 1)

# d) Criando uma variável multinomial para estrutura:

# A = Até 1,5 salário mínimo (até R$ 1.431,00).
# B = De 1,5 a 3 salários mínimos (R$ 1.431,01 a R$ 2.862,00).
# C = De 3 a 4,5 salários mínimos (R$ 2.862,01 a R$ 4.293,00).
# D = De 4,5 a 6 salários mínimos (R$ 4.293,01 a R$ 5.724,00).
# E = De 6 a 10 salários mínimos (R$ 5.724,01 a R$ 9.540,00).
# F = De 10 a 30 salários mínimos (R$ 9.540,01 a R$ 28.620,00).
# G = Acima de 30 salários mínimos (mais de R$ 28.620,00).


dados$estrutura <- (ifelse(dados$estrutura == "A", 1, 0) + 
                    ifelse(dados$estrutura == "B", 2, 0) +
                    ifelse(dados$estrutura == "C", 3, 0) + 
                    ifelse(dados$estrutura == "D", 4, 0) +
                    ifelse(dados$estrutura == "E", 5, 0) +
                    ifelse(dados$estrutura == "F", 6, 0) +
                    ifelse(dados$estrutura == "G", 7, 0))

# e) Criando varivel binaria para sexo: 1 para F (feminino) e 0 caso contrario:
dados$sexo <- ifelse(dados$sexo == "F", 1, 0)

# f) Criando varivel binaria para raça: 1 para A (branca) e 0 caso contrario:
dados$raca <- ifelse(dados$raca == "A", 1, 0)

# g) Criando variavel binaria para a ufpr:
dados$ufpr <- ifelse(dados$ufpr == 571, 1, 0)

# h) Criando variavel binaria para o curso de economia:
dados$economia <- ifelse(dados$economia == 13, 1, 0)

# i) criando variavel binaria de intereacao entre economia e UFPR:
dados$eco_ufpr <- dados$ufpr * dados$economia

# j) criando variavel binaria de intereacao entre raca e UFPR:
dados$raca_ufpr <- dados$ufpr * dados$raca

# k) Criando variavel binaria historia e UFPR:
dados$hist_ufpr <- dados$ufpr * dados$historia

dados <- na.omit(dados)
write.xlsx(dados, "dados2.xlsx")


# 4. Baixando os dados novamente:
rm(microdados)
dados <- read_excel("dados.xlsx")

# 4.1. Fazendo as transformações nos dados:
dados$desempenho <- ifelse(dados$desempenho > 0, log(dados$desempenho), 0)

# 5. Estatisticas descritivas das variaveis quantitativas nao binarias:
descritivas <- psych::describe(dados, 
                               quant = c(.25, .75))

descritivas <- round(descritivas, 3)
descritivas

write.xlsx(descritivas, "descritivas.xlsx", row.names = T)


# 7. Correlações lineares de spearman:
correlates <- rcorr(as.matrix(dados),
                    type=c("spearman"))

correlacoes <- data.frame(round(correlates$r, 2))
sig_corr <- data.frame(round(correlates$P))

write.xlsx(correlacoes, "correlacoes.xlsx", row.names = T)
# Só a correlação entre educ de mulheres e homens foi maior que 0,95.

# Signficancia das correalacoes:
correlacoes_p <- data.frame(correlates$P)
# Todas foram significativas a 1%.

# 8. Regressao por dos dados em painel: vamos avaliar o nosso modelo. 
modelo <- lm(desempenho ~ esforco + familia + historia + estrutura +
                sexo + raca, 
              data = dados)

summary(modelo)
vif(modelo)
mean(vif(modelo))

# 9. Regressao com as variaveis de interacao:
modelo2 <- lm(desempenho ~ esforco + familia + historia + estrutura +
                sexo + raca + ufpr + economia + eco_ufpr, 
              data = dados)

summary(modelo2)


modelo3 <- lm(desempenho ~ esforco + familia + historia + estrutura +
                sexo + raca + ufpr + economia + eco_ufpr + raca_ufpr + hist_ufpr, 
              data = dados)

summary(modelo3)

