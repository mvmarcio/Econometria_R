# Analise Econometrica - 18/08/21

# 1. Carregando os pacotes necessarios:
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
library(plm) # regressao de dados em painel
library(stats) # para a regressão não paramétrica
library(kdensity) # regressão não paramétrica

# 2. Mudando o diretorio:
setwd("~/Dissertacao/")

# 3. Baixando os dados:
base <- read_excel("painel_jonas.xlsx", 
                   sheet = "base")

dif_gini <- diff(base$gini, 1)
base <- base[-c(1),]
base$dif_gini <- dif_gini
base <- base %>% mutate(dif_gini2 = dif_gini^2)

# 3.1. Declarando o painel:
base <- pdata.frame(base, index = c("id", "ano"))

# 4. Observando os tipos de variaveis:
str(base)

# 5. Estatisticas descritivas das variaveis quantitativas nao binarias:
descritivas <- psych::describe(base[, c(4:11)], 
                               quant = c(.25, .75))

descritivas <- round(descritivas, 3)
descritivas

write.xlsx(descritivas, "descritivas.xlsx", row.names = T)

# 6. Testando a presença de outliers no modelo:
boxplot(base$crescimento, ylab = "Frequência", xlab = "",
        col = "white") #sim

boxplot(base$gini, ylab = "Frequência", xlab = "",
        col = "white") #sim

boxplot(base$educ_fem, ylab = "Frequência", xlab = "",
        col = "white") #não.

boxplot(base$educ_mas, ylab = "Frequência", xlab = "",
        col = "white") #não

boxplot(base$invest_estad, ylab = "Frequência", xlab = "",
        col = "white") #sim

boxplot(base$pib_percapita, ylab = "Frequência", xlab = "",
        col = "white") #sim

# 6.1. Corrigindo a presença de outliers:
boxplot(Winsorize(base$crescimento, probs = c(.01, .99)),
        ylab = "Frequência", xlab = "",
        col = "white", main = "Crescimento") # corrigido.

boxplot(Winsorize(base$gini, probs = c(.05, .95)), 
        ylab = "Frequência", xlab = "",
        col = "white") # corrigido.

#boxplot(Winsorize(base$educ_fem, probs = c(.1, .9)), 
#        ylab = "Frequência", xlab = "",
#        col = "white") #corrigido.

#boxplot(Winsorize(base$educ_mas, probs = c(.1, .9)), 
#        ylab = "Frequência", xlab = "",
#        col = "white") #corrigido.

boxplot(Winsorize(na.omit(base$invest_estad), probs = c(.05, .95)), 
        ylab = "Frequência", xlab = "",
        col = "white") #corrigido.

boxplot(Winsorize(base$pib_percapita, probs = c(.05, .95)), 
        ylab = "Frequência", xlab = "",
        col = "white") # corrigido



# 6.3. Corrigindo os outliers na base:
base <- na.omit(base)
base$crescimento <- Winsorize(base$crescimento, probs = c(.01, .99))
base$gini <- Winsorize(base$gini, probs = c(.05, .95))
#base$educ_fem <- Winsorize(base$educ_fem, probs = c(.1, .9))
#base$educ_mas <- Winsorize(base$educ_mas, probs = c(.1, .9))
base$invest_estad <- Winsorize(na.omit(base$invest_estad), 
                               probs = c(.05, .95))
base$pib_percapita <- Winsorize(base$pib_percapita, probs = c(.05, .95))


# 6.4. Histograma e box-plot da variável dependente Crescimento:
hist(base$crescimento, ylab = "Frequência", xlab = "",
        col = "white", main = "Crescimento")

boxplot(base$crescimento, ylab = "Frequência", xlab = "",
        col = "white", main = "Crescimento")


# 7. Correlações lineares de pearson:
correlates <- rcorr(as.matrix(base[,4:9]),
                    type=c("pearson"))

correlacoes <- data.frame(round(correlates$r, 2))
sig_corr <- data.frame(round(correlates$P))

write.xlsx(correlacoes, "correlacoes.xlsx", row.names = T)
# Só a correlação entre educ de mulheres e homens foi maior que 0,95.

# Signficancia das correalacoes:
correlacoes_p <- data.frame(correlates$P)
# Todas foram significativas a 1%.

# 8. Regressao por dos dados em painel: vamos avaliar o nosso modelo. 
names(base)
pooled <- plm(crescimento ~ gini + dif_gini + educ_fem + educ_mas +
              invest_estad + pib_percapita, 
              data = base, model = "pooling")

summary(pooled)
mean(vif(pooled))

# 8.2. Modelo pooled 2:
pooled2 <- plm(crescimento ~ gini + dif_gini + educ_fem +
                      invest_estad + pib_percapita, 
              data = base, model = "pooling")

summary(pooled2)
vif(pooled2)
mean(vif(pooled2))

# 8.3. Teste de especificação:
ramsey <- lm(crescimento ~ gini + dif_gini + educ_fem +
                       invest_estad + pib_percapita, 
               data = base)
reset(ramsey)
#data:  ramsey
#RESET = 0.1469, df1 = 2, df2 = 382, p-value = 0.8634

# 8.4. Modelo de efeitos fixos:
fixos <-  plm(crescimento ~ gini + dif_gini + educ_fem +
                      invest_estad + pib_percapita, 
              data = base, model = "within")
summary(fixos)

# 8.5. Modelo de efeitos aleatórios:
aleatorios <-  plm(crescimento ~ gini + dif_gini + educ_fem +
                     invest_estad + pib_percapita, 
              data = base, model = "random")
summary(aleatorios)

# 8.6. Teste de Chow: efeitos fixos x pooled
pFtest(fixos, pooled2)
#F test for individual effects
#data:  crescimento ~ gini + educ_fem + invest_estad + pib_percapita
#F = 3.6877, df1 = 25, df2 = 359, p-value = 2.117e-08
#alternative hypothesis: significant effects

# 8.6. Teste LM de Breush-Pagan:
plmtest(pooled2, type="bp")
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

# 8.8. Modelo escolhido: efeitos-fixos. Teste de heterocedasticidade.
bptest(fixos)
#studentized Breusch-Pagan test
#data:  fixos
#BP = 11.522, df = 4, p-value = 0.02128


# 8.9. Teste de autocorrelação serial: 
pbgtest(fixos)
#Breusch-Godfrey/Wooldridge test for serial correlation in panel models
#data:  crescimento ~ gini + educ_fem + invest_estad + pib_percapita
#chisq = 46.313, df = 14, p-value = 2.492e-05
#alternative hypothesis: serial correlation in idiosyncratic errors

# 8.10. Teste de normalidade nos resíduos:
boxplot(fixos$residuals)
hist(fixos$residuals)
jb.norm.test(fixos$residuals)
#Jarque-Bera test for normality
#data:  fixos$residuals
#JB = 28.299, p-value < 2.2e-16

# 8.11. Erros-padrão robustos:
fixos_robust <- coeftest(fixos, vcov. = vcovHC)
fixos_robust

stargazer(fixos, type = "text", ci = TRUE, title = "Resultados",
          dep.var.labels = "Crescimento", decimal.mark = ",",
          omit.stat = "ser")

stargazer(fixos, type = "text", ci = TRUE, title = "Resultados",
          dep.var.labels = "Crescimento", decimal.mark = ",")


# 8.12. Efeito quadrático:
base$gini2 <- base$gini**2
fixos2 <-  plm(crescimento ~ gini + dif_gini + dif_gini2 + educ_fem +
                      invest_estad + pib_percapita, 
              data = base, model = "within")
summary(fixos2)

fixos_robust2 <- coeftest(fixos2, vcov. = vcovHC)
fixos_robust2

stargazer(fixos2, type = "text", ci = TRUE, title = "Resultados 2",
          dep.var.labels = "Crescimento", decimal.mark = ",")

# 8.13. Regressão de Kernel:
base$lgini <- lag(base$gini, k = -1)
kde <- density(base$lgini, bw = "nrd0", adjust = 1,
        kernel = c("epanechnikov"),
        window = kernel, na.rm = T)
plot(kde, main = "Curva de Kernel - Índice de Gini Defasado",
     ylab = "Densidade")

