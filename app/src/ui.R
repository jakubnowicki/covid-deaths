semanticPage(
  margin = "0",
  includeCSS("www/styles.css"),
  shiny.semantic::grid(
    grid_template = grid_template(
      default = list(
        areas = cbind(
          c("controls", "controls"),
          c("general_chart", "year_comparison_chart"),
          c("general_controls", "year_comparison_controls")
        ),
        cols_width = c("1fr", "6fr", "1fr"),
        rows_height = c("1fr", "1fr")
      )
    ),
    general_chart = div(
      class = "ui raised segment",
      echarts4r::echarts4rOutput("general_chart", height = "100%")
    ),
    general_controls = div(
      class = "ui raised segment",
      shiny.semantic::selectInput(
        inputId = "grouping",
        label = "Group",
        choices = c("none", "age", "area"),
        multiple = FALSE
      )
    ),
    year_comparison_chart = div(
      class = "ui raised segment",
      echarts4r::echarts4rOutput("year_comparison_chart", height = "100%")
    ),
    year_comparison_controls = div(
      class = "ui raised segment",
      shiny.semantic::selectInput(
        inputId = "years",
        label = "Years to compare",
        choices = years,
        multiple = TRUE,
        selected = tail(sort(years), 2)
      )
    ),
    controls = div(
      class = "ui raised segment",
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
      )
    )
  )
)
