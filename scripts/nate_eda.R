library(tidyverse); theme_set(theme_minimal())
library(lubridate)
library(naniar)

lab_data <- readRDS("datasets/clean_lab_data.rda")

lab_data %>%
  filter(
    treatment == "filter"
    ) %>%
  ggplot(aes(datetime, bod)) +
    geom_point(aes(color = flow), size = 2)


