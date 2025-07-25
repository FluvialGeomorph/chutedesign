#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @import bsicons
#' @importFrom DT DTOutput
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
                  "Use these fields to configure the range of chute widths to be calculated."
                ),
                class = "d-flex justify-content-between"
              ),
              numericInput("width", "Width of Interest (m)", 60),
              fluidRow(
                column(4, numericInput("width_start", "Start Width (m)", 40)),
                column(4, numericInput("width_end", "End Width (m)", 200)),
                column(4, numericInput("width_by", "by Width (m)", 20))
              ),
            ),
            card(
              card_header(
                "Length of Chute",
                tooltip(
                  bs_icon("info-circle"),
                  "Use these fields to configure the range of chute lengths to be calculated."
                ),
                class = "d-flex justify-content-between"
              ),
              numericInput("length", "Length of Interest (m)", 2000),
              fluidRow(
                column(4, numericInput("length_start", "Start Length (m)", 1000)),
                column(4, numericInput("length_end", "End Length (m)", 3000)),
                column(4, numericInput("length_by", "by Length (m)", 500))
              ),
            ),
            card(
              card_header(
                "Slope of Chute",
                tooltip(
                  bs_icon("info-circle"),
                  "Use these fields to configure the range of chute slopes to be calculated."
                ),
                class = "d-flex justify-content-between"
              ),
              numericInput("slope", "Slope of Interest (m/m)", 0.01),
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
                  "Use these fields to configure the range of chute particle sizes to be calculated."
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
              markdown("
              # Getting Started

              This app helps estimate the stone sizes required for chutes of various dimensions.

              ## Define the Scenario

              1. In the left sidebar, specify the design characteristics of the chute.
              2. Click the `Calculate Dimensions` button.

              ## Review the Results

              Scenario results can be explored using the tabs across the top of the app.

              * Diagram - View a wireframe diagram of the specified channel.
              * by Width - View results of the scenario where chute widths are varied.
              * by Slope - View results of the scenario where chute slopes are varied.
              * by Particle Size - View results of the scenario where chute particle sizes are varied.

              ")
            ),
            nav_panel(
              title = "Diagram",
              rglwidgetOutput("channel_plot", width = "100%", height = "600px")
            ),
            nav_panel(
              title = "by Width",
              accordion(
                id = "by_width_results",
                open = c("Plots", "Data"),
                accordion_panel(
                  title = "Plots",
                  plotOutput("width_stone_size"),
                  plotOutput("width_channel_flow"),
                  plotOutput("width_stone_quants")
                ),
                accordion_panel(
                  title = "Data",
                  DTOutput("width_table")
                )
              )
            ),
            nav_panel(
              title = "by Slope",
              accordion(
                id = "by_slope_results",
                open = c("Plots", "Data"),
                accordion_panel(
                  title = "Plots",
                  plotOutput("slope_stone_size"),
                  plotOutput("slope_channel_flow"),
                  plotOutput("slope_stone_quants")
                ),
                accordion_panel(
                  title = "Data",
                  DTOutput("slope_table")
                )
              )
            ),
            nav_panel(
              title = "by Particle Size",
              accordion(
                id = "by_particle_results",
                open = c("Plots", "Data"),
                accordion_panel(
                  title = "Plots",
                  plotOutput("particle_size_stone_size"),
                  plotOutput("particle_size_channel_flow"),
                  plotOutput("particle_size_stone_quants")
                ),
                accordion_panel(
                  title = "Data",
                  DTOutput("particle_size_table")
                )
              )
            )
          ) # End navset_card_tab
        ) # End layout_sidebar
      ) # End page_navbar
    ) # End page_navbar
  )
}
