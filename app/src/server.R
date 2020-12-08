function(input, output, session) {
  session$userData$data <- data

  output$general_chart <- echarts4r::renderEcharts4r({
    selected_area <- input$area
    if (is.null(selected_area)) {
      selected_area <- "Polska"
    }

    selected_age <- input$age
    if (is.null(selected_age)) {
      selected_age <- "Ogółem"
    }

    data <- session$userData$data %>%
      filter(area %in% selected_area, age %in% selected_age)

    if (input$grouping != "none") {
      data <- data %>%
      group_by(
        across(input$grouping)
      )
    }

    data <- data %>%
      group_by(year_week, .add = TRUE) %>%
      summarise(deaths = sum(deaths)) %>%
      ungroup()

    if (input$grouping != "none") {
      data <- data %>%
      group_by(
        across(input$grouping)
      )
    }

    data %>%
      e_chart(
        x = year_week
      ) %>%
      e_line(
        deaths
      ) %>%
      e_tooltip() %>%
      e_datazoom(type = "slider") %>%
      e_title("Deaths in time", left = "10%") %>%
      e_show_loading()
  })

  output$year_comparison_chart <- echarts4r::renderEcharts4r({
    selected_area <- input$area
    if (is.null(selected_area)) {
      selected_area <- "Polska"
    }

    selected_age <- input$age
    if (is.null(selected_age)) {
      selected_age <- "Ogółem"
    }

    selected_years <- input$years
    if (is.null(selected_years)) {
      selected_years <- years
    }

    data <- session$userData$data %>%
      filter(area %in% selected_area, age %in% selected_age, year %in% selected_years)


    data <- data %>%
      group_by(year, week) %>%
      summarise(deaths = sum(deaths)) %>%
      ungroup()

    data %>%
      group_by(year, .add = TRUE) %>%
      e_chart(
        x = week
      ) %>%
      e_line(
        deaths
      ) %>%
      e_tooltip() %>%
      e_datazoom(type = "slider") %>%
      e_title("Comparison by year", left = "10%") %>%
      e_show_loading()
  })
}
