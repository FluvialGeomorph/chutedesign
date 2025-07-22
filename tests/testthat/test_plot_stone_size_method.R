test_that("check by_width_df", {
  width               = 60
  width_start         = 40
  width_end           = 200
  width_by            = 20
  length              = 2000
  length_start        = 1000
  length_end          = 3000
  length_by           = 500
  slope               = 0.01
  slope_start         = 0
  slope_end           = 1
  slope_by            = 0.05
  particle_size       = 2.6
  particle_size_start = 1
  particle_size_end   = 3
  particle_size_by    = 0.1
  side_slope          = 2.5
  total_discharge     = 2000
  stone_density       = 2650
  contingency         = 1.3
  porosity            = 0.3
  water_density       = 998
  gravity             = 9.787

  scenario <- create_scenario (
    width               = width,
    width_start         = width_start,
    width_end           = width_end,
    width_by            = width_by,
    length              = length,
    length_start        = length_start,
    length_end          = length_end,
    length_by           = length_by,
    slope               = slope,
    slope_start         = slope_start,
    slope_end           = slope_end,
    slope_by            = slope_by,
    particle_size       = particle_size,
    particle_size_start = particle_size_start,
    particle_size_end   = particle_size_end,
    particle_size_by    = particle_size_by,
    side_slope          = side_slope,
    total_discharge     = total_discharge,
    stone_density       = stone_density,
    contingency         = contingency,
    porosity            = porosity,
    water_density       = water_density,
    gravity             = gravity
  )

  channel_df <- by_width_df(scenario)
  channel_dims <- channel_dimensions(channel_df)
  plot <- plot_stone_size_method(channel_dims)
  expect_s3_class(plot, "ggplot")
})
