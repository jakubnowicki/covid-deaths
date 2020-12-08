semanticPage(
  shiny.semantic::grid(
    grid_template = grid_template(
      default = list(
        areas = rbind("chart", "controls"),
        rows_height = c("5fr", "2fr")
      )
    ),
    chart = echarts4r::echarts4rOutput("chart", height = "100%"),
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
        choices = c("area", "age", "year"),
        multiple = TRUE
      )
    )
  )
)
