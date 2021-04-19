semanticPage(
  margin = "0",
  includeCSS("www/styles.css"),
  shiny.i18n::usei18n(i18n),
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
      h3(i18n$t("Deaths in time")),
      echarts4r::echarts4rOutput("general_chart", height = "300px")
    ),
    general_controls = div(
      class = "ui raised segment",
      h3(i18n$t("Deaths in time controls")),
      shiny.semantic::selectInput(
        inputId = "grouping",
        label = i18n$t("Group"),
        choices = setNames(
          c("none", "age", "macroregion_name", "region_name", "subregion_name"),
          c("None", "Age", "Macroregion", "Region", "Subregion")
        ),
        multiple = FALSE
      )
    ),
    year_comparison_chart = div(
      class = "ui raised segment",
      style = "min-height: 350px;",
      h3(i18n$t("Comparison by year")),
      echarts4r::echarts4rOutput("year_comparison_chart", height = "300px")
    ),
    year_comparison_controls = div(
      class = "ui raised segment",
      h3(i18n$t("Comparison controls")),
      shiny.semantic::selectInput(
        inputId = "years",
        label = i18n$t("Years to compare"),
        choices = years,
        multiple = TRUE,
        selected = tail(sort(years), 3)
      )
    ),
    controls = div(
      class = "ui raised segment",
      h3(i18n$t("Filters")),
      div(
        class = "language-input",
        selectInput(
          inputId = "selected_language",
          label = NULL,
          choices = i18n$get_languages(),
          selected = i18n$get_key_translation()
        )
      ),
      shiny.semantic::grid(
        grid_template = grid_template(
          default = list(
            areas = rbind("areas", "years"),
            cols_width = "100%",
            rows_height = c("1fr", "1fr")
          ),
          mobile = list(
            areas = rbind("areas", "years"),
            cols_width = "100%",
            rows_height = c("3fr", "1fr")
          )
        ),
        areas = shiny.semantic::grid(
          grid_template = grid_template(
            default = list(
              areas = cbind("macroregion", "region", "subregion"),
              cols_width = c("1fr", "1fr", "1fr"),
              rows_width = "100%"
            ),
            mobile = list(
              areas = rbind("macroregion", "region", "subregion"),
              cols_width = "100%",
              rows_height = c("1fr", "1fr", "1fr")
            )
          ),
          macroregion = shiny.semantic::selectInput(
            inputId = "macroregion",
            label = i18n$t("Macroregion"),
            choices = macroregions,
            multiple = TRUE,
            default_text = i18n$t("All")
          ),
          region = uiOutput("region_input"),
          subregion = uiOutput("subregion_input")
        ),
        years = shiny.semantic::selectInput(
          inputId = "age",
          label = i18n$t("Age"),
          choices = ages[ages != "Ogółem"],
          multiple = TRUE,
          default_text = i18n$t("All")
        )
      )
    )
  ),
  div(
    class = "info-box",
    span(
      "Created by Jakub Nowicki",
      tags$a(href = "https://twitter.com/q_nowicki", icon("twitter")),
      tags$a(href = "https://www.linkedin.com/in/jakub-nowicki/", icon("linkedin")),
      tags$a(href = "https://github.com/jakubnowicki", icon("github"))
    )
  )
)
