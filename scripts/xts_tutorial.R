
### Aqua Aerobic -- Online Data ###

rm(list = ls())

library(xts)

load("datasets/compiled2019DBF.RData")

colnames(rawData)
view(rawData)
str(rawData)

coreData <- coredata(rawData)
view(coreData)
class(coreData)

dataIndex <- index(rawData)
view(dataIndex)

tclass(rawData) # tells us it is POSIXct form

# extract first day of data -- creates data_day_1 as xts object
data_day_1 <- rawData["/2019-01-01"]
view(data_day_1)
class(data_day_1)
colnames(data_day_1)


# plot basin level
plot.xts(data_day_1[,1])

# plot effluent_tss
plot.xts(data_day_1[,2])

# plot influent turbidity vs. effluent turbidity
plot(data_day_1[,c(23:24)], multi.panel = TRUE)






