library(readxl)
library(dplyr)
library(tidyr)
library(fs)

# Load data

## Required functions
get_year <- function(path) {
  read_excel(path, range = "B2", col_names = FALSE) %>% unlist() %>% unname
}

remove_rows <- function(data, rows) {
  data[-rows, ]
}

get_area_level <- function(area_code) {
  level <- nchar(area_code) - 1
  case_when(
    level == 1 ~ "country",
    level == 2 ~ "macroregion",
    level == 3 ~ "region",
    level == 4 ~ "subregion"
  )
}

get_data <- function(path, year) {
  read_excel(path, sheet = "OGÓŁEM", skip = 6) %>%
    remove_rows(1:2) %>%
    rename(
      age = ...1,
      area_code = ...2,
      area = ...3
    ) %>%
    mutate(
      area_level = get_area_level(area_code)
    ) %>%
    pivot_longer(
      cols = starts_with("T"),
      names_to = "week",
      values_to = "deaths"
    ) %>%
    mutate(
      year = year,
      year_week = paste(year, week, sep = "-"),
      macroregion = substr(area_code, 1, 3),
      region = substr(area_code, 1, 4),
      subregion = substr(area_code, 1, 5)
    )
}


get_region <- function(value, level, dictionary) {
  region <- dictionary %>%
    filter(area_level == level) %>%
    filter(area_code == value) %>%
    pull(area)

  if (length(region) == 0) {
    return(NA)
  }

  region
}


## Data read

deaths <- tibble()

data_files <- list.files("./data")

for (file in data_files) {
  path <- paste0("./data/", file)
  year <- get_year(path)
  tmp_df <- get_data(path, year)
  deaths <- rbind(deaths, tmp_df)
}

areas_df <- deaths %>%
  select(area, area_code, area_level, macroregion, region, subregion) %>%
  filter(area_level != "country") %>%
  distinct()

areas_dict <- areas_df %>%
  rowwise() %>%
  mutate(
    macroregion_name = get_region(macroregion, "macroregion", areas_df),
    region_name = get_region(region, "region", areas_df),
    subregion_name = get_region(subregion, "subregion", areas_df)
  ) %>%
  select(area_code, macroregion_name, region_name, subregion_name)

deaths <- deaths %>%
  left_join(areas_dict, by = "area_code")

saveRDS(deaths, file = "./app/src/data/deaths.RDS")
