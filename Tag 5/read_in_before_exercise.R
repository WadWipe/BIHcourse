#load libraries
library(tidyverse)
library(arm)
#read in data
#my_data<-read_csv("IST_corrected.csv")
#alternative directly from the web
my_data<-read_csv(url("https://datashare.is.ed.ac.uk/bitstream/handle/10283/128/IST_corrected.csv?sequence=5&isAllowed=y"))
#redo Table 1 from Lancet study
#first create a new variable DDEADC_verb
my_data$FDEAD_verb<-factor(my_data$FDEADC,labels=c("unknown","Initial stroke","Recurrent ischaemic stroke","Haemorrhagic stroke","Coronary heart disease","Pulmonary embolism","Extracranial haemorrhage","Other vascular", "Non-vascular"))
my_data$DDEAD_verb<-factor(my_data$DDEADC,labels=c("unknown","Initial stroke","Recurrent ischaemic stroke","Haemorrhagic stroke","Coronary heart disease","Pulmonary embolism","Extracranial haemorrhage","Other vascular", "Non-vascular"))
#Create Variable for Hep/Asp
my_data$HEP<-ifelse((my_data$RXHEP=="L"|my_data$RXHEP=="M"),"Heparin","No_Heparin")
my_data$ASP<-ifelse(my_data$RXASP=="Y","Asprin","No Aspirin")
my_data$HEP<-ifelse((my_data$RXHEP=="L"|my_data$RXHEP=="M"),"Heparin","No_Heparin")
my_data$ASP<-ifelse(my_data$RXASP=="Y","Asprin","No Aspirin")
table_dt<-
  my_data %>%
  group_by(HEP,DDEAD_verb) %>% 
  filter(!is.na(DDEAD_verb)) %>% 
  summarise(likely_cause=n()) %>% 
  spread(HEP,likely_cause)
names(table_dt)[1]<-c("Deaths and likely causes")
my_data$DEAD_bin<-ifelse(my_data$DDEAD=="Y",1,0)

