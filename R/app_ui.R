#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @import bsicons
#' @importFrom rgl rglwidgetOutput
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
            width = 500,
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
              numericInput("width", "Width of Interest (m)", 50),
              fluidRow(
                column(4, numericInput("width_start", "Start Width (m)", 0)),
                column(4, numericInput("width_end", "End Width (m)", 100)),
                column(4, numericInput("width_by", "by Width (m)", 10))
              ),
            ),
            card(
              card_header(
                "Length of Chute",
                tooltip(
                  bs_icon("info-circle"),
                  "Here are the instructions."
                ),
                class = "d-flex justify-content-between"
              ),
              numericInput("length", "Length of Interest (m)", 2000),
              fluidRow(
                column(4, numericInput("length_start", "Start Length (m)", 1000)),
                column(4, numericInput("length_end", "End Length (m)", 5000)),
                column(4, numericInput("length_by", "by Length (m)", 500))
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
              numericInput("slope", "Slope of Interest (m/m)", 0.1),
              fluidRow(
                column(4, numericInput("slope_start", "Start Slope (m/m)", 0)),
                column(4, numericInput("slope_end", "End Slope (m/m)", 1)),
                column(4, numericInput("slope_by", "by Slope (m/m)", 0.01))
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
              numericInput("particle_size",
                           "Particle Size of Interest (m)", 1.6),
              fluidRow(
                column(4, numericInput("particle_size_start",
                                       "Start Particle Size (m)", 1)),
                column(4, numericInput("particle_size_end",
                                       "End Particle Size (m)", 2)),
                column(4, numericInput("particle_size_by",
                                       "by Particle Size (m)", 0.1))
              ),
            ),
            numericInput("side_slope", "Side Slope (rise:run)", 2.5),
            numericInput("total_discharge", "Total Discharge (m^3/s)", 2000),
            numericInput("stone_density", "Stone Density (kg/m^3)", 2650),
            numericInput("contingency", "Contingency Factor on Quantity", 1.3),
            numericInput("porosity", "Bulk-Placed Porosity", 0.3),
            numericInput("water_density", "Water Density (kg/m^3)", 998),
            numericInput("gravity", "Gravitational Constant (N/m^3)", 9.787)
          ), # End sidebar
          navset_card_tab(
            id = "results",
            selected = "Intro",
            nav_panel(
              title = "Intro",
              "Getting Started
              Instructions go here."
            ),
            nav_panel(
              title = "Diagram",
              rglwidgetOutput("channel_plot", width = "100%", height = "600px")
            ),
            nav_panel(
              title = "by Width",
              "Plots go here."
            ),
            nav_panel(
              title = "by Length",
              "Plots go here."
            ),
            nav_panel(
              title = "by Slope",
              "Plots go here."
            ),
            nav_panel(
              title = "by Particle Size",
              "Plots go here."
            )
          ) # End navset_card_tab
        ) # End layout_sidebar
      ) # End page_navbar
    ) # End page_navbar
  )
}
