function(input, output, session) {
  session$userData$data <- deaths

  observeEvent(input$selected_language, {
    shiny.i18n::update_lang(session, input$selected_language)
  })

  output$region_input <- renderUI({
    regions_df <- areas_df %>%
      filter(macroregion %in% input$macroregion & area_level == "region")

    regions <- setNames(regions_df$region, regions_df$area)

    shiny.semantic::selectInput(
          inputId = "region",
          label = i18n$t("Region"),
          choices = regions,
          multiple = TRUE,
          default_text = i18n$t("All")
        )
  })

  output$subregion_input <- renderUI({
    subregions_df <- areas_df %>%
      filter(region %in% input$region & area_level == "subregion")

    subregions <- setNames(subregions_df$subregion, subregions_df$area)

    shiny.semantic::selectInput(
          inputId = "subregion",
          label = i18n$t("Subregion"),
          choices = subregions,
          multiple = TRUE,
          default_text = i18n$t("All")
        )
  })

  age_reactive <- reactive({
    input$age
  }) %>% debounce(2000)

  area_reactive <- reactive({
    input$area
  }) %>% debounce(2000)

  filtered_data <- reactive({
    selected_area <- area_reactive()
    if (is.null(selected_area)) {
      selected_area <- "Polska"
    }

    selected_age <- age_reactive()
    if (is.null(selected_age)) {
      selected_age <- "Ogółem"
    }

    data <- session$userData$data %>%
      filter(age %in% selected_age)

    if (!is.null(input$macroregion)) {
      data <- data %>%
        filter(macroregion %in% input$macroregion)
    }

    if (!is.null(input$region)) {
      data <- data %>%
        filter(region %in% input$region)
    }

    if (!is.null(input$subregion)) {
      data <- data %>%
        filter(subregion %in% input$subregion)
    }

    data
  })

  output$general_chart <- echarts4r::renderEcharts4r({
    data <- filtered_data()

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

    show_legend <- FALSE

    if (input$grouping != "none") {
      data <- data %>%
        group_by(
          across(input$grouping)
        )

      show_legend <- TRUE
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
      e_y_axis(formatter = htmlwidgets::JS(formatter)) %>%
      e_legend(show_legend)
  })

  output$year_comparison_chart <- echarts4r::renderEcharts4r({
    data <- filtered_data()

    selected_years <- input$years
    if (is.null(selected_years)) {
      selected_years <- years
    }

    data <- data %>%
      filter(year %in% selected_years)


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
