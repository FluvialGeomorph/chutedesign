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

    ## Step 1: Compute channel flow parameters and geometry (wide, one row per point)
    width_dims         <- compute_channel_dimensions(width_df)
    length_dims        <- compute_channel_dimensions(length_df)
    slope_dims         <- compute_channel_dimensions(slope_df)
    particle_size_dims <- compute_channel_dimensions(particle_size_df)

    ## Step 2: Compute stone size metrics by method (long, one row per point per method)
    width_stone         <- compute_stone_metrics(width_dims)
    length_stone        <- compute_stone_metrics(length_dims)
    slope_stone         <- compute_stone_metrics(slope_dims)
    particle_size_stone <- compute_stone_metrics(particle_size_dims)

    ## Step 3: Compute adopted stone dimensions and quantities (wide, one row per point)
    width_adopted         <- compute_adopted_stone(width_dims, width_stone)
    length_adopted        <- compute_adopted_stone(length_dims, length_stone)
    slope_adopted         <- compute_adopted_stone(slope_dims, slope_stone)
    particle_size_adopted <- compute_adopted_stone(particle_size_dims, particle_size_stone)

    ## Column names for table formatting (computed columns only)
    calc_colnames <- width_adopted %>%
      select((ncol(width_df) + 1):ncol(.)) %>%
      colnames()

    # Result Outputs

    ## by Width
    output$width_stone_size <- renderPlot({
      plot_stone_size_method(width_stone, x_axis = "width")
    })
    output$width_channel_flow <- renderPlot({
      plot_channel_flow(width_dims, x_axis = "width")
    })
    output$width_stone_quants <- renderPlot({
      plot_stone_quantities(width_adopted, x_axis = "width")
    })
    output$width_table <- renderDT({
      datatable(width_adopted,
                extensions = 'Buttons',
                options = list(searching = FALSE,
                               dom = 'Bfrtip',
                               buttons = c('csv'))
      ) %>%
        formatRound(columns = calc_colnames, digits = 4)
    })

    ## by Length
    output$length_stone_size <- renderPlot({
      plot_stone_size_method(length_stone, x_axis = "length")
    })
    output$length_channel_flow <- renderPlot({
      plot_channel_flow(length_dims, x_axis = "length")
    })
    output$length_stone_quants <- renderPlot({
      plot_stone_quantities(length_adopted, x_axis = "length")
    })
    output$length_table <- renderDT({
      datatable(length_adopted,
                extensions = 'Buttons',
                options = list(searching = FALSE,
                               dom = 'Bfrtip',
                               buttons = c('csv'))
      ) %>%
        formatRound(columns = calc_colnames, digits = 4)
    })

    ## by Slope
    output$slope_stone_size <- renderPlot({
      plot_stone_size_method(slope_stone, x_axis = "slope")
    })
    output$slope_channel_flow <- renderPlot({
      plot_channel_flow(slope_dims, x_axis = "slope")
    })
    output$slope_stone_quants <- renderPlot({
      plot_stone_quantities(slope_adopted, x_axis = "slope")
    })
    output$slope_table <- renderDT({
      datatable(slope_adopted,
                extensions = 'Buttons',
                options = list(searching = FALSE,
                               dom = 'Bfrtip',
                               buttons = c('csv'))
      ) %>%
        formatRound(columns = calc_colnames, digits = 4)
    })

    ## by Particle Size
    output$particle_size_stone_size <- renderPlot({
      plot_stone_size_method(particle_size_stone, x_axis = "particle_size")
    })
    output$particle_size_channel_flow <- renderPlot({
      plot_channel_flow(particle_size_dims, x_axis = "particle_size")
    })
    output$particle_size_stone_quants <- renderPlot({
      plot_stone_quantities(particle_size_adopted, x_axis = "particle_size")
    })
    output$particle_size_table <- renderDT({
      datatable(particle_size_adopted,
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

    # Help Content
  ## Tab right sidebar help
  output$getting_started <- render_help_items(
    ids = "getting_started",
    data_name = "help_data",
    package = "chutedesign",
    fields = "detail",
    separator = NULL
  )

  output$intro_sidebar <- render_help_items(
    ids = "tab_intro",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$by_width_sidebar <- render_help_items(
    ids = "tab_by_width",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$by_length_sidebar <- render_help_items(
    ids = "tab_by_length",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$by_slope_sidebar <- render_help_items(
    ids = "tab_by_slope",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$by_particle_sidebar <- render_help_items(
    ids = "tab_by_particle_size",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  ## Enter Dimensions right sidebar help
  output$width_series <- render_help_items(
    ids = c("width", "width_series"),
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail")
  )

  output$length_series <- render_help_items(
    ids = c("length", "length_series"),
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail")
  )

  output$slope_series <- render_help_items(
    ids = c("slope", "slope_series"),
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail")
  )

  output$particle_size_series <- render_help_items(
    ids = c("particle_size", "particle_size_series"),
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail")
  )

  output$side_slope <- render_help_items(
    ids = "side_slope",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$total_discharge <- render_help_items(
    ids = "total_discharge",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$stone_density <- render_help_items(
    ids = "stone_density",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$contingency <- render_help_items(
    ids = "contingency",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$porosity <- render_help_items(
    ids = "porosity",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$water_density <- render_help_items(
    ids = "water_density",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$gravity <- render_help_items(
    ids = "gravity",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  ## Help entries for plot outputs — by Width
  output$plot_stone_size_method_plot_width <- render_help_items(
    ids = "plot_stone_size_method_plot",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$plot_channel_flow_plot_width <- render_help_items(
    ids = "plot_channel_flow_plot",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$plot_stone_quantities_plot_width <- render_help_items(
    ids = "plot_stone_quantities_plot",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  ## Help entries for plot outputs — by Length
  output$plot_stone_size_method_plot_length <- render_help_items(
    ids = "plot_stone_size_method_plot",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$plot_channel_flow_plot_length <- render_help_items(
    ids = "plot_channel_flow_plot",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$plot_stone_quantities_plot_length <- render_help_items(
    ids = "plot_stone_quantities_plot",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  ## Help entries for plot outputs — by Slope
  output$plot_stone_size_method_plot_slope <- render_help_items(
    ids = "plot_stone_size_method_plot",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$plot_channel_flow_plot_slope <- render_help_items(
    ids = "plot_channel_flow_plot",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$plot_stone_quantities_plot_slope <- render_help_items(
    ids = "plot_stone_quantities_plot",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  ## Help entries for plot outputs — by Particle Size
  output$plot_stone_size_method_plot_particle_size <- render_help_items(
    ids = "plot_stone_size_method_plot",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$plot_channel_flow_plot_particle_size <- render_help_items(
    ids = "plot_channel_flow_plot",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$plot_stone_quantities_plot_particle_size <- render_help_items(
    ids = "plot_stone_quantities_plot",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  ## Help entries for Data scenario/channel_dimensions outputs
  output$scenario_by_width_channel_dims <- render_help_items(
    ids = "scenario_by_width_channel_dims",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$scenario_by_length_channel_dims <- render_help_items(
    ids = "scenario_by_length_channel_dims",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$scenario_by_slope_channel_dims <- render_help_items(
    ids = "scenario_by_slope_channel_dims",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )

  output$scenario_by_particle_size_channel_dims <- render_help_items(
    ids = "scenario_by_particle_size_channel_dims",
    data_name = "help_data",
    package = "chutedesign",
    fields = c("summary", "detail"),
    separator = NULL
  )
}
