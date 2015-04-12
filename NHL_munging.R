library(readr) #Hadley recently updated this library, why not check it out
getwd()
setwd('./NHL_Goals_Per_Team_Visualisation')
list.files()
df <- read_csv('NHL.csv')
View(df)

#Find out which column represents goals scored - should be 53 for Alex
p <- subset(df, df[,11] == "Alex Ovechkin")

#Sort by total number of goals scored
df <- df[order(-df$g1_number),]
View(df)
#Problem - Some players got traded- we are going to look at their latest teams only

#If the length of the Team string is greater than 3 characters, use last 3 characters as team name

#last three characters of the team
last_three <- substr(df$team, nchar(df$team) - 2, nchar(df$team))
#new variable for this
df$TEAM <- ifelse(nchar(df$team) == 3, df$team, last_three)
#30 unique teams in NHL - verified on google
table(df$TEAM)

library(dplyr)
#Group by team, total goals
finaldf <- df %>%
           select(TEAM, GOALS = g1_number) %>%
           group_by(TEAM) %>%
           summarise(TOTAL_GOALS = sum(GOALS)) %>%
           arrange(TOTAL_GOALS)
View(finaldf)
#Export out
write.csv(finaldf,'NHL_clean.csv')

# re-order the levels in the order of appearance in the data.frame 
finaldf$TEAM <- factor(finaldf$TEAM, as.character(finaldf$TEAM))
# make all colors, except Calgary and Vancouver 
finaldf$COLORS <- "ghostwhite"
#Vancouver's colors are predominantly blue, 3rd column is color
finaldf[finaldf$TEAM == "VAN",3] <- "blue"
#Calgary's colors are predominantly orange, 3rd column is color  
finaldf[finaldf$TEAM == "CGY",3] <- "darkorange"
#We only need to show labels for Vancouver and Calgary
finaldf$labels <- ""
finaldf[finaldf$TEAM == "VAN",4] <- finaldf[which(finaldf$TEAM == "VAN"),2] #2nd col is TOTAL_GOALS
finaldf[finaldf$TEAM == "CGY",4] <- finaldf[which(finaldf$TEAM == "CGY"),2] #2nd col is TOTAL_GOALS
#NHL Logo
# library(png)
# library(grid)
# library(jpeg)
# flames_img <- readJPEG("flames.jpeg") #Calgary flames logo
# canucks_img <- readJPEG("canucks.jpeg") #Vancouver canucks logo
# f <- rasterGrob(flames_img, interpolate=TRUE)
# c <- rasterGrob(canucks_img, interpolate=TRUE)
#Test out some visualisations
library(ggplot2)
ggplot(aes(x=TEAM,y=TOTAL_GOALS), data=finaldf) + 
  geom_bar(stat="identity", fill = finaldf$COLORS, color = "black") +
  theme_bw() +
  geom_text(aes(x=TEAM,y=TOTAL_GOALS + 10,label=finaldf$labels),vjust=0) +
  scale_y_discrete(breaks=seq(0, 250, by=10)) +
  ylab("TOTAL GOALS AGAINST (2014-2015 REGULAR SEASON)") +
  ggtitle("TOTAL GOALS SCORED BY TEAMS IN THE NHL \n(National Hockey League)") +
  coord_flip()

ggsave(file="goals_barchart.jpeg", scale=2)




  

