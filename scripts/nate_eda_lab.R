###### Exploratory Data Analysis of Lab Data #######

# Load in libraries
library(tidyverse); theme_set(theme_minimal())
library(lubridate)
library(broom)
library(glue)
library(patchwork)

# Read in the data
lab_data <- readRDS("datasets/clean_lab_data.rda")

# Create a tibble of just data from the filter
filter_data <- lab_data %>%
  filter(treatment == "filter")

# Remove crazy outliers
no_outliers <- filter_data %>%
  filter(
    bod < 1000 | is.na(bod),
    tss < 1000
  ) 

# Create a tibble of just data from the clarifier
clarifier_data <- lab_data %>% 
  filter(treatment == "clarifier")

# effluent vs influent plots ----------------------------------------------

# tss
tss_plot <- filter_data %>%
  ggplot(aes(x = datetime, y = tss)) +
    geom_point(aes(color = flow), size = 2, show.legend = FALSE) +
    scale_x_datetime(
      limits = c(as_datetime("2019-01-01"), as_datetime("2020-01-01"))
    ) 

# vss
filter_data %>%
  ggplot(aes(datetime, vss)) +
    geom_point(aes(color = flow), size = 2)

# cod
filter_data %>%
  ggplot(aes(datetime, cod)) +
    geom_point(aes(color = flow), size = 2)

# bod
filter_data %>%
  ggplot(aes(datetime, bod)) +
    geom_point(aes(color = flow), size = 2)


# cod vs bod
filter_data %>%
  filter(flow == "influent") %>%
  ggplot(aes(x = bod, y = cod)) +
    geom_point()



# distribution tables and plots ------------------------------------------------------
add_na_col <- function(x){
  mutate(x, na = 0)
}

has_n_col <- function(x, n = 6){
  return(ncol(x) == n)
}

parameter_names <- filter_data %>%
  select_if(is.numeric) %>%
  colnames()

# Five Number Summary of influent filter data
influent_summary <- filter_data %>%
  filter(flow == "influent") %>%
  select_if(is.numeric) %>%
  map(~tidy(summary(.x))) %>%
  map_if(., has_n_col, add_na_col) %>%
  do.call(rbind, .) %>%
  add_column(parameter = parameter_names, .before = "minimum")

# Five Number Summary of effluent filter data
effluent_summary <- filter_data %>%
  filter(flow == "effluent") %>%
  select_if(is.numeric) %>%
  map(~tidy(summary(.x))) %>%
  map_if(., has_n_col, add_na_col) %>%
  do.call(rbind, .) %>%
  add_column(parameter = parameter_names, .before = "minimum")

# tss boxplot, sorted by flow
no_outliers %>%
  ggplot(aes(x = flow, y = tss)) +
  geom_boxplot()

# vss boxplot, sorted by flow
no_outliers %>%
  ggplot(aes(x = flow, y = vss)) +
  geom_boxplot()

# bod boxplot, sorted by flow
no_outliers %>%
  ggplot(aes(x = flow, y = bod)) +
  geom_boxplot()

# cod boxplot, sorted by flow
no_outliers %>%
  ggplot(aes(x = flow, y = cod)) +
  geom_boxplot()


# relationships between parameters ----------------------------------------

### influent water quality vs effluent water quality. I have removed crazy outliers
### all plots indicate a weak, positive relationship. Weaker than I expected, and with 
### a more shallow slope than I expected

# tss
no_outliers %>%
  select(datetime:sample_type, tss) %>%
  pivot_wider(names_from = treatment:flow, values_from = tss) %>% 
  filter(filter_effluent < 400) %>%
  ggplot(aes(x = filter_influent, y = filter_effluent)) +
    geom_point() +
    geom_smooth(method = "lm", se = F)

### linear model for TSS. y = 18.797 + .105x, R-squared = .2003
no_outliers %>%
  select(datetime:sample_type, tss) %>%
  pivot_wider(names_from = treatment:flow, values_from = tss) %>%
  lm(filter_effluent ~ filter_influent, .) %>%
  summary()


# vss
no_outliers %>%
  select(datetime:sample_type, vss) %>%
  pivot_wider(names_from = treatment:flow, values_from = vss) %>% 
  filter(filter_effluent < filter_influent) %>%
  ggplot(aes(x = filter_influent, y = filter_effluent)) +
    geom_point()

# bod
no_outliers %>%
  select(datetime:sample_type, bod) %>%
  pivot_wider(names_from = treatment:flow, values_from = bod) %>% 
  ggplot(aes(x = filter_influent, y = filter_effluent)) +
    geom_point()

# cod
no_outliers %>%
  select(datetime:sample_type, cod) %>%
  pivot_wider(names_from = treatment:flow, values_from = cod) %>% 
  filter(filter_effluent < 800) %>%
  ggplot(aes(x = filter_influent, y = filter_effluent)) +
    geom_point()














