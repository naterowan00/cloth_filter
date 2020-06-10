library(xts)
library(tidyverse); theme_set(theme_minimal())
library(lubridate)
library(padr) ### used to creaate daily averages

### Load in data set
load("datasets/compiled2019DBF.RData")

### pull individual components of xts object
core_data <- coredata(rawData)
indices <- index(rawData)

### make core data component into a tibble
df <- core_data %>%
  as_tibble()

### append datetimes onto the tibble
raw <- df %>%
  add_column(datetime = indices, .before = "ADFS\\BASIN_LEVEL\\PROCESS_VALUE")

### WOO YAY FIGURED IT OUT, creates a tibble with the average values for each day 
daily_averages <- raw %>%
  thicken(
    interval = "day"
  ) %>%
  group_by(datetime_day) %>%
  summarise_if(is.numeric, mean)

write_csv(daily_averages, "datasets/daily_averages_online.csv")

### Now lets see if I can join daily averages to the lab data
# load in lab data
lab_data <- readRDS("datasets/clean_lab_data.rda")

# WOO LETS GO I joined the data together. Don't worry about the NA's, the join 
# only actually happens for 2019 data, since that is when the online data was going
# can easily be filtered to just include 2019 if you so choose
joined_data <- lab_data %>%
  mutate(datetime_day = date(datetime)) %>% 
  left_join(daily_averages, by = "datetime_day")

# Next step: renaming the online data to make it more coherent

  




### Create plot of average influent flow per day
raw %>%
  thicken(
    interval = "day"
  ) %>%
  group_by(datetime_day) %>%
  summarise(avg_influent_flow = mean(`ADFS\\INFLUENT_FLOW\\PROCESS_VALUE`)) %>%
  ggplot(aes(x = datetime_day, y = avg_influent_flow)) +
    geom_point() +
    geom_line()

### Create tibble with average influent flow per day
daily_inf_flow <- raw %>%
  thicken(
    interval = "day"
  ) %>%
  group_by(datetime_day) %>%
  summarise(avg_influent_flow = mean(`ADFS\\INFLUENT_FLOW\\PROCESS_VALUE`))

### create scatterplot of effluent tss vs influent flow
filter_data %>%
  filter(flow == "effluent", tss < 400) %>%
  mutate(datetime_day = as_date(datetime)) %>%
  left_join(daily_inf_flow, by = "datetime_day") %>%
  ggplot(aes(x = avg_influent_flow, y = tss)) +
    geom_point() +
    labs(
      title = "Influent flow does not appear to have a strong relationship with effluent TSS",
      subtitle = "Each point represents the average influent flow and effluent TSS on a given date",
      x = "Average Influent Flow (gpm)",
      y = "Effluent TSS (mg/L)"
    )




