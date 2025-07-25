test_that("draw_channel_3d", {
  width = 5
  length = 30
  slope = 0.03
  side_slope = 2
  depth = 2.5
  alpha = 0.6

  expect_silent({
    widget <- draw_channel_3d(width = width,
                              length = length,
                              slope = slope,
                              side_slope = side_slope,
                              depth = depth,
                              alpha = alpha)
  })
  expect_s3_class(widget, "rglWebGL")
})

test_that("draw_channel_3d from scenario", {
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
  depth = 2.5
  alpha = 0.6
  expect_silent({
    widget <- draw_channel_3d(width = scenario$width,
                              length = scenario$length,
                              slope = scenario$slope,
                              side_slope = scenario$side_slope,
                              depth = depth,
                              alpha = alpha)
  })
  expect_s3_class(widget, "rglWebGL")
})

test_that("draw_channel_3d from by_width_df", {
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
  width_dims <- channel_dimensions(width_df)
  alpha = 0.6

  diagram_dims <- width_dims %>%
    filter(.data$width == scenario$width)

  expect_silent({
    widget <- draw_channel_3d(width = diagram_dims$width,
                              length = diagram_dims$length,
                              slope = diagram_dims$slope,
                              side_slope = diagram_dims$side_slope,
                              depth = diagram_dims$depth,
                              alpha = alpha)
  })
  expect_s3_class(widget, "rglWebGL")
})
