setwd("~/Documents/Refugee")
UNdata_Export_20151118_154311015 <- read.csv("~/Documents/Refugee/UNdata_Export_20151118_154311015.csv", header=FALSE)
library(plyr)

#pull in UN refugee data
UN <- data.frame(UNdata_Export_20151118_154311015)
UN <- rename(UN, c("V1"="Asylum", "V2"="Origin", "V3" = 'Year', "V7"="Refugees"))
UN$V4<-NULL
UN$V5<-NULL
UN$V6<- NULL
UN <- UN[-c(1), ]

#subset by 2013, making a smaller data set to work with first, easier to check
UN2013 <- subset(UN, UN$Year ==  2013)
UN2013$Year<- NULL

#aggregation of the 2013 data
library(reshape2)
UN2013$Refugees <- as.integer(UN2013$Refugees)
UN2013_2 <- acast(UN2013, UN2013$Asylum ~ UN2013$Origin, sum)
write.csv(UN2013_2, file = "~/Documents/Refugee/2013.csv")
table1 <- tapply(UN2013$Refugees, UN2013$Origin, FUN=sum)
table2 <- tapply(UN2013$Refugees, UN2013$Asylum, FUN=sum)
country_region <- read.csv("~/Documents/Refugee/country_region.csv", comment.char="#")

#merge with region data
UN2013_5 <- merge(UN2013, country_region, by.x = 'Asylum', by.y = 'Country', all.x = TRUE)
UN2013_5 <- rename(UN2013_5, c("Region"="AsylumRegion"))
UN2013_5 <- merge(UN2013_5, country_region, by.x = 'Origin', by.y = 'Country', all.x = TRUE)
UN2013_5 <- rename(UN2013_5, c("Region"="OriginRegion"))

#to do (items that did not merge, special characters)
UN2013_5$AsylumRegion[which(UN2013_5$Asylum == "Côte d'Ivoire")] <- 'Western Africa'
UN2013_5$OriginRegion[which(UN2013_5$Origin == 'Serbia (and Kosovo: S/RES/1244 (1999))')] <- 'Southern Europe'
UN2013_5$OriginRegion[which(UN2013_5$Origin == "Dem. People's Rep. of Korea")] <- 'Eastern Asia'

#Working out the kinks in mergeing the data, cleaning special characters
UN2013_5 <- rename(UN2013_5, c("Region"="AsylumRegion"))
UN2013_5$AsylumRegion[which(UN2013_5$Asylum == "Côte d'Ivoire")] <- "Western Africa"
UN2013_5$AsylumRegion[which(UN2013_5$Asylum == "Curaçao")] <- "Caribbean"
UN2013_5 <- merge(UN2013_5, country_region, by.x = 'Origin', by.y = 'Country', all.x = TRUE)
UN2013_5 <- rename(UN2013_5, c("Region"="OriginRegion"))
UN2013_5$OriginRegion[which(UN2013_5$Origin == "Côte d'Ivoire")] <- "Western Africa"
UN2013_5$OriginRegion[which(UN2013_5$Origin == "Curaçao")] <- "Caribbean"
write.csv(UN2013_5, file = "~/Documents/Refugee/2013_5.csv")


#applying methods to UN dataset (not divied up by year)
UN_2 <- merge(UN, country_region, by.x = 'Origin', by.y = 'Country', all.x = TRUE )
UN_2 <- rename(UN_2, c("Region"="OriginRegion"))
UN_2 <- merge(UN_2, country_region, by.x = 'Asylum', by.y = 'Country', all.x = TRUE )
UN_2 <- rename(UN_2, c("Region"="AsylumRegion"))

UN_2clean <- UN_2$Refugees[which(is.na(UN_2$AsylumRegion) | is.na(UN_2$AsylumRegion) )]
UN_2$AsylumRegion[which(UN_2$Asylum == "Norway")] <- "Northern Europe"
UN_2$AsylumRegion[which(UN_2$Asylum == "Estonia")] <- "Northern Europe"
UN_2$AsylumRegion[which(UN_2$Asylum == "Côte d'Ivoire")] <- "Western Africa"
UN_2$AsylumRegion[which(UN_2$Asylum == "Curaçao")] <- "Caribbean"

UN_2$AsylumRegion[is.na(UN_2$AsylumRegion)] <- 'Various'
write.csv(UN_2, file = "~/Documents/Refugee/allyears.csv")

#formatting data for specific chart usage
UN_3 <- UN_2

UN_POP_5 <- merge (UN_POP_4, UNPOP_2, by.x = c("Country", "Year"), by.y = c("Region", "variable"), all.x = TRUE)
(UNPOP_2 <- as.data.frame(lapply(UNPOP_2,function(x) if(is.character(x)|is.factor(x)) gsub("C<aa>te d'Ivoire","Côte d'Ivoire",x) else x)))

#Subsetting by year
UNData_2 <- subset(UNData, UNData$Year > 1998)
sum(UNData$Refugees, na.rm = TRUE)

#aggregating data by country of asylum and origin
table1 <- aggregate.data.frame(UNData_2$Refugees, list(Asylum = UNData_2$Asylum, Year = UNData_2$Year), sum)
View(table1)
table2 <- aggregate.data.frame(UNData_2$Refugees, list(Origin = UNData_2$Origin, Year = UNData_2$Year), sum)
View(table2)
table1 <- rename(table1, c("x" = "In"))
table2 <- rename(table2, c("x" = "Out"))
allyears2 <- merge(table1, table2, by.x = c("Asylum", "Year"), by.y = c("Origin", "Year"), all = TRUE)
View(allyears2)

#bringing in country/region breakdown to merge
country_region <- read.csv("~/Documents/Refugee/country_region.csv", comment.char="#")
allyears2 <- rename(allyears2, c("Asylum" = "Country"))
allyears3 <- merge(allyears2, country_region, by.x = "Country", by.y= "Country", all.x = TRUE)

#checks to make sure data isn't missing from merges, aggs, etc.
sum(allyears$Refugees)
sum(allyears3$In, na.rm = TRUE)
sum(allyears3$Out, na.rm = TRUE)

#bringing in regional definitions
UNData3 <- merge(UNData_2, country_region, by.x = "Asylum", by.y = "Country", all.x = TRUE)
UNData3 <- rename(UNData3, c("Region" = "AsylumRegion"))

UNData3 <- merge(UNData_3, country_region, by.x = "Origin", by.y = "Country", all.x = TRUE)
UNData3 <- rename(UNData3, c("Region", "OriginRegion"))

#checks again
sum(UNData3$Refugees, na.rm = TRUE)
write.csv(allyears3, file = "~/Documents/Refugee/allyears.csv")

#bringing in population data and preparing data frame for merge
UNPOP.from.UN <- read.csv("~/Documents/Refugee/UNPOP from UN.csv", comment.char="#", stringsAsFactors=FALSE)
UNPOP <- rename(UNPOP.from.UN, c("X1999" = "1999", "X2000" = "2000","X2001" = "2001", "X2002" = "2002", "X2003" = "2003", "X2004" = "2004","X2005" = "2005", "X2006" = "2006","X2007" = "2007"))
UNPOP <- rename(UNPOP, c( "X2008" = "2008","X2009" = "2009", "X2010" = "2010", "X2011" = "2011", "X2012" = "2012","X2013" = "2013"))
UNPOP$X2015 <- NULL
UNPOP$X2014 <- NULL
UNPOP_2 <- melt(UNPOP, id=c("Country"))
write.csv(UNPOP_2, file = "~/Documents/Refugee/UNPOP_2.csv")

#merge with population data
allyears4 <- merge(allyears3, UNPOP_2, by.x = c("Country", "Year"), by.y = c("Country", "variable"), all.x = TRUE)
write.csv(allyears4, file = "~/Documents/Refugee/allyears4.csv")

#Creating percentages of refugees in and out with population data
allyears4$In_Pct <- allyears4$In / (allyears4$value*1000)
allyears4$Out_Pct <- allyears4$Out / (allyears4$value*1000)

#simple visuals to start to see the data
plot(allyears4$Year, allyears4$In_Pct)
plot(allyears4$Year, allyears4$Out_Pct)
plot(allyears4$Year[which(allyears4$Region == "Southern Asia")], allyears4$In_Pct[which(allyears4$Region == "Southern Asia")])
plot(allyears4$Year[which(allyears4$Region == "Southern Asia")], allyears4$Out_Pct[which(allyears4$Region == "Southern Asia")])
plot(allyears4$Year[which(allyears4$Region == "Eastern Africa")], allyears4$Out_Pct[which(allyears4$Region == "Eastern Africa")])
plot(allyears4$Year[which(allyears4$Region == "Eastern Africa")], allyears4$In_Pct[which(allyears4$Region == "Eastern Africa")])
plot(allyears4$Year[which(allyears4$Region == "North America")], allyears4$In_Pct[which(allyears4$Region == "North America")])
plot(allyears4$Year[which(allyears4$Region == "North America")], allyears4$Out_Pct[which(allyears4$Region == "North America")])
plot(allyears4$Year[which(allyears4$Region == "Western Africa")], allyears4$Out_Pct[which(allyears4$Region == "Western Africa")])
plot(allyears4$Year[which(allyears4$Region == "Western Africa")], allyears4$In_Pct[which(allyears4$Region == "Western Africa")])
plot(allyears4$Year[which(allyears4$Region == "Northern Africa")], allyears4$Out_Pct[which(allyears4$Region == "Northern Africa")])
plot(allyears4$Year[which(allyears4$Region == "Northern Africa")], allyears4$In_Pct[which(allyears4$Region == "Northern Africa")])
plot(allyears4$Year[which(allyears4$Region == "South America")], allyears4$In_Pct[which(allyears4$Region == "South America")])
plot(allyears4$Year[which(allyears4$Region == "South America")], allyears4$Out_Pct[which(allyears4$Region == "South America")])

