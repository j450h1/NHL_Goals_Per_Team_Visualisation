library(readr) #Hadley recently updated this library, why not check it out
getwd()
setwd('./Documents')
list.files()
df <- read_csv('NHL.csv')
View(df)

#Find out which column represents goals scored - should be 53 for Alex
p <- subset(df, df[,11] == "Alex Ovechkin")

#Sort by total number of goals scored
df <- df[order(-df$g1_number),]

#Problem - Some players got traded- we are going to look at their latest teams only

#If the length of the Team string is greater than 3 characters, use last 3 characters as team name

df$TEAM <- ifelse(
  
len(  