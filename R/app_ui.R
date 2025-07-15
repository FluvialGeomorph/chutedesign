#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),

    page_navbar(
      title = "Chute Design",
      id = "main",
      theme = bs_theme(bootswatch = "solar", version = 5),
      nav_panel(
        title = "Design a Chute",
        layout_sidebar(
          sidebar = sidebar(
            width = 400,
            accordion(
              accordion_panel(
                "Chute Parameters", icon = bsicons::bs_icon("rulers"),
                numericInput("width", "Width of Chute (m)", 10),
                numericInput("length", "Length of Chute (m)", 2000),
                numericInput("slope", "Slope of Chute (m/m)", 0.01),
                numericInput("side_slope", "Side Slope (h:v)", 2.5),
                numericInput("total_discharge", "Total Discharge (m^3/s)", 2000),
                numericInput("particle_size", "Particle Size (m)", 2.6)
              ),
              accordion_panel(
                "Constants", icon = bsicons::bs_icon("sliders"),
                numericInput("gravity", "Gravity (N/m^3)", 9.787),
                numericInput("water_density", "Water Density (kg/m^3)", 998),
                numericInput("stone_density", "Stone Density (kg/m^3)", 2650)
              )
            ), # End accordion
          ), # End sidebar
          navset_card_tab(
            nav_panel(
              title = "Plot 1",
              "Plot 1 content"
            ),
            nav_panel(
              title = "Plot 2",
              "Plot 2 content"
            )
          ) # End navset_card_tab
        ) # End layout_sidebar
      ) # End page_navbar
    ) # End page_navbar
  )
}
