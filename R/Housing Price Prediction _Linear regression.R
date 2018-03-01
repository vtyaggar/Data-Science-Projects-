library(XLConnect)
library(XLConnectJars)
library(tidyverse)
getwd()
setwd("Labs/Linear Regression OLS")
wk = loadWorkbook("Assignment3_CategoricalLab.xlsx") 
redfinHousingData =  readWorksheet(wk, "Sheet2")

rainsheet = readWorksheet(wk, "Sheet2")
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
library(forecast)
plot(timeseries_rain)
mod = Arima(timeseries_rain,order=c(1,1,1))

predictRainnxtyear = predict(mod,n.ahead= 335*1) "12.51%"

"************************************************************
  HOusing Prediction"

prop <- redfinHousingData$PropertyType
square <- redfinHousingData$SQUARE.FEET
bath <- redfinHousingData$BATHS
neighborHood <- redfinHousingData$Neighborhood

excludedvar <- factor(neighborHood, exclude=c('Tam Oshanter','Avondale','Bridle Trails','Downtown Redmond','East Bellevue','Education Hill','English Cove','English Hill','Grass Lawn Park','Hollywood Hill','Idylwood','Marymoor','Microsoft','North Rose Hill','Redmond','Rose Hill','Overlake','Redmond','Rose Hill','Sammamish River','Strattonwood','West Lake Sammamish','Woodinville'))

parsimoniousModel <- lm(redfinHousingData$Price.in.Thousands~square+bath+factor(prop, exclude=c('Condo/Co-op')))



summary(parsimoniousModel)

HOusingpredict<-data.frame( square=c(7625), bath=c(2.5), prop="Single Family Residence",neighborHood=c("Lake Sammamish","Lake Sammamish","Lake Sammamish"))

predict.price<-predict(parsimoniousModel, newdata=HOusingpredict, se.fit=TRUE) 

library('chemCal')
invCategory<-lm(redfinHousingData$Price.in.Thousands~prop)
invBath<-lm(redfinHousingData$Price.in.Thousands~bath)
invSqft <- lm(redfinHousingData$Price.in.Thousands~square) 
inverse.predict(invSqft,1750)
"********************Inverse predict*********************"

"**************
New zip code prediction
"
pricefit<-lm(price~sqfeet+beds)
TestData$beds<-as.numeric(TestData$BEDS)
TestData$sqfeet<-as.numeric(TestData$`SQUARE FEET`)
new_data_test<-data.frame(TestData$beds, TestData$sqfeet)



