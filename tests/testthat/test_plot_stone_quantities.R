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
  width_dims <- compute_channel_dimensions(width_df)
  width_stone <- compute_stone_metrics(width_dims)
  width_adopted <- compute_adopted_stone(width_dims, width_stone)
  x_axis <- "width"
  plot1 <- plot_stone_quantities(width_adopted, x_axis = x_axis)
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
  length_dims <- compute_channel_dimensions(length_df)
  length_stone <- compute_stone_metrics(length_dims)
  length_adopted <- compute_adopted_stone(length_dims, length_stone)
  x_axis <- "length"
  plot1 <- plot_stone_quantities(length_adopted, x_axis = x_axis)
  plot1
  expect_s3_class(plot1, "ggplot")
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
  slope_dims <- compute_channel_dimensions(slope_df)
  slope_stone <- compute_stone_metrics(slope_dims)
  slope_adopted <- compute_adopted_stone(slope_dims, slope_stone)
  x_axis = "slope"
  plot2 <- plot_stone_quantities(slope_adopted, x_axis = x_axis)
  plot2
  expect_s3_class(plot2, "ggplot")
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
  particle_size_dims <- compute_channel_dimensions(particle_size_df)
  particle_size_stone <- compute_stone_metrics(particle_size_dims)
  particle_size_adopted <- compute_adopted_stone(particle_size_dims, particle_size_stone)
  x_axis = "particle_size"
  plot3 <- plot_stone_quantities(particle_size_adopted, x_axis = x_axis)
  plot3
  expect_s3_class(plot3, "ggplot")
})
