library(shiny)
library(shiny.semantic)
library(dplyr)
library(echarts4r)
library(shiny.i18n)

# File with translations
i18n <- Translator$new(translation_json_path = "data/translation.json")
i18n$set_translation_language("en")

deaths <- readRDS("data/deaths.RDS")
areas <- unique(deaths$area)
macroregions <- unique(deaths$macroregion)
macroregion_names <- deaths %>% filter(area_level == "macroregion") %>% pull(area) %>% unique
ages <- unique(deaths$age)
years <- unique(deaths$year)


areas_df <- deaths %>%
  select(area, area_code, area_level, macroregion, region, subregion) %>%
  filter(area_level != "country") %>%
  distinct()

macroregions_df <- areas_df %>% filter(area_level == "macroregion")
macroregions <- setNames(macroregions_df$macroregion, macroregions_df$area)

deaths <- deaths %>% filter(area_level == "subregion")

create_axis_formatter <- function(data) {
  deaths_level <- nchar(max(data$deaths, na.rm = TRUE))

  level <- 1
  suffix <- ""
  if (deaths_level >= 4) {
    level <- 1000
    suffix <- "k"
  }

  glue::glue(
    "function(value, index) {{return(value/{level} + '{suffix}')}}"
  )
}
