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
filter_eff <- raw_filter_eff[-1]
filter_inf <- raw_filter_inf[-1]

### Add columns to each dataframe indicating treatment & flow
clar_eff <- clar_eff %>%
  add_column(treatment = rep("clarifier", nrow(.)), .after = "time") %>%
  add_column(flow = rep("effluent", nrow(.)), .after = "treatment")

clar_inf <- clar_inf %>%
  add_column(treatment = rep("clarifier", nrow(.)), .after = "time") %>%
  add_column(flow = rep("influent", nrow(.)), .after = "treatment")

filter_eff <- filter_eff %>%
  add_column(treatment = rep("filter", nrow(.)), .after = "time") %>%
  add_column(flow = rep("effluent", nrow(.)), .after = "treatment")

filter_inf <- filter_inf %>%
  add_column(treatment = rep("filter", nrow(.)), .after = "time") %>%
  add_column(flow = rep("influent", nrow(.)), .after = "treatment")

### Combine all dataframes together
combined_data <- bind_rows(clar_eff, clar_inf, filter_eff, filter_inf)

bc_lab_only <- combined_data %>%
  filter(lab == "BC Labs")

####################### More Duplicate Problems, wooo ###########

#### Changing Values ######
bc_lab_only[1312,8] <- 43.5
bc_lab_only[717, 8] <- 115
bc_lab_only[718, 8] <- 245
bc_lab_only[818, 8] <- 43
bc_lab_only[1300, 8] <- 48.5
bc_lab_only[1299, 8] <- 480
bc_lab_only[716, 8] <- 67.5
bc_lab_only[1305, 8] <- 320
bc_lab_only[1306, 8] <- 905
bc_lab_only[1302, 8] <- 4.4

#### Remvoing Rows DO NOT RUN UNTIL DONE WITH CHANGING VALUES ####
bc_lab_only <- bc_lab_only %>%
  slice(c(-1301, -651, -1242, -681, -1272, -724, -726, -1303, -819, -1310, -719, -1304, -1316, -1317, -1311, -1313))


### Spread the parameters to make them columns, merge datetimes, 
### convert to datetimes. Row 258 has a problem where the date didn't parse
spread_data <- bc_lab_only %>%
  spread(., parameter, value) %>%
  unite("datetime", date:time, sep = " ") %>%
  mutate(datetime = ymd_hms(datetime))

### Rename columns to lower case, remove non-syntactic names
clean_data <- spread_data %>%
  rename_all(tolower) %>%
  rename(
    bod = `bod (mg/l)`,
    cod = `cod (mg/l)`,
    cod_mgkg = `cod (mg/kg)`,
    op = `ortho-phosphate`,
    tss = `tss (mg/l)`,
    vss = `vss (mg/l)`
  )

### Saves the clean data as a .rda file
saveRDS(clean_data, file = "datasets/clean_lab_data.rda")

### When you want to read the file in: data_name <- readRDS(datasets/clean_lab_data.rda)

  








 

