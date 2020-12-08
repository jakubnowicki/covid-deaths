library(shiny)
library(shiny.semantic)
library(dplyr)
library(echarts4r)

data <- readRDS("data/deaths.RDS")
areas <- unique(data$area)
ages <- unique(data$age)
years <- unique(data$year)
