###############################################################################
## Aqua Aerobic - Primary Filtration Lab 
## Processing of Raw Data
## Author: Maggie Bailey
## Date: 05/29/2020
## Description: Calls master data file and creates 4 separate location files 
###############################################################################

##--------------------------------------
## Clear working memory
##--------------------------------------

rm(list = ls())


##--------------------------------------
## Install and load any needed libraries
##--------------------------------------

library(tidyverse)
library(readxl)
library(lubridate)
library(dplyr)
library(magrittr)

##--------------------------------------
## Load the data
##--------------------------------------

data <- read_xlsx( "Primary Filtration Lab 6APR17 to 31OCT19.xlsx")
data <- as.data.frame(data)
head(data)

##--------------------------------------
## Reformat Date and Time columns
##--------------------------------------

data$Date <- date(data$Date)
data$Date # check

data$Time <- format(data$Time,"%H:%M:%S")
data$Time # check

data <- data[,-1] # remove first column "Date & Time"
head(data) # check

##--------------------------------------
## Rename columns
##--------------------------------------

colnames(data) <- c("date",
                    "time",
                    "lab",
                    "sample_type",
                    "parameter",
                    "location",
                    "value",
                    "notes")

colnames(data) # Good to go

##--------------------------------------
## Remove note and lab column
##--------------------------------------

data <- data[,c(-3,-8)]
head(data)
table(data$parameter)

##--------------------------------------
## Remove sCOD and sCOD variables
##--------------------------------------

data <- data[-which(data$parameter == "sBOD (mg/L)"),]
data <- data[-which(data$parameter == "sCOD (mg/L)"),]


##--------------------------------------
## Separate data by location
##--------------------------------------

clarifier_influent <- subset(data, data$location == "Clarifier Influent")
clarifier_effluent <- subset(data, data$location == "Clarifier Effluent")
filter_influent <- subset(data, data$location == "Filter Influent")
filter_effluent <- subset(data, data$location == "Filter Effluent")

##--------------------------------------
### Remove location column -- each file is a separate location
##--------------------------------------

clarifier_effluent <- clarifier_effluent[,-which(colnames(clarifier_effluent) == "location")]
clarifier_influent <- clarifier_influent[,-which(colnames(clarifier_influent) == "location")]
filter_effluent <- filter_effluent[,-which(colnames(filter_effluent) == "location")]
filter_influent <- filter_influent[,-which(colnames(filter_influent) == "location")]

##--------------------------------------
## Create separate CSVs for each location
##--------------------------------------

setwd("~/Documents/Mines/MOWATER /Aqua Aerobic/data/clean") # Create path to clean data folder

write.csv(clarifier_effluent, file = "clarifier_effluent.csv")
write.csv(clarifier_influent, file = "clarifier_influent.csv")
write.csv(filter_effluent, file = "filter_effluent.csv")
write.csv(filter_influent, file = "filter_influent.csv")

## Note: each file was check for NA's in data cleaning process
## and none were detected




