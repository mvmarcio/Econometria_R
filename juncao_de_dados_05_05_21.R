# Juntando os dados

#1. Importando pacotes
library(dplyr) #ligar os municípios.
library(tidyr) #liga os municípios.
library(tidyverse)
library(readxl) #para ler arquivos em Excel.
library(openxlsx) #Exportar arquivos em Excel. 

#2. Alterando o diretório
setwd("~/Dissertacao/2021/Liara_Darabas_RS_UFRGS/Dados")

#3. Importando os dados

#3.1. PIB
pib <- read_excel("painel_modelo_05_05.xls", 
                  sheet = "pib")
#3.2. Exportações
export <- read_excel("painel_modelo_05_05.xls", 
                     sheet = "exp")

#3.3. Importações:
import <- read_excel("painel_modelo_05_05.xls", 
           sheet = "import")

#3.4. Vínculos Empregatícios sem Indústria
vinc_sem_ind <- read_excel("painel_modelo_05_05.xls", 
                           sheet = "vinc_sem_ind")

#3.5. Vínculos Empregatícios da Indústria
vinc_ind <- read_excel("painel_modelo_05_05.xls", 
                       sheet = "vinculos_ind")

#3.5. População
pop <- read_excel("painel_modelo_05_05.xls", 
                  sheet = "pop")

#3.6. Fundeb:
fundeb <- read_excel("painel_modelo_05_05.xls", 
                     sheet = "fundeb")

#2. Juntando os dados via municipios
base1 <- inner_join(pib, export, by = c("municipio", "ano"))
base2 <- inner_join(base1, import, by = c("municipio", "ano"))
base3 <- inner_join(base2, vinc_sem_ind, by = c("municipio", "ano"))
base4 <- inner_join(base3, vinc_ind, by = c("municipio", "ano"))
base5 <- inner_join(base4, pop, by = c("municipio", "ano"))
base6 <- inner_join(base5, fundeb, by = c("municipio", "ano"))

painel_sc <- base6

#3. Vamos criar um id para os municípios
painel_sc$id <- as.numeric(as.factor(painel_sc$municipio))

#4. Exportando dados:
write.xlsx(painel_sc, "painel_sc.xlsx")
