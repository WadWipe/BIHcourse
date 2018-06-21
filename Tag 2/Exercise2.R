########
#Vectorisation vs loops
#some additional thoughts on vectorisation:_
#http://www.noamross.net/blog/2014/4/16/vectorization-in-r--why.html
#read if finished with this exercise early
######
setwd("D:/R Skripte Doktorarbeit/R Workspace/Statistikcourse BIH 18 intermediate/Tag 2")

#consider the following example of a
#Loop
x <- 1:5
y <- 6:10
z <- NULL
for (i in c(1:4)) {
  z <- c(z, x[i] + y[i])
}

#VS a vectorized approach
x <- 1:5
y <- 6:10
z <- x + y

###
#you want to create a vector which returns True/False if an element in a vector equals the previous element
#write this in a vectorized format:
###
binary.vector<-rbinom(100,1,0.5)
check.vector1<-NULL
#example with a loop
#the first entry has no previous element
check.vector1[1]<-FALSE
#for loop
for (i in 2:length(binary.vector)){
  if(binary.vector[i]==binary.vector[i-1]) check.vector1[i]<-TRUE else check.vector1[i]<-FALSE
}

#vectorised
check_vector2 <- vector()
check_vector2[1] <- F
test_vector <- c(check_vector2[1], binary.vector)
test_vector 

compare <- test_vector[1:100] == binary.vector
check.vector2 <- compare
check.vector1
#check whether both give the same result
#in a vectorised format (compare check.vector1 and check.vector2 without for loop)
compared_vectors  <- check.vector2 == check.vector1
compared_vectors


#ifelse
#conditional statements vectorized!
my_data<-data.frame(y=runif(100,0,5))
#assign a variable check the value TRUE if y is larger than 0 or FALSE if it is smaller (or equal to 0)
greater_zero_check  <-my_data$y > 0  
my_data


#read in data directly from the web
#we will use data from an older Lancet study
my_data<-read.csv(url("https://datashare.is.ed.ac.uk/bitstream/handle/10283/128/IST_corrected.csv?sequence=5&isAllowed=y"))
#we will try to redo some of the results from the paper

#first create some labels to two Variables
#redo Table 1 from Lancet study
#first create a new variable DDEADC_verb
#This is taken from the 
my_data$FDEAD_verb<-factor(my_data$FDEADC,labels=c("unknown","Initial stroke","Recurrent ischaemic stroke","Haemorrhagic stroke","Coronary heart disease","Pulmonary embolism","Extracranial haemorrhage","Other vascular", "Non-vascular"))
my_data$DDEAD_verb<-factor(my_data$DDEADC,labels=c("unknown","Initial stroke","Recurrent ischaemic stroke","Haemorrhagic stroke","Coronary heart disease","Pulmonary embolism","Extracranial haemorrhage","Other vascular", "Non-vascular"))

# now Create Variables for Heparin (coded in RXHEP) and Aspirin (RXASP) that state whether Heparin or Aspirin was given
#use the ifelse statement!
heparin <- ifelse(my_data$RXHEP=="N",F,T)
heparin
my_data$RXHEP










