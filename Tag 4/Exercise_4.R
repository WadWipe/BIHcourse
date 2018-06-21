################
#plotting
###############
#create a plot with percentage dead patients per gender and per treatment (HEP/ASP yes,no)
#############
#load libraries
library(tidyverse)
library(formattable)
#read in data
#my_data<-read_csv("IST_corrected.csv")
#directly from online source
my_data<-read.csv(url("https://datashare.is.ed.ac.uk/bitstream/handle/10283/128/IST_corrected.csv?sequence=5&isAllowed=y"))
####
#create a data frame for plotting
####
my_data$HEP<-ifelse((my_data$RXHEP=="N"),"No Heparin","Heparin")
my_data$ASP<-ifelse(my_data$RXASP=="Y","Aspirin","No Aspirin")
plot_data <- 
  #based on my_data
  my_data %>% mutate(DDEAD2 = ifelse(DDEAD=="Y",1,0))%>% mutate(Treatment = paste(HEP,"\n",ASP, sep= "")) %>% group_by(SEX, HEP,ASP, Treatment) %>%
  summarise(N_Group = n(),N_Dead = sum(DDEAD2),Percents_Died = N_Dead/N_Group, SD = sd(DDEAD2),
            SEM = SD/sqrt(N_Group)) 
  
  #create a new variable (T/F) whether a patient is dead from DDEAD variable
  #reason for this is: we cannot calculate means across "Y" and "N" values
  
  #group the analysis by the variables of interest (SEX, Heparin or Aspirin Treatment)
  
  #Now summarise the percentage and SEM, calculate for the plot also mean plus/minus sem
  
ggplot(plot_data, aes(x= Treatment,y=Percents_Died)) + geom_bar(stat="identity", alpha=0.8)+
  geom_errorbar(aes(x=Treatment, ymax=SEM+Percents_Died,ymin=-SEM+Percents_Died, width= 0.5))  + facet_wrap(~SEX)
  #now create a barplot with error bars
  #how can you create a combined factor from ASP HEP?
  #also create two separate facets for male and female



#######
#often we need to visualize binary variables
#here we use an example
#death of patient after # days after randomisation in dependence of AGE  
#FDEADD vs AGE
#######
my_data$DEAD <- ifelse(my_data$DDEADD<=14,my_data$DDEADC,9)
#recode NAs as alive (again using 9 as a code)
my_data$DEAD<-ifelse(is.na(my_data$DEAD),9,my_data$DEAD)
my_data$DEAD_bin<-ifelse(my_data$DEAD!=9,1,0)
ggplot(aes(y=DEAD_bin,x=AGE),data=my_data)+geom_point()+geom_smooth()
#this is not a nice representation!
#we need something better!
#see for example here: 
#https://doi.org/10.1890/0012-9623(2004)85[100:ANMOPT]2.0.CO;2
#also as pdf on osf
#first summarise the data in a histogram format
#Summarise data to create histogram counts
#what is the min and max age?
min(my_data$AGE)
max(my_data$AGE)
#looking at this I decide to start at 10 years until 100 years in steps of 1
breaks1 <- c(1:100)
breaks2 <- c(0:99)
hist_data = my_data %>% mutate(agecut = cut(AGE, breaks = breaks1))%>%
  #first add new variable that codes breaks

  #then group by dead/alive and the breaks
  group_by(AGE, DDEAD)%>%
  #count
  summarise(N=n())%>% mutate(Living = )
  #if patients are dead, we want them to show on top with histogram on top so you need to 
  #calculate in this case the percentage as 1-percentage
  
  
  ####

##########################solution################################

hist_data = my_data %>% 
  #first add new variable that codes breaks
  mutate(breaks = findInterval(AGE, seq(10,100,1))) %>%
  #then group by dead/alive and the breaks
  group_by(DEAD_bin, breaks) %>% 
  #count
  summarise(n = n()) %>%
  #if patients are dead, we want them to show on top with histogram on top so you need to 
  #calculate in this case the percentage as 1-percentage
  mutate(pct = ifelse(DEAD_bin==0, n/sum(n), 1 - n/sum(n)),breaks=seq(10,100,1)[breaks])

ggplot() + #this just sets an empty frame to build upon
  #first add a histopgram with geom_segment use the help of geom_segment
  geom_segment(data=hist_data, size=2, show.legend=FALSE,
               aes(x=breaks, xend=breaks, y=DEAD_bin, yend=pct, colour=factor(DEAD_bin)))+
  #then predict a logistic regression via stat_smooth and the glm method (we will cover the details in the next session)
  stat_smooth(data=my_data,aes(y=DEAD_bin,x=AGE),method="glm", method.args = list(family = "binomial"))+
  #some cosmetics 
  scale_y_continuous(limits=c(-0.02,1.02)) +
  scale_x_continuous(limits=c(15,101)) +
  theme_bw(base_size=12)+
  ylab("Patient Alive=0/Dead=1")+xlab("Age")



#now plot this
####
ggplot() + #this just sets an empty frame to build upon
  #first add a histopgram with geom_segment use the help of geom_segment
  geom_segment()+
  #then predict a logistic regression via stat_smooth and the glm method (we will cover the details in the next session)
  stat_smooth()+
  #some cosmetics 
  scale_y_continuous(limits=c(-0.02,1.02)) +
  scale_x_continuous(limits=c(15,101)) +
  theme_bw(base_size=12)+
  ylab("Patient Alive=0/Dead=1")+xlab("Age")

model <- lm(data=my_data, DEAD_bin~AGE)
?model.extract()
install.packages("car")
library(car)
qqPlot(model)
#####
#find here more interesting visualisations
#http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html
#####