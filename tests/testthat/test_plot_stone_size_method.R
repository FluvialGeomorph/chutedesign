test_that("check by_width_df", {
  scenario <- create_scenario (
    width               = 60,
    width_start         = 40,
    width_end           = 200,
    width_by            = 20,
    length              = 2000,
    length_start        = 1000,
    length_end          = 3000,
    length_by           = 500,
    slope               = 0.01,
    slope_start         = 0,
    slope_end           = 1,
    slope_by            = 0.05,
    particle_size       = 2.6,
    particle_size_start = 1,
    particle_size_end   = 3,
    particle_size_by    = 0.1,
    side_slope          = 2.5,
    total_discharge     = 2000,
    stone_density       = 2650,
    contingency         = 1.3,
    porosity            = 0.3,
    water_density       = 998,
    gravity             = 9.787
  )
  width_df <- by_width_df(scenario)
  channel_dimensions <- compute_channel_dimensions(width_df)
  stone_metrics <- compute_stone_metrics(channel_dimensions)
  x_axis <- "width"
  plot1 <- plot_stone_size_method(stone_metrics, x_axis)
  plot1
  expect_s3_class(plot1, "ggplot")
})

test_that("check by_length_df", {
  scenario <- create_scenario (
    width               = 60,
    width_start         = 40,
    width_end           = 200,
    width_by            = 20,
    length              = 2000,
    length_start        = 1000,
    length_end          = 3000,
    length_by           = 500,
    slope               = 0.01,
    slope_start         = 0,
    slope_end           = 1,
    slope_by            = 0.05,
    particle_size       = 2.6,
    particle_size_start = 1,
    particle_size_end   = 3,
    particle_size_by    = 0.1,
    side_slope          = 2.5,
    total_discharge     = 2000,
    stone_density       = 2650,
    contingency         = 1.3,
    porosity            = 0.3,
    water_density       = 998,
    gravity             = 9.787
  )
  length_df <- by_length_df(scenario)
  channel_dimensions <- compute_channel_dimensions(length_df)
  stone_metrics <- compute_stone_metrics(channel_dimensions)
  x_axis <- "length"
  plot2 <- plot_stone_size_method(stone_metrics, x_axis)
  #plot2
  expect_s3_class(plot2, "ggplot")
})

test_that("check by_slope_df", {
  scenario <- create_scenario (
    width               = 60,
    width_start         = 40,
    width_end           = 200,
    width_by            = 20,
    length              = 2000,
    length_start        = 1000,
    length_end          = 3000,
    length_by           = 500,
    slope               = 0.01,
    slope_start         = 0,
    slope_end           = 1,
    slope_by            = 0.05,
    particle_size       = 2.6,
    particle_size_start = 1,
    particle_size_end   = 3,
    particle_size_by    = 0.1,
    side_slope          = 2.5,
    total_discharge     = 2000,
    stone_density       = 2650,
    contingency         = 1.3,
    porosity            = 0.3,
    water_density       = 998,
    gravity             = 9.787
  )
  slope_df <- by_slope_df(scenario)
  channel_dimensions <- compute_channel_dimensions(slope_df)
  stone_metrics <- compute_stone_metrics(channel_dimensions)
  x_axis = "slope"
  plot3 <- plot_stone_size_method(stone_metrics, x_axis)
  #plot3
  expect_s3_class(plot3, "ggplot")
})

test_that("check by_particle_size_df", {
  scenario <- create_scenario (
    width               = 60,
    width_start         = 40,
    width_end           = 200,
    width_by            = 20,
    length              = 2000,
    length_start        = 1000,
    length_end          = 3000,
    length_by           = 500,
    slope               = 0.01,
    slope_start         = 0,
    slope_end           = 1,
    slope_by            = 0.05,
    particle_size       = 2.6,
    particle_size_start = 1,
    particle_size_end   = 3,
    particle_size_by    = 0.1,
    side_slope          = 2.5,
    total_discharge     = 2000,
    stone_density       = 2650,
    contingency         = 1.3,
    porosity            = 0.3,
    water_density       = 998,
    gravity             = 9.787
  )
  particle_size_df <- by_particle_size_df(scenario)
  channel_dimensions <- compute_channel_dimensions(particle_size_df)
  stone_metrics <- compute_stone_metrics(channel_dimensions)
  x_axis = "particle_size"
  plot4 <- plot_stone_size_method(stone_metrics, x_axis)
  #plot4
  expect_s3_class(plot4, "ggplot")
})

test_that("plot_stone_size_method handles missing or invalid inputs", {
  scenario <- create_scenario(
    width               = 60,
    width_start         = 40,
    width_end           = 200,
    width_by            = 20,
    length              = 2000,
    length_start        = 1000,
    length_end          = 3000,
    length_by           = 500,
    slope               = 0.02,
    slope_start         = 0,
    slope_end           = 1,
    slope_by            = 0.05,
    particle_size       = 2.6,
    particle_size_start = 1,
    particle_size_end   = 3,
    particle_size_by    = 0.1,
    side_slope          = 2.5,
    total_discharge     = 2000,
    stone_density       = 2650,
    contingency         = 1.3,
    porosity            = 0.3,
    water_density       = 998,
    gravity             = 9.787
  )

  channel_df <- by_width_df(scenario)
  channel_dimensions <- compute_channel_dimensions(channel_df)
  stone_metrics <- compute_stone_metrics(channel_dimensions)

  # Test invalid x_axis
  expect_error(plot_stone_size_method(stone_metrics, x_axis = "invalid"),
               "x_axis must be one of")

  # Test missing required columns
  invalid_metrics <- stone_metrics %>% dplyr::select(-width)
  expect_error(plot_stone_size_method(invalid_metrics, x_axis = "width"),
               "The following required columns are missing")
})
