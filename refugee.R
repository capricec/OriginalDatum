setwd("~/Documents/Refugee")
UNdata_Export_20151118_154311015 <- read.csv("~/Documents/Refugee/UNdata_Export_20151118_154311015.csv", header=FALSE)
library(plyr)
UN <- data.frame(UNdata_Export_20151118_154311015)
UN <- rename(UN, c("V1"="Asylum", "V2"="Origin", "V3" = 'Year', "V7"="Refugees"))
UN$V4<-NULL
UN$V5<-NULL
UN$V6<- NULL
UN <- UN[-c(1), ]
UN2013 <- subset(UN, UN$Year ==  2013)
UN2013$Year<- NULL

library(reshape2)
UN2013$Refugees <- as.integer(UN2013$Refugees)
UN2013_2 <- acast(UN2013, UN2013$Asylum ~ UN2013$Origin, sum)
write.csv(UN2013_2, file = "~/Documents/Refugee/2013.csv")
table1 <- tapply(UN2013$Refugees, UN2013$Origin, FUN=sum)
table2 <- tapply(UN2013$Refugees, UN2013$Asylum, FUN=sum)
country_region <- read.csv("~/Documents/Refugee/country_region.csv", comment.char="#")

UN2013_5 <- merge(UN2013, country_region, by.x = 'Asylum', by.y = 'Country', all.x = TRUE)
UN2013_5 <- rename(UN2013_5, c("Region"="AsylumRegion"))
UN2013_5 <- merge(UN2013_5, country_region, by.x = 'Origin', by.y = 'Country', all.x = TRUE)
UN2013_5 <- rename(UN2013_5, c("Region"="OriginRegion"))

#to do
UN2013_5$AsylumRegion[which(UN2013_5$Asylum == "Côte d'Ivoire")] <- 'Western Africa'
UN2013_5$OriginRegion[which(UN2013_5$Origin == 'Serbia (and Kosovo: S/RES/1244 (1999))')] <- 'Southern Europe'
UN2013_5$OriginRegion[which(UN2013_5$Origin == "Dem. People's Rep. of Korea")] <- 'Eastern Asia'

#done in excel file. no need.
UN2013_5$OriginRegion[which(UN2013_5$Origin == 'Islamic Rep. of Iran')] <- 'Southern Asia'
UN2013_5$AsylumRegion[which(UN2013_5$Origin == 'State of Palestine')] <- 'Western Asia'
UN2013_5$OriginRegion[which(UN2013_5$Origin == 'Dem. Rep. of the Congo')] <- 'Middle Africa'
UN2013_5$AsylumRegion[which(UN2013_5$Asylum == 'Syrian Arab Rep.')] <- 'Western Asia'
UN2013_5$OriginRegion[which(UN2013_5$Origin == 'Central African Rep.')] <- 'Middle Africa'
UN2013_5$OriginRegion[which(UN2013_5$Origin == 'Rep. of Moldova')] <- 'Eastern Europe'

#USE ME
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
UN_2$AsylumRegion[which(UN_2$Asylum == "Estonie")] <- "Northern Europe"
UN_2$AsylumRegion[which(UN_2$Asylum == "Estonia")] <- "Northern Europe"
UN_2$AsylumRegion[which(UN_2$Asylum == "Côte d'Ivoire")] <- "Western Africa"
UN_2$AsylumRegion[which(UN_2$Asylum == "Curaçao")] <- "Caribbean"
UN_2$OriginRegion[which(UN_2$Origin == "Côte d'Ivoire")] <- "Western Africa"
UN_2$OriginRegion[which(UN_2$Origin == "Curaçao")] <- "Caribbean"

UN_2$AsylumRegion[is.na(UN_2$AsylumRegion)] <- 'Various'
write.csv(UN_2, file = "~/Documents/Refugee/allyears.csv")

#formatting data for specific chart usage
UN_3 <- UN_2

UN_POP_5 <- merge (UN_POP_4, UNPOP_2, by.x = c("Country", "Year"), by.y = c("Region", "variable"), all.x = TRUE)
(UNPOP_2 <- as.data.frame(lapply(UNPOP_2,function(x) if(is.character(x)|is.factor(x)) gsub("C<aa>te d'Ivoire","Côte d'Ivoire",x) else x)))




