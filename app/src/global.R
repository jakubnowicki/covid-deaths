library(shiny)
library(shiny.semantic)
library(dplyr)
library(echarts4r)

deaths <- readRDS("data/deaths.RDS")
areas <- unique(deaths$area)
ages <- unique(deaths$age)
years <- unique(deaths$year)

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
