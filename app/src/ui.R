semanticPage(
  shiny.semantic::grid(
    grid_template = grid_template(
      default = list(
        areas = cbind(c("controls", "controls"), c("general_chart", "year_comparison_chart")),
        cols_width = c("1fr", "5fr"),
        rows_height = c("1fr", "1fr")
      )
    ),
    general_chart = echarts4r::echarts4rOutput("general_chart", height = "100%"),
    year_comparison_chart = echarts4r::echarts4rOutput("year_comparison_chart", height = "100%"),
    controls = div(
      shiny.semantic::selectInput(
        inputId = "area",
        label = "Area",
        choices = areas,
        selected = "Polska",
        multiple = TRUE
      ),
      shiny.semantic::selectInput(
        inputId = "age",
        label = "Age",
        choices = ages,
        selected = "Ogółem",
        multiple = TRUE
      ),
      shiny.semantic::selectInput(
        inputId = "grouping",
        label = "Group",
        choices = c("none", "age", "area"),
        multiple = FALSE
      ),
      shiny.semantic::selectInput(
        inputId = "years",
        label = "Years to compare",
        choices = years,
        multiple = TRUE,
        selected = tail(sort(years), 2)
      )
    )
  )
)
