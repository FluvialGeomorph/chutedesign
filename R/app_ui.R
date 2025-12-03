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
          border_radius = FALSE,
          fillable = TRUE,
          class = "p-0",
          sidebar = sidebar(
            width = 500,
            actionButton("calculate_dimensions", "Calculate Dimensions"),
            card(
              card_header(
                "Width of Chute",
                popover(
                  bs_icon("info-circle"),
                  uiOutput("width_series")
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
                popover(
                  bs_icon("info-circle"),
                  uiOutput("length_series")
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
                popover(
                  bs_icon("info-circle"),
                  uiOutput("slope_series")
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
                popover(
                  bs_icon("info-circle"),
                  uiOutput("particle_size_series")
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
            fluidRow(
              column(11, numericInput("side_slope", "Side Slope (rise:run)", 2.5)),
              column(1, 
                popover(
                  bs_icon("info-circle"),
                  uiOutput("side_slope")
                ) 
              )
            ),
            fluidRow(
              column(11, numericInput("total_discharge", "Total Discharge (m^3/s)", 2000)),
              column(1, 
                popover(
                  bs_icon("info-circle"),
                  uiOutput("total_discharge")
                ) 
              )
            ),
            fluidRow(
              column(11, numericInput("stone_density", "Stone Density (kg/m^3)", 2650)),
              column(1, 
                popover(
                  bs_icon("info-circle"),
                  uiOutput("stone_density")
                ) 
              )
            ),
            fluidRow(
              column(11, numericInput("contingency", "Contingency Factor on Quantity", 1.3)),
              column(1, 
                popover(
                  bs_icon("info-circle"),
                  uiOutput("contingency")
                ) 
              )
            ),
            fluidRow(
              column(11, numericInput("porosity", "Bulk-Placed Porosity", 0.3)),
              column(1, 
                popover(
                  bs_icon("info-circle"),
                  uiOutput("porosity")
                ) 
              )
            ),
            fluidRow(
              column(11, numericInput("water_density", "Water Density (kg/m^3)", 998)),
              column(1, 
                popover(
                  bs_icon("info-circle"),
                  uiOutput("water_density")
                ) 
              )
            ),
            fluidRow(
              column(11, numericInput("gravity", "Gravitational Constant (N/m^3)", 9.787)),
              column(1, 
                popover(
                  bs_icon("info-circle"),
                  uiOutput("gravity")
                ) 
              )
            )
          ), # End sidebar
          navset_card_tab(
            id = "results",
            selected = "Intro",
            nav_panel(
              title = "Intro",
              layout_sidebar(
                border_radius = FALSE,
                fillable = TRUE,
                sidebar = sidebar(
                  id = "intro_help",
                  title = "Help",
                  position = "right",
                  width = "25pc",
                  open = TRUE,
                  uiOutput("intro_sidebar") 
                ),
                uiOutput("getting_started")
              )
            ),
            nav_panel(
              title = "by Width",
              layout_sidebar(
                border_radius = FALSE,
                fillable = TRUE,
                class = "p-0",
                sidebar = sidebar(
                  id = "by_width_help",
                  title = "Help",
                  position = "right",
                  width = 300,
                  open = TRUE,
                  uiOutput("by_width_sidebar")
                ),
                accordion(
                  id = "by_width_results",
                  open = c("Plots", "Data"),
                  accordion_panel(
                    id = "by_width_results",
                    title = "Plots",
                    help_overlay(
                      main    = plotOutput("width_stone_size"),
                      help_ui = popover(bs_icon("info-circle"), 
                                        uiOutput("plot_stone_size_method_plot"))
                    ),
                    help_overlay(
                      main    = plotOutput("width_channel_flow"),
                      help_ui = popover(bs_icon("info-circle"), 
                                        uiOutput("plot_channel_flow_plot"))
                    ),
                    help_overlay(
                      main    = plotOutput("width_stone_quants"),
                      help_ui = popover(bs_icon("info-circle"), 
                                        uiOutput("plot_stone_quantities_plot"))
                    )
                  ),
                  accordion_panel(
                    title = "Data",
                    help_overlay(
                      main    = DTOutput("width_table"),
                      help_ui = popover(bs_icon("info-circle"), 
                                        uiOutput("scenario_by_width_channel_dims"))
                    )
                  )
                )
              )
            ),
            nav_panel(
              title = "by Slope",
              layout_sidebar(
                border_radius = FALSE,
                fillable = TRUE,
                class = "p-0",
                sidebar = sidebar(
                  id = "by_width_help",
                  title = "Help",
                  position = "right",
                  width = 300,
                  open = TRUE,
                  uiOutput("by_slope_sidebar")
                ),
                accordion(
                  id = "by_slope_results",
                  open = c("Plots", "Data"),
                  accordion_panel(
                    id = "by_slope_results",
                    title = "Plots",
                    help_overlay(
                      main    = plotOutput("slope_stone_size"),
                      help_ui = popover(bs_icon("info-circle"), 
                                        uiOutput("plot_stone_size_method_plot"))
                    ),
                    help_overlay(
                      main    = plotOutput("slope_channel_flow"),
                      help_ui = popover(bs_icon("info-circle"), 
                                        uiOutput("plot_channel_flow_plot"))
                    ),
                    help_overlay(
                      main    = plotOutput("slope_stone_quants"),
                      help_ui = popover(bs_icon("info-circle"), 
                                        uiOutput("plot_stone_quantities_plot"))
                    )
                  ),
                  accordion_panel(
                    title = "Data",
                    help_overlay(
                      main    = DTOutput("slope_table"),
                      help_ui = popover(bs_icon("info-circle"), 
                                        uiOutput("scenario_by_slope_channel_dims"))
                    )
                  )
                )
              )
            ),
            nav_panel(
              title = "by Particle Size",
              layout_sidebar(
                border_radius = FALSE,
                fillable = TRUE,
                class = "p-0",
                sidebar = sidebar(
                  id = "by_width_help",
                  title = "Help",
                  position = "right",
                  width = 300,
                  open = TRUE,
                  uiOutput("by_particle_sidebar")
                ),
                accordion(
                  id = "by_particle_size_results",
                  open = c("Plots", "Data"),
                  accordion_panel(
                    id = "by_particle_size_results",
                    title = "Plots",
                    help_overlay(
                      main    = plotOutput("particle_size_stone_size"),
                      help_ui = popover(bs_icon("info-circle"), 
                                        uiOutput("plot_stone_size_method_plot"))
                    ),
                    help_overlay(
                      main    = plotOutput("particle_size_channel_flow"),
                      help_ui = popover(bs_icon("info-circle"), 
                                        uiOutput("plot_channel_flow_plot"))
                    ),
                    help_overlay(
                      main    = plotOutput("particle_size_stone_quants"),
                      help_ui = popover(bs_icon("info-circle"), 
                                        uiOutput("plot_stone_quantities_plot"))
                    )
                  ),
                  accordion_panel(
                    title = "Data",
                    help_overlay(
                      main    = DTOutput("particle_size_table"),
                      help_ui = popover(bs_icon("info-circle"), 
                                        uiOutput("scenario_by_particle_channel_dims"))
                    )
                  )
                )
              )
            )
          ) # End navset_card_tab
        ) # End layout_sidebar
      ) # End page_navbar
    ) # End page_navbar
  )
}
