test_that("compute_channel_dimensions integrates with by_width_df", {
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
  channel_df <- by_width_df(scenario)
  channel_dimensions <- compute_channel_dimensions(channel_df)
  
  # Ensure essential columns exist
  expect_true("unit_discharge" %in% colnames(channel_dimensions))
  expect_true("critical_depth" %in% colnames(channel_dimensions))
  expect_true("froude" %in% colnames(channel_dimensions))

  # Validate output dimensions
  expect_gt(nrow(channel_dimensions), 0)

  # Validate specific calculations against expected values
  expect_equal(channel_dimensions$unit_discharge[1], 
               channel_dimensions$total_discharge[1] / channel_dimensions$width[1])
  expect_lt(channel_dimensions$froude[1], 1)

  # Edge case: very small or large width
  channel_df_small_width <- channel_df %>% dplyr::mutate(width = 0.0)
  channel_dimensions_small_width <- compute_channel_dimensions(channel_df_small_width)
  
  expect_true(all(is.infinite(channel_dimensions_small_width$unit_discharge)))
  expect_true(all(is.nan(channel_dimensions_small_width$froude)))

  channel_df_large_width <- channel_df %>% dplyr::mutate(width = 1e6)
  channel_dimensions_large_width <- compute_channel_dimensions(channel_df_large_width)
  expect_gt(max(channel_dimensions_large_width$unit_discharge, na.rm = TRUE), 0)

  # Test for missing columns
  invalid_df <- channel_df %>% dplyr::select(-slope)
  expect_error(compute_channel_dimensions(invalid_df), "object 'slope' not found")
})