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
    # Design Inputs

    ## Create scenario
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

    ## Create channel data frames
    width_df         <- by_width_df(scenario)
    slope_df         <- by_slope_df(scenario)
    particle_size_df <- by_particle_size_df(scenario)

    ## Calculate channel dimensions
    width_dims         <- channel_dimensions(width_df)
    slope_dims         <- channel_dimensions(slope_df)
    particle_size_dims <- channel_dimensions(particle_size_df)

    calc_colnames <- width_dims %>%
      select((ncol(width_df) + 1):ncol(.)) %>%
      colnames()

    # Result Outputs

    ## Chute diagram
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

    ## by Width
    output$width_stone_size <- renderPlot({
      plot_stone_size_method(width_dims, x_axis = "width")
    })
    output$width_channel_flow <- renderPlot({
      plot_channel_flow(width_dims, x_axis = "width")
    })
    output$width_stone_quants <- renderPlot({
      plot_stone_quantities(width_dims, x_axis = "width")
    })
    output$width_table <- renderDT({
      datatable(width_dims,
                extensions = 'Buttons',
                options = list(searching = FALSE,
                               dom = 'Bfrtip',
                               buttons = c('csv'))
      ) %>%
        formatRound(columns = calc_colnames, digits = 4)
    })

    ## by Slope
    output$slope_stone_size <- renderPlot({
      plot_stone_size_method(slope_dims, x_axis = "slope")
    })
    output$slope_channel_flow <- renderPlot({
      plot_channel_flow(slope_dims, x_axis = "slope")
    })
    output$slope_stone_quants <- renderPlot({
      plot_stone_quantities(slope_dims, x_axis = "slope")
    })
    output$slope_table <- renderDT({
      datatable(slope_dims,
                extensions = 'Buttons',
                options = list(searching = FALSE,
                               dom = 'Bfrtip',
                               buttons = c('csv'))
      ) %>%
        formatRound(columns = calc_colnames, digits = 4)
    })

    ## by Particle Size
    output$particle_size_stone_size <- renderPlot({
      plot_stone_size_method(particle_size_dims, x_axis = "particle_size")
    })
    output$particle_size_channel_flow <- renderPlot({
      plot_channel_flow(particle_size_dims, x_axis = "particle_size")
    })
    output$particle_size_stone_quants <- renderPlot({
      plot_stone_quantities(particle_size_dims, x_axis = "particle_size")
    })
    output$particle_size_table <- renderDT({
      datatable(particle_size_dims,
                extensions = 'Buttons',
                options = list(searching = FALSE,
                               dom = 'Bfrtip',
                               buttons = c('csv'))
      ) %>%
        formatRound(columns = calc_colnames, digits = 4)
    })

    ## Navigate to results
    nav_select(id = "results", selected = "by Width", session)
  })

}
