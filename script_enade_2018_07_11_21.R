# Script para o trabalho de Econometria

# 1. Importando pacotes necessarios:
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
library(tidyverse) #organizar os dados
library(caret) # testes estatisticos
library(car) #econometria
library(lmtest) #testes lineares
library (sandwich) #correcao de heterocedasticidade
library(ISwR) #mudar os nomes
library(MASS) #analise multivariada
library(strucchange) #organizacao do banco de dados
library(biotools)
library(MVN)
library("kernlab")
library(ROCR)
library(pROC)
library(faraway)
library(mfx)
library("ResourceSelection")
library(modEvA)


# 2. Baixando os dados: 
setwd("~/Mestrado/Igor_UFPR")

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

# Recorte amostral para o curso de economia: nao foi possivel.
# microdados <- microdados[microdados$CO_GRUPO == 13,]

attach(microdados)
dados <- data.frame(NT_GER, QE_I23,
                          QE_I07, QE_I12, 
                          QE_I08, TP_SEXO,
                          QE_I02, CO_IES, CO_GRUPO, TP_PRES, QE_I01, QE_I21,
                          QE_I25, QE_I27, QE_I47, NU_IDADE, TP_PRES, 
                          CO_TURNO_GRADUACAO)

detach(microdados)

# Apagando os microdados para desocupar a memoria: 
rm(microdados)

# 3.2. Renomeando as variaveis:
names(dados)
dados <- dados %>% rename("desempenho"="NT_GER", "esforco"="QE_I23", 
                          "familia"="QE_I07", 
                          "historia"="QE_I12", "estrutura"="QE_I08",
                          "sexo"="TP_SEXO", "raca"="QE_I02", "ufpr"="CO_IES",
                          "economia"="CO_GRUPO", "presenca"="TP_PRES", 
                          "casado"="QE_I01", "sup_fam"="QE_I21",
                          "profissional"="QE_I25", "formacao"="QE_I27",
                          "praticas"="QE_I47", "idade"="NU_IDADE",
                          "presenca"="TP_PRES", "turno"="CO_TURNO_GRADUACAO")

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

# l) Criando variavel binaria se foi ou nao fazer a prova:
dados$presenca <- ifelse(dados$presenca==555, 1, 0)

# m) Criando variavel binaria de interacao se foi ou nao fazer a prova e cursa
# economia:
dados$pres_eco <- dados$presenca*dados$economia

# n) Criando variavel binaria de estado civil:
dados$casado <- ifelse(dados$casado == "B", 1, 0)

# o) Crivando variavel binaria de escolha do curso pelo ponto de vista 
# profissional e mercado de trabalho:
dados$profissional <- ifelse(dados$profissional == "A", 1, 0)

# p) Criando variavel multinomial para urso contribuiu com formação cidada e 
# profissional?

# 1 = Discordo totalmente.
# 2 = Discordo.
# 3 = Discordo parcialmente.
# 4 = Concordo parcialmente.
# 5 = Concordo.
# 6 = Concordo totalmente.
# 7 = Não se aplica = 0.
# 8 = Não sei responder = 0.

dados$formacao <- (ifelse(dados$formacao == 1, 1, 0) + 
                     ifelse(dados$formacao == 2, 2, 0) +
                     ifelse(dados$formacao == 3, 3, 0) + 
                     ifelse(dados$formacao == 4, 4, 0) +
                     ifelse(dados$formacao == 5, 5, 0) +
                     ifelse(dados$formacao == 6, 6, 0) + 
                     ifelse(dados$formacao == 7, 0, 0) + 
                     ifelse(dados$formacao == 8, 0, 0))

# q) Criando variavel multinomial se o curso favoreceu articulação do 
# conhecimento teorico com atividades praticas? 

# 1 = Discordo totalmente.
# 2 = Discordo.
# 3 = Discordo parcialmente.
# 4 = Concordo parcialmente.
# 5 = Concordo.
# 6 = Concordo totalmente.
# 7 = Não se aplica = 0.
# 8 = Não sei responder = 0.

dados$praticas <- (ifelse(dados$praticas == 1, 1, 0) + 
                     ifelse(dados$praticas == 2, 2, 0) +
                     ifelse(dados$praticas == 3, 3, 0) + 
                     ifelse(dados$praticas == 4, 4, 0) +
                     ifelse(dados$praticas == 5, 5, 0) +
                     ifelse(dados$praticas == 6, 6, 0) + 
                     ifelse(dados$praticas == 7, 0, 0) + 
                     ifelse(dados$praticas == 8, 0, 0))


# r) Criando variavel binaria de ensino superior na familia:
dados$sup_fam <- ifelse(dados$sup_fam == "A", 1, 0)

# t) Criando variavel para turno noturno:
dados$noturno <- ifelse(dados$turno == 4, 1, 0)


write.xlsx(dados, "dados3.xlsx")

# 4. Ajustando os dados:

# 4.1. Fazendo as transformações nos dados:
dados$desempenho <- ifelse(dados$desempenho > 0, log(dados$desempenho), 0)

# 5. Estatisticas descritivas das variaveis quantitativas nao binarias:
descritivas <- psych::describe(dados, 
                               quant = c(.25, .75))

descritivas <- round(descritivas, 3)
descritivas

# write.xlsx(descritivas, "descritivas.xlsx", row.names = T)


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

# 10. Modelo de regressao Logistica Binaria - Logit:
modelo4 <- glm(pres_eco ~ idade + sexo + noturno,
                data = dados, family = binomial(link = "logit"))

# Vendo os resultados do modelo:
summary(modelo4)

# De forma mais visual:
stargazer(modelo4, title="Resultados",type = "text")


# Encontrando a razao das chances no modelo. Os resultados encontrados mostram 
# em quantas vezes cada coeficiente tem forca para mostrar que o um domicilio e As:

exp(modelo4$coefficients)

# De forma mais visual:
logitor(pres_eco ~ idade + sexo + noturno,
        data = dados)

# Predicoes:
probab <- predict(modelo4, type = "response")
dados$probab <- probab
classes.preditas <- ifelse(probab > .5, 1, 0)

# Matriz de Confusao

# Primeiro montando os objetos para medir a qualidade do modelo:
acuracia <- c()
sensitividade <- c()
especificidade <- c()

#Gerar matriz de confusao:
confusao <- table(Predito = classes.preditas, Original = dados$pres_eco)

confusao

#Verificando valores previstos:
vp <- confusao[2,2] #verdadeiros positivos
fn <- confusao[2,1] #falsos negativos

vn <- confusao[1,1] #verdadeiros negativos
fp <- confusao[1,2] #falsos positivos


#Calculando a acuracia do modelo:
acuracia <- sum(diag(confusao))/sum(confusao)

acuracia

#Calculando a sensitividade:
sensitividade <- vp/(vp+fn)

sensitividade

#Calculando a espeficidade:
especificidade <- vn/(vn+fp)

especificidade

lines(logit_8$fitted.values)

library(pROC)

myroc <- roc(as.numeric(modelo$model[1]>0),as.vector(fitted(modelo)))
mycoords <- coords(myroc, "all", transpose = TRUE)

plot(mycoords["threshold",], mycoords["specificity",], type="l", col="red", xlab="Cutoff", ylab="Performance")
lines(mycoords["threshold",], mycoords["sensitivity",], type="l", col="blue")
legend(100, 0.4, c("Specificity", "Sensitivity"), col=c("red", "blue"), lty=1)

best.coords <- coords(myroc, "best", best.method = "youden", best.weights = c(1, 0.5), transpose = TRUE)
abline(v=best.coords["threshold"], lty=2, col="grey")
abline(h=best.coords["specificity"], lty=2, col="red")
abline(h=best.coords["sensitivity"], lty=2, col="blue")

auc(as.numeric(modelo$model[1]>0),as.vector(fitted(modelo)))

plot(roc(as.numeric(modelo$model[1]>0),as.vector(fitted(modelo))))

# 11. Regressao com as probabilidades:
dados$inv_prob <- (1/dados$probab)
dados$desemp_pond <- dados$desempenho*dados$inv_prob

modelo5 <- lm(desemp_pond*economia ~ esforco + familia + historia + estrutura +
                sexo + raca + ufpr, 
              data = dados)

summary(modelo5)
