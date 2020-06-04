
#######################
##set working directory
#######################
setwd("/Users/alessandrarodriguez/Desktop/AQUACLOTH")

################
##load libraries
################
library("tidyverse"); theme_set(theme_minimal()) 
theme_update(panel.grid.minor = element_blank())
library(xts)
library(tidyverse)

##############
##loading data
##############
clar_eff <- read.csv(file = "clarifier_effluent.csv")
clar_inf <- read.csv(file = "clarifier_influent.csv")
filter_eff <- read.csv(file = "filter_effluent.csv")
filter_inf <- read.csv(file = "filter_influent.csv")

clar_eff <- clar_eff[,-1]
clar_inf <- clar_inf[,-1]
filter_eff <- filter_eff[,-1]
filter_inf <- filter_inf[,-1]

clar_eff$date<- as_date(clar_eff$date)
clar_inf$date<- as_date(clar_inf$date)
filter_eff$date<- as_date(filter_eff$date)
filter_inf$date<- as_date(filter_inf$date)

######################
##spreading parameters
######################

##clar_eff##
unique(clar_eff$parameter)

clar_eff$time <- as.character(clar_eff$time)
clar_eff$value <- as.numeric(clar_eff$value)

clar_eff<- clar_eff %>%
  spread(., parameter, value)

##clar_inf##
unique(clar_inf$parameter)

clar_inf$time <- as.character(clar_inf$time)
clar_inf$value <- as.numeric(clar_inf$value)

clar_inf<- clar_inf %>%
  spread(., parameter, value)

##filter_eff##
unique(filter_eff$parameter)

filter_eff$time <- as.character(filter_eff$time)
filter_eff$value <- as.numeric(filter_eff$value)

filter_eff<- filter_eff %>%
  group_by_at(vars(-value)) %>%
  mutate(row_id=1:n()) %>%
  ungroup() %>%
  spread(., parameter, value) %>%
  select(-row_id)

##filter_inf##
unique(filter_inf$parameter)

filter_inf$time <- as.character(filter_inf$time)
filter_inf$value <- as.numeric(filter_inf$value)

filter_inf<- filter_inf %>%
  group_by_at(vars(-value)) %>%
  mutate(row_id=1:n()) %>%
  ungroup() %>%
  spread(., parameter, value) %>%
  select(-row_id)

