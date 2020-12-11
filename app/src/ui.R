semanticPage(
  margin = "0",
  includeCSS("www/styles.css"),
  shiny.semantic::grid(
    grid_template = grid_template(
      default = list(
        areas = cbind(
          c("controls", "general_chart", "year_comparison_chart"),
          c("controls", "general_controls", "year_comparison_controls")
        ),
        cols_width = c("7fr", "1fr"),
        rows_height = c("1fr", "7fr", "7fr")
      ),
      mobile = list(
        areas = rbind(
          c("controls"),
          c("general_controls"),
          c("general_chart"),
          c("year_comparison_controls"),
          c("year_comparison_chart")
        ),
        rows_height = c("1fr", "1fr", "5fr", "1fr", "5fr"),
        cols_width = c("100%")
      )
    ),
    general_chart = div(
      class = "ui raised segment",
      style = "min-height: 350px;",
      h3("Deaths in time"),
      echarts4r::echarts4rOutput("general_chart", height = "330px")
    ),
    general_controls = div(
      class = "ui raised segment",
      h3("Deaths in time controls"),
      shiny.semantic::selectInput(
        inputId = "grouping",
        label = "Group",
        choices = c("none"),
        multiple = FALSE
      )
    ),
    year_comparison_chart = div(
      class = "ui raised segment",
      style = "min-height: 350px;",
      h3("Comparison by year"),
      echarts4r::echarts4rOutput("year_comparison_chart", height = "330px")
    ),
    year_comparison_controls = div(
      class = "ui raised segment",
      h3("Comparison controls"),
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
      h3("Filters"),
      shiny.semantic::grid(
        grid_template = grid_template(
          default = list(
            areas = cbind("areas", "years"),
            cols_width = c("1fr", "1fr"),
            rows_height = "100%"
          ),
          mobile = list(
            areas = rbind("areas", "years"),
            cols_width = "100%",
            rows_height = c("1fr", "1fr")
          )
        ),
        areas = shiny.semantic::selectInput(
          inputId = "area",
          label = "Area",
          choices = areas[areas != "Polska"],
          multiple = TRUE,
          default_text = "Polska"
        ),
        years = shiny.semantic::selectInput(
          inputId = "age",
          label = "Age",
          choices = ages[ages != "Ogółem"],
          multiple = TRUE,
          default_text = "Ogółem"
        )
      )
    )
  ),
  shiny.info::display(
    span(
      "Created by Jakub Nowicki",
      tags$a(href = "https://twitter.com/q_nowicki", icon("twitter")),
      tags$a(href = "https://www.linkedin.com/in/jakub-nowicki/", icon("linkedin")),
      tags$a(href = "https://github.com/jakubnowicki", icon("github"))
    ),
    position = "bottom right"
  )
)
