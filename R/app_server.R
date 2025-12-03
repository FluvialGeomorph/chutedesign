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
    length_df        <- by_length_df(scenario)
    slope_df         <- by_slope_df(scenario)
    particle_size_df <- by_particle_size_df(scenario)

    ## Calculate channel dimensions
    width_dims         <- channel_dimensions(width_df)
    length_dims        <- channel_dimensions(length_df)
    slope_dims         <- channel_dimensions(slope_df)
    particle_size_dims <- channel_dimensions(particle_size_df)

    calc_colnames <- width_dims %>%
      select((ncol(width_df) + 1):ncol(.)) %>%
      colnames()

    # Result Outputs

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

    ## by Length
    output$length_stone_size <- renderPlot({
      plot_stone_size_method(length_dims, x_axis = "length")
    })
    output$length_channel_flow <- renderPlot({
      plot_channel_flow(length_dims, x_axis = "length")
    })
    output$length_stone_quants <- renderPlot({
      plot_stone_quantities(length_dims, x_axis = "length")
    })
    output$length_table <- renderDT({
      datatable(length_dims,
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

  # Render help text
  output$getting_started <- renderUI({
    markdown(filter(chutedesign::help_data, id == "getting_started")$sidebar)
  })
  output$intro_sidebar <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "tab_intro")$popover),
      markdown(filter(chutedesign::help_data, id == "tab_intro")$sidebar)
    )
  })
  output$by_width_sidebar <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "tab_by_width")$popover),
      markdown(filter(chutedesign::help_data, id == "tab_by_width")$sidebar)
    )
  })
  output$by_length_sidebar <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "tab_by_length")$popover),
      markdown(filter(chutedesign::help_data, id == "tab_by_length")$sidebar)
    )
  })
  output$by_slope_sidebar <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "tab_by_slope")$popover),
      markdown(filter(chutedesign::help_data, id == "tab_by_slope")$sidebar)
    )
  })
  output$by_particle_sidebar <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "tab_by_particle_size")$popover),
      markdown(filter(chutedesign::help_data, id == "tab_by_particle_size")$sidebar)
    )
  })
  output$width_series <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "width_series")$popover),
      markdown(filter(chutedesign::help_data, id == "width_series")$sidebar) 
    )
  })
  output$length_series <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "length_series")$popover),
      markdown(filter(chutedesign::help_data, id == "length_series")$sidebar)
    )
  })
  output$slope_series <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "slope_series")$popover),
      markdown(filter(chutedesign::help_data, id == "slope_series")$sidebar)
    )
  })
  output$particle_size_series <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "particle_size_series")$popover),
      markdown(filter(chutedesign::help_data, id == "particle_size_series")$sidebar)
    )
  })
  output$side_slope <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "side_slope")$popover),
      markdown(filter(chutedesign::help_data, id == "side_slope")$sidebar)
    )
  })
  output$total_discharge <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "total_discharge")$popover),
      markdown(filter(chutedesign::help_data, id == "total_discharge")$sidebar)
    )    
  })
  output$stone_density <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "stone_density")$popover),
      markdown(filter(chutedesign::help_data, id == "stone_density")$sidebar)
    )
  })
  output$contingency <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "contingency")$popover),
      markdown(filter(chutedesign::help_data, id == "contingency")$sidebar)
    )
  })
  output$porosity <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "porosity")$popover),
      markdown(filter(chutedesign::help_data, id == "porosity")$sidebar)
    )
  })
  output$water_density <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "water_density")$popover),
      markdown(filter(chutedesign::help_data, id == "water_density")$sidebar)
    )
  })
  output$gravity <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "gravity")$popover),
      markdown(filter(chutedesign::help_data, id == "gravity")$sidebar)
    )
  })

  # Help entries for plot outputs
  output$plot_stone_size_method_plot <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "plot_stone_size_method_plot")$popover),
      markdown(filter(chutedesign::help_data, id == "plot_stone_size_method_plot")$sidebar)
    )
  })
  output$plot_channel_flow_plot <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "plot_channel_flow_plot")$popover),
      markdown(filter(chutedesign::help_data, id == "plot_channel_flow_plot")$sidebar)
    )
  })
  output$plot_stone_quantities_plot <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "plot_stone_quantities_plot")$popover),
      markdown(filter(chutedesign::help_data, id == "plot_stone_quantities_plot")$sidebar)
    )
  })

  # Help entries for scenario/channel_dimensions outputs
  output$scenario_by_width_channel_dims <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "scenario_by_width_channel_dims")$popover),
      markdown(filter(chutedesign::help_data, id == "scenario_by_width_channel_dims")$sidebar)
    )
  })
  output$scenario_by_slope_channel_dims <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "scenario_by_slope_channel_dims")$popover),
      markdown(filter(chutedesign::help_data, id == "scenario_by_slope_channel_dims")$sidebar)
    )
  })
  output$scenario_by_particle_size_channel_dims <- renderUI({
    tagList(
      markdown(filter(chutedesign::help_data, id == "scenario_by_particle_size_channel_dims")$popover),
      markdown(filter(chutedesign::help_data, id == "scenario_by_particle_size_channel_dims")$sidebar)
    )
  })
}
