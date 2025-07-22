#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @import dplyr
#' @importFrom DT renderDT datatable formatRound
#' @importFrom rgl renderRglwidget
#' @noRd
app_server <- function(input, output, session) {

  observeEvent(input$calculate_dimensions, {
    scenario <- create_scenario(
      width               = input$width,
      width_start         = input$width_start,
      width_end           = input$width_end,
      width_by            = input$width_by,
      length              = input$length,
      length_start        = input$length_start,
      length_end          = input$length_end,
      length_by           = input$length_by,
      slope               = input$slope,
      slope_start         = input$slope_start,
      slope_end           = input$slope_end,
      slope_by            = input$slope_by,
      particle_size       = input$particle_size,
      particle_size_start = input$particle_size_start,
      particle_size_end   = input$particle_size_end,
      particle_size_by    = input$particle_size_by,
      side_slope          = input$side_slope,
      total_discharge     = input$total_discharge,
      stone_density       = input$stone_density,
      contingency         = input$contingency,
      porosity            = input$porosity,
      water_density       = input$water_density,
      gravity             = input$gravity
    )
    message("Scenario created")

    # Create channel data frames
    width_df <- by_width_df(scenario)
    message("width_df created")

    # Calculate channel dimensions
    width_dims <- channel_dimensions(width_df)
    message("width_dims created")

    calc_colnames <- width_dims %>%
      select(ncol(width_df):ncol(.)) %>%
      colnames()

    # Result outputs
    output$width_stone_size <- renderPlot({
      plot_stone_size_method(width_dims)
    })

    output$width_table <- renderDT(
      datatable(width_dims) %>%
        formatRound(columns = calc_colnames)
    )

    # Create diagram
    diagram_dims <- width_dims %>%
      filter(.data$width == input$width)

    output$channel_plot <- renderRglwidget({
      draw_channel_3d(
        width = input$width,
        length = input$length,
        slope = input$slope,
        side_slope = input$side_slope,
        depth = diagram_dims$depth,
        alpha = 0.5
      )
    })

    nav_select(id = "results", selected = "Diagram", session)

  })

}
