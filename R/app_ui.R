#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @import bsicons
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),

    page_navbar(
      title = "Chute Design",
      id = "main",
      theme = bs_theme(bootswatch = "flatly", version = 5),
      nav_panel(
        title = "Design a Chute",
        layout_sidebar(
          sidebar = sidebar(
            width = 450,
            actionButton("calculate_dimensions", "Calculate Dimensions"),
            card(
              card_header(
                "Width of Chute",
                tooltip(
                  bs_icon("info-circle"),
                  "Here are the instructions."
                ),
                class = "d-flex justify-content-between"
              ),
              fluidRow(
                column(4, numericInput("width_start", "Start Width(m)", 0)),
                column(4, numericInput("width_end", "End Width(m)", 100)),
                column(4, numericInput("width_by", "by Width(m)", 10))
              ),
            ),
            card(
              card_header(
                "Slope of Chute",
                tooltip(
                  bs_icon("info-circle"),
                  "Here are the instructions."
                ),
                class = "d-flex justify-content-between"
              ),
              fluidRow(
                column(4, numericInput("slope_start", "Start slope (m/m)", 0)),
                column(4, numericInput("slope_end", "End slope (m/m)", 1)),
                column(4, numericInput("slope_by", "by slope (m/m)", 0.01))
              ),
            ),
            card(
              card_header(
                "Particle Size",
                tooltip(
                  bs_icon("info-circle"),
                  "Particle Size for Hydrauic Comps (m)"
                ),
                class = "d-flex justify-content-between"
              ),
              fluidRow(
                column(4, numericInput("particle_size_start",
                                       "Start particle size (m)", 1)),
                column(4, numericInput("particle_size_end",
                                       "End particle size (m)", 2)),
                column(4, numericInput("particle_size_by",
                                       "by particle size (m)", 0.1))
              ),
            ),
            numericInput("length", "Length of Chute (m)", 2000),
            numericInput("side_slope", "Side Slope (h:v)", 2.5),
            numericInput("total_discharge", "Total Discharge (m^3/s)", 2000),
            numericInput("stone_density", "Stone Density (kg/m^3)", 2650),
            numericInput("particle_size", "Particle Size (m)", 2.6),
            numericInput("contingency", "Contingency Factor on Quantity", 1.3),
            numericInput("porosity", "Bulk-Placed Porosity", 0.3),
            numericInput("water_density", "Water Density (kg/m^3)", 998),
            numericInput("gravity", "Gravitational Constant (N/m^3)", 9.787)
          ), # End sidebar
          navset_card_tab(
            nav_panel(
              title = "by Width",
              "Plot 1 content"
            ),
            nav_panel(
              title = "by Slope",
              "Plot 2 content"
            )
          ) # End navset_card_tab
        ) # End layout_sidebar
      ) # End page_navbar
    ) # End page_navbar
  )
}
