########
# Things to do
# - combine date and time into one datetime
# - figure out if we need to change data to work in tidyverse/ggplot





library(tidyverse); theme_set(theme_minimal())
library(lubridate)
library(here) # eliminates working directory/filepath stuff

# Read in the data
raw_clar_eff <- read_csv(here("datasets", "clarifier_effluent.csv"))
raw_clar_inf <- read_csv(here("datasets", "clarifier_influent.csv"))
raw_filter_eff <- read_csv(here("datasets", "filter_effluent.csv"))
raw_filter_inf <- read_csv(here("datasets", "filter_influent.csv"))

# Shows what water quality things are measured in filter data
unique(raw_filter_eff$parameter)
unique(raw_filter_inf$parameter)

# a time series plot of ammonia
raw_filter_eff %>%
  filter(parameter == "Ammonia") %>%
  ggplot(aes(x = date, y = value)) +
    geom_point() +
    geom_line()





 

