library(XLConnect)
library(XLConnectJars)
library(tidyverse)
getwd()
setwd("/Labs/Logistic Regression")
wk = loadWorkbook("RainSeattle2016.xlsx") 
rainsheet = readWorksheet(wk, "Sheet1")
na.omit(rainsheet)
seasonCategory <- factor(rainsheet$Season)
seasonCategory <- factor(rainsheet$Season,levels=c("Summer","Fall", "Spring", "Winter"))
windDirection<-cut(rainsheet$WDF5-22, breaks=c(-22,22,67,112,157,202,247,292,337,360), labels=c("N", "NE","E","SE","S","SW","W","NW","N1"))
rainsheet$windDirection = windDirection
rainFactor <- factor(rainsheet$Rain)

includedSeason <- factor(seasonCategory, exclude=c('Spring'))
includedwindDirection <- factor(rainsheet$windDirection, exclude=c('NE','SW','W','NW','N1','E','S'))

tempMax <- rainsheet$TMAX
tempMin <-  rainsheet$TMIN
GenLinearModel <- glm(formula = rainFactor~ seasonCategory+ tempMax+ tempMin,
                      data=rainsheet,
                      family=binomial)

summary(GenLinearModel)
predictrain<-  data.frame(seasonCategory = c("Fall"), tempMax= c(54), tempMin = c(39))
predictionvalues <- predict.glm(GenLinearModel,newdata = predictrain,se.fit = TRUE)

setwd("/Labs/TimeSeries")
raindata = read.csv("RainSeattle2016.csv") 
library(zoo)
timeseries_rain<-ts(raindata$PRCP, frequency=365,start=c(2016/1/1,1))
library(tseries)
plot(timeseries_rain)
mod = Arima(timeseries_rain,order=c(1,1,1))

predictRainnxtyear = predict(mod,n.ahead= 335*1)

"************************************************************
  HOusing Prediction"
lotSize <- redfinHousingData$LotsizeCategory
propCat <- redfinHousingData$propertyCategory
squareYear <- redfinHousingData$SQUARE.FEET*redfinHousingData$YEAR.BUILT
bedBath <- redfinHousingData$BEDS*redfinHousingData$BATHS
neighborHood <- redfinHousingData$NeighborhoodCategory

parsimoniousModel<- lm(data =redfinHousingData, redfinHousingData$Price.in.Thousands~lotSize
                       +propCat
                       +squareYear
                       +bedBath
                       + neighborHood)
summary(parsimoniousModel)

HOusingpredict<-data.frame(lotSize =c("0-3000"), propCat="Single Family Residence", squareYear=c(2258*2008), bedBath=c(4*2.5), neighborHood=c("Redmond"))
HOusingpredict1<-data.frame(lotSize =c("3001-6000"), propCat="Single Family Residence", squareYear=c(1980*2013), bedBath=c(3*2.5), neighborHood=c("Education Hill"))
HOusingpredict2<-data.frame(lotSize =c("6001-9000"), propCat="Single Family Residence", squareYear=c(2390*1985), bedBath=c(4*2.5), neighborHood=c("English Hill"))

predict.price<-predict(parsimoniousModel, newdata=HOusingpredict, se.fit=TRUE) 

"********************Inverse predict*********************"


