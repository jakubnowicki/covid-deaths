function(input, output, session) {
  session$userData$data <- deaths

  observeEvent(input$selected_language, {
    shiny.i18n::update_lang(session, input$selected_language)
  })

  age_reactive <- reactive({
    input$age
  }) %>% debounce(2000)

  area_reactive <- reactive({
    input$area
  }) %>% debounce(2000)

  observeEvent(c(age_reactive(), area_reactive()), {
    age <- NULL
    if (!is.null(input$age)) {
      age <- "age"
    }

    area <- NULL
    if (!is.null(input$area)) {
      area <- "area"
    }

    old_value <- input$grouping

    update_dropdown_input(
      session,
      input_id = "grouping",
      choices = c("none", age, area),
      value = old_value
    )
  }, ignoreNULL = FALSE, ignoreInit = TRUE)

  output$general_chart <- echarts4r::renderEcharts4r({
    selected_area <- area_reactive()
    if (is.null(selected_area)) {
      selected_area <- "Polska"
    }

    selected_age <- age_reactive()
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

    formatter <- create_axis_formatter(data)

    data %>%
      e_chart(
        x = year_week
      ) %>%
      e_line(
        deaths
      ) %>%
      e_tooltip() %>%
      e_datazoom(type = "slider") %>%
      e_show_loading() %>%
      e_y_axis(formatter = htmlwidgets::JS(formatter))
  })

  output$year_comparison_chart <- echarts4r::renderEcharts4r({
    selected_area <- area_reactive()
    if (is.null(selected_area)) {
      selected_area <- "Polska"
    }

    selected_age <- age_reactive()
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

    formatter <- create_axis_formatter(data)

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
      e_show_loading() %>%
      e_y_axis(formatter = htmlwidgets::JS(formatter))
  })
}
