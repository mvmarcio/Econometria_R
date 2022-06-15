# 1. Carregando pacotes necessarios
library(tidyverse) # organizacao dos dados
library(tidyquant) # organizacao dos dados financeiros
library(timetk) # para baixar as series
library(AER) # testes dos modelos
library(car) # testes dos modelos
library(psych) # analise descritiva dos dados
library(quantmod) # cotações das ações e do Ibov
library(Quandl) # Selic BACEN
library(ggplot2) # para gerar os gráficos
library(gridExtra) # para vaios graficos juntos
library(lmtest) # testes: breusch-godfrey, breuch-pagan
library(tseries) # jarque-bera test

options(scipen=999) # evita a transformação para notação científica

# 2. Baixando as series de precos da PETRO, Ibovesta e Petroleo:
getSymbols(c("PETR4.SA", "^BVSP", "CL=F"),
           periodicity = "monthly",
           from = "2011-01-01",
           to = "2021-10-31")

CL <- `CL=F`
rm(`CL=F`)

# pegando a taxa selic mensal
Quandl.api_key('TC1ow5j6G7s4SFHTzgDz') # set your API key = Comando necessário
# pra acessar o Quandl

selic <- Quandl("BCB/4390",type = 'xts',
                start_date="2011-01-01",
                end = "2021-10-31") # importando a serie do selic do Bacen

selic <- selic[-c(131),] # retirando o mes de novembro

# 2.1. Checando a periodicidade das series:
periodicity(PETR4.SA)
periodicity(BVSP)
periodicity(CL)
periodicity(selic)

# 3. Graficos das das series:

# Petro:
g1 <-  ggplot(PETR4.SA, aes(time(PETR4.SA), PETR4.SA$PETR4.SA.Adjusted)) + geom_line() +
  scale_x_date(date_labels =  "%m/%Y", date_breaks = "1 year", 
               limits=c(min(time(PETR4.SA)),max(time(PETR4.SA)))) +
  xlab("") + ylab("PETR4") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# ibov
g2 <- ggplot(BVSP, aes(time(BVSP), BVSP$BVSP.Adjusted)) + geom_line() +
  scale_x_date(date_labels =  "%m/%Y", date_breaks = "1 year", 
               limits=c(min(time(BVSP)),max(time(BVSP)))) +
  xlab("") + ylab("BVSP") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Petroleo
g3 <- ggplot(CL, aes(time(CL), CL$`CL=F.Adjusted`)) + geom_line() +
  scale_x_date(date_labels =  "%m/%Y", date_breaks = "1 year", 
               limits=c(min(time(CL)),max(time(CL)))) +
  xlab("") + ylab("Barris de Petroleo") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Selic:
g4 <- ggplot(CL, aes(time(selic), selic$)) + geom_line() +
  scale_x_date(date_labels =  "%m/%Y", date_breaks = "1 year", 
               limits=c(min(time(selic)),max(time(selic)))) +
  xlab("") + ylab("Selic") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# os 3 graficos de cotacoes juntos  
grid.arrange(g1, g2, g3, nrow = 3)

# Selic
ggtsdisplay(selic, ylab = "Selic", xlab = "anos")


# 4. Testando estacionaridade das series:
spetro <- ts(data = PETR4.SA$PETR4.SA.Adjusted, 
             start = c(2011, 1), frequency = 12)

sibov <- ts(data = BVSP$BVSP.Adjusted, 
             start = c(2011, 1), frequency = 12)

scl <- ts(data = CL$`CL=F.Close`, 
             start = c(2011, 1), frequency = 12)

sselic <- ts(data = selic, 
             start = c(2011, 1), frequency = 12)

spetro <- diff(spetro, 1)
sibov <- diff(sibov, 1)
scl <- diff(scl, 1)

##
adf_petro <- ur.df(spetro, lags = 12, type = "drift",
                    selectlags = "AIC")
summary(adf_petro) # nao foi detectada presença de raiz unitária.

##
adf_ibov <- ur.df(sibov, lags = 12, type = "drift",
                     selectlags = "AIC")
summary(adf_ibov) # nao foi detectada presença de raiz unitária.

##
adf_cl <- ur.df(scl, lags = 12, type = "drift",
                    selectlags = "AIC")
summary(adf_cl) # nao foi detectada presença de raiz unitária.
##

##
adf_selic <- ur.df(sselic, lags = 3, type = "drift",
                selectlags = "AIC")
summary(adf_selic) # nao foi detectada presença de raiz unitária.
##

# 5. Calculando retornos mensais petr4, ibov e CL com base no preço ajustado
dados <- merge(monthlyReturn(PETR4.SA[,6],type='arithmetic')[-1,], 
               monthlyReturn(BVSP[,6],type="arithmetic")[-1,],
               monthlyReturn(CL[,6],type="arithmetic")[-1,])

# 5. Juntando os dados petr4, ibov e selic
dados <- merge(dados, as.xts(diff(selic, 1)),join="inner")

# 5.1 Renomeando as colunas
names(dados) <- c("petr4","ibov","barris", "selic")

# 6. Estimando o modelo de regressão do CAPM sem os barris
mod1 <- lm(I(petr4 - selic) ~ I(ibov - selic), data = dados)

# Mostrando os resultados
summary(mod1)
AIC(mod1)
BIC(mod1)

# 6.1. Teste de normalidade e hetero nos residuos:
jb.norm.test(mod1$residuals)
bptest(mod1)
durbinWatsonTest(mod1)
bgtest(mod1)

# 7. Estimando o modelo de regressão do CAPM com os barris
dados2 <- na.omit(dados)

mod2 <- lm(I(petr4 - selic - barris) ~ I(ibov - selic - barris), 
           data = dados2)

# Mostrando os resultados
summary(mod2)
AIC(mod2)
BIC(mod2)

# 7.1. Teste de normalidade e hetero nos residuos:
jb.norm.test(mod2$residuals)
bptest(mod2)
durbinWatsonTest(mod2)
bgtest(mod2)
