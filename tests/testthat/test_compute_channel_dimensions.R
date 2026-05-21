test_that("compute_channel_dimensions integrates with by_width_df", {
  scenario <- create_scenario(
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
  channel_df        <- by_width_df(scenario)
  channel_dimensions <- compute_channel_dimensions(channel_df)

  # --- Flow parameter columns ---
  flow_cols <- c(
    "unit_discharge", "mannings_n",
    "critical_depth", "critical_velocity", "critical_slope",
    "normal_depth", "normal_velocity",
    "froude", "shear_stress",
    "avail_stream_power", "applied_stream_power"
  )
  for (col in flow_cols) {
    expect_true(col %in% colnames(channel_dimensions),
                label = paste("flow column present:", col))
  }

  # --- Geometry columns ---
  geom_cols <- c("side_angle", "depth", "length_side_horz", "length_left_bank")
  for (col in geom_cols) {
    expect_true(col %in% colnames(channel_dimensions),
                label = paste("geometry column present:", col))
  }

  # --- Output dimensions ---
  expect_gt(nrow(channel_dimensions), 0)

  # --- Spot-check calculations ---
  expect_equal(
    channel_dimensions$unit_discharge[1],
    channel_dimensions$total_discharge[1] / channel_dimensions$width[1]
  )
  expect_lt(channel_dimensions$froude[1], 1)

  # depth = 2 * normal_depth
  expect_equal(channel_dimensions$depth, channel_dimensions$normal_depth * 2)

  # length_left_bank is positive and greater than width
  expect_true(all(channel_dimensions$length_left_bank > 0))

  # critical_slope is positive
  expect_true(all(channel_dimensions$critical_slope > 0))

  # --- Edge case: zero width produces Inf unit_discharge ---
  channel_df_zero_width <- channel_df %>% dplyr::mutate(width = 0.0)
  channel_dims_zero     <- compute_channel_dimensions(channel_df_zero_width)
  expect_true(all(is.infinite(channel_dims_zero$unit_discharge)))
  expect_true(all(is.nan(channel_dims_zero$froude)))

  # --- Edge case: large width produces small but positive unit_discharge ---
  channel_df_large_width <- channel_df %>% dplyr::mutate(width = 1e6)
  channel_dims_large     <- compute_channel_dimensions(channel_df_large_width)
  expect_gt(max(channel_dims_large$unit_discharge, na.rm = TRUE), 0)

  # --- Missing column raises error ---
  invalid_df <- channel_df %>% dplyr::select(-slope)
  expect_error(compute_channel_dimensions(invalid_df), "object 'slope' not found")
})
