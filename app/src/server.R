function(input, output, session) {
  session$userData$data <- data

  output$chart <- echarts4r::renderEcharts4r({
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

    if (!is.null(input$grouping)) {
      data <- data %>%
      group_by(
        across(input$grouping)
      )
    }

    data <- data %>%
      group_by(year_week, .add = TRUE) %>%
      summarise(deaths = sum(deaths)) %>%
      ungroup()

    if (!is.null(input$grouping)) {
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
      e_datazoom(type = "slider")
  })
}
