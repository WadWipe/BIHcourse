library(arm)
library(tidyverse)
#library(bbmle)
#download this file from the OSF and place it in your working directory
source("read_in_before_exercise.R")
#create a glm with dead patients as dependent variable
#add heparin and aspirin as covariates. 
#For this create a new variable that has all possible factor levels 
#(use e.g. the interaction function)
#also add the follwoing covariates: Age and delay to randomisation
m_1<-glm( )
summary(m_1)
#do the same as above only execute this command before:
my_data$treatment<-relevel(my_data$treatment,ref=4)
#What has changed?
#talk to your neighbour what this may mean....


#now compare the AIC of different models containing combinations of the covariates
#e.g. without treatment or without AGE
?geom_segment



#CAVE interaction

#change for git 