#Estatísticas descritivas:
#install.packages("pastecs")
library(pastecs)
library(e1071)
library(moments)
library(Benchmarking)
library(ucminf)
library(lpSolveAPI)
library(dplyr)
library(openxlsx)
library(readxl)

#1. Mudando o diretório (pasta) em que estão os dados
setwd("~/Consultorias/2021/Gutemberg_FUCAP/DEA")


#2. lendo a base de dados
dados_dea <- read_excel("dados_dea_id.xlsx")
#names(dados_dea)

#2.1 Criando ativo total ajustado

dados_dea <- dados_dea %>% mutate(ativo_t_ajus = total_ativo - compensacao)

str(dados_dea)

#3. Estatísticas descritivas:

#3.1 - Criando id:
#names(dados_dea)
#dados_dea$id <- as.numeric(as.factor(dados_dea$cnpj))

#3.2 - Criando nova variável sobras: credoras + devedoras.
#dados_dea <- dados_dea %>% 
#                    mutate(sobras = contas_result_credoras + contas_result_devedoras)
        

summary(dados_dea)

#3.1 2012
dados2012 <- subset(dados_dea, ano == 2012)
est_2012 <- round(stat.desc(subset(dados_dea, ano==2012, select = c("dea","oper_de_credito", "sobras",
                                                "depositos", "despesas_captacao", 
                                                "despesas_adm", "outras_desp_operacionais",
                                                "ativo_t_ajus"))), digits = 4)

#Quantis 25%:
dea <- quantile(dados2012$dea, .25)
oper_de_credito <- quantile(dados2012$oper_de_credito, .25)
sobras <- quantile(dados2012$sobras, .25)
depositos <- quantile(dados2012$depositos, .25) 
despesas_captacao <- quantile(dados2012$despesas_captacao, .25)
despesas_adm <- quantile(dados2012$despesas_adm, .25)
outras_desp_operacionais <- quantile(dados2012$outras_desp_operacionais, .25)
ativo_t_ajus <- quantile(dados2012$ativo_t_ajus, .25)

q25 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                 outras_desp_operacionais, ativo_t_ajus)

est_2012 <- rbind.data.frame(est_2012, q25)

#Quantis 75%:
dea <- quantile(dados2012$dea, .75)
oper_de_credito <- quantile(dados2012$oper_de_credito, .75)
sobras <- quantile(dados2012$sobras, .75)
depositos <- quantile(dados2012$depositos, .75) 
despesas_captacao <- quantile(dados2012$despesas_captacao, .75)
despesas_adm <- quantile(dados2012$despesas_adm, .75)
outras_desp_operacionais <- quantile(dados2012$outras_desp_operacionais, .75)
ativo_t_ajus <- quantile(dados2012$ativo_t_ajus, .75)

q75 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
             outras_desp_operacionais, ativo_t_ajus)

est_2012 <- rbind.data.frame(est_2012, q75)

#Curtose:
dea <- kurtosis(dados2012$dea)
oper_de_credito <- kurtosis(dados2012$oper_de_credito)
sobras <- kurtosis(dados2012$sobras)
depositos <- kurtosis(dados2012$depositos) 
despesas_captacao <- kurtosis(dados2012$despesas_captacao)
despesas_adm <- kurtosis(dados2012$despesas_adm)
outras_desp_operacionais <- kurtosis(dados2012$outras_desp_operacionais)
ativo_t_ajus <- kurtosis(dados2012$ativo_t_ajus)

curtose <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                 outras_desp_operacionais, ativo_t_ajus)

est_2012 <- rbind.data.frame(est_2012, curtose)

#Assimetria:
dea <- skewness(dados2012$dea)
oper_de_credito <- skewness(dados2012$oper_de_credito)
sobras <- skewness(dados2012$sobras)
depositos <- skewness(dados2012$depositos) 
despesas_captacao <- skewness(dados2012$despesas_captacao)
despesas_adm <- skewness(dados2012$despesas_adm)
outras_desp_operacionais <- skewness(dados2012$outras_desp_operacionais)
ativo_t_ajus <- skewness(dados2012$ativo_t_ajus)

assimetria <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                    outras_desp_operacionais, ativo_t_ajus)
                               

est_2012 <- rbind.data.frame(est_2012, assimetria)

est_2012 <- data.frame(est_2012, row.names = c("nbr.val", "nbr.null", "nbr.na", "min", "max",
                                               "range", "sum", "q25", "median", "q75", "mean", "SE.mean", 
                                               "CI.mean.0.95", "var", "std.dev", "coef.var",
                                               "curtose", "assimetria"))

write.xlsx(t(est_2012), "descritivas_2012.xlsx", row.names = T)

###############

#3.2 2013:
dados2013 <- subset(dados_dea, ano == 2013)
est_2013 <- round(stat.desc(subset(dados_dea, ano==2013, select = c("dea","oper_de_credito", "sobras",
                                                                    "depositos", "despesas_captacao", 
                                                                    "despesas_adm", "outras_desp_operacionais",
                                                                    "ativo_t_ajus"))), digits = 4)

#Quantis 25%:
dea <- quantile(dados2013$dea, .25)
oper_de_credito <- quantile(dados2013$oper_de_credito, .25)
sobras <- quantile(dados2013$sobras, .25)
depositos <- quantile(dados2013$depositos, .25) 
despesas_captacao <- quantile(dados2013$despesas_captacao, .25)
despesas_adm <- quantile(dados2013$despesas_adm, .25)
outras_desp_operacionais <- quantile(dados2013$outras_desp_operacionais, .25)
ativo_t_ajus <- quantile(dados2013$ativo_t_ajus, .25)

q25 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
             outras_desp_operacionais, ativo_t_ajus)

est_2013 <- rbind.data.frame(est_2013, q25)

#Quantis 75%:
dea <- quantile(dados2013$dea, .75)
oper_de_credito <- quantile(dados2013$oper_de_credito, .75)
sobras <- quantile(dados2013$sobras, .75)
depositos <- quantile(dados2013$depositos, .75) 
despesas_captacao <- quantile(dados2013$despesas_captacao, .75)
despesas_adm <- quantile(dados2013$despesas_adm, .75)
outras_desp_operacionais <- quantile(dados2013$outras_desp_operacionais, .75)
ativo_t_ajus <- quantile(dados2013$ativo_t_ajus, .75)

q75 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
             outras_desp_operacionais, ativo_t_ajus)

est_2013 <- rbind.data.frame(est_2013, q75)

#Curtose:
dea <- kurtosis(dados2013$dea)
oper_de_credito <- kurtosis(dados2013$oper_de_credito)
sobras <- kurtosis(dados2013$sobras)
depositos <- kurtosis(dados2013$depositos) 
despesas_captacao <- kurtosis(dados2013$despesas_captacao)
despesas_adm <- kurtosis(dados2013$despesas_adm)
outras_desp_operacionais <- kurtosis(dados2013$outras_desp_operacionais)
ativo_t_ajus <- kurtosis(dados2013$ativo_t_ajus)

curtose <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                 outras_desp_operacionais, ativo_t_ajus)

est_2013 <- rbind.data.frame(est_2013, curtose)

#Assimetria:
dea <- skewness(dados2013$dea)
oper_de_credito <- skewness(dados2013$oper_de_credito)
sobras <- skewness(dados2013$sobras)
depositos <- skewness(dados2013$depositos) 
despesas_captacao <- skewness(dados2013$despesas_captacao)
despesas_adm <- skewness(dados2013$despesas_adm)
outras_desp_operacionais <- skewness(dados2013$outras_desp_operacionais)
ativo_t_ajus <- skewness(dados2013$ativo_t_ajus)

assimetria <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                    outras_desp_operacionais, ativo_t_ajus)


est_2013 <- rbind.data.frame(est_2013, assimetria)

est_2013 <- data.frame(est_2013, row.names = c("nbr.val", "nbr.null", "nbr.na", "min", "max",
                                               "range", "sum", "q25", "median", "q75", "mean", "SE.mean", 
                                               "CI.mean.0.95", "var", "std.dev", "coef.var",
                                               "curtose", "assimetria"))

write.xlsx(t(est_2013), "descritivas_2013.xlsx", row.names = T)

#####


#3.4 2014
dados2014 <- subset(dados_dea, ano == 2014)
est_2014 <- round(stat.desc(subset(dados_dea, ano==2014, select = c("dea","oper_de_credito", "sobras",
                                                                    "depositos", "despesas_captacao", 
                                                                    "despesas_adm", "outras_desp_operacionais",
                                                                    "ativo_t_ajus"))), digits = 4)

#Quantis 25%:
dea <- quantile(dados2014$dea, .25)
oper_de_credito <- quantile(dados2014$oper_de_credito, .25)
sobras <- quantile(dados2014$sobras, .25)
depositos <- quantile(dados2014$depositos, .25) 
despesas_captacao <- quantile(dados2014$despesas_captacao, .25)
despesas_adm <- quantile(dados2014$despesas_adm, .25)
outras_desp_operacionais <- quantile(dados2014$outras_desp_operacionais, .25)
ativo_t_ajus <- quantile(dados2014$ativo_t_ajus, .25)

q25 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
             outras_desp_operacionais, ativo_t_ajus)

est_2014 <- rbind.data.frame(est_2014, q25)

#Quantis 75%:
dea <- quantile(dados2014$dea, .75)
oper_de_credito <- quantile(dados2014$oper_de_credito, .75)
sobras <- quantile(dados2014$sobras, .75)
depositos <- quantile(dados2014$depositos, .75) 
despesas_captacao <- quantile(dados2014$despesas_captacao, .75)
despesas_adm <- quantile(dados2014$despesas_adm, .75)
outras_desp_operacionais <- quantile(dados2014$outras_desp_operacionais, .75)
ativo_t_ajus <- quantile(dados2014$ativo_t_ajus, .75)

q75 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
             outras_desp_operacionais, ativo_t_ajus)

est_2014 <- rbind.data.frame(est_2014, q75)

#Curtose:
dea <- kurtosis(dados2014$dea)
oper_de_credito <- kurtosis(dados2014$oper_de_credito)
sobras <- kurtosis(dados2014$sobras)
depositos <- kurtosis(dados2014$depositos) 
despesas_captacao <- kurtosis(dados2014$despesas_captacao)
despesas_adm <- kurtosis(dados2014$despesas_adm)
outras_desp_operacionais <- kurtosis(dados2014$outras_desp_operacionais)
ativo_t_ajus <- kurtosis(dados2014$ativo_t_ajus)

curtose <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                 outras_desp_operacionais, ativo_t_ajus)

est_2014 <- rbind.data.frame(est_2014, curtose)

#Assimetria:
dea <- skewness(dados2014$dea)
oper_de_credito <- skewness(dados2014$oper_de_credito)
sobras <- skewness(dados2014$sobras)
depositos <- skewness(dados2014$depositos) 
despesas_captacao <- skewness(dados2014$despesas_captacao)
despesas_adm <- skewness(dados2014$despesas_adm)
outras_desp_operacionais <- skewness(dados2014$outras_desp_operacionais)
ativo_t_ajus <- skewness(dados2014$ativo_t_ajus)

assimetria <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                    outras_desp_operacionais, ativo_t_ajus)


est_2014 <- rbind.data.frame(est_2014, assimetria)

est_2014 <- data.frame(est_2014, row.names = c("nbr.val", "nbr.null", "nbr.na", "min", "max",
                                               "range", "sum", "q25", "median", "q75", "mean", "SE.mean", 
                                               "CI.mean.0.95", "var", "std.dev", "coef.var",
                                               "curtose", "assimetria"))

write.xlsx(t(est_2014), "descritivas_2014.xlsx", row.names = T)
####

#3.3 2015:
dados2015 <- subset(dados_dea, ano == 2015)
est_2015 <- round(stat.desc(subset(dados_dea, ano==2015, select = c("dea","oper_de_credito", "sobras",
                                                                    "depositos", "despesas_captacao", 
                                                                    "despesas_adm", "outras_desp_operacionais",
                                                                    "ativo_t_ajus"))), digits = 4)

#Quantis 25%:
dea <- quantile(dados2015$dea, .25)
oper_de_credito <- quantile(dados2015$oper_de_credito, .25)
sobras <- quantile(dados2015$sobras, .25)
depositos <- quantile(dados2015$depositos, .25) 
despesas_captacao <- quantile(dados2015$despesas_captacao, .25)
despesas_adm <- quantile(dados2015$despesas_adm, .25)
outras_desp_operacionais <- quantile(dados2015$outras_desp_operacionais, .25)
ativo_t_ajus <- quantile(dados2015$ativo_t_ajus, .25)

q25 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
             outras_desp_operacionais, ativo_t_ajus)

est_2015 <- rbind.data.frame(est_2015, q25)

#Quantis 75%:
dea <- quantile(dados2015$dea, .75)
oper_de_credito <- quantile(dados2015$oper_de_credito, .75)
sobras <- quantile(dados2015$sobras, .75)
depositos <- quantile(dados2015$depositos, .75) 
despesas_captacao <- quantile(dados2015$despesas_captacao, .75)
despesas_adm <- quantile(dados2015$despesas_adm, .75)
outras_desp_operacionais <- quantile(dados2015$outras_desp_operacionais, .75)
ativo_t_ajus <- quantile(dados2015$ativo_t_ajus, .75)

q75 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
             outras_desp_operacionais, ativo_t_ajus)

est_2015 <- rbind.data.frame(est_2015, q75)

#Curtose:
dea <- kurtosis(dados2015$dea)
oper_de_credito <- kurtosis(dados2015$oper_de_credito)
sobras <- kurtosis(dados2015$sobras)
depositos <- kurtosis(dados2015$depositos) 
despesas_captacao <- kurtosis(dados2015$despesas_captacao)
despesas_adm <- kurtosis(dados2015$despesas_adm)
outras_desp_operacionais <- kurtosis(dados2015$outras_desp_operacionais)
ativo_t_ajus <- kurtosis(dados2015$ativo_t_ajus)

curtose <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                 outras_desp_operacionais, ativo_t_ajus)

est_2015 <- rbind.data.frame(est_2015, curtose)

#Assimetria:
dea <- skewness(dados2015$dea)
oper_de_credito <- skewness(dados2015$oper_de_credito)
sobras <- skewness(dados2015$sobras)
depositos <- skewness(dados2015$depositos) 
despesas_captacao <- skewness(dados2015$despesas_captacao)
despesas_adm <- skewness(dados2015$despesas_adm)
outras_desp_operacionais <- skewness(dados2015$outras_desp_operacionais)
ativo_t_ajus <- skewness(dados2015$ativo_t_ajus)

assimetria <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                    outras_desp_operacionais, ativo_t_ajus)


est_2015 <- rbind.data.frame(est_2015, assimetria)

est_2015 <- data.frame(est_2015, row.names = c("nbr.val", "nbr.null", "nbr.na", "min", "max",
                                               "range", "sum", "q25", "median", "q75", "mean", "SE.mean", 
                                               "CI.mean.0.95", "var", "std.dev", "coef.var",
                                               "curtose", "assimetria"))

write.xlsx(t(est_2015), "descritivas_2015.xlsx", row.names = T)
####


#3.5 2016:
dados2016 <- subset(dados_dea, ano == 2016)
est_2016 <- round(stat.desc(subset(dados_dea, ano==2016, select = c("dea","oper_de_credito", "sobras",
                                                                    "depositos", "despesas_captacao", 
                                                                    "despesas_adm", "outras_desp_operacionais",
                                                                    "ativo_t_ajus"))), digits = 4)

#Quantis 25%:
dea <- quantile(dados2016$dea, .25)
oper_de_credito <- quantile(dados2016$oper_de_credito, .25)
sobras <- quantile(dados2016$sobras, .25)
depositos <- quantile(dados2016$depositos, .25) 
despesas_captacao <- quantile(dados2016$despesas_captacao, .25)
despesas_adm <- quantile(dados2016$despesas_adm, .25)
outras_desp_operacionais <- quantile(dados2016$outras_desp_operacionais, .25)
ativo_t_ajus <- quantile(dados2016$ativo_t_ajus, .25)

q25 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
             outras_desp_operacionais, ativo_t_ajus)

est_2016 <- rbind.data.frame(est_2016, q25)

#Quantis 75%:
dea <- quantile(dados2016$dea, .75)
oper_de_credito <- quantile(dados2016$oper_de_credito, .75)
sobras <- quantile(dados2016$sobras, .75)
depositos <- quantile(dados2016$depositos, .75) 
despesas_captacao <- quantile(dados2016$despesas_captacao, .75)
despesas_adm <- quantile(dados2016$despesas_adm, .75)
outras_desp_operacionais <- quantile(dados2016$outras_desp_operacionais, .75)
ativo_t_ajus <- quantile(dados2016$ativo_t_ajus, .75)

q75 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
             outras_desp_operacionais, ativo_t_ajus)

est_2016 <- rbind.data.frame(est_2016, q75)

#Curtose:
dea <- kurtosis(dados2016$dea)
oper_de_credito <- kurtosis(dados2016$oper_de_credito)
sobras <- kurtosis(dados2016$sobras)
depositos <- kurtosis(dados2016$depositos) 
despesas_captacao <- kurtosis(dados2016$despesas_captacao)
despesas_adm <- kurtosis(dados2016$despesas_adm)
outras_desp_operacionais <- kurtosis(dados2016$outras_desp_operacionais)
ativo_t_ajus <- kurtosis(dados2016$ativo_t_ajus)

curtose <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                 outras_desp_operacionais, ativo_t_ajus)

est_2016 <- rbind.data.frame(est_2016, curtose)

#Assimetria:
dea <- skewness(dados2016$dea)
oper_de_credito <- skewness(dados2016$oper_de_credito)
sobras <- skewness(dados2016$sobras)
depositos <- skewness(dados2016$depositos) 
despesas_captacao <- skewness(dados2016$despesas_captacao)
despesas_adm <- skewness(dados2016$despesas_adm)
outras_desp_operacionais <- skewness(dados2016$outras_desp_operacionais)
ativo_t_ajus <- skewness(dados2016$ativo_t_ajus)

assimetria <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                    outras_desp_operacionais, ativo_t_ajus)


est_2016 <- rbind.data.frame(est_2016, assimetria)

est_2016 <- data.frame(est_2016, row.names = c("nbr.val", "nbr.null", "nbr.na", "min", "max",
                                               "range", "sum", "q25", "median", "q75", "mean", "SE.mean", 
                                               "CI.mean.0.95", "var", "std.dev", "coef.var",
                                               "curtose", "assimetria"))

write.xlsx(t(est_2016), "descritivas_2016.xlsx", row.names = T)
####


#3.6. 2017:
dados2017 <- subset(dados_dea, ano == 2017)
est_2017 <- round(stat.desc(subset(dados_dea, ano==2017, select = c("dea","oper_de_credito", "sobras",
                                                                    "depositos", "despesas_captacao", 
                                                                    "despesas_adm", "outras_desp_operacionais",
                                                                    "ativo_t_ajus"))), digits = 4)

#Quantis 25%:
dea <- quantile(dados2017$dea, .25)
oper_de_credito <- quantile(dados2017$oper_de_credito, .25)
sobras <- quantile(dados2017$sobras, .25)
depositos <- quantile(dados2017$depositos, .25, na.rm = T) 
despesas_captacao <- quantile(dados2017$despesas_captacao, .25)
despesas_adm <- quantile(dados2017$despesas_adm, .25)
outras_desp_operacionais <- quantile(dados2017$outras_desp_operacionais, .25)
ativo_t_ajus <- quantile(dados2017$ativo_t_ajus, .25)

q25 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
             outras_desp_operacionais, ativo_t_ajus)

est_2017 <- rbind.data.frame(est_2017, q25)

#Quantis 75%:
dea <- quantile(dados2017$dea, .75)
oper_de_credito <- quantile(dados2017$oper_de_credito, .75)
sobras <- quantile(dados2017$sobras, .75)
depositos <- quantile(dados2017$depositos, .75, na.rm = T) 
despesas_captacao <- quantile(dados2017$despesas_captacao, .75)
despesas_adm <- quantile(dados2017$despesas_adm, .75)
outras_desp_operacionais <- quantile(dados2017$outras_desp_operacionais, .75)
ativo_t_ajus <- quantile(dados2017$ativo_t_ajus, .75)

q75 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
             outras_desp_operacionais, ativo_t_ajus)

est_2017 <- rbind.data.frame(est_2017, q75)

#Curtose:
dea <- kurtosis(dados2017$dea)
oper_de_credito <- kurtosis(dados2017$oper_de_credito)
sobras <- kurtosis(dados2017$sobras)
depositos <- kurtosis(dados2017$depositos, na.rm = T) 
despesas_captacao <- kurtosis(dados2017$despesas_captacao)
despesas_adm <- kurtosis(dados2017$despesas_adm)
outras_desp_operacionais <- kurtosis(dados2017$outras_desp_operacionais)
ativo_t_ajus <- kurtosis(dados2017$ativo_t_ajus)

curtose <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                 outras_desp_operacionais, ativo_t_ajus)

est_2017 <- rbind.data.frame(est_2017, curtose)

#Assimetria:
dea <- skewness(dados2017$dea)
oper_de_credito <- skewness(dados2017$oper_de_credito)
sobras <- skewness(dados2017$sobras)
depositos <- skewness(dados2017$depositos, na.rm = T) 
despesas_captacao <- skewness(dados2017$despesas_captacao)
despesas_adm <- skewness(dados2017$despesas_adm)
outras_desp_operacionais <- skewness(dados2017$outras_desp_operacionais)
ativo_t_ajus <- skewness(dados2017$ativo_t_ajus)

assimetria <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                    outras_desp_operacionais, ativo_t_ajus)


est_2017 <- rbind.data.frame(est_2017, assimetria)

est_2017 <- data.frame(est_2017, row.names = c("nbr.val", "nbr.null", "nbr.na", "min", "max",
                                               "range", "sum", "q25", "median", "q75", "mean", "SE.mean", 
                                               "CI.mean.0.95", "var", "std.dev", "coef.var",
                                               "curtose", "assimetria"))

write.xlsx(t(est_2017), "descritivas_2017.xlsx", row.names = T)
####


#3.7. 2018:
dados2018 <- subset(dados_dea, ano == 2018)
est_2018 <- round(stat.desc(subset(dados_dea, ano==2018, select = c("dea","oper_de_credito", "sobras",
                                                                    "depositos", "despesas_captacao", 
                                                                    "despesas_adm", "outras_desp_operacionais",
                                                                    "ativo_t_ajus"))), digits = 4)

#Quantis 25%:
dea <- quantile(dados2018$dea, .25)
oper_de_credito <- quantile(dados2018$oper_de_credito, .25)
sobras <- quantile(dados2018$sobras, .25)
depositos <- quantile(dados2018$depositos, .25, na.rm = T) 
despesas_captacao <- quantile(dados2018$despesas_captacao, .25)
despesas_adm <- quantile(dados2018$despesas_adm, .25)
outras_desp_operacionais <- quantile(dados2018$outras_desp_operacionais, .25)
ativo_t_ajus <- quantile(dados2018$ativo_t_ajus, .25)

q25 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
             outras_desp_operacionais, ativo_t_ajus)

est_2018 <- rbind.data.frame(est_2018, q25)

#Quantis 75%:
dea <- quantile(dados2018$dea, .75)
oper_de_credito <- quantile(dados2018$oper_de_credito, .75)
sobras <- quantile(dados2018$sobras, .75)
depositos <- quantile(dados2018$depositos, .75, na.rm = T) 
despesas_captacao <- quantile(dados2018$despesas_captacao, .75)
despesas_adm <- quantile(dados2018$despesas_adm, .75)
outras_desp_operacionais <- quantile(dados2018$outras_desp_operacionais, .75)
ativo_t_ajus <- quantile(dados2018$ativo_t_ajus, .75)

q75 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
             outras_desp_operacionais, ativo_t_ajus)

est_2018 <- rbind.data.frame(est_2018, q75)

#Curtose:
dea <- kurtosis(dados2018$dea)
oper_de_credito <- kurtosis(dados2018$oper_de_credito)
sobras <- kurtosis(dados2018$sobras)
depositos <- kurtosis(dados2018$depositos, na.rm = T) 
despesas_captacao <- kurtosis(dados2018$despesas_captacao)
despesas_adm <- kurtosis(dados2018$despesas_adm)
outras_desp_operacionais <- kurtosis(dados2018$outras_desp_operacionais)
ativo_t_ajus <- kurtosis(dados2018$ativo_t_ajus)

curtose <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                 outras_desp_operacionais, ativo_t_ajus)

est_2018 <- rbind.data.frame(est_2018, curtose)

#Assimetria:
dea <- skewness(dados2018$dea)
oper_de_credito <- skewness(dados2018$oper_de_credito)
sobras <- skewness(dados2018$sobras)
depositos <- skewness(dados2018$depositos, na.rm = T) 
despesas_captacao <- skewness(dados2018$despesas_captacao)
despesas_adm <- skewness(dados2018$despesas_adm)
outras_desp_operacionais <- skewness(dados2018$outras_desp_operacionais)
ativo_t_ajus <- skewness(dados2018$ativo_t_ajus)

assimetria <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                    outras_desp_operacionais, ativo_t_ajus)


est_2018 <- rbind.data.frame(est_2018, assimetria)

est_2018 <- data.frame(est_2018, row.names = c("nbr.val", "nbr.null", "nbr.na", "min", "max",
                                               "range", "sum", "q25", "median", "q75", "mean", "SE.mean", 
                                               "CI.mean.0.95", "var", "std.dev", "coef.var",
                                               "curtose", "assimetria"))

write.xlsx(t(est_2018), "descritivas_2018.xlsx", row.names = T)
####

#3.9. 2019:
dados2019 <- subset(dados_dea, ano == 2019)
est_2019 <- round(stat.desc(subset(dados_dea, ano==2019, select = c("dea","oper_de_credito", "sobras",
                                                                    "depositos", "despesas_captacao", 
                                                                    "despesas_adm", "outras_desp_operacionais",
                                                                    "ativo_t_ajus"))), digits = 4)

#Quantis 25%:
dea <- quantile(dados2019$dea, .25, na.rm = T)
oper_de_credito <- quantile(dados2019$oper_de_credito, .25, na.rm = T)
sobras <- quantile(dados2019$sobras, .25, na.rm = T)
depositos <- quantile(dados2019$depositos, .25, na.rm = T) 
despesas_captacao <- quantile(dados2019$despesas_captacao, .25, na.rm = T)
despesas_adm <- quantile(dados2019$despesas_adm, .25, na.rm = T)
outras_desp_operacionais <- quantile(dados2019$outras_desp_operacionais, .25, na.rm = T)
ativo_t_ajus <- quantile(dados2019$ativo_t_ajus, .25, na.rm = T)

q25 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
             outras_desp_operacionais, ativo_t_ajus)

est_2019 <- rbind.data.frame(est_2019, q25)

#Quantis 75%:
dea <- quantile(dados2019$dea, .75, na.rm = T)
oper_de_credito <- quantile(dados2019$oper_de_credito, .75, na.rm = T)
sobras <- quantile(dados2019$sobras, .75, na.rm = T)
depositos <- quantile(dados2019$depositos, .75, na.rm = T) 
despesas_captacao <- quantile(dados2019$despesas_captacao, .75, na.rm = T)
despesas_adm <- quantile(dados2019$despesas_adm, .75, na.rm = T)
outras_desp_operacionais <- quantile(dados2019$outras_desp_operacionais, .75, na.rm = T)
ativo_t_ajus <- quantile(dados2019$ativo_t_ajus, .75, na.rm = T)

q75 <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
             outras_desp_operacionais, ativo_t_ajus)

est_2019 <- rbind.data.frame(est_2019, q75)

#Curtose:
dea <- kurtosis(dados2019$dea, na.rm = T)
oper_de_credito <- kurtosis(dados2019$oper_de_credito, na.rm = T)
sobras <- kurtosis(dados2019$sobras, na.rm = T)
depositos <- kurtosis(dados2019$depositos, na.rm = T) 
despesas_captacao <- kurtosis(dados2019$despesas_captacao, na.rm = T)
despesas_adm <- kurtosis(dados2019$despesas_adm, na.rm = T)
outras_desp_operacionais <- kurtosis(dados2019$outras_desp_operacionais, na.rm = T)
ativo_t_ajus <- kurtosis(dados2019$ativo_t_ajus, na.rm = T)

curtose <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                 outras_desp_operacionais, ativo_t_ajus)

est_2019 <- rbind.data.frame(est_2019, curtose)

#Assimetria:
dea <- skewness(dados2019$dea, na.rm = T)
oper_de_credito <- skewness(dados2019$oper_de_credito, na.rm = T)
sobras <- skewness(dados2019$sobras, na.rm = T)
depositos <- skewness(dados2019$depositos, na.rm = T) 
despesas_captacao <- skewness(dados2019$despesas_captacao, na.rm = T)
despesas_adm <- skewness(dados2019$despesas_adm, na.rm = T)
outras_desp_operacionais <- skewness(dados2019$outras_desp_operacionais, na.rm = T)
ativo_t_ajus <- skewness(dados2019$ativo_t_ajus, na.rm = T)

assimetria <- cbind(dea, oper_de_credito, sobras, depositos, despesas_captacao, despesas_adm,
                    outras_desp_operacionais, ativo_t_ajus)


est_2019 <- rbind.data.frame(est_2019, assimetria)

est_2019 <- data.frame(est_2019, row.names = c("nbr.val", "nbr.null", "nbr.na", "min", "max",
                                               "range", "sum", "q25", "median", "q75", "mean", "SE.mean", 
                                               "CI.mean.0.95", "var", "std.dev", "coef.var",
                                               "curtose", "assimetria"))

write.xlsx(t(est_2019), "descritivas_2019.xlsx", row.names = T)
########################
