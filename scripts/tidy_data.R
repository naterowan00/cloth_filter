library(tidyverse); theme_set(theme_minimal())
library(lubridate)
library(here) # eliminates working directory/filepath stuff

# Read in the data
raw_clar_eff <- read_csv(here("datasets", "clarifier_effluent.csv"))
raw_clar_inf <- read_csv(here("datasets", "clarifier_influent.csv"))
raw_filter_eff <- read_csv(here("datasets", "filter_effluent.csv"))
raw_filter_inf <- read_csv(here("datasets", "filter_influent.csv"))


###############
### dplyr stuff
###############

clar_eff <- raw_clar_eff[-1]
clar_inf <- raw_clar_inf[-1]
filter_eff <- raw_clar_eff[-1]
filter_inf <- raw_clar_inf[-1]

### Add columns to each dataframe indicating treatment & flow
clar_eff <- clar_eff %>%
  add_column(treatment = rep("clarifer", nrow(.)), .after = "time") %>%
  add_column(flow = rep("effluent", nrow(.)), .after = "treatment")

clar_inf <- clar_inf %>%
  add_column(treatment = rep("clarifer", nrow(.)), .after = "time") %>%
  add_column(flow = rep("influent", nrow(.)), .after = "treatment")

filter_eff <- filter_eff %>%
  add_column(treatment = rep("filter", nrow(.)), .after = "time") %>%
  add_column(flow = rep("effluent", nrow(.)), .after = "treatment")

filter_inf <- filter_inf %>%
  add_column(treatment = rep("filter", nrow(.)), .after = "time") %>%
  add_column(flow = rep("influent", nrow(.)), .after = "treatment")

### Combine all dataframes together
combined_data <- bind_rows(clar_eff, clar_inf, filter_eff, filter_inf)

### Spread the parameters to make them columns, merge datetimes, 
### convert to datetimes
spread_data <- combined_data %>%
  spread(., parameter, value) %>%
  unite("datetime", date:time, sep = " ") %>%
  mutate(datetime = ymd_hms(datetime))

### Rename columns to lower case, remove non-syntactic names
clean_data <- spread_data %>%
  rename_all(tolower) %>%
  rename(
    bod = `bod (mg/l)`,
    cod = `cod (mg/l)`,
    op = `ortho-phosphate`,
    tss = `tss (mg/l)`,
    vss = `vss (mg/l)`
  )

### Saves the clean data as a .rda file
save(clean_data, file = "datasets/clean_lab_data.rda")


  









 

